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

**Done three times — 2026-09-22, and this is where it rests.** The twins are cut. Walking a tree
node by node is a traversal, and the thing being claimed is a comparison: *the same operation,
one implementation per representation*. That is a row of a table, not a beat of a walk, and six
shown slides for it was the wrong price. The frame is now `One kernel per representation`
(SC3) — three of the ten kernels against two representation columns, static, one slide:

| | generic sparse (CSR) | permuted dense |
|---|---|---|
| `index`, `A[r,:]` | copy the column indices | intersect `r` with the selected rows |
| `BA`, `B A` | Gustavson's algorithm | one `dgemm` |
| `add`, `A + B` | CSR views of both operands — *the sum is where the dense path stops* ||

Which is, in the end, the illustration this file recommended in the first place: the `index`
example of `7-Theme1.tex:427-437`, one operation in three representations. The third
representation is a grey line under the table rather than a third column — on a stacked block the
same dense kernel runs per block and the empty blocks are dropped. The `add` row's cell spans both
columns on purpose, so the one operation with no dense implementation *looks* like one. Both
backups stay. The two worked expressions the twins drew, `sum(d ⊙ x)` and `(B x)[(0,3)]`, are now
spoken over the table — a finger on the `BA` row, then the `index` row — and are recorded in the
frame's `%` comment. `plans/defence_timing.md` re-synced again: −1 frame, −5 shown slides, −0:50.

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

---

## Read-through of the built deck — 2026-09-22, second entry

Three comments on the engine section, plus the decision that reshapes the whole deck. All done,
all deleted from the source.

### SC-OV "Overview" — what the library is
> SparseDiffEngine is a small C library which computes sparse Jacobians and Hessians.
> from expression trees of atoms from the CVXPY library.
> can we then do matrix representations.
> maybe let's not say generic sparse? Just sparse matrix?
> and then a small graph of what they look like below them could be nice.
> and then the one sentnece bullet point can be: goal is to use different
> representations to exploit the different structures in the problem data.

All five. The lead opened on the contribution — *new matrix classes for the structure the
problem data already has* — and left the room to work out what the thing being contributed to
actually was. It now says what the library **is** first, Hessians included (they are real:
`7-Theme1.tex:24`, `:744-746`), and the three representations arrive as the second half of that
same sentence.

**`generic sparse` → `sparse`, deck-wide.** Four occurrences on slides, plus the `%` blocks. The
word `generic` was drawing a distinction the three boxes already draw, and it made the default
sound like a fourth representation.

**Each box gets a sketch under it** — scattered dots, one shaded block, two shaded blocks — in
the preamble's existing `nz` and `matframe` styles. This is exactly what the three grey notes
used to say in words before the 2026-09-21 concision pass cut them; a picture says it in no
time at all, which is why it can come back when the text could not.

The closing line is your sentence, in polyblue. The old BLAS line moves to SC2, where the
representation that needs BLAS is actually on screen. **+0:05** (0:45 → 0:50).

Later the same day, the tail of the lead came off too:

> one Jacobian per expression node, in one of three matrix representations — let's cut this.

Right — it was announcing the three boxes sitting directly underneath it, and the closing line
already says what they are for. The lead now stops at *…from the expression trees of CVXPY
atoms*, which is the whole of what the frame has to assert in text.

**Spoken instead**, and it is the sentence that makes the three boxes mean anything: one
Jacobian per expression node, and the node's atom picks which of the three it allocates
(`7-Theme1.tex:121-127`). Say it while the boxes are on screen — it is in the frame's `%` block.
Budget unchanged.

### SC2 "Permuted-Dense matrix" — the definition, and the figure
> I think we should cut this definition with S matrices that are not even shown.
> we don't need to define it so clearly.
> what is a permuted dense matrix exactly? it is a dense matrix block
> that is contained within a larger and sparser matrix. …
> one bullet point on exploiting dense matrix algebra
> like BLAS: basic linear algebra subprograms. (available in most computers).
> maybe the matrix doesn't need to be shown then? and the rows/columns also?
> maybe this could be better motivated with a more scattered
> matrix? with disjoint columns and rows? and maybe even empty rows?

