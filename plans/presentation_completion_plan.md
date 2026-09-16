# Completing the defence deck — working plan (2026-09-16)

Target: ~30 minute defence, October 2nd.

> **Status, 2026-09-16: Batches 1-4 are done** (`2bc33bc`, `85a8a14`, and the commit that
> carries this line). The deck is 33 content frames + 1 outline + 10 backups, 52 PDF pages,
> building clean. Two things in the plan below were *not* done and should not be: the
> retarget of `B-DCP` (unnecessary once `F1` became the short grammar slide), and the
> trimming of `I5` (it reads fine at size; cutting content there is a call for the author).
> What remains is rehearsal against the clock.

`presentation.tex` is largely written — 31 content frames, 9 backup frames, 50 PDF pages — but
three frames in the Introduction are still empty `\vfill` placeholders, and the deck has no
contributions or future-work slide.

The deck's existing architecture is deliberate and is preserved here: the Introduction is three
nested zoom levels of one pipeline sharing a fixed geometry so the figure never moves between
slides; the Example section twins the Introduction slide-for-slide (concept → instance); and the
accent colour is rationed to exactly three arrows, which are the thesis.

Two findings constrain what is possible:

1. **The thesis contains no argument for why convex problems are special** — no tractability,
   global-optimum, or LP/QP/SOCP/SDP material anywhere in the `.tex` sources. `I0b` cannot be
   lifted from the prose.
2. **`copt_talk.pdf` supplies exactly the three missing slides.** The COPT talk (Cederberg,
   Zhang, Nobel, Boyd; Shanghai, May 2026; committed at `fcfd6b6`) opens with `Convex
   optimization` (pp. 3-4), `Disciplined convex programming (DCP)` (pp. 5-6) and `Modeling
   languages implementing DCP` (pp. 7-9) — the same three beats, at the right altitude for an
   introduction, already written and already delivered. Batch 2 adapts them instead of building
   from the thesis prose, and the thesis line references survive only where they add something
   the COPT slide does not have.

Budget: 31 content + 5 outline frames today. Adding five slides at ~30 min needs four removed,
so the structural trims in Batch 1 are part of the plan, not optional polish.

---

## Batch 1 — structure (do first; cheap, no prose, frees the budget)

**1. Retitle `I1` (`presentation.tex:274`).** `Convex optimization` is currently the title of
three frames: `I0b` (:239), `I1` (:274), `F3a` (:644). `F3a` twinning `I0b` is intentional; `I1`
sharing it is not, and becomes confusing the moment `I0b` has content. `I1`'s payload is the
level-2 zoom, problem → conic form → solver. Retitle to **"From convex problem to solver"**.

**2. Drop the per-section outline frames (`presentation.tex:69-75`).** `\AtBeginSection` emits
five outline frames. Replace with a single `\tableofcontents` frame after the title page. Saves
four slides and roughly two minutes. One-line revert if the jury preference is otherwise.

**3. Move `SUM` "Ten kernels is the whole library" (`:1428-1475`) into the appendix.** It is a
method slide sitting in the Conclusion section, and it is the densest frame in the deck (a
10-row table plus four multi-line bullets). Retitle `Backup: ten kernels is the whole library`
and move below `\appendix`. The Conclusion then reads: contributions → three observations →
future work → thank you.

**4. Merge `B4` into `B3` as a second overlay (`:787-867`).** `B4` redraws `B3`'s exact matrix
with everything greyed but `μ` and `-g`. Making it beat 2 of `B3` is both a slide saved and a
better animation — it matches the deck's established grammar of revealing emphasis without
moving the picture. Implement with `\only<1>{...}\only<2>{...}` around the whole `blockarray`
pair and around the bullet list; the two copies have identical content so nothing shifts.
Retitle the merged frame **"Canonicalization: the backend"**, keeping `\recallstrip{3}`.

