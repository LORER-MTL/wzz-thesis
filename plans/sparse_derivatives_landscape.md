# Sparse Derivatives & the SparseDiffEngine as a CVXPY Backend — Landscape Notes

> Working notes (not compiled into the thesis). Purpose: capture the background and the
> discussion needed to frame the contribution — *using the diff engine as a backend for
> CVXPY* — against the existing literature on computing sparse derivatives, and to pin down
> the main similarities and differences with existing implementations.

---

## 0. The one-paragraph thesis framing

In a conic/QP interface the constraints are affine (`Ax + b ∈ K`) and the objective is
quadratic (`½xᵀPx + qᵀx`), so the "constraint Jacobian" is the **constant sparse matrix
`A`** and the "objective Hessian" is the **constant sparse matrix `P`**. A modeling layer's
job is **problem-data extraction**: turn a high-level description into `(P, q, A, b)` in the
solver's sparse format, and — when the problem is *parametric* — re-extract those values
across iterations while the **sparsity pattern stays fixed**. The diff engine does this by
**forward-mode sparse Jacobian accumulation over a vectorized DCP expression tree**,
evaluated at `x = 0`. The contribution is *not* "faster than CasADi" (it isn't, on constant
data); it is **filling the non-DPP gap in CVXPY's parametric pipeline** with a
structure-exploiting differentiation method that needs neither sparsity detection nor graph
coloring.

---

## 1. The problem: extracting a constant, sparse `A` and `P`

- Objective `½xᵀPx + qᵀx + d`; constraints `Ax + b ∈ K`. For a QP/conic program `A`, `P` are
  **constant in `x`** and **sparse**.
- Differentiating the *canonicalized* affine/quadratic form recovers the data exactly:
  - gradient of objective at `x=0` → `q`; constant term → `d`
  - constraint Jacobian → `A`; constraint value at `x=0` → `b`
  - objective Hessian → `P`
- Parametric case: parameters `θ` change; `(P,q,A,b)` values change but the **sparsity
  pattern is invariant**. This invariance is the lever every fast extractor pulls.

---

## 2. Background on the three modeling languages (conic/QP focus)

### 2.1 CVXPY (Python, DCP)
- High-level DCP modeling. Canonicalizes via a **reductions / rewriting system** (analysis →
  canonicalization → solver standard form).
- `ConeMatrixStuffing` / `qp_matrix_stuffing` + `CoeffExtractor` assemble `A, b, P, q`
  ("matrix stuffing").
- **DPP (Disciplined Parametrized Programming):** restricts how parameters enter so the map
  `θ → (P,q,A,b)` is **affine**. Then the data is a precompiled **linear tensor**, and
  re-extraction is one sparse matvec. Valid only for affine parameter dependence.
- Two existing parametric paths: **(1) DPP tensor** (fast, restrictive); **(2)
  re-canonicalize** (general, slow). The diff engine is the missing **third path**.

### 2.2 JuMP / MathOptInterface (Julia)
- Algebraic DSL over MOI. For **linear/quadratic/conic**: **no AD at all** — coefficients are
  *stored as you type them*. `VectorAffineFunction` = `Ax+b` as a list of
  `(row, var, coeff)` terms; `ScalarQuadraticFunction` = `½xᵀQx + aᵀx + b` as `Q`-terms.
  Extracting `A`/`P` = **serializing stored terms** into the solver's sparse format.
- Cone reformulation via structural **MOI bridges**, not differentiation.
- AD only appears in the **nonlinear** path (`Nonlinear.ReverseAD`, reverse-mode + graph
  coloring for sparse Hessians; newer `SymbolicAD` = differentiate-once/plug-in-data). *Out of
  scope here.*
- Does **not vectorize** naturally — nonlinear models are scalar-indexed expression graphs.

### 2.3 CasADi (C++/Python, symbolic AD framework)
- You build the QP yourself: give quadratic `f` and linear `g`; CasADi **differentiates**
  `H = hessian(f,x)` (→`P`) and `A = jacobian(g,x)`.
- Two graph dialects: **SX** (scalar expression graph — small problems, symbolic node-by-node
  diff, exact sparsity) and **MX** (matrix/vectorized graph — large problems).
- Compiles a function to a flat **instruction tape** over a shared work vector
  (`n_instructions`, `instruction_id`, `instruction_input/output` = work-vector slots,
  `sz_w`). Enables CSE, constant folding, codegen.
- For assembling a full sparse Jacobian/Hessian it uses **sparsity detection + graph
  coloring** (star coloring for symmetric Hessians; distance-2 unidirectional forward/reverse
  for Jacobians) — the "What Color Is Your Jacobian?" machinery.

### Related lineage worth knowing (conic/QP data, fixed sparsity)
- **CVXGEN** (Mattingley & Boyd 2012): flat branch-free C for small QPs.
- **CVXPYgen** (Schaller et al. 2022): generates C mapping `θ → (P,q,A,b)` at a fixed,
  user-defined sparsity pattern; "partial update canonicalization."
- **OSQP** `OSQP_EMBEDDED_MODE=2`: `P`/`A` patterns fixed; `update_P`/`update_A` replace only
  the value arrays (optional `Px_idx`/`Ax_idx`). The "fixed pattern, new values" contract at
  the solver boundary.

---

## 3. Scalar vs vectorized computational graphs

| | Scalar (unvectorized) | Vectorized (array-level) |
|---|---|---|
| node = | one scalar op | one array op |
| `A@x` (`m×n`) → | ~`m·n` mul + `m·(n−1)` add nodes | **one** `matmul` node |
| graph size | `O(nnz)` — millions | `O(#atoms)` — dozens |
| local partial | a scalar | a **structured sparse operator** (Kronecker / diagonal / selection) |
| used by | ADOL-C, CasADi **SX**, JuMP nonlinear | CasADi **MX**, **CVXPY**, **diff engine** |