**Decision: keep the matrix, redraw it scattered.** The matrix stays — it is the only place in
the deck where the correspondence between $\mmat{A}$ and $\mmat{X}$ is visible, and the row
tints carry it. But the thesis's own figure (`fig:permuted-dense`) puts the block on four
*adjacent* rows at two *adjacent* columns, which is a picture of a contiguous submatrix and
teaches exactly the wrong thing: the whole point of the representation is that $\mvec{r}$ and
$\mvec{c}$ are arbitrary index vectors. So $\mvec{r} = (0,2,3,5)$ with empty rows between the
occupied ones, and $\mvec{c} = (4,7)$ with two columns of zeros between them. Six rows instead
of four; same tints, same $\mmat{X}$.

**$\mmat{A} = \mmat{S}_r^\top \mmat{X} \mmat{S}_c$ is cut.** It defines the representation in
terms of two selector matrices that are never drawn, never named again in the presented deck,
and never formed in the code. What replaces it is the sentence it was standing in for:
*a permuted dense matrix is a dense submatrix of a much sparser one — its rows and its columns
need not be contiguous.* ($\mmat{S}_r$ and $\mmat{S}_c$ do survive in the SUM2 backup, where the
product of two permuted dense matrices genuinely needs them written out.)

**The BLAS bullet is added**, with `lawson1979blas` and `dongarra1990level3` cited in grey under
it. It is the other half of why the representation exists and the frame never said it.
**+0:10** (1:05 → 1:15).

**The lead line is cut, later the same day — the redraw made it false.**

> the Jacobian of Bx with dense B ∈ R^4×2, for the entries of x at columns (4,7) — this is not
> true anymore right? let's maybe cut it?

Correct, and it is worth writing down why, because the same trap is one redraw away at any time.
The sentence is a true description of the **thesis** figure, which is 4 × 10: $\mmat{B}\mvec{x}$
has four output entries, so its Jacobian has four rows and every one of them is occupied. The
redrawn $\mmat{A}$ has six rows with two of them empty, and no Jacobian of a four-output
expression can have an empty row. Four rows of $\mmat{B}\mvec{x}$ landing at rows 0, 2, 3 and 5
is a claim about where the block sits inside a *larger* matrix, which the sentence never made.

Cut rather than repaired: the frame is about the storage format, and beat 2's definition is what
explains the picture.

Two things it was carrying, and where they went:

- **The word "Jacobian" is no longer on this frame.** It is introduced on *Overview* — "computes
  sparse Jacobians and Hessians" — and used again on the kernels frame, so the section still has
  it. But the sentence tying *this picture* to a derivative is now **spoken**, and it is worth
  saying: this is what the Jacobian of one expression node looks like when its data is dense.
  What licenses it is I5's accent arrow, $\mmat{A} = \partial\mvec{h}/\partial\mvec{x}$.
- **$b_{ij}$ is unlabelled by the prose** and reads as "the entries of the block", which is all
  beat 2 needs it to be.

If a lead is wanted back, the true one-liner for this picture is *a dense block at rows
$(0,2,3,5)$ and columns $(4,7)$ of a much larger matrix* — but it says what the display says.

### SC3 → "One operation, two kernels"
> I really don't like this table currently.
> I would like something like: just one matmul for example.
> and then show a kernel, like dense_BA_matmul or something, doesn't
> matter if its a real name or not. just basically show that
> for an identical operation, but different datatypes, we will
> do different operations.
> and we can add a bullet point, about being aware of these things.
> I'll come back to this later.

Built rather than deferred; come back to it if it still reads wrong.

This material has now had **four** shapes in three days — a ten-kernel table beside three
bullets, then two twinned tree-walks, then the three-row table of the entry above, and now this.
The three-row table lasted one day and the diagnosis is the same one that killed the twins, one
level up: it read as a reference card. Three operations across two representation columns, six
cells, nothing to look at first. And the claim it was making is not a list — it is a
substitution. The same product, and the representation of the operand decides which C function
runs.

So: one operation, $\mmat{C} = \mmat{B}\mmat{A}$, and two named entry points side by side.
`BA_csr_gustavson(B, A, C)` against `BA_pdense_dgemm(B, X, r, c)`. The names are illustrative,
not the library's — the kernel is `BA` in the thesis (`7-Theme1.tex:405`) and the suffixes say
which representation and which algorithm, which is the whole point of putting them next to each
other. Your bullet, *about being aware of these things*, is the first of the two: **the kernel
is chosen by the representation of the operand, not by the atom**.

