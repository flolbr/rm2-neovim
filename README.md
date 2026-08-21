# Neovim for reMarkable 2

Reproducible ARMv7 hard-float builds of Neovim for the reMarkable 2, using the
Toltec cross-compilation image. The current build targets Neovim `v0.12.4`.

## Build

Install Docker and Git, then run:

```sh
./build.sh
```

The build downloads the pinned Neovim release source, applies the cross-build
patches, and writes a portable archive to `dist/`. Set `NVIM_VERSION` to build
another release tag, after confirming that the patches still apply.

GitHub Actions runs the same build and publishes the archive as a workflow
artifact. Pushing a version tag such as `v0.12.4` also creates a GitHub Release
and attaches the archive.

## Install on a reMarkable 2

Download the archive for the release you want on a computer with SSH access to
the tablet:

```sh
VERSION=v0.12.4
curl -fLO "https://github.com/flolbr/rm2-neovim/releases/download/$VERSION/neovim-rm2-$VERSION-armv7.tar.gz"
```

Copy it to the tablet, replacing `<rm2-host>` with its hostname or IP address:

```sh
scp "neovim-rm2-$VERSION-armv7.tar.gz" "root@<rm2-host>:/home/root/"
```

Connect to the tablet and extract it into a versioned directory:

```sh
ssh "root@<rm2-host>"
mkdir -p "/home/root/neovim-$VERSION"
tar -xzf "/home/root/neovim-rm2-$VERSION-armv7.tar.gz" -C "/home/root/neovim-$VERSION"
ln -sfn "/home/root/neovim-$VERSION/bin/nvim" /usr/local/bin/nvim
nvim --version
```

The `/usr/local/bin/nvim` symlink selects the active release, so Neovim is
available directly as `nvim`. Keeping each release in its own directory makes
upgrading and rollback independent: repoint the symlink to switch versions.

## What is included

The archive contains `bin/nvim`, the Neovim runtime, and bundled Tree-sitter
parsers. It is self-contained apart from the standard ARM hard-float runtime
provided by the reMarkable/Toltec environment.
