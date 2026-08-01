# "Computing derivatives" — high-level overview of what the section should say

> Working notes (not compiled). Companion to `sparse_derivatives_landscape.md` (the deep
> background) and to the section itself in `6-Revue_litterature.tex` (`sec:computing-derivatives`,
> now positioned *before* `sec:coefficient-extraction`). This file is about the **message and
> narrative** of the section, not its wording. Decisions captured here drive the next editing pass.

## Guardrail: stay inside the thesis spine

The thesis spine is **faster canonicalization / matrix stuffing for CVXPY**, with sparse-derivative
computation as the *mechanism* (decided; the full "new AD method" reframe in the landscape notes is
deferred). So this section's job is to **build the conceptual toolkit and position the thesis**, not
to sell a standalone AD contribution. The honest claim to land is the landscape notes' own: *not
"faster than CasADi," but a structure-exploiting differentiation that needs neither sparsity
detection nor graph coloring, filling CVXPY's non-DPP gap.*

## The one thing the section must land

> Most of the AD literature is built around **scalar, dense** derivatives — single-output gradients
> for machine learning, entry-by-entry Jacobians for general nonlinear programs. Extracting
> optimization problem data needs the opposite regime: **vectorized, sparse** derivatives, because
> the conic/QP data (`A`, `P`) is a large sparse matrix read off a small array-level graph. Two
> independent paradigm shifts separate the two worlds:
> - **scalar → vectorized**: local derivatives stop being scalars and become *compositions of
>   structured linear operators* (matrix differential calculus);
> - **dense → sparse**: the derivative's *underlying data structure* changes — only nonzeros are
>   stored and propagated.
>
> Graph **coloring** is the technique that retrofits sparse output onto *oracle-based* (matrix-free)
> AD; the vectorized + direct route this thesis uses produces sparse data natively, so coloring
> never arises.

Slogan worth keeping: **coloring is structure recovered after the fact; direct vectorized
accumulation is structure preserved up front.**

## Narrative spine — survey, then pivot to the optimization regime (REVISED: D1)

The section reads as a **survey of existing AD methods** (largely what's there now — "probably
fine"), then **pivots** to the regime the thesis cares about and contrasts the two paradigm axes one
paragraph at a time, with a third paragraph on coloring as the oracle-route workaround. This is
*additive* — the survey stays; we add a pivot and three crisp contrast paragraphs. Ordered beats:

1. **Survey the existing methods (keep, tighten lightly).** Numerical (finite differences), symbolic
   (expression swell), algorithmic differentiation; what AD is (augmented evaluation trace, machine
   precision over arbitrary programs); forward vs reverse mode. This is the "what exists" part and is
   largely fine as written.
2. **The pivot (the section's turn).** State the organizing claim plainly: *most AD literature is
   fixated on scalar and dense derivatives — single-output ML gradients, entry-by-entry NLP Jacobians
   — whereas extracting optimization problem data calls for vectorized and sparse ones.* Everything
   after is read through this. Two independent paradigm shifts follow, one paragraph each.
3. **¶ scalar vs vectorized — the mathematical contrast.** In a scalar graph each node is a scalar op
   and the local partial is a *number*; in a vectorized graph a whole matrix operation is one node
   and the local derivative is a **structured linear operator**. Use matrix differential calculus
   (Magnus–Neudecker): Kronecker products, diagonal and selection matrices, e.g.
   `d vec(AB) = (Bᵀ⊗I) d vec A + (I⊗A) d vec B`. The payoff line: **derivatives become compositions
   of linear operators**, and vectorization *preserves* the macro-structure a scalar graph shatters
   into individual entries.
4. **¶ dense vs sparse — the data-structure contrast.** Primarily a choice of **underlying data
   structure**: carry derivatives as sparse objects (store and propagate only nonzeros) rather than
   dense arrays. This is what makes a large `A`/`P` tractable at all; point forward to the sparse
   formats of `sec:sparse-matrices`.
5. **¶ coloring — the oracle-route substitute.** When the only primitive is a matrix-free oracle
   (JVP/VJP), a sparse matrix is recovered by seeded sweeps, and **graph coloring** compresses the
   seeds (structurally-orthogonal columns share one); add sparsity detection when the pattern is
   unknown. Frame explicitly as *a way to get sparse data out of oracle-based differentiation* —
   structure recovered after the fact — which the vectorized + direct route never needs. CasADi MX as
   the "vectorized yet still colors" counter-example; internals deferred to `sec:coefficient-extraction`.
6. **Placement + lineage.** The thesis regime = vectorized + sparse + direct. Direct-sparse lineage
   (SparsLinC, edge-pushing, matrix-derivative rules) → recent vectorized-forward-sparse works
   (Zou–Jiang, Kwok et al., ∇SD) → this thesis, distinguished by differentiating the *canonicalized
   affine tree* so the Jacobian is exactly the constant conic data.
7. **Hessian beat — short (DECIDED: D4).** Same axes, symmetric case: CasADi assembles `∇²f` by
   forward-over-reverse + *star* coloring, whereas the direct route builds the Lagrangian Hessian as
   explicit structured sparse blocks `JᵀDJ + Σ wᵢ∇²fᵢ` with the pattern computed once — no gradient
   tape, no star coloring, no seeds. (Background: landscape §14.)
8. **Summary + placement.** Four axes (expression type / mode / assembly / data format), the landscape
   table, the thesis's cell, and the bridge into the methodology chapter.

No worked numerical example (DECIDED: D3) — the contrasts are carried in prose, math, and citations,
keeping the section at literature-review altitude.

## Key claims to keep / make sure are earned

- Forward & reverse are two orderings of the same accumulation; optimal ordering is NP-complete on
  general scalar graphs — *but that difficulty is specific to dense scalar graphs* and evaporates on
  a small vectorized graph with structured local Jacobians. (Already in the draft — it's load-bearing
  for the thesis claim; keep it crisp.)
- Coloring exists to (a) recover a lost pattern and (b) minimize probes through an oracle — *neither
  arises when the matrix is assembled directly*.
- The distinction is **oracle vs direct**, not scalar vs vectorized (CasADi MX is the proof).

## Decisions

- **D1 — Organization → survey, then pivot (revised).** Keep the existing survey of AD methods, then
  pivot to "the literature is scalar + dense; optimization needs vectorized + sparse" and contrast the
  two axes one paragraph each (scalar/vectorized, dense/sparse), plus a coloring paragraph as the
  oracle-route substitute. Additive, not a teardown. (Supersedes the earlier "lead with the
  punchline" plan.)
- **D3 — Worked example → no.** Prose + citations only; no tridiagonal/coloring example. Keep at
  literature-review altitude.
- **D4 — Hessian → short beat here.** One paragraph positioning the symmetric case (beat 7).

## Still open (lower stakes, defaulting unless told otherwise)

- **D2 — Division of labor with `sec:coefficient-extraction`.** CasADi's coloring is previewed here
  and detailed there; AMPL's partial separability (the *closest prior art*, landscape §16) currently
  lives only there. *Default: keep a one-line forward pointer here naming AMPL as the same
  "structured accumulation without coloring" philosophy, full treatment deferred.*
- **D5 — Length/altitude.** *Default: position only — the engine's actual mechanism (the
  `eval_jacobian` chain-rule table, the structure/value split) belongs in Theme1, not here.*

## What this section explicitly does NOT do

- It does not implement or benchmark the engine (Theme1 / Theme2).
- It does not detail CasADi's tape / batched seeds / star coloring internals — those are background
  (landscape §12–14); at most a sentence and a citation, with the worked detail deferred.
