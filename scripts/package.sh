#!/usr/bin/env bash

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
release_name="${1:-}"

if [[ ! "$release_name" =~ ^[a-z0-9][a-z0-9_-]*$ ]]; then
  printf 'Usage: %s <release-name>\n' "${0##*/}" >&2
  printf 'Example: %s milestone_4_1\n' "${0##*/}" >&2
  exit 1
fi

for command in jq zip unzip; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$command" >&2
    exit 1
  fi
done

"$root_dir/scripts/validate.sh"

dist_dir="$root_dir/dist"
mkdir -p "$dist_dir"
temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/jurassic-trex-package.XXXXXX")"
trap 'rm -rf "$temp_dir"' EXIT

behavior_name="jurassic_trex_behavior_${release_name}.mcpack"
resource_name="jurassic_trex_resources_${release_name}.mcpack"
addon_name="jurassic_trex_${release_name}.mcaddon"

(
  cd "$root_dir/behavior_pack"
  zip -qr "$temp_dir/$behavior_name" . -x '*.DS_Store'
)

(
  cd "$root_dir/resource_pack"
  zip -qr "$temp_dir/$resource_name" . -x '*.DS_Store'
)

(
  cd "$temp_dir"
  zip -q "$addon_name" "$behavior_name" "$resource_name"
)

unzip -tq "$temp_dir/$behavior_name"
unzip -tq "$temp_dir/$resource_name"
unzip -tq "$temp_dir/$addon_name"
unzip -p "$temp_dir/$behavior_name" manifest.json | jq empty
unzip -p "$temp_dir/$resource_name" manifest.json | jq empty

mv "$temp_dir/$behavior_name" "$dist_dir/$behavior_name"
mv "$temp_dir/$resource_name" "$dist_dir/$resource_name"
mv "$temp_dir/$addon_name" "$dist_dir/$addon_name"

printf 'Created:\n'
printf '  %s\n' "$dist_dir/$behavior_name"
printf '  %s\n' "$dist_dir/$resource_name"
printf '  %s\n' "$dist_dir/$addon_name"