Key point: **vectorization preserves the macro-structure** that a scalar graph shatters into
individual entries. Granularity drives graph size, what the local partials look like, and how
badly accumulation fills in.

---

## 4. Two ways to get derivatives out of a graph

A computational graph, after evaluation, labels every edge with a **local partial**
`∂v_j/∂v_i`. By the chain rule, `∂y_k/∂x_l` = sum over input→output paths of the product of
edge labels. There are two strategies to compute this:

### 4.1 Vector-mode (JVP / VJP) — "oracle" route
- **JVP** = `J·v` (one forward sweep); **VJP** = `Jᵀ·w` (one reverse sweep). Each ≈ one
  function eval, independent of dimension. Returns a **projection** of `J` (a
  column/row-combination), *not* the matrix.
- To assemble the **full** `J`: repeat with many unit seeds (`n` for forward, `m` for
  reverse). **Graph coloring** minimizes the seed count.
- Carries a **vector** through the graph → low memory, but repeated sweeps.

### 4.2 Accumulation / elimination — "assemble it directly" route
- Combine the local partials into the full `J` by **eliminating intermediate vertices**
  (vertex/edge/face elimination on the linearized graph).
- **Forward and reverse mode are just two special elimination orderings** (topological /
  reverse-topological). "Cross-country" orders can be cheaper.
- Carries **matrices** (or eliminates edges directly) → builds all of `J` at once, no seed
  loop. But intermediate **fill-in** can blow up, and choosing the cheapest order is
  **NP-complete** (Naumann 2008).

### 4.3 The crisp distinction
- **VJP gives you `J` times a vector**; **accumulation gives you `J` itself.** If your only
  primitive is the VJP, you *accumulate the matrix by calling it with many seeds* — and that's
  when coloring matters. Accumulation in general is **not** tied to seed vectors.
- Conic/QP solvers need the **explicit** `A`, `P` — so you cannot stop at VJPs; you must
  materialize. Two ways: seeded sweeps + coloring (CasADi), or direct structured accumulation
  (diff engine).

---

## 5. What the diff engine actually does (= accumulation, different syntax)

The diff engine does **not** literally delete graph vertices, but it is doing
**forward-mode Jacobian accumulation** — vertex elimination in topological order — carried
with **sparse-matrix edge labels** instead of scalars.

- **Leaf seed = identity.** A variable's Jacobian is a selection matrix: row `j` has a `1` at
  column `j + var_id` (`variable.c:29`). That is `∂x/∂x = I`, kept sparse.
- **Each node stores `∂(node)/∂x`** — its Jacobian w.r.t. the *global* input vector — the whole
  sparse matrix at once (`expr.h:74`).
- **Built bottom-up** (leaves → root): every atom's `eval_jacobian` recurses into children
  first, then combines. Storing `∂node/∂x` means all intermediates *below* the node have
  already been **composed away** — i.e., the node is expressed directly in terms of `x`. **That
  stored form *is* the eliminated graph.** Topological-order vertex elimination ≡ bottom-up
  forward accumulation.
- **Each `eval_jacobian` is one elimination step** — "(local partial) ∘ (children's
  accumulated `J`), summed":

  | atom | `eval_jacobian` | code |
  |---|---|---|
  | `add` | `J = J_L + J_R` | `add.c:53` (`sum_matrices_fill_values`) |
  | `multiply` | `J = diag(y)·J_L + diag(x)·J_R` | `multiply.c:64` (`sum_scaled_matrices_fill_values`) |
  | elementwise `f` | `J = diag(f'(g))·J_child` | `common.c:56` (`DA_fill_values`) |
  | `matmul` | `J = (gᵀ⊗I)·J_f + (I⊗f)·J_g` | `matmul.c:250` (kron + `sum_csr_fill_values`) |

- **Forward mode everywhere, including the scalar gradient.** `problem_gradient`
  (`problem.c:490`) just calls `objective->eval_jacobian` and reads the objective's `1×n`
  Jacobian as `q`. (Classically reverse is cheaper for a scalar output; the engine uses forward
  anyway because the affine objective's gradient is constant/cheap and the machinery is
  uniform.)
- **Hessian is a separate, partly-reverse scheme.** `eval_wsum_hess(node, w)` propagates a
  dual-like weight vector `w` *downward* to children to form `Σ wᵢ ∇²fᵢ`
  (`multiply.c:219`, `matmul.c:483`) — forward-over-reverse-flavoured, not plain forward.

**Terminology bridge:** what the AD literature calls *Jacobian accumulation by vertex
elimination*, the diff engine implements as *bottom-up propagation of each node's sparse
Jacobian w.r.t. the inputs.* Same algorithm; the engine never materializes/deletes a scalar
graph because it stores the composed result at each (vectorized) atom. The repo name
"Jacobian-accumulation" is literally the AD term for this route.

---

## 6. The structure/value split & the matmul example

- Every atom is a **pair**: `*_alloc` (build the sparsity pattern, **once**) and
  `*_fill_values` (refill the numeric values, **every iteration**). `update_params` keeps the
  patterns valid (`c_problem.py`: "sparsity structures remain valid").
- **Sparse matmul** makes this vivid (`linalg_sparse_matmuls.c`):
  - `csr_csc_matmul_alloc` (`:256`): symbolic — `C[i,j] ≠ 0` iff row `i` of `A` and col `j` of
    `B` overlap; scans **all** `m×p` pairs, builds `C->p`/`C->i`.
  - `csr_csc_matmul_fill_values` (`:233`): numeric — loops over the **precomputed pattern**
    (`for jj in C->p[i]..C->p[i+1]`), computes only the `nnz(C)` dot products. Structural zeros
    never visited.