**5. Shorten `I1c` "Conic form" (`:250-269`).** It currently carries the display plus two
bullets, the second of which enumerates all six standard cones. Nobody retains a six-item cone
list, and `F2` will re-state the conic form anyway as the target of synthesis. Cut to the
display plus one line: the problem data is four arrays `P`, `A`, `b`, `c`, and `K` is a product
of standard cones. The enumeration moves to the `B-DPP` backup or is dropped.

`I1c` cannot be cut outright, despite `F2` covering the same ground: `I1` (the level-2 zoom)
draws `problem → compilation → conic form → solver`, and its header comment records that `I1c`
was placed before it precisely so the target of that arrow is already familiar. `F2` comes after
`I1` in the running order, so it cannot do that job.

Net after Batch 1: 29 content frames, 1 outline frame.

---

## Batch 2 — the three empty Introduction frames, adapted from the COPT talk

All three come from `copt_talk.pdf`, kept short and built as overlays, which is how that deck
paces them. Adapting them costs almost nothing and they have already survived a live audience.

Three adaptations apply to all three slides, and matter more than the wording:

- **Notation.** COPT writes the conic form as `minimize cᵀx  s.t.  Ax + s = b,  s ∈ K`, with an
  explicit slack `s`. This deck writes `minimize ½xᵀPx + cᵀx  s.t.  b − Ax ∈ K` (`I1c:250-269`,
  `I1:300-305`, `SC1:992-997`). **Use the deck's form.** Importing COPT's would contradict every
  other frame and silently drop `P`.
- **Bullet style.** COPT uses Boyd-style `I` triangles and lowercase fragments; this deck uses
  `\begin{itemize}\small\bul`. Re-set the text, do not transcribe the layout.
- **Citations.** COPT writes `[Grant et al., 2006]` inline. The deck has `\bibliographystyle` but
  no `\bibliography`, and the Makefile target runs no bibtex — so attribution is a grey
  `\scriptsize` line at the foot of the frame, as on `R2` and the cut Boehm slide.

### `I0b` "Convex optimization" (`presentation.tex:236-242`)

COPT pp. 3-4, essentially verbatim. Two beats:

- Display: `minimize f₀(x)`, `s.t. fᵢ(x) ≤ 0, i = 1,…,m`, `gⱼ(x) = 0`. **Use the deck's own
  form from `I0` (`:226-229`)** — `gⱼ(x) = 0` rather than COPT's `Ax = b` — so the display on
  this slide and the annotation box on the previous one are the same object.
- variable `x ∈ ℝⁿ`; equality constraints are linear and `f₀,…,f_m` are convex.
- why care about convexity?
  - beat 2: *classic answer: local optimum = global optimum*
  - beat 2: *modern answer: very actionable because of reliable software*

That last pair is the whole reason this slide exists, and it is the one thing the thesis never
says anywhere. Keep the two-beat reveal: the question lands, then the answer.

**Do not** add the parameter `θ` here — it would cost the slide its shape. Instead put the
family/instance naming on `F3` (`:617-636`), which already says "the parameters change from solve
to solve; `F` does not" and is the concrete place for it. That fixes the real gap: **the deck
uses "problem family" on `B4`, `PC1`, `R3` and `R4` and never defines it**
(`5-Introduction.tex:52-62`).

### `F1` "Disciplined convex programming" (`:397-402`)

COPT pp. 5-6, verbatim. Two beats:

- a grammar for specifying convex optimization problems (Grant et al., 2006)
- convex and concave functions are constructed by combining a set of atoms
- each atom has known curvature and monotonicity
- simple rules specify how atoms can be composed
- beat 2: a problem that follows the DCP rules is **convex by construction**
- beat 2: and can be solved globally and efficiently, in theory and in practice

This is a better `F1` than a composition-rule slide: it is the right altitude for an
introduction, and the rules themselves are already covered twice — `F3b` (`:708`) shows them
applied bottom-up to the running example, and `B-DCP` (`:1525`) is the backup that states them.

**This cancels the previously planned retarget of `B-DCP`.** Since `F1` no longer carries the
composition rules, `B-DCP` keeps them, and its atom table stays where it is. No change to the
backups in this batch.

Optional one-word addition from the thesis: atoms also declare the **sign** of their output
(`5-Introduction.tex:171-176`), which COPT omits and which `B-DCP`'s table has a column for.