`index` and `add` come off. `index` was the thesis's three-representation illustration and is
still the second bullet of the *ten kernels* backup; `add` has a backup of its own. The closing
bullet still says *in a **product***, which is the careful half of the claim `add` was there to
protect. **+0:05** (0:45 → 0:50).

### PC1/PC2 — the decision
> let's put everything related to the two passes in the backup
> I decided I want to focus solely on the first and more important contribution.
> the matrix classes. I won't have time to talk about everything.

Done. *Two passes* and *What the symbolic pass stores* are backups 13 and 14; *What this buys*,
which was this section's close, is cut outright. Its punchline — *the structure is in the
problem already; the engine is what keeps it* — moves to the Conclusion, which is the only other
place in the deck it can end. See `deck-comments-03-parametric.md` for the rest of the demotion
and `plans/defence_timing.md` for what it does to the clock.

**The section is now four frames**: Overview, CSR, Permuted-Dense, One operation two kernels.
Five shown slides, 3:35. It is the shortest it has ever been and it is the only argument the
deck makes.

---

## Read-through of the built deck — 2026-09-22, third entry

### SC3 "Algorithms" — shape five, and the last of the invented names
> maybe just say we choose the kernel based on the representation of the operand
> i dont actually like these two examples.

The two examples were `BA_csr_gustavson(B, A, C)` and `BA_pdense_dgemm(B, X, r, c)`, side by
side, one per representation. They were **illustrative names, not the library's** — the kernel
is `BA` in the thesis (`7-Theme1.tex:405`) and the suffixes were invented here to say which
representation and which algorithm. A frame whose centre is two invented identifiers asks the
room to read an example when the claim it is making is a rule.

The rule is the frame now: the ten operations on the left, three arrows, one per
representation, and a note above the fan — *the representation of $\mmat{A}$, not the atom,
picks the kernel that runs*. The three boxes are SC-OV's three boxes, in SC-OV's order and
colours, which is what lets the arrows go unlabelled.

**Follow-up, same day:**
> maybe here we can have a small table on the left?

The left box was *an operation on $\mmat{A}$ / one of ten*, which asserted the number where it
can just as easily be counted. It is now the ten operations by name, two columns of five, in
the order of `tab:kernel-operations`: `transpose`, `index`, `sum_row_partition`, `promote`,
`broadcast` in the first column, `DA`, `sum_matrices`, `BA`, `BTA`, `BTDA` in the second. Same
room, and the number is now something the room can check. What each one computes, and which
atoms call it, stays in the *ten kernels* backup.

**What came off with the names.** The `Gustavson (1978); Dongarra et al. (1990)` line: nothing
on the frame names either algorithm any more. Both stay on *References* — Dongarra is cited on
SC2 (*Permuted-Dense matrix*), Gustavson on the *which kernel runs on which pair* backup. And
both are **spoken**, with a finger on the boxes: on the sparse form the product merges rows,
Gustavson's algorithm; on a block it is one BLAS call and the result is a block again. The two
worked paths, `sum(d ⊙ x)` and `(Bx)[(0,3)]`, are still spoken, now off the kernel names
themselves.

**No lead line.** One was written in this pass — the thesis's own opening of the kernels
section, *an atom does not touch a representation directly, it calls a kernel* — and then cut:
the title, the box and the note say it, and the sentence was the two lines that pushed the
second bullet off the bottom of the frame. `\vspace` before the bullets went 2.5ex → 1ex in
the same fix.

**Δ +0 frames, +0 shown slides, +0:00** (0:50). The cue in `plans/defence_timing.md` changes
from "left box, then right box" to "the ten names, then the three representations".

**Follow-up, same day — the table needs its legend.**
> here we should add a bullet point that is the Jacobian of the children and that B and D
> are data matrices?