- **Contrast with a normal SpGEMM** (SciPy/CSparse/Gustavson): stateless `C = A@B`
  *rediscovers* the pattern on every call (the SPA "marking" step). AD engines keep it.
- **CasADi's `casadi_mtimes`** does the same structure/value split (precomputed output sparsity
  `sp_z` + dense work vector `w`, Gustavson scatter/gather) — confirming the split is universal;
  it is *not* what distinguishes the tools.
- **Numeric-phase nuance:** the diff engine's per-entry `sparse_dot` merge (`:30`) is a *weaker*
  numeric kernel than Gustavson's sparse accumulator — it re-scans operands per output entry
  (the engine even notes this, `CSC_matrix.c:444`). Second-order: the first-order win is
  caching the pattern, shared by all.

---

## 7. Graph coloring = recovering structure you lost

- Coloring (Gebremedhin–Manne–Pothen, "What Color Is Your Jacobian?") solves: given a **known**
  sparsity pattern and only a **JVP/VJP oracle**, find the fewest seed directions to recover
  the full matrix. Structurally-orthogonal columns share a seed; minimizing groups = a coloring
  problem.
- It exists to **(a) detect** a pattern lost in a scalar graph and **(b) minimize probes**. The
  NP-completeness results (Naumann) concern choosing the cheapest **elimination ordering**.
- **None of these problems arise for the diff engine:**
  1. **No detection** — patterns are known analytically per (vectorized) atom, computed once.
  2. **No probing/recovery** — it assembles the matrix directly; never restricted to an oracle.
  3. **No ordering search** — fixed topological/forward order; NP-hard optimum is moot.
  4. **No fill-in fight** — DCP canonical form is shallow & affine-dominated; atom Jacobians are
     structured, so accumulation stays sparse.
- **Slogan:** *coloring is structure recovered after the fact; vectorization is structure
  preserved up front.* Same goal, opposite ends of the pipeline. Because the diff engine keeps
  the structure and needs the explicit matrices, coloring is simply never the relevant tool.

---

## 8. The landscape table (conic/QP data only)

| | graph granularity | how `A`,`P` obtained | coloring? | differentiation? |
|---|---|---|---|---|
| ADOL-C, JuMP nonlinear | scalar | seeded JVP/VJP sweeps | **yes** | yes (generic) |
| CasADi **SX** | scalar | symbolic, node-by-node | no | yes |
| CasADi **MX** | vectorized | seeded sweeps over MX graph | **yes** | yes |
| **diff engine** | vectorized | **structured forward accumulation** | **no** | yes (structured) |
| CVXPY-DPP | (linear tensor) | one matvec | no | no (affine) |
| JuMP/MOI conic | (coefficient triplets) | serialize stored terms | no | no |

Two axes, mostly independent: **granularity** (scalar vs vectorized) × **assembly method**
(sweeps+coloring vs accumulation). The diff engine's distinctive cell = *vectorized graph +
structured accumulation*.

---

## 9. The contribution, stated against the literature

1. **A non-DPP parametric backend native to CVXPY.** `DiffengineConeProgram` is a sibling of
   `ParamConeProg`; `DiffEngineExtractor` is the non-DPP analog of `CoeffExtractor`. It
   re-extracts `(P,q,A,b)` when parameters enter **nonlinearly** — the regime DPP's linear
   tensor and JuMP's coefficient storage can't handle — *without leaving CVXPY's DCP stack*.
2. **Structure-exploiting differentiation (not "no AD").** It is AD — specifically the
   **accumulation** branch (forward, vectorized, statically-sparse), *not* the
   **sweep + coloring** branch. Closest analogs in the literature: CasADi-symbolic and MOI
   `SymbolicAD` ("differentiate once, plug in data"). Cite these as prior art; the difference is
   the application to CVXPY conic canonicalization with per-atom analytic sparse Jacobians.
3. **Generalizes the parametric-reuse principle past the affine boundary.** DPP / CVXPYgen /
   OSQP all assume the value map is affine/stored. The diff engine extends "fixed sparsity,
   refill values" to nonlinear-in-parameter conic data via an evaluable C graph.

**Honest caveats (state them — they strengthen the thesis):**
- No whole-program constant-folding: keeping a live tree means re-walking nodes and reassembling
  matrices each call (CasADi's tape folds constant `P`, collapses `q=−2Aᵀb` to one matvec — why
  it wins the LS micro-benchmark). Natural future work.
- The matmul numeric kernel (`sparse_dot`) is sub-optimal vs a sparse accumulator.

---

## 10. Key references

**Modeling languages / canonicalization**
- Agrawal, Verschueren, Diamond, Boyd — *A Rewriting System for Convex Optimization Problems*
  (2018). https://arxiv.org/abs/1709.04494
- *A New Architecture for Optimization Modeling Frameworks* — https://arxiv.org/pdf/1609.03488
- CVXPY code: `cone_matrix_stuffing.py`, `qp_matrix_stuffing.py`, `coeff_extractor.py`
- Dunning, Huchette, Lubin — *JuMP* (SIAM Review 2017); Legat et al. — *MathOptInterface* (2022)
- MOI standard form: https://jump.dev/MathOptInterface.jl/stable/reference/standard_form/
- Andersson, Gillis, Horn, Rawlings, Diehl — *CasADi* (Math. Prog. Comp. 2019).
  https://web.casadi.org/docs/

