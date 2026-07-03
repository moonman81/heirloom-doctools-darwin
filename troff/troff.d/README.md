# troff.d

troff back-end + PostScript output pipeline.

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

- **C sources**: afm.c, draw.c, makedev.c, otf.c, otfdump.c, otfdump_vs.c, t10.c, t6.c, ta.c, unimap.c
- **Headers**: afm.h, dev.h, heirloom_flags.h, pt.h, troff.h, unimap.h
- **Build**: Makefile, Makefile.mk
- **Man pages**: otfdump.1
- **Subdirs**: devaps, dpost.d, font, postscript, tmac.d

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
