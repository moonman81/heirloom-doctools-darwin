---
name: lp64-null-plus-offset-pointer-bug
description: "K&R / early-ANSI C bug pattern that hides on 32-bit ILP32 and crashes reliably on 64-bit LP64. In a realloc-based buffer growth path: j = (char*)new - (char*)old; buf_ptr = (T*)((char*)buf_ptr + j); — when the FIRST allocation runs with buf_ptr == old == NULL, j equals the integer value of the new allocation address, and NULL + j = a poisoned pointer that gets dereferenced. On ILP32 the low-32-bit value happened to fall inside process address space often enough that the store touched some unrelated heap byte and the next realloc relocated before anyone read it. On LP64 the kernel traps immediately. Fix: on first-allocation (word == NULL), set buf_ptr = new directly, skipping the rebase arithmetic."
gate: 3
version: "1.0.0"
author: moonman81
tags: [c-bug, lp64, ilp32, realloc, pointer-arithmetic, null-pointer, silent-corruption, troff, heirloom]
depends_on: []
allowed-tools:
  - Read
  - Grep
  - Write
when_to_use: "Invoke when a legacy C codebase crashes on 64-bit hardware with EXC_BAD_ACCESS / SIGSEGV in a realloc growth path, when reviewing K&R-era buffer-grow code for LP64 safety, or when a bug reproduces on LP64 but not on ILP32. Triggers: 'LP64 SIGSEGV', 'NULL plus offset', 'realloc first-allocation crash', 'rebase pointer after grow', 'storeword crash', 'troff n7.c bug'."
---

# LP64 NULL + offset pointer bug pattern

## The canonical instance

In `doctools/troff/n7.c:1489`, `storeword()` grows an internal word
buffer on demand:

```c
if (wordp == NULL || wordp >= &word[wdsize - 3]) {
    tchar *k, **h;
    int j;
    // ... realloc path ...
    if ((k = realloc(word, wdsize * sizeof *word)) == NULL /* || pp ... */)
        goto fail;
    j = (char *)k - (char *)word;                       /* offset */
    wordp = (tchar *)((char *)wordp + j);               /* REBASE   ← trap */
    for (h = hyptr; h < hyp; h++)
        if (*h)
            *h = (tchar *)((char *)*h + j);
    word = k;
    // ...
}
// ...
*wordp++ = c;                                           /* CRASH HERE */
```

The intent of the rebase is: after realloc moves the buffer, adjust
every pointer that was pointing into the old buffer to point into the
new buffer.

## The bug

On the **very first entry** to `storeword()`, `word == NULL` and
`wordp == NULL`. `realloc(NULL, N)` correctly returns a fresh
allocation `k`. Then:

- `j = (char *)k - (char *)NULL` = address of `k` cast to
  `ptrdiff_t` — a huge value.
- `wordp = (tchar *)((char *)NULL + j)` = a `tchar *` whose
  numeric value is the address of `k` **cast through NULL** — on
  LP64, this is undefined behaviour and typically lands as a garbage
  pointer that is not the same as `k`.
- `*wordp++ = c` dereferences the garbage pointer.

## Why LP64 traps + ILP32 hides

- **ILP32:** `intptr_t` is 32 bits. `char *k - (char *)NULL` on a
  32-bit system produces a 32-bit `j`. `NULL + j` produces a pointer
  whose bits happen to equal `k`'s bits. The store lands somewhere
  inside the process heap; probably not a segfault; the next
  `realloc` relocates before anyone reads that byte.
- **LP64:** `intptr_t` is 64 bits. Same arithmetic; same result of
  `k`; but the pointer subtraction of `k - NULL` is genuinely UB in
  ISO C, and modern compilers do not guarantee the result equals
  the numeric address of `k`. On Darwin arm64 the result is
  a pointer outside any mapping. Kernel traps.

## The fix

Special-case the first-allocation path:

```c
if (word == NULL) {
    wordp = k;                              /* no rebase needed */
} else {
    j = (char *)k - (char *)word;
    wordp = (tchar *)((char *)wordp + j);
    for (h = hyptr; h < hyp; h++)
        if (*h)
            *h = (tchar *)((char *)*h + j);
}
word = k;
```

Behavioural difference vs. original: **zero**, in every case where
the original was correct. In the buggy case (first allocation), the
fix produces the correct pointer.

## How to spot this pattern

- **Any realloc growth path** that stores a "rebase offset" computed
  from the old pointer.
- **Struct-of-pointers-into-a-buffer** designs where the buffer can
  grow and the pointers must move with it.
- **Trap symptom:** crash on the very first call, always at the
  `*ptr++ = value` line that follows the growth.

Codebases known to have this shape (audit if porting to LP64):

- Bell Labs troff `n7.c` (fixed in heirloom-doctools-darwin).
- BSD `join.c`, some old sort implementations.
- Various K&R-era text-processing utilities that grow a token buffer.

## Debugging technique

`lldb` catches this instantly:

```
(lldb) run
* thread #1 stop reason = EXC_BAD_ACCESS (code=1, address=0x62fdf0)
    frame #0: nroff`storeword(c=..., w=24) at n7.c:1489
    -> *wordp++ = c;
```

If `wordp` points somewhere outside any mapping AND the function was
just called for the first time, you have this bug.

## Prior art in the port

- Commit `phase 6-a: fix nroff/troff n7.c storeword LP64 SIGSEGV`
  in heirloom-doctools-darwin. See `patches/*.patch`.
- The same shape may exist in `troff/troff.d/dpost.d/*.c` for the
  PostScript driver — not yet audited.

## Reference

- Rob Pike + Brian Kernighan, "The Practice of Programming" (1999),
  chapter 5 on debugging.
- ISO C99 §6.5.6/7-9 on additive operators + null pointer arithmetic.
