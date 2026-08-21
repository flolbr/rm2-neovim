#!/usr/bin/env bash
set -euo pipefail

root_dir=$(cd "$(dirname "$0")" && pwd)
nvim_version=${NVIM_VERSION:-v0.12.4}
build_dir="$root_dir/build"
source_dir="$build_dir/neovim"
install_dir="$root_dir/dist/neovim-rm2-${nvim_version#v}"
archive="$root_dir/dist/neovim-rm2-${nvim_version}-armv7.tar.gz"
image=rm2-neovim-build:toltec-v4

mkdir -p "$build_dir" "$root_dir/dist"

if [[ ! -d "$source_dir/.git" ]]; then
  git clone --branch "$nvim_version" --depth 1 https://github.com/neovim/neovim.git "$source_dir"
fi

if [[ $(git -C "$source_dir" describe --tags --exact-match) != "$nvim_version" ]]; then
  echo "Build directory contains a different Neovim source version: $source_dir" >&2
  exit 1
fi

for patch in "$root_dir"/patches/*.patch; do
  if ! git -C "$source_dir" apply --reverse --check "$patch" 2>/dev/null; then
    git -C "$source_dir" apply "$patch"
  fi
done

docker build -t "$image" -f "$root_dir/Dockerfile.rm2-build" "$root_dir"

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e NVIM_VERSION="$nvim_version" \
  -e ARM_LUAJIT=/project/build/neovim/.deps/usr/bin/luajit \
  -e ARM_NVIM=/project/build/neovim/build/bin/nvim \
  -e CCACHE_DIR=/project/.ccache \
  -e HOSTCC="gcc-12 -m32" \
  -v "$root_dir:/project" \
  -w /project/build/neovim \
  "$image" \
  bash -lc '
    set -euo pipefail
    . /opt/x-tools/switch-arm.sh
    make CMAKE_BUILD_TYPE=Release \
      CMAKE_EXTRA_FLAGS="-DCMAKE_TOOLCHAIN_FILE=/project/rm2-toolchain.cmake -DCMAKE_INSTALL_PREFIX=/project/dist/neovim-rm2-${NVIM_VERSION#v} -DCMAKE_C_COMPILER_LAUNCHER=ccache -DLUA_PRG=/usr/local/bin/arm-luajit -DLUA_GEN_PRG=/usr/local/bin/arm-luajit -DNVIM_HOST_PRG=/usr/local/bin/arm-nvim" \
      DEPS_CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=/project/rm2-toolchain.cmake" \
      install
  '

tar -C "$install_dir" -czf "$archive" .
