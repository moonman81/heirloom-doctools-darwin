# charlib

`charlib` — see the repo root docs for context.

## Where this fits

This directory is part of `moonman81/heirloom-doctools-darwin`, the
Darwin port of the doctools package from Gunnar Ritter's Heirloom
Project. See the repo root `README.md`, `PROVENANCE.md`, and
`NOTICE.md` for context.

**Not authoritative.** Upstream is
`http://heirloom.sourceforge.net/` (unmaintained since ≈ 2008).
Port fixes here are for macOS 26.4 arm64 compatibility, not for
new feature work.

## Contents

- 12
- 14
- 34
- BRACKETS_NOTE
- Fi
- Fl
- L1
- L1.map
- LH
- LH.map
- Lb
- Lb.map
- OLD_LH
- OLD_LH.map
- README

## Modality

Every installed binary honours the shared help / version / variant
/ dialect flag set:

- `--help`, `--usage`, `-H`  → man page
- `--version`, `-V`          → port banner (built variant + active variant)
- `--variants`               → list personality variants installed
- `--describe-modality`      → full modality matrix
- `--variant=<name>`, `HEIRLOOM_VARIANT=<name>`, `HEIRLOOM_DIALECT=<name>`
  → re-exec into the requested personality binary

See `heirloom_flags.h` (in each source directory) for the shared shim.

## Licence

Per-file patchwork — CDDL-1.0 / Caldera / Lucent / GPL-2.0-or-later /
LGPL-2.0-or-later / zlib. See headers on each source file and the
per-package `NOTICE.md`.
