# Deck comments — Single canonicalization (the method section)

Working checklist for the comments left in `presentation.tex`. Line numbers are as of the
working tree on 2026-09-20 and will drift as entries are done.

This is the one section that gets a **restructure** rather than edits. It is four frames today
and skips the organizing idea entirely. Do it early: `deck-comments-00-intro.md` (I5) and
`deck-comments-04-conclusion.md` both wait on it.

**Settle D-SEC first** — see the bottom of this file.

---

## The comments this file works from

### `:1149` (above SC0, opening the section)
> maybe one slide for overview?
> then we could mention that we have tree matrix classes?
> I also quite like the talks about dispatching between types in the thesis. this is the main
> ideas. and then we should also motivate this organization somehwere.
> when the problem data is dense, we can use a standard dense matrix representation. and
> benefit from blas both storage and computation. then we can show CSR, and then afterwards
> talk about permuted dense.

### `:1288` (above SC3)
> let's cut this slide, it's too much to talk about.
> i would like one simple slide which shows the dispatching. and depending on the expression
> type we would do something different/use a different kernel. the composition of operators
> doesn't happen that often anyways.
> instead we could have a simple slide showing the dispatching based on the expression type.
> also there could be an ending slide of this section which kind of summarizes everything and
> also highlights how other modeling languages cannot handle dense data this efficiently. and
> also that our approach maintains high performance for dense blocks. whereas existing cvxpy
> approaches convert everything to sparse and also a quick word about other works.

---

## Target sequence for the section

1. **NEW — "The engine" (overview)**
2. SC0 "Compressed sparse row" *(kept, opening line moved up to 1)*
3. SC2 "A dense block at permuted positions" *(kept as is)*
4. **NEW — dispatch by expression type** *(replaces SC3)*
5. ~~SC3 "Closed under the operations we need"~~ *(cut)*
6. **NEW — section close**
7. R1 "First canonicalization", R2 "Performance profile" *(no comments, untouched)*

