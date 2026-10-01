# Rebuttal plan for Legrain's examiner report

Source: `RapportExaminateur_2362162_Legrain.pdf` (24 Sept 2026). Recommendation: the defence may go
ahead, on condition that items (i)–(vi) are carried out in full before final deposit. He will
check them. A separate detailed report with defence questions is still to come.

**Status, 2026-09-29.** A first round of edits went into the thesis as blue `[AL]` markup. The
edits were **reverted**: I did not like them as written. This file keeps their content so each
item can be answered, or re-drafted, on its own terms. The exact reverted diff is in
`plans/legrain-thesis-changes.patch`. Any piece of it can come back with
`git apply --include=<file> plans/legrain-thesis-changes.patch`, or by hand-copying from the
**Drafted text** blocks below. Items ii–vi are experiments, planned in
`plans/legrain-deferred-experiments.md`.

One entry per request: **Request**, **Short answer**, **Drafted text** (what was reverted),
**Where**, **Status**.

---

## (i-a) Discuss matrix-free modelling (Diamond & Boyd 2016)

**Request:** position the work against matrix-free convex modelling.

**Short answer:** matrix-free modelling never forms A, so it has no assembly cost. It only
serves solvers that need nothing more than the products Ax and Aᵀy. The solvers CVXPY calls by
default (Clarabel, MOSEK, and SCS/OSQP in direct mode) factorize a matrix built from A and P, so
they need A explicitly. The thesis keeps the explicit matrix and makes it cheaper to form.

**Drafted text** (an ALblock after "Our approach in Chapter 3 addresses these limitations"):
> Two earlier efforts answer the same question of how to make matrix stuffing cheaper.
> `cvxcore` itself began as `CVXcanon` [miller2015cvxcanon], a C++ rewrite of the Python matrix
> stuffing of early CVXPY versions, which was later renamed and absorbed into the library. It
> keeps the approach of this section, forming A explicitly, and moves the work into compiled
> code. Diamond and Boyd take the opposite approach [diamond2016matrixfree]: they never form A,
> and represent each linear function in the problem as an abstract operator that supports only
> the products Ax and Aᵀy. Such operators feed first-order or Krylov-based solvers directly and
> remove the cost of assembly altogether. Their scope is different from ours. Interior-point
> solvers such as Clarabel and MOSEK, and operator-splitting solvers such as SCS and OSQP in
> their default direct mode, factorize a matrix built from A and P, and therefore need these
> matrices explicitly. This thesis keeps the explicit matrix and reduces the cost of forming it.

**Where:** `6-Revue_litterature.tex`, end of the matrix-stuffing section ("two limitations").
**Status:** reverted.

## (i-b) Antecedents: the symbolic/numeric split, and dense blocks in sparse Jacobians

**Request:** acknowledge that the two-phase split and dense-block exploitation are older.

**Short answer:** agreed. Sparse direct solvers have separated symbolic analysis from numeric
factorization since George & Liu, and Gustavson's product works in the same two phases.
Finite-element assembly and Ceres both exploit dense blocks. What is new is where these ideas
are applied.

**Drafted text** (Intro, "Our approach", after the IPOPT sentence):
> The idea itself is older. Sparse direct solvers have long split a factorization into a
> symbolic analysis of the sparsity pattern and a numeric factorization that can be repeated
> for new values on the same pattern [george1981computer, davis2006direct, chen2008cholmod],
> and Gustavson's sparse product has the same two phases [gustavson1978two]. Similarly,
> exploiting dense blocks inside a sparse Jacobian is standard in finite-element assembly and
> in nonlinear least-squares libraries such as Ceres [agarwal2023ceres]. The novelty of our
> approach is therefore architectural: applying these known ideas to the backend of a DCP
> modelling language.

