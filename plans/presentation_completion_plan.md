# Completing the defence deck — working plan (2026-09-16)

Target: ~30 minute defence, October 2nd.

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
   lifted from the prose; the argument the thesis actually makes is about *conic generality*
   (`5-Introduction.tex:34-37`) and *recognizability* (`:235-237`).
2. **`B-DCP` (backup) already contains everything `F1` would say**, including the full
   composition rules. Filling `F1` without retargeting `B-DCP` creates a duplicate.

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

Net after Batch 1: 29 content frames, 1 outline frame.

---

## Batch 2 — the three empty Introduction frames

### `I0b` "Convex optimization" (`presentation.tex:236-242`)

The frame's own comment says it was left "deliberately empty: spoken, not written" — because the
thesis has nothing to lift. Rather than importing a textbook convexity argument, make the slide
earn its place by defining the vocabulary the rest of the deck silently assumes: **the deck uses
"problem family" and "problem instance" on `B4`, `PC1`, `R3` and `R4` and never defines either.**

Shape it like its twin `F3a` — one display, three bullets:

- Display: the parametrized standard form, `5-Introduction.tex:46-62` —
  minimize `f_0(x;θ)` s.t. `f_i(x;θ) ≤ 0`, `g_j(x;θ) = 0`.
- Bullet 1: `f_0`, `f_i` convex and `g_j` affine — this is what "convex" means structurally
  here, and it is what the DCP rules will be built to certify.
- Bullet 2: `θ` is data fixed when an instance is solved. The parametrized problem is a
  **problem family**; a fixed `θ` gives a **problem instance** (`5-Introduction.tex:52-62`).
  This is the term `B4`, `PC1` and `R3` depend on.
- Bullet 3, the hand-off to `I1c`: general-purpose solvers read conic form, which
  "can represent nearly every convex program used in practice" (`5-Introduction.tex:34-37`).

Attribution for the standard form goes in a grey `\scriptsize` line, not `\cite` — the deck sets
`\bibliographystyle` but has no `\bibliography`, and the Makefile target runs no bibtex.

### `F1` "Disciplined convex programming" (`:397-402`)

Carry the ruleset, and **retarget the `B-DCP` backup so it does not duplicate this**:

- Lead line: each atom declares its curvature, its monotonicity in each argument, and the sign
  of its output (`5-Introduction.tex:171-176`).
- The composition rule for `φ(u_1(x), …, u_k(x))`, three sub-bullets verbatim from
  `5-Introduction.tex:239-251`. Note the thesis renames subexpressions `u_i` (not `f_i`) at the
  advisor's request, because `f_i` is already the inequality constraints — keep that.
- Compliance in one line: convex objective, convex ≤ concave, affine equalities
  (`5-Introduction.tex:227-237`).
- Closing line: the rules are sufficient for convexity, not necessary.

No expression tree on this slide — `F3b` (`:708`) already shows the rules applied bottom-up, and
that is the twin's job.

Then **retitle `B-DCP` (`:1525-1564`) to "Backup: the atom library"** and cut it back to
`tab:atoms` (`5-Introduction.tex:178-197`, 9 rows × definition/curvature/monotonicity/sign),
dropping the composition-rule half that `F1` now carries. `B-NONDCP` (`:1570`) is unaffected and
remains the answer to "give me a problem the rules reject".

### `F2` "DCP-based modelling languages" (`:404-409`)

The taxonomy, from `5-Introduction.tex:15-32`. Three groups, best as a small three-row table or
a grouped list:

| | |
|---|---|
| standalone algebraic | `AMPL`, `AIMMS`, `GAMS` |
| embedded, general purpose | `Pyomo` (Python), `JuMP` (Julia), `CasADi` (C++), `YALMIP` (MATLAB) |
| embedded, DCP-based | `CVX` (MATLAB), `CVXR` (R), `CVXPY` (Python), `Convex.jl` (Julia) |

Then the one sentence that separates the third row from the second
(`6-Revue_litterature.tex:884-887`): `AMPL` and `JuMP` have **no atom library and no
canonicalization step**, so a norm is left to the solver or written in conic form by hand.

Close on `CVXPY` specifically (`5-Introduction.tex:310-318`): expression tree as the central
representation, reduction-based canonicalization, and parameters — so compilation work can be
reused when a problem is solved repeatedly. That last clause is what the whole second half of
the deck is about, so it is the right hand-off into `I1b`.

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
Example section starts. Sources: `7-Theme1.tex:1-33`, `8-Conclusion.tex:1-33`.

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