**DPP / code generation (fixed sparsity, value refill)**
- Agrawal, Amos, Barratt, Boyd, Diamond, Kolter — *Differentiable Convex Optimization Layers*
  (NeurIPS 2019) [introduces DPP / ASA]. https://arxiv.org/abs/1910.12430
- Schaller et al. — *Embedded Code Generation with CVXPY* (CVXPYgen, 2022).
  https://arxiv.org/pdf/2203.11419 ; code https://github.com/cvxgrp/cvxpygen
- Mattingley & Boyd — *CVXGEN* (2012). https://stanford.edu/~boyd/papers/pdf/code_gen_impl.pdf
- *Code generation for solving and differentiating through convex optimization problems* (2025).
  https://arxiv.org/pdf/2504.14099
- Stellato et al. — *OSQP* (2020) https://arxiv.org/pdf/1711.08013 ; codegen docs
  https://osqp.org/docs/codegen/index.html

**Sparse derivatives / AD theory**
- Gebremedhin, Manne, Pothen — *What Color Is Your Jacobian?* (SIAM Review 2005) [coloring]
- Naumann — *Optimal Jacobian accumulation is NP-complete* (Math. Prog. 2008).
  https://link.springer.com/article/10.1007/s10107-006-0042-z
- Griewank & Walther — *Evaluating Derivatives* (2nd ed., 2008) [the textbook: chain rule on
  graphs, accumulation, elimination]
- Baydin, Pearlmutter, Radul, Siskind — *Automatic Differentiation in ML: a Survey* (2018)
  [forward/reverse as graph ops, JVP/VJP, taping/Wengert list]. https://arxiv.org/pdf/1502.05767

---

## 11. Diff engine code map (SparseDiffEngine, `~/Documents/SparseDiffEngine`)

- `include/expr.h` — node struct; the two-phase function pointers (`jacobian_init_impl` vs
  `eval_jacobian`; `wsum_hess_init_impl` vs `eval_wsum_hess`); `jacobian_csc_filled` affine cache.
- `src/expr.c` — `init_expr`, guarded `jacobian_init`/`wsum_hess_init`, refcounting,
  `expr_set_needs_refresh`.
- `src/atoms/affine/variable.c` — leaf Jacobian = selection/identity seed.
- `src/atoms/affine/add.c`, `bivariate_full_dom/multiply.c`, `bivariate_full_dom/matmul.c`,
  `elementwise_full_dom/common.c` — the chain-rule (`eval_jacobian`) and Hessian
  (`eval_wsum_hess`) steps.
- `src/utils/linalg_sparse_matmuls.c` — `csr_csc_matmul_alloc` (symbolic) /
  `_fill_values` (numeric); `sparse_dot` merge.
- `src/utils/CSR_sum.c` — `sum_scaled_csr_matrices_fill_values` (the row-scaled CSR add).
- `src/problem.c` — orchestration; `problem_gradient` (forward-mode read of objective Jacobian).

**CVXPY side (installed PR branch `diffengine-backend-ignoredpp`, cvxpy#3348):**
- `reductions/dcp2cone/diffengine_cone_program.py` — `DiffengineConeProgram` (sibling of
  `ParamConeProg`); `apply_parameters`.
- `reductions/solvers/nlp_solvers/diff_engine/extractor.py` — `DiffEngineExtractor`
  (non-DPP analog of `CoeffExtractor`); `build` (patterns once) / `extract` at `x=0` /
  `update_parameters`.
- `.../diff_engine/c_problem.py` — `C_problem` wrapper; `_alloc` vs `_fill_values` API.

---

## 12. CasADi MX in depth: directional derivatives, batched seeds, and why coloring

> Source-verified against `github.com/casadi/casadi` `main` (CasADi 3.7.2+), read 2026-06-22.
> Line numbers drift — cite by *file → function*. Two of my earlier guesses were wrong and are
> corrected below.

**The MX graph is an instruction tape, but AD is *symbolic-then-seeded*.** An `MXFunction` is a
flat list of instructions (`algorithm_`) over a shared work vector. Crucially, CasADi does **not**
read the explicit Jacobian off the graph the way the diff engine reads it off each atom. It builds
the Jacobian by the **oracle route** of §4.1: apply a directional-derivative operator to seed
vectors, then recover the matrix from the results. Vectorization (MX) makes the *graph* small and
each sweep cheap; it does **not** remove the need to recover an `m×n` matrix from `J·v` products.
That is the whole answer to "why coloring/batching when it already works at the array level":
**the array-level graph still only gives you `J·(seed)` per sweep, so you still need enough seeds
to span the columns — and coloring is what minimizes that seed count.**

### 12.1 Batched directions — one sweep carries `nfwd` tangents

The per-node virtuals take *vectors of directions*, not single vectors
(`casadi/core/mx_node.hpp` → `MXNode::ad_forward`/`ad_reverse`):

```cpp
virtual void ad_forward(const std::vector<std::vector<MX> >& fseed,
                        std::vector<std::vector<MX> >& fsens) const;
virtual void ad_reverse(const std::vector<std::vector<MX> >& aseed,
                        std::vector<std::vector<MX> >& asens) const;
```

`MXFunction::ad_forward` (`casadi/core/mx_function.cpp`) takes `nfwd = fseed.size()` and indexes
the work array as `dwork[work_location][direction]` — i.e. **every intermediate node holds all
`nfwd` tangents simultaneously**. The sweep collects seeds for all live directions, drops
all-zero directions (`skip[d]`), and makes **one batched** `e.data.ad_forward(oseed, osens)` call
per node:

```cpp
casadi_int nfwd = fseed.size();
...
for (casadi_int d=0; d<nfwd; ++d) {        // gather seeds for every direction
  ...
  if (skip[d] && !seed[i].is_zero()) skip[d] = false;   // prune all-zero directions
  if (!skip[d]) oseed.push_back(seed);
}
osens.resize(oseed.size());
if (!osens.empty()) e.data.ad_forward(oseed, osens);     // ONE call, all live directions
```

`ad_reverse` is the mirror image with `nadj = aseed.size()`. **This is the "batching of tangent
vectors" the question asks about**: a single pass over the tape pushes a *block* of `nfwd` seed
columns through, so the cost is one graph-walk amortized over many directions rather than one
walk per direction.

### 12.2 Choosing forward vs reverse — `ad_weight`

`FunctionInternal::ad_weight()` defaults to `0.33` ("reverse ≈ 2× the cost of forward").
`FunctionInternal::get_partition()` picks forward when
`ad_weight·rows ≤ (1−ad_weight)·cols` — roughly **forward when `#outputs` is not much smaller
than `#inputs`**, reverse otherwise:

```cpp
bool test_fwd_first = allow_forward &&
    w*static_cast<double>(A.size1()) <= (1-w)*static_cast<double>(A.size2());
```

It then tries the chosen mode's coloring first and keeps whichever (forward-of-`A` or
reverse-of-`Aᵀ`) yields fewer colors, using `cutoff`/`max_colorings_to_test` to abort a losing
mode early.

