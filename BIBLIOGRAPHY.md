# BIBLIOGRAPHY

Reference list of the primary sources, standards documents, and
historical texts that inform the `doctools` package (troff/eqn/tbl/pic/grap/refer) in
this Heirloom Darwin port.

## Standards + specifications

- **POSIX.1-2001** (IEEE Std 1003.1-2001). Base Definitions +
  System Interfaces + Shell and Utilities. The behavioural target
  for the `posix2001/` personality binaries in this port.
- **POSIX.1-1990** and **XPG3/XPG4** (X/Open). Historical basis
  for the `s42/` (SVID4-subset) and `posix/` (SUS) personalities.
- **SVID Issue 4** — System V Interface Definition, Fourth Edition,
  AT&T 1995. Behavioural reference for the default (SVID3/SVID4)
  personality binaries.
- **RFC 5735**, **RFC 3986** — for URI handling in tools that emit
  or parse network references (mail utilities in toolchest;
  pkgweb.c in pkgtools).
- **FIPS PUB 203, 204, 205** — Post-quantum crypto standards
  (ML-KEM, ML-DSA, SLH-DSA). Relevant to pkgtools' OpenSSL 3.5+
  signature verification path even though not exercised by the
  default sunw_PKCS12_parse code path.

## Foundational Bell Labs + BSD papers

- Kernighan, Brian W. and Rob Pike (1984). *The UNIX Programming
  Environment*. Prentice-Hall. Establishes many of the design
  norms this port preserves.
- McIlroy, M. Douglas (1978). "A Research UNIX Reader: Annotated
  Excerpts from the Programmer's Manual, 1971-1986." Bell Labs
  Computing Science Technical Report No. 139.
- Kernighan, Brian W. and Dennis M. Ritchie (1988). *The C
  Programming Language*, 2nd ed. Prentice-Hall. K&R style still
  appears in some Heirloom sources; the port preserves it.
- Ossanna, Joseph F. (1977). "NROFF/TROFF User's Manual." Bell
  Labs Computing Science Technical Report No. 54. (Relevant to
  doctools even outside that repo, because pkgtools' `pkginfo`
  emits nroff-formatted output.)
- Lions, John (1977). *A Commentary on the UNIX Operating System*.
  Bell Labs internal circulation; later released. Historical
  context for the code style.

## Package-specific references

- Kernighan, Brian W. and Lorinda L. Cherry (1975). "A System for
  Typesetting Mathematics." Communications of the ACM 18(3). The
  founding paper for eqn.
- Bentley, Jon L. and Brian W. Kernighan (1985). "GRAP - A
  Language for Typesetting Graphs." Bell Labs Computing Science
  Technical Report No. 114.
- Kernighan, Brian W. (1982). "PIC - A Graphics Language for
  Typesetting." Bell Labs Computing Science Technical Report
  No. 116.
- Lesk, M. E. (1976). "TBL - A Program to Format Tables." Bell
  Labs Computing Science Technical Report No. 49.
- Lesk, M. E. (1976). "Some Applications of Inverted Indexes on
  the UNIX System." Bell Labs Computing Science Technical Report
  No. 69. Foundation of the refer utility.
- Ossanna, Joseph F. and Brian W. Kernighan (1976). "Troff
  User's Manual." Bell Labs Computing Science Technical Report
  No. 54. The base troff reference.
- Knuth, Donald E. and Michael F. Plass (1981). "Breaking
  Paragraphs into Lines." Software - Practice and Experience
  11(11). The line-breaking algorithm used by the mpm rewrite.
- Liang, Franklin M. (1983). "Word Hy-phen-a-tion by Com-pu-ter."
  PhD thesis, Stanford University. Foundation for libhnj shipped
  in troff/libhnj/.

## Solaris + Ritter era

- Sun Microsystems (2005). *OpenSolaris source distribution*.
  The CDDL-1.0 fragments that carry the Sun copyright headers
  in this port descend from this drop.
- Ritter, Gunnar (2001-2008). *The Heirloom Project* — patch
  notes and README files inside the upstream tarballs at
  http://heirloom.sourceforge.net/. Definitive semantic authority
  for anything the port did NOT explicitly change.
- Ritter, Gunnar (personal communication, various mailing-list
  posts). Design rationale for the personality tree (SVID3 default
  + POSIX/SUS/SUS3/UCB variants).

## Security + hardening frameworks

- **CWE Top 25** (MITRE, 2024 edition). Referenced by
  `hardening/COVERAGE-MATRIX.md` in the workspace repo.
- **OWASP Top 10** (2021). Referenced likewise.
- **MITRE ATT&CK v14** (2024). Behavioural threat modelling for
  privileged utilities (`su`, `pkgadd`).
- **CAPEC 3.9** (2023). Attack-pattern catalogue used in threat
  modelling.

## Darwin-specific references

- Apple Inc. (2024). *macOS System Programming Guide* — chapters
  on Mach umbrella, libproc, and dyld. Foundation for the ps /
  pgrep / whodo re-implementations.
- IEEE Std 1003.1-2017 (POSIX.1-2017) — the current POSIX revision
  that Darwin claims conformance to. This port targets 2001
  behaviour where the two conflict.
- Apple's XNU source (public releases at
  https://github.com/apple-oss-distributions). Consulted for
  syscall semantics that differ between Darwin and Solaris.

## AI-assisted authorship references

- Anthropic (2026). *Claude Opus 4.7* model card. See
  `AI-DISCLOSURE.md` for how the model contributed to this port.

## Related community work

- Homebrew formulae for `heirloom-mailx`, `heirloom-doctools`,
  `heirloom-toolchest`. Not upstream to this port; independent
  packagings.
- Debian `heirloom-mailx` package (removed in 2018 due to CVE
  history in the upstream `nail` codebase).
- Fedora `heirloom-devtools` retired package.

## How to add to this bibliography

If you patch a specific tool and want to cite a paper or standard
that motivated the fix, append a row under **Package-specific
references** in the source of this file and commit alongside the
patch. Keep entries in APA-adjacent format for consistency.

## Cross-references to the sibling reference repos

Where a source cited here is preserved locally, the local path is
given via the sibling `heirloom-citations-darwin` or
`heirloom-ancestors-darwin` repo:

- **Cited primary documents** (CSTRs, BSTJ papers, K&R draft, USG
  documents): see
  <https://github.com/moonman81/heirloom-citations-darwin>.
- **Ancestor source manifests** (V7, 32V, DWB 1.0, PWB, PCC, 1-4BSD):
  see <https://github.com/moonman81/heirloom-ancestors-darwin>.

Cross-references are hyperlinks by design; if a link 404s, fall back
to the upstream TUHS Archive at <https://www.tuhs.org/Archive/>.
