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

### Update — 2026-09-22

Two changes to the Conclusion, and a new last slide.

**The limits beat is cut.**

> let's cut the limits here. I am thinking of what to say to rewrite
> these slides.

Cut, and here is the argument for it beyond the clock: both limits point at the parametric
machinery — *the re-solve needs the cached program in memory*, *synthetic problems, not a
standard benchmark library* — and as of today the presented deck does not show that machinery
(see `deck-comments-03-parametric.md`). Stating the cost of a mechanism the room has not been
shown makes the question harder to answer, not easier. Both are still true and both are still
said out loud if the Q&A goes there; backup 12, *what the two-phase split costs*, is the frame
behind the first of them.

**The punchline arrives in its place.** *The structure is in the problem already. The engine is
what keeps it.* came off SC4, cut the same day. It was the close of a section that no longer has
one, it is the only sentence in the deck that is not said on some other frame, and this is the
last slide with anything on it. It keeps its `\onslide<2->`, so the Conclusion is still two
beats and the frame budget is unchanged at 1:45.

Bullet 2 keeps *re-solve caching without DPP*, which is the single line pointing at backups
13–16.

**A References frame is new, and is the last presented slide** — after *Thank you*, before
`\appendix`, so it is what is on the screen during questions, which is when a reference is
actually wanted. Budgeted at 0:00; it is not spoken.

> let's also put a citation for BLAS, gustavson's and also one final citation slide where we
> have all the citations in the presentation.

Nine entries, alphabetical, copied from `Document.bib`, with the bibtex key of each recorded in
the frame's `%` block so the two can be diffed by eye. Three attributions are new and the deck
now cites every work it names:

| Key | Where it is cited |
|---|---|
| `gustavson1978two` | *One operation, two kernels* — the CSR product |
| `dongarra1990level3` | *Permuted-Dense matrix* and *One operation, two kernels* — Level 3 BLAS, where `dgemm` comes from |
| `lawson1979blas` | *Permuted-Dense matrix* — BLAS itself |
| `diamond2016cvxpy` | *DCP-based modelling languages* — the deck had never cited CVXPY |
| `boyd2004convex`, `bental2001lectures`, `grant2006disciplined` | already on their frames |
| `dolan2002`, `agrawal2019dpp` | backup-only, and on the list because it claims to be complete |

**Written by hand, not through bibtex.** The `presentation` target of the Makefile runs
`pdflatex` three times and no `bibtex`; the deck's four existing citations were already hand-set
grey lines; nine entries do not justify a build-system change. The cost is that the frame and
`Document.bib` can drift, which is what the key list in the `%` block is for.

> Moving the frame into the appendix instead, so the deck ends on *Thank you*, is a one-line
> move — it is the last thing before `\appendix`.

---

## Update — 2026-09-22, second pass. Karpathy's notes, applied to the Results and the Conclusion

The asks came from reading Andrej Karpathy's guide to giving talks — the goal of a talk is to
make the room care about the problem, then teach them something, and dense result tables are
where an audience reaches for its phone. This entry spans two sections; there is no
results-specific comments file (`deck-comments-03-parametric.md` is explicitly a historical
record), so both halves are recorded here.

### The benchmarks get a motivation

> I need to better introduce/motivate the benchmarks. Maybe one slide about why are we even
> doing this? and then one slide about the actual setup? maybe we can include a small code
> snippet calling `get_problem_data`? [...] In the setup slide we can say a quick word about the
> other cvxpy backends, just in what language they are in?

Two new frames open the Results section.

**R0, *Why benchmark?*** — 0:40, two beats. Both motivations come from the chapter's own opening
(`7-Theme2.tex:7-20`):

| bullet | what it says |
|---|---|
| 1 | `cvxcore` — C++, and CVXPY's default — is deprecated and will be removed, and neither Python backend has shown a decisive speedup on the first canonicalization |
| 2 | everything so far was argued on a 5×3 example small enough to check by hand |

Beat 2 is the question the next three frames answer: *does keeping the structure pay off on the
problems people actually solve?*