### 12.3 Coloring compresses the seed matrix; scatter-back recovers columns

`get_partition` computes the Jacobian sparsity, then calls **`uni_coloring`** (greedy distance-2
one-sided coloring, `casadi/core/sparsity_internal.cpp`) on the pattern (forward) and/or its
transpose (reverse). The returned object is an `(original-columns × colors)` sparsity: **each
column is one color**, listing the matrix columns assigned to it. The number of sweeps =
`D1.size2()` (number of colors), **not** `n`.

The seed for each color is built in `XFunction::jac()` (`casadi/core/x_function.hpp`) as a
**sum of unit vectors** — a `1` at *every* input column sharing that color:

```cpp
for (casadi_int el = D1.colind(offset_nfdir+d); el<D1.colind(offset_nfdir+d+1); ++el) {
  casadi_int c = D1.row(el);          // an input column assigned to color d
  seed_col.push_back(input_col[c]);
  seed_row.push_back(input_row[c]);   // push a 1 there
}
fseed[d][iind] = MatType::ones(Sparsity::triplet(nrow, ncol, seed_row, seed_col));
```

**This is the requested non-identity seed**: with no coloring you'd seed the `n×n` identity (one
unit column per input); coloring collapses structurally-orthogonal columns into one compressed
column. Recovery (`jac()` scatter loop) walks the transposed Jacobian sparsity `jsp_trans` and a
precomputed `mapping` to route each recovered sensitivity nonzero back to its unique Jacobian
entry (`ret.nz(adds) = fsens[d][oind].nz(tmp)`). It is unambiguous *because* columns of one color
never collide in a row.

**Corrections to my earlier notes:** (a) there is **no `bw_coloring`** — the routines are
`uni_coloring`, `star_coloring`, `star_coloring2`. (b) The symbolic `MX::hessian`/`SX::hessian`
live in `mx.cpp`/`sx_instantiator.cpp`, **not** `function_internal.cpp` (which holds only the
partition/coloring machinery).

---

## 13. Worked example with compressed (non-identity) seeds

Take the tridiagonal map from `Jacobian-accumulation/casadi/sparse_jacobian.py` (the running
example): `fᵢ = sin(xᵢ) + xᵢ₋₁xᵢ + exp(−xᵢxᵢ₊₁)`, so `∂fᵢ/∂xⱼ ≠ 0` only for `j ∈ {i−1,i,i+1}`.
The Jacobian is `10×10`, banded, **28 nonzeros**. CasADi's `sp.uni_coloring()` returns **3
colors** (= bandwidth), and the actual assignment (verified by running the script) is:

```
color 0 → columns {0, 3, 6, 9}
color 1 → columns {1, 4, 7}
color 2 → columns {2, 5, 8}
```

So instead of the 10 identity columns, CasADi pushes **3 compressed forward seeds**, each a sum
of unit vectors (no identity column among them):

```
s0 = e0+e3+e6+e9 = [1,0,0,1,0,0,1,0,0,1]ᵀ
s1 = e1+e4+e7    = [0,1,0,0,1,0,0,1,0,0]ᵀ
s2 = e2+e5+e8    = [0,0,1,0,0,1,0,0,1,0]ᵀ
```

**One forward sweep per seed** (§12.1) yields the dense vector `J·sₖ`. Recovery works because
columns of the same color are **structurally orthogonal**: no row `r` has a nonzero in two
columns of one color (bandwidth 3 guarantees columns sharing a color are ≥3 apart). Hence

```
(J·s0)[r] = Σ_{c∈{0,3,6,9}} J[r,c] = J[r, c*]   where c* is THE color-0 column nonzero in row r
```

— a *single* term, read straight off as that Jacobian entry. Three sweeps + scatter reconstruct
all 28 nonzeros. Without coloring it would be 10 sweeps; with it, 3, *independent of n* (a
`1000×1000` tridiagonal still takes 3).

**The diff-engine contrast, on the same shape.** For the conic/QP data the relevant map is the
*affine* part `g(x) = A·x` (constant `A`). The diff engine never seeds anything: `A` is the
variable leaf's selection Jacobian pushed through `matmul`'s analytic rule (`(I⊗f)·J_g + (gᵀ⊗I)·
J_f`, §5), so it **writes the 28 nonzeros of `A` directly** — one structure pass + one value
fill, zero sweeps, zero coloring. The example uses general `sin/exp` atoms to show CasADi's
*general* machinery; the point is that **the same seeded-recovery cost applies to the constant
conic `A` and `P`**, which is exactly the data CVXPY needs explicitly.