### `F2` "DCP-based modelling languages" (`:404-409`)

COPT pp. 7-9. Three beats, and the most valuable steal of the three because of the
analysis/synthesis framing:

- `YALMIP` (MATLAB), `CVX` (MATLAB), `CVXPY` (Python), `Convex.jl` (Julia), `CVXR` (R)
- classic commercial software like `AMPL` and `GAMS` does not implement DCP
- beat 2: the two main tasks of a DCP-based modelling language —
  - **analysis:** verify that a high-level problem description follows the DCP rules
  - **synthesis:** build an equivalent problem in conic form *(display, in the deck's notation)*
- beat 3: no more communication between the modelling language and the solver

Two things to add to the COPT version:

1. **Name synthesis.** In DCP-based languages the synthesis step is called **canonicalization**
   (`5-Introduction.tex:37-42`) — that is the deck's own word for the rest of the talk, and this
   is where it should be introduced. `I1b` immediately after is titled
   "Canonicalization: frontend and backend", so this hand-off has to land here.
2. **Sharpen the AMPL/GAMS line** with the thesis sentence (`6-Revue_litterature.tex:884-887`):
   they have no atom library and no canonicalization step, so a norm is left to the solver or
   written in conic form by hand. That says *why* the distinction matters rather than only
   listing who is on which side.

Drop the three-row taxonomy table previously planned for this slide — COPT's flat two-line list
is shorter and makes the same point, and `Pyomo`/`AIMMS` do not appear anywhere else in the deck.

Do **not** repeat "the goal of this thesis is to reduce CVXPY's compilation time" here — `I5`
(`:598`) already closes on it.

**Watch:** the Introduction pairs run `F1` (DCP) → `F2` (languages); the Example twins run `F3c`
(code) → `F3b` (tree), i.e. the reverse order. The Example's order is forced (the code produces
the tree). Leaving them mirrored is defensible — concept-first in the Introduction,
artifact-first in the Example — but it is worth a look once both are on screen.

---

## Batch 3 — contributions and future work

### New frame: "Contributions", after `I5` (insert around `:600`)

`I5` ends the Introduction on the goal; the jury should then be told what was built before the
Example section starts. Sources: `7-Theme1.tex:1-33`, `8-Conclusion.tex:1-33`, and the COPT
talk's "Our approach to computing derivatives" slide, which is already a four-line version of
this: *developed a C package for sparse differentiation with Python bindings* / *every atom
implements its own forward, jacobian and hessian* / *our goal is still to not be the bottleneck
(spend less time than in the solver)*. That last line is the best one-sentence statement of the
goal in either deck — consider using it as the closing line of this frame.

- `SparseDiffEngine` — a C library that computes the conic problem data as sparse derivatives;
  ~17k lines, ~45 atoms, three operations each (forward / symbolic / numeric).
- Two new matrix classes, permuted dense and stacked permuted dense: dense storage and BLAS
  where the structure is dense, with no sparsity detection and no graph colouring.
- The symbolic/numeric split: structure cached once, values per solve — caching **without** the
  DPP ruleset and with no restriction on how parameters enter.
- `sparsediffpy` (Python bindings) and `diffengine` (a `CVXPY` backend with the same interface
  as the output of matrix stuffing, so the rest of `CVXPY` is unchanged).

This also fixes a live loose end: the preamble defines `\sdp` (`:154`) and it is never used —
the deck currently never names the library it is about outside one backup slide.

### New frame: "Future work", before the Thank-you frame (`:1507`)

The three directions of `8-Conclusion.tex:68-120`, one line each:

1. A standalone `sparsediffpy` interface — build and evaluate sparse Jacobians and Hessians
   without `CVXPY`, with trees built from `sparsediffpy`'s own functions.
2. `diffengine` as the default backend on the `ignore_dpp` path, and removal of `cvxcore`
   (already deprecated) — `CVXPY` would then ship no C++ binaries at all.