Bullet 2 is not new writing — it is the old Conclusion's third bullet, the one recorded under
*Future work* above ("although some examples are simple and can be done by hand, our approach is
general..."). It says the same thing in the place where it is a reason to run a benchmark rather
than something to mention once the benchmark is over.

**Deliberately not on it:** the chapter's other motivation, the symbolic and numeric split
against the parameter-to-data tensor. That machinery is backups 13–16 and the presented deck
never shows it. It is in the frame's `%` block as a spoken answer if the Q&A goes there.

**R0b, *Setup*** — 0:45. The listing is the harness's real call, not a paraphrase — it is
`bench/bench_one.py:13-17` of the diffengine handoff, and `"DIFFENGINE"` is the opt-in backend
string of PR #3448:

```python
data, chain, inv = prob.get_problem_data(
    solver=cp.CLARABEL,
    canon_backend="DIFFENGINE",   # CPP | SCIPY | COO
    ignore_dpp=True)
```

The backends are four `art` boxes in a row, the same grammar as *Overview*, with one grey line
each: `CPP` (`cvxcore`) C++, the default · `SCIPY` Python · `COO` Python · `diffengine` C. That
is the whole of "a quick word about what language they are in"; what each delegates its matrix
operations to (Eigen, `scipy.sparse`) is the limitation the engine section was about and is
spoken, from the frame's `%` block.

One LaTeX note, since it will bite the next listing with a string in it: `mypython` sets
`upquote=true`, which routes a straight `"` to `\textquotedbl`, and that glyph does not exist in
OT1. This block passes `upquote=false`. Loading `textcomp` does **not** fix it; changing the
document to T1 would, and would also re-metric every frame in the deck.

### The table is cut

> we could also probably remove the table, I think it just adds lots of confusion.

*First canonicalization* is gone from the presented deck. The full 25-row table is **backup 17,
*the per-problem times***, so a question from the floor can still be answered with it.

Its two headline sentences are not lost. *Fastest of the four on 21 of the 25, and more than
twice as fast as the best CVXPY backend on 17* is now the grey line under the performance
profile, which is why that frame goes 0:45 → 0:55. It is a **swap, not an addition** — the line
it replaces (*no CVXPY backend is fastest on more than two problems, and each needs τ ≈ 8 to
cover 92–96% of them*) is spoken now, and the line count under the figure is deliberately
unchanged, because that frame was 2.3pt overfull once and the `\vspace{-3.6ex}` under the figure
is the fix.

**Watch the two pairs of numbers.** 21 of 25 is against the *best of the three* CVXPY backends,
which is what the profile and the cut table both measure. The *24 of 25* that used to be in the
Conclusion was against the default `cvxcore` alone. Only one of them is in the deck now.

### The Conclusion is two frames

> I want maybe two slides max. Maybe first one is takeaways. [...] one bullet point about future
> work in having solvers potentially accept different matrix representations or a combination of
> them to further speedup the solve process.

**C0, *Takeaways*** — 1:00, two beats. The lead line states what the deck taught —
*what CVXPY does between `cp.Problem` and the solver, and what it costs* — rather than wishing
for it; your own sentence ("I hope you now understand better how CVXPY, canonicalization and
perhaps even convex optimization work") is the spoken version and is in the `%` block.

Then the three practices, one line each: use a `cp.Parameter` when the same problem is solved
again; vectorize, one operation rather than a loop, where it does not cost readability; read the
release notes. Beat 2 is the example of the third:

```python
rows, cols = pattern.nonzero()
X = cp.Variable((n, n), sparsity=(rows, cols))
```

with one grey line under it — *one scalar variable per stored entry, not n²*. The API is
verified, not recalled: `sparsity` is a `Leaf` attribute taking COO-style index arrays
(`cvxpy/expressions/leaf.py:89, 105, 149-150`), the call form is
`cvxpy/tests/test_attributes.py:59`, and `sparsity` is in `dim_reducing_attr` (`leaf.py:156`),
which is what makes the grey line true.

**C1, *Conclusion*** — 1:45 → 1:00. The forward-looking half only:

- not covered today: handling parameters efficiently — the symbolic and numeric split
- ahead: solvers that accept, or mix, matrix representations, so the structure survives
  canonicalization into the solve itself

`\onslide<2->` keeps the punchline unchanged. The two backward-looking bullets came **off** — the
Results section had made both claims two minutes earlier, which is the same argument that cut
*Three observations*. Bullet 1 is now the invitation that *re-solve caching without DPP* used to
be: backups 13–16 answer it in order.

**Bullet 2 is not in the thesis.** `8-Conclusion.tex:68-120` has three development directions and
this is not among them. It is yours, new to the deck today, and the honest answer to "is that
written up?" is no.

### Bookkeeping

Two works are newly named on a slide and are added to References: `cvxpybenchmarks` and
`clarabel`. The deprecation on *Why benchmark?* is the speaker's own paper (`zhang2026cvxpy`),
so it stays off the slide and out of References and is worth a sentence out loud instead.
13 entries → 15, still two frames, now 8 and 7, and both keys are in the frame's `%` block key
list.

**Net: +2 presented frames, +4 shown slides, +0:55.** The deck is 50 shown slides in 36 frames
with 18 backups; the budget is 24:00 in a 30-minute slot. `plans/defence_timing.md` carries the
per-frame rows and the checkpoints.

---

## Update — 2026-09-22, third pass. The Results section opens on *Setup*

> let's maybe cut this slide? [*Why benchmark?*]

Done. **R0 is cut**, one day after the entry above wrote it, and the entry above stands as the
record of what it said — nothing there is retracted, it is a question of where the words live.

The frame was two bullets and a question with `\vspace{6ex}` between them: three sentences, no
figure, nothing to trace. Against the deck's own trim rule — a line stays only if it says
something a figure, display or code block cannot — a whole frame of prose is the first thing to
go, and the 0:40 was never the argument for cutting it (the card has six minutes of slack either
way).

**Where the three sentences went:**

| R0 said | now |
|---|---|
| `cvxcore` is C++, CVXPY's default, deprecated and slated for removal; neither Python backend is decisively faster | **spoken** over *Setup*, while the first of its four boxes — `CPP (cvxcore)`, "C++, the default" — is on screen |
| everything so far was argued on a 5 × 3 example small enough to check by hand | **spoken** over *Setup*, before the code is walked |
| *does keeping the structure pay off on the problems people actually solve?* | **kept in writing**: the polyblue lead line of *Setup* |

Both spoken lines are in the `%` block of *Setup*, numbered, which is the deck's only
speaker-notes mechanism. The Karpathy point the frame was written for is not given up — the room
is still told why to care before it is shown numbers; it is told in the 25 seconds before the
listing is read rather than on a frame of its own.

### Clarabel comes off

> let's not cite clarabel, its fine. and we don't need to mention it.

`get_problem_data` stops before the solver, so which solver it is changes nothing this section
measures. The citation came off the footer line, and the entry came off References: **15 → 14**,
still two frames, now **8 and 6**, and `clarabel` is out of the frame's `%` key list.

`solver=cp.CLARABEL` **stays in the listing** — the call takes a solver and the snippet is the
harness's real one. Say nothing about it; if the floor asks, the answer is that the solver is
never called. (One word and it comes out too.)

> I also don't like the code with chain and inv, maybe just put bars there?

```python
data, _, _ = prob.get_problem_data(
    solver=cp.CLARABEL,
    canon_backend="DIFFENGINE",   # CPP | SCIPY | COO
    ignore_dpp=True)
```

Neither return value is used by the benchmark, and the eye should land on `canon_backend`.

### *One operation, two kernels* → *Algorithms*

> this should be called algorithms instead.

Retitled. The section now reads as its three representations and then the algorithms over them,
which is what the outline promises. Nothing else on the frame changed: same two named kernel
boxes, same two bullets, same 0:50, same reading — left box, then right box. The old title was
stating the frame's claim, and the lead line under it states that claim anyway ("same operation
either way — the representation of `A` picks the code that runs").

**Net: −1 presented frame, −2 shown slides, −0:40.** The deck is **48 shown slides in 35 frames**
with 18 backups; the budget is **23:20**. `plans/defence_timing.md` is re-synced — the Results
block is three frames, and the Results and Conclusion checkpoints move up by 0:40.

### Postscript, same day — the *Why benchmark?* beat comes back as evidence

> I think a cool motivation for the results is showing some photos of github issues complaining
> about slow canonicalization.

The frame stays cut exactly as recorded above; what comes back is the beat, in the form the cut
was an argument for. The objection was that R0 *asserted* the problem in three sentences with no
figure. Four real issues from `github.com/cvxpy/cvxpy` show it:

| | what it says | who, when, status |
|---|---|---|
| **#704** *Canonicalization performance [Tracking Issue]* | "a tracking issue for CVXPY performance, specifically for the time (and sometimes memory) it takes to construct and canonicalize problems" | akshayka, Apr 2019, closed |
| **#886** *Slow canonicalization of problems with many parameters* | "constructing the CVXPY problem takes less than 1 ms, but the CVXPYlayer initialization takes around 42 seconds" | akshayka, Nov 2019, closed (quoting a cvxpylayers user) |
| **#2205** *Slow compiling time for an unconstrained quadratic problem* | ~12 s at small sizes, **~4000 s** at the size wanted, against 12 s for the MATLAB CVX equivalent | a user, Aug 2023, **open** |
| **#3072** *Excessive memory consumption* | 65k variables, ~128 MB of problem data — "I run out of memory and my computer crashes", on a machine with **128 GB of RAM** | govindchari, Jan 2026, closed |

Spares, if a question needs one: #1058 (parametrized QP 30× the conic path, "effectively
unusable"), #1521 (compile time linear in the number of variables, on a problem already in
standard form), #2522 (overflow on the problem shape).

**Say it honestly.** Three of the four are closed and two are the maintainers' own reports. The
claim is that canonicalization time has been tracked since 2019, worked on, and is still being
hit — #3072 is eight months old — not that CVXPY ignores it. The jury can open the tracker.
#886 is the one that states the deck's premise (modelling is free, canonicalization is not) and
it is about parameters, which *Two passes* answered a section earlier; #3072 is why the Results
section has a memory slide, and it is the frame to point back to on *Peak memory*.

**The frame.** *A known bottleneck*, first in the Results section, **five beats, 0:50**. The four
captures arrive one per click and pile on top of one another, oldest first, each burying most of
the one before. #704 lands straight — alone on screen, a tilted image reads as a mistake rather
than as a pile — and the three after it come in at a few degrees. The last one is readable in
full and is the only one to read aloud. The dark GitHub theme is kept by
choice — it reads as a screenshot. Beat 2 is the question, which had been *Setup*'s polyblue lead
for one afternoon (between R0 being cut and this frame existing) and is now back where it was
written; *Setup*'s lead is its own again.

Two shapes were built before this one and are worth not rebuilding: a fan of whole pages, where
`\fitfig` scaled the titles to about 6 pt, and a flat stack of title bars, which was legible but
read as a bibliography rather than as a pile of complaints.

The picture's bounding box is fixed by hand with `\useasboundingbox`, and has to be: with the
overlays on, `\adjustbox` would otherwise measure each beat separately, scale the single first
image up to fill the frame, and the pile would jump and resize under every click. If any
position, angle, width or crop changes, recompute that rectangle.

The crops are `images/issue-{704,886,2205,3072}.png` — the live pages, cropped only, the three at
the back to their title block and first line, the top one whole. The frame sits behind
`\issueshots` in the preamble so a missing file fails loudly rather than silently dropping it.

---

## Read-through of the built deck — 2026-09-22, later entry

### Setup "Benchmark setup" — what the 25 problems are, and where they live
> we should definitely mention the wide range of applications in convex optimization
> that are present in the benchmark.
> let's also link the benchmark repo?

Both, and the first is the one that matters. The frame opened on a `get_problem_data` call
under a bare title, so `25` arrived as a count with nothing behind it. The lead line is now the
chapter's own sentence (`7-Theme2.tex:20-22`): *the 25 problems of CVXPY's public benchmark
suite: portfolio selection, regression and classification, image inpainting, and many more
applications of convex optimization* — the four named are the chapter's four, `many more` is
its phrase, and the polyblue is on `many more applications`. It is what makes 25 a claim about
convex optimization rather than a number.

The repo goes in the footer, live, next to the existing citation:
`CVXPY benchmarks (2025), github.com/cvxpy/benchmarks`. It is a `\href` around a `\nolinkurl`,
so it stays in the footer's grey `\scriptsize` and is clickable from the built PDF. The point
of showing it is that the suite is **public and not ours** — we did not choose the problems we
are measured on.

**Δ +0 frames, +0 shown slides, +0:10** (0:45 → 0:55), the only frame in this pass that costs
anything. `plans/defence_timing.md` re-synced: *Results* 3:05 → 3:15, and the *Results* and
*Conclusion* checkpoints move to 22:50 and 25:15.