---

## 14. How CasADi computes the Hessian (forward-over-reverse + star coloring)

This is genuinely harder to explain than the linear Jacobian because it composes **two AD modes**
and a **symmetry-aware** coloring. CasADi builds the Hessian as *the Jacobian of the gradient,
with symmetry forced on* (`casadi/core/mx.cpp` → `MX::hessian`):

```cpp
MX MX::hessian(const MX& f, const MX& x, MX &g, const Dict& opts) {
  Dict all_opts = opts;
  g = gradient(f, x, opts);                                   // (1) reverse mode → ∇f
  if (!opts.count("symmetric")) all_opts["symmetric"] = true; // (2) tell jacobian it's symmetric
  return jacobian(g, x, all_opts);                            // (3) forward mode over ∇f
}
```

**Step (1) — gradient by reverse mode (VJP).** `GenericMatrix::gradient`
(`casadi/core/generic_matrix.hpp`) is a single reverse sweep seeded with ones —
`jtimes(ex, arg, ones, tr=true)` is exactly `Jᵀ·1 = ∇f`:

```cpp
return project(jtimes(ex, arg, MatType::ones(ex.sparsity()), /*tr=*/true, opts), arg.sparsity());
```

**Step (3) — Jacobian-of-gradient by forward mode, exploiting symmetry.** `jacobian(g,x,
{symmetric:true})` routes through `XFunction::jac` → `get_partition(..., symmetric=true)`, whose
symmetric branch asserts forward mode and calls **`star_coloring`** instead of `uni_coloring`
(`casadi/core/function_internal.cpp`):

```cpp
if (symmetric) {
  casadi_assert_dev(allow_forward);
  D1 = A.star_coloring();   // symmetry-exploiting: recovers (i,j) AND (j,i) from one direction
}
```

So the full path is **forward-over-reverse**: reverse builds a vector-valued gradient function
`g(x)=∇f`; forward-mode then probes `g` with **star-colored compressed seeds** to assemble
`∇²f`. Star coloring (a distance-2 coloring on the Hessian's adjacency graph,
`SparsityInternal::star_coloring`) needs fewer colors than treating `∇²f` as a generic Jacobian,
because a recovered direction gives both `H[i,j]` and its mirror `H[j,i]`. The symmetric Hessian
**sparsity** is detected/symmetrized first (`jac_sparsity(..., symmetric)` →
`get_jac_sparsity_hierarchical_symm`, itself star-coloring based).

Three things make it subtler than the linear Jacobian: (a) two composed modes (forward-over-
reverse) rather than one sweep; (b) the seed compression must preserve **symmetry**, so it is
**star** coloring, not the distance-2 unidirectional coloring of §12; (c) the Hessian pattern is
not given — it must be detected and symmetrized before coloring.

### 14.1 The diff engine's Hessian: structured weighted-sum accumulation, no coloring

The diff engine computes the **Lagrangian Hessian** `Σᵢ wᵢ ∇²cᵢ(x) + w₀∇²f(x)` by a
**downward weight propagation** — `eval_wsum_hess(node, w)` carries a dual/weight vector `w` into
children (forward-over-reverse *flavoured*, but with **explicit sparse blocks**, never seeds).
For the canonical `quad_form` atom `h(x)=f(x)ᵀQ f(x)` it assembles two sparse terms directly
(`src/atoms/other/quad_form.c`):

```c
/* hess = term1 + term2:
 *   term1 = Jf^T (2wQ) Jf            (the Gauss-Newton / curvature-through-Jf part)
 *   term2 = Σ (2w·Qf)_i ∇²f_i        (child curvature, via x->eval_wsum_hess) */
node->work->hess_term1 = new_sparse_matrix(BTA_alloc(Jf, B));   // structure once
wsum_hess_init(x);
node->work->hess_term2 = x->wsum_hess->copy_sparsity(x->wsum_hess);
node->wsum_hess = ...; sum_matrices_alloc(term1, term2, node->wsum_hess);
```

and on each evaluation only refills values (`eval_wsum_hess_sparse`): scale `Q` by `2w`, recompute
`Jfᵀ B(w) Jg` via the cached sparse-matmul pattern, recurse into the child for `term2`, add. The
**global Lagrangian Hessian** is stacked from each node's `wsum_hess` into one CSR through a
**precomputed `hess_idx_map`** built once in `problem_init_hessian` /
`problem_lagrange_hess_fill_sparsity` (`src/problem.c:240,85`); thereafter it is a scatter of
values into fixed slots.

**The contrast in one line:** CasADi *recovers* the symmetric Hessian by star-colored
forward-over-reverse seed sweeps; the diff engine *builds* it as an explicit sum of structured
sparse blocks (`Jᵀ D J + Σ wᵢ∇²fᵢ`) with the pattern computed once — **no gradient tape, no
star coloring, no seeds, no symmetry-recovery**, because the symmetric pattern is known per atom
and assembled directly.

---

## 15. diff engine vs CasADi — pros and cons