And a clause in §3.5 (`7-Theme1.tex`, "our contribution is the two-phase approach… which we
borrow from the interfaces of NLP solvers"):
> …, and which goes back to the symbolic and numeric factorizations of sparse direct solvers
> [george1981computer, chen2008cholmod].

**Status:** reverted.

## (i-c) Cite CVXcanon, CVXGEN, and the Convex.jl rewrite

**Drafted text:**
- CVXcanon: see i-a.
- CVXGEN (§2, after the CVXPYgen citation): "…, following the earlier code generator `CVXGEN`
  [mattingley2012cvxgen] for small quadratic programs."
- Convex.jl (Intro, list of languages): "…`Convex.jl` [udell2014convex] in Julia, whose
  internals were rewritten in 2024 on top of JuMP's MathOptInterface [convexjl2024release]."

**Status:** reverted.

## (i-d) State frankly that the novelty is architectural

**Drafted text:** the last sentence of i-b ("The novelty of our approach is therefore
architectural…").
**Status:** reverted. The framing needs a decision: the sentence may undersell the matrix
representations, which are new as data structures, and not only as an application of old ideas.

## (i-e) Separate my contribution from the DNLP work

**Short answer:** SparseDiffEngine was written jointly with Daniel Cederberg. It is also the
differentiation engine behind DNLP. The thesis contributes its use for canonicalization: the
CVXPY backend, the parametric re-solve path, and the benchmarks. (Do not invent a finer split
of authorship. See memory `sparsediffengine-authorship`.)

**Drafted text** (an ALblock at the end of §3.1, the overview):
> SparseDiffEngine was developed jointly by Daniel Cederberg and the author. The same library
> also serves as the differentiation engine of the disciplined nonlinear programming extension
> of CVXPY [cederberg2025disciplined], which uses the atoms that canonicalization does not
> need, described in §3.x (atom classes). This thesis contributes the use of the engine for
> canonicalization: the CVXPY backend of §3.x, the re-solve path that caches the symbolic pass
> for parametric problems, and the benchmark study of Chapter 4.

**Status:** reverted.

## (i-f) An elementary complexity analysis

**Drafted text** (an ALblock after eq. `pd-product`, §3.3 kernel dispatch):
> An elementary count makes this precise. Let X_A ∈ ℝ^{m_A×n_A} and X_B ∈ ℝ^{m_B×n_B}, and let
> s = |r_A ∩ r_B| be the number of shared rows. The symbolic pass of (pd-product) merges two
> sorted index vectors in O(m_A + m_B) operations and allocates the n_B × n_A result. The
> numeric pass performs n_B·s·n_A multiply-adds in one `dgemm`. For a stacked operand, both
> counts are summed over the pairs of blocks with intersecting rows. If the same blocks were
> stored as generic sparse matrices, Gustavson's algorithm would perform the same n_B·s·n_A
> multiply-adds, but its symbolic pass would build the full pattern of the result, with
> O(n_B·s·n_A) operations and one stored index per entry. The dense representations therefore
> reduce the symbolic pass and the index storage from the number of entries of a block to the
> number of its rows and columns. In the numeric pass they keep the same operation count and
> replace the index-driven sparse loop by a BLAS call, a gain in the constant factor rather
> than in the asymptotic cost. When one operand is dense and the other is generic sparse, the
> numeric pass costs one multiply-add per stored nonzero of the sparse operand in the shared
> rows, per column of the dense block.

**Status:** reverted.

## (ii)–(vi) Experiments

| # | Request | Plan |
|---|---|---|
| ii | Ablation with and without the dense representations | `DIFFENGINE_NO_DENSE` env var |
| iii | Non-DPP parametric re-solve | ConvexPlasticity + a purpose-built problem |
| iv | Repeated measurements, mean ± std | `BENCH_REPS=5`, fresh subprocess each |
| v | Instance dimensions | record n, m, nnz(A), nnz(P), parameter counts |
| vi | Time broken down by phase; explain the underperformers | expose `prob->stats`, Python stage timers |

Details: `plans/legrain-deferred-experiments.md`. **Status:** not started.

---

## Minor corrections

| Request | Drafted fix | Where | Status |
|---|---|---|---|
| "librairie" → "bibliothèque" | word swap | `3-Resume_sujet.tex` | reverted |
| "24 of 25" vs "21 of 25" look contradictory | "faster *than cvxcore* on 24 of the 25 problems, and faster than all three CVXPY backends on 21" | §4.3 Discussion, bullet 3 | reverted |
| Name the main contribution the same way in §1.5, Ch. 3 and §3.5 | dense matrix classes = main contribution; the split = borrowed (see below) | §1.5 items 1–2; Ch. 3 opening | reverted |
| Fig. 3.5 uses colour alone | each cell and legend entry lettered (a)–(d); caption "its colour and letter (a)–(d) indicate…" | `7-Theme1.tex` `fig:kernel-dispatch` | reverted |
| "p." → "pp." in [41] [42] [43] [76] [88] | Unicode en-dash `–` → `--`; [88] is an article number → `note = {Art. no. 2}` | `Document.bib` | reverted |
| [60] Eigen, [72] CppAD, [21] MOSEK incomplete | `url` → `howpublished = {\url{…}}`; MOSEK `@manual` → `@misc` + docs URL | `Document.bib` | reverted |
| Update the status of the merged PR | "Since then, the pull request below was merged into the main branch of CVXPY on September 9, 2026. It adds diffengine as an opt-in backend for parameter-free problems. The parametric re-solve path of §4.x is still under review in a follow-up pull request (#3449)." | Ch. 4 intro | reverted |

Drafted contribution naming:
- §1.5 item 1: "…with no sparsity detection or graph colouring. Our main contribution within
  it is two matrix representations, permuted dense and stacked permuted dense, and their
  kernels, which keep the dense blocks of the problem data intact and process them with BLAS."
- §1.5 item 2: "…built on SparseDiffEngine. It applies a symbolic and numeric split, borrowed
  from NLP solvers and sparse factorization, to canonicalization. This backend avoids…"
- Ch. 3 opening: reordered so that the two matrix classes come first ("Our main contribution is
  two new matrix classes…"), followed by "In addition, we split the computation…" and "This
  two-phase approach is borrowed from NLP solvers and sparse direct factorization, and we apply
  it to canonicalization."

---

## Appendix A: new bib entries (drafted, reverted)

```bibtex
@incollection{diamond2016matrixfree,
  author    = {Diamond, Steven and Boyd, Stephen},
  title     = {Matrix-free convex optimization modeling},
  booktitle = {Optimization and its Applications in Control and Data Sciences},
  series    = {Springer Optimization and Its Applications},
  volume    = {115},
  editor    = {Goldengorin, Boris},
  publisher = {Springer},
  pages     = {221--264},
  year      = {2016}
}

@misc{miller2015cvxcanon,
  author       = {Miller, John and Quigley, Paul and Zhu, Jack},
  title        = {{CVXcanon}: Automatic canonicalization of disciplined convex programs},
  howpublished = {EE364B project report, Stanford University},
  year         = {2015}
}

@article{mattingley2012cvxgen,
  author  = {Mattingley, Jacob and Boyd, Stephen},
  title   = {{CVXGEN}: a code generator for embedded convex optimization},
  journal = {Optimization and Engineering},
  volume  = {13},
  number  = {1},
  pages   = {1--27},
  year    = {2012}
}

@misc{convexjl2024release,
  author       = {{The Convex.jl developers}},
  title        = {{Convex.jl} release notes, v0.16.0},
  howpublished = {\url{https://jump.dev/Convex.jl/stable/release_notes/}},
  year         = {2024}
}

@book{george1981computer,
  author    = {George, Alan and Liu, Joseph W. H.},
  title     = {Computer Solution of Large Sparse Positive Definite Systems},
  publisher = {Prentice-Hall},
  address   = {Englewood Cliffs, NJ},
  year      = {1981}
}

@article{chen2008cholmod,
  author  = {Chen, Yanqing and Davis, Timothy A. and Hager, William W. and Rajamanickam,
             Sivasankaran},
  title   = {Algorithm 887: {CHOLMOD}, supernodal sparse {Cholesky} factorization and
             update/downdate},
  journal = {ACM Transactions on Mathematical Software},
  volume  = {35},
  number  = {3},
  note    = {Art. no. 22},
  year    = {2008}
}

@misc{agarwal2023ceres,
  author       = {Agarwal, Sameer and Mierle, Keir and {The Ceres Solver Team}},
  title        = {{Ceres Solver}},
  howpublished = {\url{https://github.com/ceres-solver/ceres-solver}},
  year         = {2023}
}
```

## Appendix B: revision markup (drafted, reverted)

`defs.tex`. It also needs `xcolor` in place of `color` in `Document.tex` (the patch also added
`patterns` to `\usetikzlibrary`, which nothing used in the end).

```latex
\newif\ifrevmarks
\revmarkstrue
\newcommand{\ALtag}{\ifrevmarks\textsuperscript{\textsf{\scriptsize[AL]}}\,\fi}
\newcommand{\AL}[1]{\ifrevmarks{\color{blue}\ALtag#1}\else#1\fi}
\newenvironment{ALblock}{\ifrevmarks\color{blue}\ALtag\fi}{}
```
