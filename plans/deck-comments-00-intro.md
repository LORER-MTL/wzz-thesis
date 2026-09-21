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
