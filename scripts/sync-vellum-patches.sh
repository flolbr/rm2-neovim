#!/usr/bin/env bash
set -euo pipefail

root_dir=$(cd "$(dirname "$0")/.." && pwd)
source_dir="$root_dir/patches"
package_dir="$root_dir/packaging/vellum/neovim"
velbuild="$package_dir/VELBUILD"

usage() {
  echo "Usage: $0 [--check|--sync]"
  echo "  --check  Verify Vellum patch copies and checksums (default)."
  echo "  --sync   Copy canonical patches and refresh their SHA-512 checksums."
}

mode=${1:---check}
case "$mode" in
  --check | --sync) ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

test -f "$velbuild"

for source_patch in "$source_dir"/*.patch; do
  patch_name=$(basename "$source_patch")
  package_patch="$package_dir/$patch_name"
  hash=$(sha512sum "$source_patch" | awk '{print $1}')

  if [[ "$mode" == "--sync" ]]; then
    cp "$source_patch" "$package_patch"
    checksum_file=$(mktemp)
    awk -v hash="$hash" -v name="$patch_name" '
      $2 == name { $1 = hash }
      { print }
    ' "$velbuild" > "$checksum_file"
    mv "$checksum_file" "$velbuild"
  else
    cmp --silent "$source_patch" "$package_patch" || {
      echo "Patch differs: $patch_name" >&2
      exit 1
    }
    grep --fixed-strings --quiet "$hash  $patch_name" "$velbuild" || {
      echo "Checksum differs: $patch_name" >&2
      exit 1
    }
  fi
done

echo "Vellum patches are in sync."
