#!/usr/bin/env bash

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v jq >/dev/null 2>&1; then
  printf 'Required command not found: jq\n' >&2
  exit 1
fi

json_count=0
while IFS= read -r -d '' file; do
  jq empty "$file"
  json_count=$((json_count + 1))
done < <(find "$root_dir/behavior_pack" "$root_dir/resource_pack" \
  -type f -name '*.json' -print0)

if ((json_count == 0)); then
  printf 'No pack JSON files found.\n' >&2
  exit 1
fi

behavior_manifest="$root_dir/behavior_pack/manifest.json"
resource_manifest="$root_dir/resource_pack/manifest.json"
dependency_uuid="$(jq -r '.dependencies[0].uuid // empty' "$behavior_manifest")"
dependency_version="$(jq -r '.dependencies[0].version | join(".")' "$behavior_manifest")"
resource_uuid="$(jq -r '.header.uuid // empty' "$resource_manifest")"
resource_version="$(jq -r '.header.version | join(".")' "$resource_manifest")"

if [[ -z "$dependency_uuid" || "$dependency_uuid" != "$resource_uuid" ]]; then
  printf 'Behavior Pack dependency UUID does not match Resource Pack UUID.\n' >&2
  exit 1
fi

if [[ "$dependency_version" != "$resource_version" ]]; then
  printf 'Behavior Pack dependency version does not match Resource Pack version.\n' >&2
  exit 1
fi

pack_uuids="$(jq -r '.header.uuid, .modules[].uuid' \
  "$behavior_manifest" "$resource_manifest")"
pack_uuid_count="$(printf '%s\n' "$pack_uuids" | wc -l | tr -d ' ')"
unique_uuid_count="$(printf '%s\n' "$pack_uuids" | sort -u | wc -l | tr -d ' ')"

if [[ "$unique_uuid_count" != "$pack_uuid_count" ]]; then
  printf 'Manifest header and module UUIDs must be unique.\n' >&2
  exit 1
fi

printf 'Validated %d JSON files and pack dependency metadata.\n' "$json_count"
