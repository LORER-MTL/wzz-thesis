# Deck comments — Conclusion

Working checklist for the comments left in `presentation.tex`. Line numbers are as of the
working tree on 2026-09-20 and will drift as entries are done.

**Do this file last.** Both entries depend on the new section-close frame in
`deck-comments-02-single-canon.md` — that frame is what carries the motivating summary, which
is the premise of your "the conclusion can be short" comment.

---

## [x] D-R4 — R4 "Three observations" — `presentation.tex:1653`

### `:1663`
> let's cut this observations slide, I will summarize the key points verbally instead.
> maybe the conclusion can just be very short and concise, since we would have given the
> motivating summary for sparsediffengine already before the reuslts right?

Yes — provided the section-close frame exists first. Delete the three-observations list
(caching does not require DPP / the tensor's upfront cost is not always justified / `cvxcore`
can be replaced).

**Decision D-R4 — what happens to beat 2, "and the downsides"?** Your comment does not cover
it, and one of its three lines is moving anyway:

| line | fate |
| --- | --- |
| peak memory: SCIPY lowest on 16 of 25, `\de{}` about 1.4× it | **moves** to the promoted memory slide (`deck-comments-03-parametric.md`) |
| the re-solve needs the cached program in memory; a built tensor does not | keep |
| synthetic problems, not a standard benchmark library | keep |

**Recommendation:** replace the whole frame with one short conclusion slide — what was built,
what it buys, and the honest limits (the two lines above, plus the FW bullet below).

---

## [x] FW "Future work" — `presentation.tex:1683` — cut

### `:1693`
> I don't think we need future work honestly, let's cut it. it is mostly development.
> we could have one bullet point where I say although some examples are simple and can be done
> by hand, our approach is general and can work for larger and much more complex problems.
> this is where the performance can be seen as having a significant impact.

Delete the frame. **−1 frame.** The three directions on it (a standalone `sparsediffpy`
interface; `\de{}` as the default on the `ignore_dpp` path; passing block structure to the
solver) are all development, as you say — they are in `8-Conclusion.tex:68-120` if anyone asks.

The replacement bullet goes on the new conclusion slide: *the examples here are simple enough
to do by hand, but the approach is general and works for much larger and more complex problems
— which is where the performance matters.*

---

## [x] The closing "Thank you" frame — `presentation.tex:1698`

No comments. Unchanged.

---

## Status, 2026-09-21

All entries in the five files are applied. `make presentation` is clean: no errors, 30
main-deck frames (was 29), and no new overfull boxes — the one that existed on the peak-memory
backup is fixed by the narrower figure.

**Still open, deliberately:**

1. **D-SEC option 3** — rename `Parametric canonicalization` to `Results` and move
   R1 / R2 / peak memory / R3 into it. Section 3 is renamed to `SparseDiffEngine`; the rest is
   a structural change to where results live and was left for you. The `.tex` carries the
   question as an inline note on the section line.
2. **B3 `:1033`** — your comment breaks off at "one other suggestion is to". The two beat-1
   bullets are cut and replaced with one line about where `F` and `g` land; swap in whatever
   you meant to write.

### Update, later on 2026-09-21

D-SEC option 3 is applied — see `deck-comments-02-single-canon.md`. The deck now runs
Introduction / Example / SparseDiffEngine / Results / Conclusion, 36 presented slides.

The only item still open is **B3 `:1033`**, where your comment breaks off mid-sentence.
