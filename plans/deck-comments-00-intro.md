# Deck comments — Introduction

Working checklist for the comments left in `presentation.tex`. One entry per turn: make the
edit, `make presentation`, confirm, tick the box. Line numbers are as of the working tree on
2026-09-20 and will drift as entries are done.

Cross-cutting decisions live in the master plan; **D-SEC** (section names) should be settled
before the I5 entry, because it decides where `\sde{}` is first named.

---

## [x] I0 "Optimization in practice" — `presentation.tex:256`

Three comments on one frame; do them together, they interact.

### `:277` — staging
> this should appear after the problem formulation example with min. f(x)...

The `ex` exbox (the min/s.t. display) is currently beat 2 and `ml` (modelling language) is on
beat 1. Swap them: `ex` to beat 1, `ml` to `visible on=<2->`. Bullet 2 already fires on beat
2, so it stays aligned with `ml`.

### `:278` — the curved bridge
> also maybe we should draw it from modelling to solver and the arrow can be curved? sort of
> like a symbolic bridge?

Replace the straight `zoomline` from `ml` down to the arrow midpoint with a curved path
`(mod) to[bend left=35] (solv)` arching over `prob`, carrying `modelling language` as a node
on it.

**Risk.** The arc grows the picture's height and `\fitfig` pays for that by shrinking every
label on the slide. Draw the arc with `visible on=` rather than `\only` so the bounding box is
identical on both beats, and compare label size against the current build before keeping it.
If it shrinks noticeably, fall back to the straight annotation.

### `:296` — first bullet becomes examples
> maybe first bullet can be examples of what you want to optimize
> operate grids reliably and efficiently, control a car or plane, manage a portfolio, design a
> circuit, etc.

New bullet 1 with the four examples; the current "the formulation says what you want, not how
to compute it" slides to bullet 2.

### `:301` — last bullet, scope
> maybe we won't talk about: - how to model a problem in a particular domain, how the solvers
> work to find the solution efficiently, and what to do with x^* once it is computed
> that could be the last bullet point.

**Decision D-I0.** No other frame in the deck talks about the talk. Two phrasings:
1. as written — "we will not talk about ..."
2. about the picture — "not here: domain modelling, solver internals, what happens to x*"

(2) keeps the register. Pick at edit time.

**After:** 4 bullets + 2 figure beats. Re-check the `\vfill … \vfill` still balances.

---

## [x] I1 "Convex optimization in practice" — `presentation.tex:391`

### `:485`
> maybe the algorithms could be a next slide? so we can first talk about just the compilation
> aspect?

**Decision D-I1**, three ways:

| | change | Δ frames |
| --- | --- | --- |
| (a) | both standing boxes (`algorithms` + `solvers`) move to a new frame after I1; I1 ends on the two questions | +1 |
| (b) | only `algorithms` moves | +1, and it splits a visual pair |
| (c) | cut the `algorithms` box, say it aloud, keep `solvers` here | 0 |

(a) is cleanest, (c) is cheapest against the time budget. (b) not recommended.

Either way the two question boxes renumber from beats 3/4 to beats 2/3.

---

## [x] F2 "DCP-based modelling languages" — `presentation.tex:517`

### `:522`
> maybe bring back cvxpy in the list?
> and then we can have a follow-up slide which is identical to this one which highlights CVXPY
> specifically — don't make another slide necessarily, but reuse this and add a tag.

Merge bullet 2 into bullet 1, so the survey reads CVX, Convex.jl, CVXR, YALMIP, CVXPY. On a
new final overlay, recolour CVXPY polyblue with `\alt<3->{{\color{polyblue}\cvxpy{}}}{\cvxpy{}}`
on a new final overlay. The tag line under the list (*the one this thesis targets — open
source, so the backend can be replaced*) was written and then cut: the recolour carries the
point on its own.

Beats go 2 → 3. ±0 frames.

---

## [x] I1b "Canonicalization" — `presentation.tex:537`

### `:594`
> maybe this can be a bullet point? then we can add another one about our focus being on the
> backend. then we wouldn't really need to bold the backend and add this thesis, I think it's
> not that nice afterall on the slide.

- Remove the `ex` exbox (AMPL `.nl` / JuMP MOI / CVXPY expression trees) and its zoomline.
- Remove the `\alt<3->` bold + "this thesis" label on the backend arrow.
- Add two bullets under the picture:
  1. the intermediate form is a choice — AMPL `.nl`, JuMP MOI, CVXPY expression trees
  2. this thesis works on the backend
