# eqn

equation preprocessor for troff.

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

- **C sources**: diacrit.c, eqnbox.c, font.c, fromto.c, funny.c, glob.c, integral.c, io.c, lex.c, lookup.c, mark.c, matrix.c (+9 more)
- **Headers**: e.h, heirloom_flags.h
- **Subdirs**: checkeq.d, eqn.d, eqnchar.d, neqn.d

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