3. Pass the block structure along with the problem data, so presolve and factorization work on
   the dense blocks directly instead of rediscovering them in a generic sparse matrix.

Net after Batch 3: 31 content frames, 1 outline frame, 10 backup frames — one fewer shown slide
than today, with the gaps filled.

---

## Batch 4 — read-through pass

- **Density.** `I5` (`:495-600`) is the heaviest remaining frame: locator strip + figure +
  three multi-line bullets. Check it against a live read; the third bullet is the goal statement
  and must survive, the second may be cuttable.
- **Invariants.** The accent colour still appears exactly three times (`I1b:444`, `I5:588`,
  `SC1:998`); `\recallstrip` still fires on every Example frame; no frame title used twice.
- **Notation.** New frames use the `defs.tex` macros (`\mvec`, `\mmat`, `\gvec`, `\cone`,
  `\reals`, `\zeros`) and the `\cvxpy{}` / `\sde{}` / `\sdp{}` / `\de{}` shorthands.
- **Preamble comment block** (`:168-185`) updated if any new macro or style is added.
- **Timing.** Rehearse against the clock; the trims in Batch 1 assume ~30 min.

---

## Verification

```bash
make presentation          # pdflatex -interaction=nonstopmode, twice (no bibtex)
pdfinfo presentation.pdf | grep Pages
grep -n "^!" presentation.log                       # hard errors
grep -n "Overfull \\\\vbox" presentation.log        # frames overflowing — the real risk
```

Target: no `!` lines, no `Overfull \vbox` on any new frame, and a page count that has not grown
past today's 50 despite five new frames.

Both `\includegraphics` targets resolve (`images/performance_profile_thesis.pdf`,
`images/memory_profile_thesis.pdf`) and are unaffected by this work.

Finally, open the PDF and read every changed frame at presentation size — `\fitfig` shrinks
silently, so a frame can be correct in the log and unreadable on screen.

---

## The rest of the COPT talk — what else is worth taking, and what is not

Reviewed page by page so this does not have to be done again.

**Worth taking (optional):**

- *"What DCP modeling languages do → **Nothing.** The problem data A, b, c of the conic form are
  already the derivatives of interest."* This is the thesis's central claim stated more bluntly
  than anywhere in the thesis itself. `SC1` (`:982`) already makes it with the `∂/∂x` arrow, so
  this is a candidate spoken line for `SC1` rather than a new frame — but it is a good line.
- The "Our approach to computing derivatives" slide — folded into the Contributions frame above.

**Deliberately not taking:**

- Everything from "Nonlinear programming (NLP)" onward — solver guarantees, KKT points, LICQ,
  the domain and nonsmoothness failure examples, the Ipopt crash output, DNLP itself, circle
  packing. It is a different contribution with a different argument.
- "How NLP modeling languages compute derivatives" (AD, graph colouring, expensive Hessians).
  This is the `CasADi` contrast, and the defence deliberately does not cover `CasADi` — see
  `plans/presentation_dense_sparse_slide_cut.md`. It stays in the `B-OTHERLANG` backup
  (`:1654`), where it already is.
- "Who is responsible? the solver / no, it's the user / also no, it should be the modelling
  language." A good three-beat, but it argues for DNLP's premise, not this thesis's.

---

## Material with no slide, deliberately left out

Recorded so it is not rediscovered later. All of it is defensible as backup-slide fodder if a
jury question calls for it:

- `tab:atom-classes` (`7-Theme1.tex:61-77`) — the six atom classes and how each computes its
  Jacobian.
- `fig:jacobian-stacking` (`7-Theme1.tex:840-863`) — per-constraint Jacobians stacked into one
  global CSR, with affine trees skipped after the first evaluation.
- `lst:diffengine-cone-program` / `lst:extract-at-origin` (`7-Theme1.tex:866-914`) — how the
  backend plugs into `CVXPY`. `SC1` already carries the `b = h(0)`, `c = ∇f_0(0)` half of it.
- The dense/sparse storage contrast and Boehm's optimization ladder — cut 2026-09-14, archived
  in `plans/presentation_dense_sparse_slide_cut.md`.