- Beats drop 3 → 2.
- The panel's `0.76\textheight` override must come down to make room for the bullets; try
  `0.62` and check the chain still reads.

**Open:** whether the arrow keeps the accent colour once the bold is gone. Colour alone may be
the right amount of emphasis — decide by looking at the build.

---

## [x] I5 "Problem statement" — `presentation.tex:615`

Three comments. Do the `:756` one last; it depends on **D-SEC**.

### `:635` — gap from the title
> I think this should have a bigger gap from the title, its a bit cramped and I think we can
> have some room.

`\vspace{-2ex}` before the locator strip becomes a positive space. Pay for it by trimming the
figure cap (`0.38` → `0.34\textheight`) or out of the bullet cuts below.

### `:743` — the text is too much
> I think this text might be a bit too much. let's cut it.
> I want some text under one expression tree per cone constraint.. that says describes Ax-b but
> as a bunch of functions.
> I think the bullet points should just have one thing: the main idea or takeaway of the slide.
> and a summary of the problem which is going from multiple constraints to one big description
> of everything.
> but also maybe that's why it would be nice to have a sort of box maybe on each side?
> what do you think? This slide is already quite dense.

- The forest's note becomes something like *one tree per cone constraint — together they are
  b − Ax*.
- Bullets 1 and 2 collapse into the single "many constraints → one description of everything"
  line.

**Decision D-I5 — boxes on each side, or stronger notes?** The figure already carries a note
under each half (`one tree per cone constraint…` and `[A b], explicit and sparse`). Adding
boxes duplicates them and re-crowds a slide this comment calls dense. **Recommendation:**
strengthen the two notes, no boxes.

### `:756` — cut the SparseDiffEngine clause
> this can be cut, I will make sure to talk about this in the implementation section

Trim the last bullet to *the goal of this thesis is to reduce CVXPY's compilation time*.

**Consequence:** `\sde{}` is then never named before the method section. The new overview
frame in `deck-comments-02-single-canon.md` has to introduce it. Do not tick this box until
that entry is scheduled.

---

## Read-through of the built deck — 2026-09-22

Five comments, all in the Introduction, all done. Each is quoted from `presentation.tex` as it
stood that morning, and the comment itself is deleted from the source now that it is answered.

### F0 "Optimization in practice" — the third bullet
> this last one can maybe be not in this talk:? how to model a problem.
> and how does the solver work?

The bullet read *not here: modelling a problem in a domain, how the solver finds* and broke off
mid-sentence — the line had been trimmed once too often. It is now two named things:
*not in this talk: how to model a problem in a domain, and how a solver works*. These are the
two scope questions a jury asks first, and fencing them off explicitly on the opening frame is
worth the line.

### I1 "Convex optimization in practice" — the `algorithms` box
> format this so that it fits a bit better and we can distinguish that its 4 things.
> maybe add commas too.

Four algorithms separated by `\quad` read as two lines of prose. They are now commas plus a
fixed first column set with `\makebox[2.7cm][l]`, so the two rows align into a grid: interior
point / simplex (LP) on the left, operator splitting / active set (QP) on the right. Same
content, same grouping as the old rows, transposed into columns.

### F2 "DCP-based modelling languages" — the arrow, and the AMPL bullet
> maybe we can add an arrow on top of cvxpy at the same time as 3? so that
> we can better visually see that its now blue?

Done. The word is wrapped in a `tikzpicture` with the arrow drawn under `visible on=<3->`, so
the bounding box — and therefore the line height — is the same on all three beats and nothing
reflows when the arrow appears. It costs 4mm of leading on that line, permanently.

> \item AMPL, GAMS and JuMP do not implement DCP % maybe cut this if its not really important.
> I agree, because we shouldn't mention things which we don't really use later on.

Cut. Nothing in the presented deck names AMPL, GAMS or JuMP again; the backup *two ways to get
the coefficients* is where they live.

Also on this frame, and not from a comment: **`diamond2016cvxpy` is now cited here**, in the
deck's grey attribution style. This is the frame that singles CVXPY out, and the deck had gone
its whole length without citing the system it is about. See the References entry in
`deck-comments-04-conclusion.md`.

