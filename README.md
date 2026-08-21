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
artifact.

## What is included

The archive contains `bin/nvim`, the Neovim runtime, and bundled Tree-sitter
parsers. It is self-contained apart from the standard ARM hard-float runtime
provided by the reMarkable/Toltec environment.