Net: **+2 frames** in this section, paid for by cuts elsewhere (see the master plan's budget).

---

## [x] 1. NEW — "The engine" (overview)

Opens the section. Carries three things:

- **Names `SparseDiffEngine`.** After the I5 entry in `deck-comments-00-intro.md`, this is the
  first place in the deck the name appears. Do not tick that I5 box until this frame exists.
- **The organizing idea.** One Jacobian per expression node, stored in one of **three
  representations** — generic sparse (CSR), permuted dense, stacked permuted dense — and
  kernels that dispatch on the representation in front of them.
- **Why that organization** (your `:1149` line): when the problem data is dense, use a dense
  representation and get BLAS for both storage and computation; when it is scattered, CSR.

Recommend **one slide, not two** — the motivation is the second half of the overview, not a
frame of its own.

**Sources.** `7-Theme1.tex:35-47` (a small C library, ~17k lines, ~45 atoms in six classes,
`utils/` for the matrix structures and kernels) and `7-Theme1.tex:121-127` (the three
representations, the generic sparse one as default, and that an atom picks one when it
allocates its Jacobian during the symbolic pass).

**Note on the third representation.** Stacked permuted dense is currently invisible on the main
line — SC2 stops at the permuted dense triple, and the picture lives only on backup **SUM1b**
(`presentation.tex:2033`). **Recommendation:** name it in one clause here and leave the picture
in backup, rather than promoting SUM1b.

---

## [x] 2. SC0 "Compressed sparse row" — `presentation.tex:1157`

Keep the frame. Move its opening punchline —

> New matrix classes for the structure the problem data already has, and kernels that dispatch
> on them. Starting from what everything is stored in today:

— up to the overview, which is now the slide whose job that is. SC0 keeps only the "starting
from what everything is stored in today" lead-in.

---

## [x] 3. SC2 "A dense block at permuted positions" — `presentation.tex:1229`

No comment. Unchanged.

(Reminder if it ever moves: this frame must **not** go inside `\fitfig` — `nicematrix` places
its `\CodeBefore` panels with absolute coordinates and a `scalebox` displaces them, so the row
tints leave the matrix and run the height of the frame.)

---

## [x] 4. NEW — dispatch by expression type

Your ask: one simple slide, dispatch keyed on the **expression/atom**, not the operand-pair
grid, since composition of operators is rare in practice.

**Check first:** backup **SUM** — "Backup: ten kernels is the whole library",
`presentation.tex:1967` — may already be 80% of this slide. If so, promote and simplify it
rather than drawing something new. It already carries the ten-kernel table and the line
*each kernel is written once per representation, and the call selects the implementation*.

**Sources.** `7-Theme1.tex:378-411` (the ten kernels, with the "Called by" column that maps
each kernel to the atoms that reach it — which is precisely the expression-type view you want)
and `7-Theme1.tex:413-437` (unary vs binary dispatch; addition always in CSR; only the
transposed products double-dispatch).

The clearest single illustration is the `index` example at `7-Theme1.tex:427-437`: one
operation, three representations, three implementations — CSR copies column indices, permuted
dense intersects the row index vector, stacked applies the permuted dense kernel per block and
drops empty ones.

**Done twice.** The first version was the ten-kernel table in a left column with three bullets
on the right — including that `index` sentence, which is a sentence describing a picture that
was not on the slide. On 2026-09-21 it became **two twinned frames**, `Dispatch: a data vector`
and `Dispatch: a dense block`: a three-node tree on the left, the kernel each node dispatches to
on the right, walked leaf-first one node per beat, the node and its card lit together. The two
expressions are `sum(d ⊙ x)` and `(B x)[(0,3)]`, the second on SC2's own numbers, so its cards
are the thesis's `fig:permuted-dense` and `fig:permuted-dense-index`. The contrast between the
frames is the claim the bullets used to assert: the `result` column reads CSR / CSR / CSR, then
CSR / PD / PD.

The table is now the backup `the ten kernels`, next to `which kernel runs on which pair`, with
the two claims the worked paths cannot make: that ten kernels cover the whole library, and that
the dense form is absorbing — a claim about *binary* operands, which a unary `index` cannot
demonstrate. `plans/defence_timing.md` was re-synced in the same pass.

---

## [x] 5. SC3 "Closed under the operations we need" — `presentation.tex:1298` — **cut**

Its 2×2 grid and the intersect/`dgemm` bullets are already carried, in fuller form, by backup
**SUM2** (`presentation.tex:2081`) — the 3×3 dispatch table plus the written-out product
identity $\mmat{B}^\top\mmat{A} = \mmat{S}_{c_B}^\top \mmat{X}_B^\top (\mmat{S}_{r_B}
\mmat{S}_{r_A}^\top) \mmat{X}_A \mmat{S}_{c_A}$.

So this is mostly deletion. **Before deleting, verify nothing on SC3 is unique to it** — in
particular the closing line *the dense form is absorbing: a sparse operand never flattens a
block*, which is the section's punchline and should survive on the new closing frame (6).

---

## [x] 6. NEW — section close

Your ask, four parts:

- dense blocks stay dense end to end — the structure is never flattened into (row, column,
  value) triples
- existing CVXPY backends convert everything to sparse
- other modelling languages have no equivalent — no atom library, so a norm is left to the
  solver or written in conic form by hand
- a quick word on other work

This frame is also what lets the Conclusion be short — see **D-R4** in
`deck-comments-04-conclusion.md`. Do this one before that one.

**Sources.** `6-Revue_litterature.tex:493-504` (CVXPY's backends store dense constant data as
sparse matrices), `6-Revue_litterature.tex:884-887` (AMPL/JuMP have no atom library), and
backup **B-OTHERLANG** (`presentation.tex:1869`) and **B-GAP** (`:1901`), which already hold
the evidence for the last two points.

---

## [x] D-SEC — the section title — `presentation.tex:1146`

**Option 3 applied.** The deck is now Introduction / Example / SparseDiffEngine / Results /
Conclusion. `Parametric canonicalization` is gone as a section: its three method frames (Two
passes, What the symbolic pass stores, The parameter maps) moved into SparseDiffEngine, ahead
of the section close, and all four results frames (First canonicalization, Performance
profile, Peak memory, Parametric problems) collect under `Results`.

`What this buys` gained a bullet on the two-pass split, since it now closes a section that
covers the caching as well as the representations.

**Later trim.** The frame was then cut back to the two claims the design makes (dense stays
dense, structure found once). The CVXPY-backends bullet (triples, DPP required) and the
AMPL/JuMP bullet were four long bullets' worth of asserting a contrast before any data was
shown, so they came off the slide and are spoken instead; B-GAP and B-OTHERLANG already carry
the evidence. Parts two and three of the ask in item 6 above are therefore spoken, not on the
frame.



> on second thought maybe this should be called SparseDiffEngine?

Paired with the same question on the next section (`:1406`, "maybe this should be results?").
The five section names are read five times — once per outline frame — so they carry more than
their length suggests.

| | Single canonicalization | Parametric canonicalization | notes |
| --- | --- | --- | --- |
| 1 | *(keep)* | *(keep)* | parallel, descriptive |
| 2 | SparseDiffEngine | *(keep)* | names the artifact once |
| 3 | SparseDiffEngine | Results | R3 moves out of the parametric section; R1, R2, memory and R3 collect into one Results section |

Option 3 is the biggest change and the clearest arc — it stops results from being interleaved
with method in two different places (R1/R2 sit inside this section today).

**Decide before the overview frame (1) is written:** options 2 and 3 change where `\sde{}` is
first named.