| axis | **CasADi (MX + coloring)** | **diff engine (structured accumulation)** |
|---|---|---|
| Jacobian route | oracle: seeded JVP/VJP sweeps + coloring + scatter | direct: per-atom analytic sparse `J`, composed bottom-up |
| Hessian route | forward-over-reverse, star coloring, symmetry recovery | weighted-sum sparse blocks `JᵀDJ + Σwᵢ∇²fᵢ`, pattern once |
| sparsity pattern | **detected** then colored (heuristic, greedy) | **known** per vectorized atom, computed once |
| seeds / coloring | required (compressed seed matrix, §13) | **none** |
| whole-program opt | CSE, constant folding, codegen to flat C | none — re-walks the live tree each call |
| arbitrary nonlinearity | yes (any smooth op) | only its DCP atom library (conic/QP-shaped) |
| memory per pass | light (carries `nfwd` vectors) | heavier (carries full sparse matrices) |
| parametric re-extract | re-run sweeps (tape folds constants → fast) | refill values into fixed patterns (no detection) |
| optimal accumulation order | N/A (seed-based) | fixed topological/forward order (NP-hard optimum moot) |

**CasADi wins when:** the nonlinearity is arbitrary; the data has lots of constant structure the
tape can fold (the LS micro-benchmark — `P` constant, `q=−2Aᵀb` collapsed to one matvec); you want
codegen / branch-free C; or the matrix is so structured that a handful of colors recovers it
cheaply. Its costs are the *machinery*: sparsity detection, a greedy (non-optimal) coloring, the
seed/scatter bookkeeping, and re-running sweeps on every parametric solve.

**diff engine wins when:** the problem is DCP conic/QP, the sparsity pattern is fixed across a
parametric sweep, and you want the **explicit** `A,P` (or Lagrangian `H`) with *zero* detection or
coloring overhead — assemble-once, refill-many. Its costs are the missing whole-program folding
(re-walking nodes and reassembling matrices each call — why it loses the constant-data
micro-benchmark) and a weaker per-entry numeric kernel (`sparse_dot` vs a Gustavson accumulator,
§6). Both are second-order to the first-order win of *never paying for structure you already know*.

**The honest framing for the thesis:** these are not faster/slower versions of the same algorithm
— they sit at **opposite ends of §4**. CasADi is the *oracle + coloring* branch (recover the
matrix from directional-derivative probes); the diff engine is the *direct accumulation* branch
(carry the explicit structured matrix). Coloring is "structure recovered after the fact";
vectorized accumulation is "structure preserved up front" (§7 slogan).

---

## 16. Wider literature: other optimization interfaces (AMPL, GAMS, Pyomo, Convex.jl, Gravity)

Two orthogonal questions sort every modeling system: **(i)** scalar tape vs vectorized graph;
**(ii)** are coefficients **stored** (read off what the user typed), **differentiated** (reverse/
forward AD over a tape), or assembled via **sparsity-detection + graph coloring**?

| system | representation | derivative mechanism | coloring? |
|---|---|---|---|
| CVXPY / JuMP-MOI / **Convex.jl** | affine/quadratic/conic coefficient **store** | none — coefficients from user input / matrix stuffing | n/a |
| **AMPL** (ASL, `.nl`) | scalar expression DAG | **reverse-mode AD** | **no — partial separability** |
| **GAMS** | interpreted nonlinear instruction tape | AD (mode unverified) | sparsity yes; coloring unverified |
| **Pyomo**-NL / PyNumero / cyipopt | scalar `.nl` tape (via ASL) | **reverse-mode AD** (ASL) | no — ASL tape structure |
| JuMP-nonlinear | scalar expression graph | reverse-mode AD | **yes — coloring** |
| **Gravity** | symbolic **template** constraints | **symbolic** diff of one template, re-indexed | no — de-dup/caching |
| CasADi (SX/MX) | sparse scalar / vectorized graph | forward + reverse AD | **yes — uni + star coloring** |
| JAX | traced array/tensor program | forward + reverse AD | no — dense `vmap` batching |
| **diff engine** | vectorized DCP graph | structured forward/wsum accumulation | **no — pattern known per atom** |

**AMPL (the key comparator).** AMPL writes the model to `stub.nl` (prefix-notation expression
graphs); the **AMPL Solver Library (ASL)** rebuilds the DAG and does **operator-overloaded
reverse-mode AD** — `objval/objgrd`, `conval/jacval`, and the Lagrangian-Hessian family
`sphsetup`+`sphes` (sparse) / `fullhes`, with readers `fg_read`…`pfgh_read`. Critically, AMPL
gets sparse **Hessians not by graph coloring but by detecting partial separability**
`f(x)=Σ fᵢ(Aᵢx)` (and group partial separability, the LANCELOT form), assembling `∇²f` as a sum of
small dense blocks. *Gay's expression-graph paper contains zero occurrences of "coloring."* This
makes **AMPL the closest prior art to the diff engine's philosophy**: exploit *known structure*
to assemble the sparse second derivative directly, rather than detect-then-color. The difference
is granularity — AMPL's structure is *partial separability of a scalar tape*; the diff engine's is
*per-atom analytic sparsity of a vectorized DCP graph*.

**Gravity** is the other "structured accumulation without coloring" cousin: it **symbolically
differentiates one indexed *template* constraint once** and re-indexes data to materialize all
instances, explicitly marketing this against "AD implementations (e.g. JuMP) which use graph
coloring for exploiting Hessian sparsity." **GAMS** ships an interpreted nonlinear instruction
file (a tape) evaluated by the solver link via the GMO API (AD mode not cleanly documented).
**Pyomo**'s production NLP path is just AMPL's: its NL writer emits `.nl` and the ASL does the AD
(PyNumero/cyipopt wrap the same ASL through ctypes); Pyomo's native `differentiate` reverse-AD is
an analysis utility, not the solver feed. **Convex.jl** is the Julia CVXPY: DCP atoms certified by
curvature/monotonicity rules (*not* differentiation), matrix-stuffed into conic `(A,b,c)` over
MOI — pure coefficient store. **JAX/Enzyme** are vectorized/IR-level AD backends with no sparsity
detection (JAX densely `vmap`-batches seeds; Enzyme differentiates optimized LLVM IR).

