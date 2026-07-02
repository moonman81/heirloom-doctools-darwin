---
name: troff-preprocessor-pipeline
description: "Understand + preserve the Bell Labs troff preprocessor pipeline — a chain of small language processors (soelim → refer → grap → pic → tbl → eqn → troff) each of which handles one domain-specific 'little language' embedded in the source. Each preprocessor emits augmented troff input for the next. Preserving the pipeline's structure lets 40-year-old .ms / .me / .mm / man-macro documents typeset unchanged."
gate: 2
version: "1.0.0"
author: moonman81
tags: [troff, nroff, tbl, eqn, pic, grap, refer, soelim, bell-labs, little-languages]
depends_on: []
allowed-tools:
  - Read
  - Grep
when_to_use: "Invoke when scoping troff porting, when a user asks about the preprocessor chain, or when debugging a document that formats incorrectly because a preprocessor was skipped. Triggers: 'troff preprocessor', 'tbl eqn pic', 'refer bibliography', 'soelim', '.EQ .EN block', '.PS .PE block', '.TS .TE block', 'grap plot', 'little language', 'Bell Labs pipeline'."
---

# Troff preprocessor pipeline

## The chain

```
input.tr → soelim → refer → grap → pic → tbl → eqn → troff/nroff → output
```

Each stage is a **separate binary**. Each stage handles one
domain-specific "little language" embedded in the surrounding troff
input, produces augmented troff, and passes the result to the next
stage.

## The preprocessors

| Preprocessor | Handles | Delimiter | Author |
|---|---|---|---|
| `soelim` | `.so filename` includes (recursive) | `.so ...` | Bell Labs |
| `refer` | Bibliographies — reference lookups | `.[ ... .]` | Mike Lesk, ~1978 |
| `grap` | Statistical plots (wraps pic) | `.G1 ... .G2` | Bentley + Kernighan, ~1986 |
| `pic` | Line-drawing / diagrams | `.PS ... .PE` | Brian Kernighan, ~1981 |
| `tbl` | Formatted tables | `.TS ... .TE` | Mike Lesk, ~1979 |
| `eqn` | Mathematical typesetting | `.EQ ... .EN` | Kernighan + Cherry, ~1975 |
| `troff` / `nroff` | Base typesetter (macro-driven) | `.XX` macros | Joseph Ossanna, ~1973 |

## Invocation order matters

Preprocessors are ordered so each one can wrap the output of the
next. Wrong order = wrong output:

- `pic` must run **before** `tbl`, so `pic` graphics can appear
  inside table cells.
- `eqn` must run **after** `tbl`, so equations can appear inside
  table cells (and can span multiple table columns).
- `refer` runs **before** `pic` because a bibliographic reference
  can contain a `pic` diagram (rare but supported).
- `soelim` runs **first** because included files might contain any
  of the other blocks.

Canonical pipeline command (nroff/troff macros are `-me` here):

```sh
soelim doc.tr | refer -e | grap | pic | tbl | eqn | troff -me
```

The `Makefile` in each `doctools/` subdirectory encodes this
ordering.

## Wrapper scripts assemble the pipeline

`groff`-style wrappers exist but the pure Heirloom approach is a
shell script that runs the pipeline. The Heirloom `troff` and
`nroff` binaries are the base typesetters; they do NOT auto-invoke
preprocessors. That's a user responsibility.

If a document uses `.EQ ... .EN` and you invoke `troff doc.tr`
without `eqn`, you get literal `.EQ` and `.EN` lines in the output
— the equation block is not expanded. This is not a bug; it's the
Unix "small tools that compose" philosophy.

## Preserving the pipeline in a Darwin port

- Every preprocessor binary must install to `$PREFIX/bin/` — they
  are not "optional" utilities you can drop.
- Each preprocessor's man page (`tbl.1`, `eqn.1`, `pic.1`, `grap.1`,
  `refer.1`, `soelim.1`) must install to `$PREFIX/share/man/5man/`.
- The `troff/nroff/tmac.d/` macro directories must install to
  `$PREFIX/lib/troff/tmac/`; deleting even one macro package
  breaks the documents that use it.
- `dpost` (troff → PostScript driver) must install alongside
  `troff` — output from `troff -Tps` is intermediate device-
  independent language that `dpost` translates to PostScript.

## LP64 gotcha

`nroff`'s core module `n7.c` contained the LP64 NULL+offset pointer
bug documented in the sibling skill
`lp64-null-plus-offset-pointer-bug`. That single bug crashed
`nroff` and `troff` on every input on Darwin arm64 until fixed.
Audit the other core modules (`n5.c`, `n6.c`, `t6.c`, `t10.c`) for
the same pattern — first-allocation realloc rebase.

## What each little language is worth learning

- **eqn** — mathematical typesetting predating TeX by a few
  years. Simpler grammar; incredibly compact. Used in the
  original UNIX Programmer's Manual.
- **pic** — declarative diagram description. Still extraordinarily
  effective for line diagrams; predates and inspired much of
  today's declarative-diagram tooling (mermaid, plantuml, tikz).
- **tbl** — table typesetting. Still the reference implementation
  of "how a text-only tables language should feel".
- **grap** — Bentley + Kernighan's statistical-plot language. Wraps
  pic; you write `plot from 1..10` and get a graph.
- **refer** — bibliographic-reference database lookup. The pattern
  every citation manager since is a variation of.

## Reference

- Joseph Ossanna, "Nroff / Troff User's Manual" (Bell Labs
  Computer Science Technical Report No. 54, 1976).
- Brian Kernighan, "PIC — A Language for Typesetting Graphics"
  (Software: Practice + Experience, 1982).
- Mike Lesk, "Tbl — A Program to Format Tables" (Bell Labs, 1976).
- Kernighan + Cherry, "A System for Typesetting Mathematics"
  (Communications of the ACM, 1975).
- Bentley + Kernighan, "Grap — A Language for Typesetting
  Graphs" (CACM, 1986).
