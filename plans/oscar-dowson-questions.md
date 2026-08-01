# Questions for Oscar Dowson (JuMP) — meeting prep

Purpose: verify the claims in the JuMP subsection of the literature review (`6-Revue_litterature.tex`,
`sec:jump`) and the JuMP benchmark methodology in `7-Theme2.tex` (`sec:bench-declared`) before they
go to print. Each `TODO(oscar)` comment in the .tex maps to a question below.

## Thesis-correctness (claims we will print)

1. **Canonical data path.** Is `MOI.copy_to` into `Utilities.MatrixOfConstraints` the canonical
   route by which conic solver wrappers (SCS.jl, Clarabel.jl) receive problem data? Or do some
   wrappers ingest the term lists incrementally / differently? We describe extraction as "pure
   serialization of stored term lists into the solver's sparse format."
2. **No differentiation, no exceptions.** For LP/QP/conic models, is it accurate that no
   differentiation occurs anywhere between `@constraint` and the solver's matrices? Any edge case
   (e.g. quadratic-to-conic conversion, `NonlinearExpr` sneaking in) that would falsify the
   blanket claim?
3. **Macro story.** Do the `@objective`/`@constraint` macros build coefficient lists eagerly with
   duplicate terms merged as entered (so no expression tree is ever retained)? Is
   `GenericAffExpr` backed by an ordered dict of terms? Is "the model never holds an expression
   tree, only coefficient lists" a fair sentence?
4. **Bridges.** Is "a structural rewrite from one function-set pair to another, chosen by a
   shortest-path search over the graph of available bridges" a correct one-sentence description?
   Is bridge cost ever significant relative to `copy_to` on typical conic problems?

## Benchmark fairness (Theme2)

5. **What to time.** We time one `MOI.copy_to` of a built model into a `MatrixOfConstraints`-based
   cache as "JuMP's extraction cost" (no solver call). Is that the fair and idiomatic measure, or
   is there a cheaper path a performance-conscious user would take? Anything we should set
   (e.g. `direct_model`, disabling bridges) to avoid overstating JuMP's cost?
6. **Parametric re-solves.** What is the idiomatic way to re-solve a parametric family: in-place
   `MOI.modify` / `set_normalized_coefficient`, rebuilding the model, or ParametricOptInterface?
   What does each cost relative to a fresh `copy_to`? (Our re-solve benchmark should match the
   idiomatic path.)

## Lit-review narrative

7. **Design rationale.** Why coefficient storage (typed term lists) rather than expression graphs
   for the linear/quadratic path? Was AMPL's `.nl` design an explicit reference point (for or
   against)? Any history worth citing?
8. **What to cite.** Beyond the MathOptInterface paper (Legat et al. 2020) and the two JuMP
   papers, is there a preferred citation for `MatrixOfConstraints`, the bridge system, or MOI
   internals? A docs page acceptable as a thesis citation?
9. **Future-proofing.** Anything upcoming in JuMP/MOI that would change our characterization
   (storage model, new conic pipeline, nonlinear rewrite), so the thesis does not print something
   about to be obsolete?

## Nonlinear fence (one question)

10. **ReverseAD summary check.** Our out-of-scope sentence: "expression graphs are retained and
    `Nonlinear.ReverseAD` computes derivatives by reverse-mode AD with coloring for sparse
    Hessians." Which coloring (acyclic? star?), and is the sentence otherwise accurate?

## After the meeting

- Resolve the four `% TODO(oscar)` comments in `6-Revue_litterature.tex` (`sec:jump`).
- Revisit the JuMP timing paragraph in `7-Theme2.tex` if Q5/Q6 change the methodology.