Added, as the frame's *first* bullet, above the two claims. Four of the ten names — `DA`, `BA`,
`BTA`, `BTDA` — are unreadable without it, and it is the caption of `tab:kernel-operations`
(`7-Theme1.tex:388-391`) saying the same thing for the same reason. It also gives the note above
the fan a subject: of the symbols in those names only $\mmat{A}$ has a representation, which is
why it is $\mmat{A}$'s representation that picks the kernel.

It was written as *$\mmat{A}$ is the Jacobian of the children; $\mmat{B}$ and
$\mmat{D} = \diag(\mvec{d})$ are data matrices*, and then:

> I think the jacobian of the children is a bit complicated.. do we really need to say that?

No. It now reads **$\mmat{A}$ is a Jacobian; $\mmat{B}$ and $\mmat{D} = \diag(\mvec{d})$ are
problem data**. The precision was real — it is the *child* node's Jacobian that the parent's
kernel is handed — but nothing on this frame or after it turns on *whose* Jacobian
$\mmat{A}$ is, only on the fact that $\mmat{A}$ has a representation and $\mmat{B}$ and
$\mmat{D}$ do not. *Of the children* is spoken if it is asked for.

Still one slide, still 0:50 — the legend is pointed at, not read out.

**Follow-up — the kernel names come back, one operation across the three boxes.**
> maybe under sparse and the others we can have for example sparse_sum_matrices..
> and also pd_sum_matrices?

Yes, and it is what turns the fan from a list into a substitution. Each box now carries a
second line: `sparse_index`, `pd_index`, `spd_index`. The link is colour and nothing else —
`index` is polyblue in the table on the left and polyblue in all three names — so it needs no
fourth arrow and no label.

**Not `sum_matrices`, and this is the one thing to keep straight about the frame.** Addition is
the single operation with *no* dense implementation: both operands are read through their CSR
views and the result is generic sparse, so there is no `pd_sum_matrices` to put in that box
(`7-Theme1.tex:417-437`, and the backup *addition is where the dense path stops*). Putting one
there would make the slide claim the opposite of the backup behind it. `index` is the thesis's
own three-representation illustration (`:427-437`) and the only operation written out in all
three, which is exactly why it was the `index` row of the cut table and why it is here now.

Note these are *shaped like* the library's names, not lifted from it — the kernel is `index`
and the prefix says which representation. That is a different thing from the cut
`BA_csr_gustavson`, which also encoded a named algorithm the frame was not otherwise
discussing.

Spacing: the boxes went from one line to two, so the fan spread went 1.55 → 1.75, the note
above it 2.25 → 2.55, and the `\vspace` before the bullets 1.5ex → 0.3ex. The frame is within
0.2pt of full and there is no room left on it.

---

## Read-through of the built deck — 2026-09-23

### SC-OV "Overview" — which structures, exactly
> we could add that there is both a problem level structure and the dense block structure?
> maybe as a bullet point? and that can appear as a follow-up unveiling slide?

Both, and as a second beat. The closing line has been promising *the different structures in the
problem data* since the frame was rewritten, without ever saying what they are — the room is
asked to hold an unnamed plural through the whole section. Beat 2 names them, in the order of
the three boxes:

| | | which box |
|---|---|---|
| **problem level** | the canonicalized data is mostly zeros | sparse |
| **block level** | each data matrix enters as a dense block inside it | permuted dense, stacked |

Both halves are *already drawn* on the frame — the scattered dots and the shaded blocks in the
sketches under the names — so the beat labels what has been on screen for a beat rather than
introducing anything new. That is why it can be two short lines and not a paragraph.

`\onslide`, not `\only`: the two lines reserve their room on beat 1, so the boxes above do not
move when they arrive. It is the only overlay in the engine section, which is deliberate — the
rest of the section is static frames, and a beat here reads as an unveiling rather than as the
section's habit.

The pair is also the map of what follows: *Compressed sparse row* is the problem level,
*Permuted-Dense matrix* the block level, in that order. Backwards, it is the pair
*Structure in the problem data* set up one section back on the running example's own
$[\mmat{A}\ \mvec{b}]$ — which is where the room last saw both structures in one picture.

**Δ +0 frames, +1 shown slide, +0:10** (0:50 → 1:00). `plans/defence_timing.md` re-synced:
55 shown slides, *SparseDiffEngine* 4:40, and the last three checkpoints move to 19:35, 23:00
and 25:25.