### I1b "Canonicalization" — the last note of the pipeline
> we should maybe emphasize sparse matrices? and say this is the form
> required by solvers.

The note under `P, A, b, c` is now bold, with a second line: *the form the solver requires*.
It is the only box on that strip the thesis touches, and the whole engine section is spent
inside it.

### I5 "Problem statement" — the note, and the trees
> maybe we can put a newline here? before b-Ax?
> also feel free to take more room with the trees on the left.

Both. The note breaks after *one tree per cone constraint*, which was the element binding the
picture's width on that side; the room it frees goes to the forest, whose scope is now at
`scale=1.55` with the node radii grown 2.4mm → 3.5mm by hand (coordinates scale, absolute sizes
do not).

**Follow-up, same day** — the enlargement broke the arrow label:

> can we move the trees to the left? the sparse derivative text is over it?

It was. At `scale=1.55` the third tree reaches $x = 3.80$ and the arrow's landing point is
pinned at $4.76$ — `rpanel` cannot move right without putting the arrowhead on the $\cone{K}$
labels — which left under a centimetre of arrow for a two-line edge label needing about two, so
`sparse derivative` sat on top of the tree. The forest scope now carries `xshift=-1.6cm`
**before** `scale`, so a point $p$ lands at $-1.6 + 1.55p$ and the gap opens to 2.6cm. The note
moves with it, to $(-1.6, -1.25)$, so it stays centred under the forest.

It costs about 8% on the whole picture, which is width-bound by the forest on one side and the
matrix on the other — the trees still render well above where they were before the scale went
up. If this ever needs to be undone, the trade is: shrinking the scale closes the gap for free,
shifting left opens it at 8%.

### Later on 2026-09-22 — two follow-ups on the same two frames

**I5 "Problem statement" — the arrow label.**
> matrix stuffing — I don't want to introduce this term, maybe just sparse derivative?

Done: the accent arrow reads `sparse derivative` over $\mmat{A} = \partial\mvec{h}/\partial\mvec{x}$.
`matrix stuffing` is what the literature calls the step (`5-Introduction.tex:83-86`) and it stays
in the thesis, but that arrow was the only place the deck would have used it — a name the talk
does not go on to need is a cost with no return. `sparse derivative` says the same thing in the
words the line underneath then writes down, and it is what `SparseDiffEngine` and the word
Jacobian both land on later. B3a's header comment is updated to match; it referred to "what
matrix stuffing produced for this problem".

**F2 "DCP-based modelling languages" — cite the rest of them.**
> instead of just citing this can we also cite yalmip and maybe grant and boyd for cvx?

Yes, and all five rather than three — the bullet names five systems and citing three of them
would read as an oversight. The grey line carries them in the bullet's own order, so the two
lines read off each other:

| System on the bullet | Citation | Key |
|---|---|---|
| CVX (MATLAB) | Grant and Boyd (2008) | `grant2008graph` |
| Convex.jl (Julia) | Udell et al. (2014) | `udell2014convex` |
| CVXR (R) | Fu et al. (2020) | `Fu_2020` |
| YALMIP (MATLAB) | Löfberg (2004) | `lofberg2004yalmip` |
| CVXPY (Python) | Diamond and Boyd (2016) | `diamond2016cvxpy` |

For CVX this is `grant2008graph` — *Graph implementations for nonsmooth convex programs* — and
not the `cvx` software entry, whose author field in `Document.bib` is "CVX Research, Inc." rather
than Grant and Boyd. If you want the software cited instead, that entry exists and the bib is
what would need changing, not the slide.

The References frame goes from nine entries to thirteen.

> maybe split the citations into two? … I meant the references slide.
> … yeah sure two slides.

**Two frames**, *References* and *References (continued)*, seven entries then six, alphabetical
straight through. Each is a single full-width list at `\footnotesize`.

Three shapes were tried and the reasoning is worth keeping, because this slide will be on screen
longer than any other: one column of thirteen needed `\scriptsize` and filled the frame edge to
edge; two columns on one frame fixed the density but gave every entry three short broken lines
and forced abbreviated journal names; two frames give two clean lines per entry and the full
titles. **Δ +1 presented frame, +1 shown slide, +0:00** — neither frame is spoken. The first is
what the deck sits on during questions; the second is where it goes if the question is about a
reference on it.
