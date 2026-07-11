# Matrix stuffing section — working notes

Working outline and progress for `\section{Matrix stuffing}` in `6-Revue_litterature.tex`
(`sec:matrix-stuffing`).

## Status (2026-07-10)

**All paragraphs drafted (P3–P9 filled in one pass at the user's request); awaiting the user's
editing pass.** Section order: lead-in, Matrix calculus, Composing linear operators, Views and
copies, Local versus global derivatives, Parameters and tensors (+ eq:param-maps display,
fig:param-map-c moved below it), ignore_dpp path, Code generation, Implementation notes,
Example (fig:matrix-stuffing moved below it), References. Compiles clean, no undefined refs
(the dangling `\ref{eq:param-maps}` in the coefficient-extraction section is fixed).

Open items:
- P6 has a `% TODO` in the tex: user must confirm the stated reason for not benchmarking
  against CVXPYgen (drafted as: offline codegen fixing problem structure at compile time,
  different deployment model from a runtime backend).
- P3–P9 facts re-verified against ~/Documents/cvxpy on 2026-07-10 (canon_backend.py TensorView
  dict-of-dicts keyed by variable id, id_to_col shift in get_tensor_representation:940-956;
  Utils.hpp is at cvxpy/cvxcore/src/Utils.hpp:26, not include/).

## Earlier status (2026-07-08)

Done:
- Lead-in (single paragraph): matrix-calculus hook + burden claim + section roadmap, merged into
  one paragraph. Deliberately does NOT re-define matrix stuffing (the chapter roadmap already does).
- `\paragraph{Matrix calculus.}`: vec convention (column stacking), Magnus & Neudecker citation
  (`magnus2019matrix`), layout ambiguity of matrix-by-matrix derivatives, and the structural payoff
  example vec(FX) = (I ⊗ F) vec(X) that Theme1's Kronecker block subsection later exploits.
- `\paragraph{Composing linear operators.}`: e(x) = Ex + f node form, E = constant Jacobian,
  chain-rule display sum_i L_i E_i, bottom-up pass, identity block for variable leaves.
- Housekeeping: finished truncated caption of `fig:param-map-c` (was "The two..."), resolved the
  TODO in the `fig:conic-form-tree` caption (same variable x across trees, one column block),
  renamed subcaption to "Matrix stuffing tree of the constraints".
- `\paragraph{Views and copies.}` (P2): two styles of operator; views mutate in place (negation
  = sign flip, indexing = row selection), reshape free under the vec convention, data-carrying
  ops (matmul, mul_elem, div) form a matrix from atom data and create a new copy of the product.
  User asked for a tightening pass: the addition-merging claim was dropped (merging is arguably
  work) and the "free operators" digression compressed to the single reshape clause. Kept
  library-agnostic; concrete backend names deferred to P7.

**Next: P3 (Local versus global derivatives).**

## Remaining paragraphs (approved outline)
- **P3 `\paragraph{Local versus global derivatives.}`** CVXPY differentiates per variable (tensor
  keyed by variable id, blocks concatenated by column offset at the end); the alternative is one
  global Jacobian across the flattened variable vector. Hint diffengine takes the global approach.
  (Verified: TensorView docstring, canon_backend.py:829-931; shape rows x var_length x
  (param_size+1).)
- **P4 `\paragraph{Parameters and tensors.}`** Very brief. Coefficients affine in θ ⇒ third tensor
  axis; slicing gives the cached parameter map Q of fig:param-map-dpp; DPP re-solve = one sparse
  matvec Qθ̃. Cite agrawal2019dpp. Move figure `fig:param-map-c` below this paragraph. Label the
  construction `eq:param-maps` — this fixes the pre-existing dangling `\ref{eq:param-maps}` at
  line ~877 (coefficient-extraction section).
- **P5 `\paragraph{The ignore_dpp path.}`** EvalParams replaces parameter leaves with constants,
  full walk redone per parameter change (fig:param-map-evalparams). General but repeats all
  symbolic work although the sparsity pattern never changes; hint this is the regime the
  diffengine improves.
- **P6 `\paragraph{Code generation.}`** Few sentences: CVXPYgen compiles the DPP parameter map to
  problem-specific C (schaller2022cvxpygen); lineage chu2013codegen. Reason for no direct
  comparison still to be confirmed by user (draft: offline codegen with fixed problem structure,
  different deployment model from a runtime backend).
- **P7 `\paragraph{Implementation notes.}`** Three verified facts that set up the diffengine:
  1. Both backends lean on external sparse libraries: cvxcore on Eigen (Utils.hpp:26 typedefs
     Matrix = Eigen::SparseMatrix<double>), Python backend on scipy.sparse. Hard to customize,
     cannot exploit structure known at canonicalization time.
  2. All coefficient data treated as sparse; dense atom data converted via .sparseView()
     (LinOpOperations.cpp:288). No BLAS calls, no dense/block-dense special cases.
  3. Quadratic objectives take a separate, involved path: each quadratic atom becomes a
     SymbolicQuadForm, quad_form() swaps it for a dummy variable, extracts the affine head's
     coefficients, scales each form's P by them and reassembles the global P
     (coeff_extractor.py:94-235). State at high level only.
  Must name cvxcore and the SciPy backend explicitly (7-Theme1.tex:328-329 references them).
- **P8 `\paragraph{Example.}`** Move fig:matrix-stuffing below this paragraph. Walk the figure
  with the operator lens (variable = identity block, Fx = F times identity, neg = sign-flip view,
  root stacks block rows). Must use the exact phrase "constraint row offsets"
  (7-Theme1.tex:308). Conclude: easy for this problem, but the backend must work for arbitrary
  problems.
- **P9 `\paragraph{References.}`** diamond2016cvxpy, agrawal2018rewriting (architecture),
  agrawal2019dpp (DPP/parameter map), chu2013codegen + schaller2022cvxpygen (codegen lineage).
  All keys already exist in Document.bib.

## Terminology contract with Theme1

The section must establish: matrix stuffing walk, ignore_dpp / EvalParams, cvxcore, SciPy
backend, constraint row offsets, parameter map Q. (Forward references at 7-Theme1.tex:11, 50,
308, 319, 329.)

## Style notes (what worked, keep doing)

- Start from the user's dictated sentences and stay close to them; expand only where asked.
- Punchy declarative opening; no re-defining terms the chapter roadmap already defined; no
  justification sentences bolted onto claims the user stated bare.
- Single lead-in paragraph merging hook + section roadmap (varied phrasing from the derivatives
  section's "The remainder of the section is structured as follows" to avoid adjacent repetition).
- Establish conventions once with the canonical citation (Magnus & Neudecker vec convention),
  then one concrete identity whose payoff lands later in the thesis (I ⊗ F reappears in Theme1).
- One display equation per concept at most (node form, chain rule); other math inline.
- Verify every implementation claim against the CVXPY source (~/Documents/cvxpy) before writing
  it; keep the file:line evidence in these notes, not in the prose.
- Plant one forward hint per paragraph toward Theme1 rather than a heavy comparison block.
- No em-dashes; ~100-char line wrap; \paragraph{} blocks in sibling-section style.
