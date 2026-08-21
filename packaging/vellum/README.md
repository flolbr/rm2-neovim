# Vellum package submission

`neovim/` is a prepared package directory for the
[Vellum package repository](https://github.com/vellum-dev/vellum).

The recipe builds Neovim `0.12.4` from the upstream tag for `armv7`, installs
it under `/home/root/.vellum`, and declares compatibility with reMarkable 2
only. Copy this directory to `vellum/packages/neovim/`, then run Vellum's lint,
checksum, and ARMv7 build commands before submitting it upstream.