**Where the diff engine sits:** in the **store-vs-differentiate-vs-color** taxonomy it is a fourth
thing — *differentiate, but with statically-known per-atom sparsity, so neither detection nor
coloring is ever needed*. Its nearest neighbours are **AMPL (partial separability)** and
**Gravity (template de-duplication)** — both "structured accumulation without coloring" — but it
is the only one operating on a **vectorized DCP conic/QP** graph and feeding **CVXPY's non-DPP
parametric gap** directly.

---

## 17. Additional references (this pass)

**AMPL / ASL (reverse-mode AD + partial separability — closest prior art)**
- Fourer, Gay, Kernighan — *A Modeling Language for Mathematical Programming.* Management Science
  36(5), 1990. https://doi.org/10.1287/mnsc.36.5.519
- Gay — *Automatic Differentiation of Nonlinear AMPL Models.* In Griewank & Corliss (eds.), SIAM
  1991. (Bell Labs NAM 91-05.)
- Gay — *Hooking Your Solver to AMPL.* Bell Labs NAM 93-10, 1993/97.
  https://ampl.com/wp-content/uploads/Hooking-Your-Solver-to-AMPL-by-David-M.-Gay.pdf
- Gay — *More AD of Nonlinear AMPL Models: Computing Hessian Information and Exploiting Partial
  Separability.* In *Computational Differentiation*, SIAM 1996.
- Gay — *Using Expression Graphs in Optimization Algorithms.* In *Mixed Integer Nonlinear
  Programming* (IMA 154), Springer 2012. https://www.osti.gov/servlets/purl/1141882

**Other modeling languages**
- Drud — *Interactions between nonlinear programming and modeling systems.* Math. Prog. 79, 1997.
  https://doi.org/10.1007/BF02614313  (GAMS; primary source for AD mode — verify before asserting)
- Bussieck & Meeraus — *GAMS.* In *Modeling Languages in Mathematical Optimization*, Springer 2004.
- Hart, Watson, Woodruff — *Pyomo.* Math. Prog. Computation 3(3), 2011.
  https://doi.org/10.1007/s12532-011-0026-8
- Rodriguez et al. — *Scalable Parallel Nonlinear Optimization with PyNumero and Parapint.*
  INFORMS J. Computing 35(2), 2023. https://doi.org/10.1287/ijoc.2023.1272
- Udell, Mohan, Zeng, Hong, Diamond, Boyd — *Convex Optimization in Julia* (Convex.jl). HPTCDL
  2014. https://arxiv.org/abs/1410.4821
- Hijazi, Wang, Coffrin — *Gravity: A Mathematical Modeling Language for Optimization and Machine
  Learning.* NeurIPS 2018 MLOSS. https://openreview.net/pdf?id=SygqpT-2YQ

**AD backends / coloring (already partly in §10)**
- Moses & Churavy — *Instead of Rewriting Foreign Code for ML, Automatically Synthesize Fast
  Gradients* (Enzyme). NeurIPS 2020. https://arxiv.org/abs/2010.01709
- Bradbury et al. — *JAX: composable transformations of Python+NumPy programs.* 2018.
- Dalle & Hill — *Sparser, Better, Faster, Stronger: Efficient AD for Sparse Jacobians and
  Hessians.* 2025. https://arxiv.org/abs/2501.17737  (modern detection+coloring pipeline)

**CasADi source (cite by file → function; line numbers drift, CasADi 3.7.2+ `main`)**
- `casadi/core/mx_function.cpp` → `MXFunction::ad_forward` / `ad_reverse` — batched `nfwd`/`nadj`
  sweeps over the instruction tape.
- `casadi/core/mx_node.hpp` → `MXNode::ad_forward` / `ad_reverse` — per-node multi-direction AD.
- `casadi/core/function_internal.cpp` → `ad_weight()` (default 0.33), `get_partition()`
  (mode choice + `uni_coloring`/`star_coloring` dispatch).
- `casadi/core/x_function.hpp` → `XFunction::jac()` — compressed (non-identity) seed build +
  scatter-back recovery.
- `casadi/core/sparsity_internal.cpp` → `uni_coloring()` (distance-2 unidirectional),
  `star_coloring()` / `star_coloring2()` (symmetric/Hessian). **No `bw_coloring`.**
- `casadi/core/mx.cpp` → `MX::hessian`; `casadi/core/sx_instantiator.cpp` → `SX::hessian` —
  Hessian = `jacobian(gradient(f), symmetric=true)`.
- `casadi/core/generic_matrix.hpp` → `GenericMatrix::gradient` — reverse-mode (`jtimes` tr=true).
- Running example: `Jacobian-accumulation/casadi/sparse_jacobian.py` (tridiagonal, `uni_coloring`
  → 3 colors; §13).

**diff engine Hessian source**
- `include/expr.h` — `wsum_hess` matrix, `wsum_hess_init_impl` / `eval_wsum_hess` two-phase fns.
- `src/atoms/other/quad_form.c` — `wsum_hess_init_*` / `eval_wsum_hess_*` (`JᵀDJ + Σwᵢ∇²fᵢ`).
- `src/atoms/bivariate_full_dom/multiply.c`, `.../matmul.c` — `eval_wsum_hess` weight backprop.
- `src/problem.c` — `problem_init_hessian` (`:240`), `problem_lagrange_hess_fill_sparsity` (`:85`),
  `hess_idx_map` stacking into the global Lagrangian CSR.
