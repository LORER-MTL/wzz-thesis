# Final revisions: response table

Sources:
- **J**: the jury's required modifications, after the defence.
- **SLD**: Sébastien Le Digabel's minor corrections. Page numbers refer to the defended PDF.
- **AL**: Antoine Legrain's final examiner report (`examiner_report_2362162.pdf`).

How to use this file:
- The diff against the version sent to the jury (`21b013b`) is built by `make diff`, which
  writes `Document-diff.pdf`.
- Drafting sources: `plans/legrain-rebuttal.md`, `plans/legrain-thesis-changes.patch`, and
  `plans/legrain-deferred-experiments.md`.
- The plan is in `~/.claude/plans/pasted-content-id-0ad8-modifications-1-abundant-bubble.md`.

Status values: `todo`, `done`, `needs William` (a decision or the wording is his).
The **Where** column gives the section and the page in the final PDF (`Document.pdf` built from
`final-results-lean`, 14 Oct 2026). Rebuild and recheck the pages after any further edit.

## Required (jury and Legrain)

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| J1a | Statistical significance (p-values) of every numerical test | Every timed comparison of 20 runs is tested with a two-sided Mann–Whitney test, Holm-adjusted over the problems of the comparison. On Table 4.1 the replicates of the two backends never overlap, so every adjusted p-value is 1.7×10⁻⁶, the smallest attainable with 20 replicates; §4.1 states it. Significant ratios are starred in Tables 4.1, 4.2, A.6 and A.7, and the caption of Table A.5 states that all seven of its differences are significant (all six non-DPP ratios significant, every std below 1 % of the mean). The sensitivity points of App. A.5 are five-run medians, and the text says they are reported without a test. | Ch. 4 intro and §4.1, p. 52; Table 4.1, p. 55; Table 4.2, p. 57; App. A, pp. 73–81; Table A.6, p. 77 | done |
| J1b / AL-ii | Ablation: separate the two contributions (time, memory) | App. A.4, pointed to from §4.2 and §4.3: two contrasts, reported as measurements: no dense blocks on the first canonicalization (25 problems, with memory) and no split on the re-solves (7 DPP); per-problem values in App. A. A.4 says why the dense blocks raise peak memory (the zeros of a constant that is sparse in fact, e.g. ConvexPlasticity's diagonal) | §4.1, p. 56; App. A.4, p. 77 | done |
| J1c | More instances (random parameters, modified instances) | Each replicate draws new parameter values from its own seed; all 25 suite problems at three sizes, nine of them and the lasso family at five, five problems at five densities | Ch. 4 intro, p. 52; App. A.1, pp. 71–73; App. A.5, pp. 79–81 | done |
| J1d / AL scaling | Sensitivity to problem characteristics (size, % sparsity) | App. A.5, pointed to from §4.1: all 25 problems at three sizes and ten families at five, in Tables A.8–A.9, five problems at five densities (Table A.10) | §4.1, p. 56; App. A.1, pp. 71–73; App. A.5, pp. 79–81 | done |
| J1e / AL-iii | Non-DPP problems: DPP versus non-DPP gain against CVXPY | App. A.3.1: lasso and factor_cov in DPP / non-DPP / parameter-free variants, Table A.6; §4.2 keeps the 12–13× headline, and the 1st Discussion observation cites App. A.3.1, which also reports ConvexPlasticity, the suite's one non-DPP parametric problem, where the cached re-solve is slower (204 vs 42 ms) because of its dense Hessian block, and 18× faster without dense blocks | §4.2, p. 57; App. A.3.1, pp. 76–77 | done |
| J2 / AL-i | Related literature: matrix-free, CVXcanon, CVXGEN, Convex.jl 0.16, antecedents, Pyomo APPSI, DNLP delineation | Drafts D1–D7 (PR #3). Legrain 3e (dense blocks in sparse formats): two cited sentences in §3.2 and where our blocks differ; the informal appendix was dropped | §2.1.3, pp. 23–24 (CVXcanon, CVXGEN); §2.2, p. 25 (matrix-free); §2.3.1, p. 31 (Pyomo); §2.3.2, p. 33 (Convex.jl); §3.2, p. 39 (block-sparse antecedents) | done |
| J3 | AI-use declaration | New front-matter page with the content of ai-usage-wzz.md: same sections and points, letter framing removed, language cleaned up | front matter, p. vii | done |
| AL-iv | Repeated measurements, mean ± std | 20 replicates in fresh processes (10 above 30 s, never reached); tables in mean ± std | Ch. 4 intro, p. 52; Table 4.1, p. 55; App. A, pp. 73–78 | done |
| AL-v | Dimensions of every instance | Tables A.1 (descriptions) and A.2: m, n, nnz(A), nnz(P), param. size, DPP (checked against the dims of the final runs) | App. A, Tables A.1–A.2, pp. 71–73 | done |
| AL-vi | Time by phase, explaining the underperforming problems | §4.1 names the four slower problems and the two causes in two sentences; App. A.2.1 gives, for each, the formulation, the phase shares (Table A.4) and the mechanism. Mechanisms: the matmul chain of UnconstrainedQP evaluated away from its constant (98 % numeric pass; 16 ms with CVXPY #3524, 489 ms without dense blocks), dense constant data (SDPSegfault1132, ConvexPlasticity), and the global layout (OptimalAdvertising: each of the 250 minimum terms has a Jacobian over all 250 000 variables, and the symbolic pass visits every column, so the cost grows with terms × variables). QuantumHilbertMatrix is no longer slower (0.82) once the rewrite is left out on both sides, so its paragraph was dropped. Found by sampling the native stacks on the thesis build | §4.1, p. 55; App. A.2.1, pp. 74–75 | done |
| AL-vii | Explicit statement of the correctness check against the existing backends | Sentence in the Ch. 4 intro (1e-9 relative, first and after update, against CPP). It names the one exception: OptimalAdvertising's generator divides 0/0, so one coefficient is NaN; diffengine (b = constraints at the origin) carries it into one entry of b as well as into A | Ch. 4 intro, p. 52 | done |

## Le Digabel, minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| SLD1 | p. vii: « librairie » → « bibliothèque » | « bibliothèque logicielle » (also meets AL's « logiciel ») | Résumé, p. x | done |
| SLD2 | p. xv: consistent case in the acronym list | All expansions lowercase except proper nouns (AMPL, MathOptInterface, Jacobian), in both lists | List of acronyms, p. xix | done |
| SLD3 | p. 2: convexity in x suffices, not in (x, θ) | Convex (resp. affine) in x for every fixed θ | §1.1, p. 2 | done |
| SLD4 | pp. 2–3: link between m in (1.2) and m₁, m₂ in (1.1) | Sentence after (1.2): m ≠ m₁+m₂ in general (vector constraints, auxiliary rows/variables); cone count in (1.3) renamed r | §1.1, p. 2; §1.3 | done |
| SLD5 | p. 4: are x_i, θ_i scalars or vectors? | x_j ∈ ℝ^{n_j}, θ_j ∈ ℝ^{p_j}, with n = Σn_j, p = Σp_j | §1.2, p. 4 | done |
| SLD6 | p. 7: [27] is an arXiv report, not a paper | « A recent report » ([27] = zhang2026cvxpy, confirmed against a fresh .bbl) | §1.3, p. 7 | done |
| SLD7 | p. 20 and elsewhere: non-breaking spaces (cleveref) | All 41 \eqref after a breakable space now tied with ~ (\ref/Figure~ were already tied); cleveref not needed | all chapters | done |
| SLD8 | p. 21, Fig. 2.4: key « -1 » unexplained | Caption: −1 is CVXPY's id for the constant column, labelled 1 in both layouts | Fig. 2.4, p. 22 | done |
| SLD9 | p. 39: m and n reused | Stacked-PD subsection uses k×q expression, B ∈ ℝ^{r×k}; perf-profile count is N | §3.2.3, p. 42; §4.1, p. 52 | done |
| SLD10 | pp. 41–42: B is data in Table 3.2 but a Jacobian in Fig. 3.5 | Table 3.2 caption and dispatch text: B is data in BA, a second Jacobian in sum_matrices/BTA/BTDA (checked against quad_form.c) | Table 3.2 and §3.3.1, p. 43; Fig. 3.5, p. 44 | done |
| SLD11 | p. 41: for BA the outer selector also changes | BA written out as its own equation (3.3); text says both selectors of B swap roles, result at rows r_B | §3.3.1, p. 44 | done |
| SLD12 | p. 46: Listing 3.2's « Ax + b ∈ K » differs from (1.2) | Text says the class stores Ax + b ∈ K and CVXPY negates A to get (1.2); showstringspaces=false | §3.4.2, p. 48 | done |
| SLD13 | p. 49: SCIPY is fastest on three problems, not at most two | Recounted on the final runs: no CVXPY backend is fastest on more than two | §4.1, p. 53 | done |
| SLD14 | p. 51: the 0.01 ratio on UnconstrainedQP needs a comment | The 0.01 came from comparing a diffengine branch that contained CVXPY #3524 (reassociation of matmul chains ending in a constant) with stock CVXPY. All four backends are now timed without #3524, which applies to every backend; the setup says so. UnconstrainedQP is then 11.8× *slower* (22.9 s against 1.95 s for CPP), and §4.1 explains why and gives the 16 ms it takes with #3524. The earlier best-of-both table (Table A.3 in the previous draft) is removed | Ch. 4 intro, p. 51; §4.1, p. 55 | done |
| SLD15 | p. 52: Table 4.2 diffengine times equal Table 4.1's, and 0.001 s rounding hides the ratios | Re-solves now in ms; text says the diffengine first-canonicalization column repeats Table 4.1 because it builds no tensor | §4.2, pp. 56–57 | done |

## Legrain, other minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| AL-m1 | Attribute the symbolic/numeric split to sparse factorization first (p. 3, p. 46) | Davis and Gustavson cited before the NLP interfaces in the Intro's approach paragraph, §1.5, the Ch. 3 opening and §3.5 | §1.2, p. 3; §1.5, p. 17; Ch. 3 opening, p. 36; §3.5, p. 49 | done |
| AL-m2 | Table 2.2: qualify the AMPL/Pyomo row (Pyomo persistent interfaces) | Draft D6 (PR #3): Pyomo persistent interfaces after the .nl sentence, note under the table | §2.3.1, p. 31; Table 2.2 (§2.4), p. 35 | done |
| AL-m3 | §1.5, §3.1: delineate the contribution relative to DNLP | §3.1: the engine is joint work with Daniel Cederberg and serves both uses; DNLP differentiates nonlinear atoms at every iterate, this thesis evaluates the affine atoms and the quadratic form to get the problem data; specific to the thesis are the diffengine backend, its re-solve path and the Ch. 4 benchmarks. §1.5 item 1 points there | §1.5, p. 17; §3.1, p. 37 | done |
| AL-m4 | p. 48: PR #3448 merged 9 Sept 2026 (opt-in, parameter-free); parametric path not yet merged | Merged 9 Sept 2026, opt-in, parameter-free; parametric path not yet integrated (verified via GitHub API) | Ch. 4 setup, p. 51 | done |
| AL-m5 | Ch. 4: the author contributed to the SCIPY and COO backends | One sentence in the setup | Ch. 4 setup, p. 51 | done |
| AL-m6 | p. 52: « faster than cvxcore on 24 of the 25 » | « faster than cvxcore on 23 of the 25 » (final runs) | §4.3, p. 57 | done |
| AL-m7 | p. 46: harmonize the « main contribution » with §1.5 and the Ch. 3 opening | Same order everywhere, with no "main contribution": the matrix classes first, the split second, in §1.5 item 1, the Ch. 3 opening and §3.5 | §1.5, p. 17; Ch. 3 opening, p. 36; §3.5, p. 49 | done |
| AL-m8 | p. 48: number of repetitions and the BLAS implementation | Apple M2 (24 GB, macOS 26.5.1), Accelerate, single-threaded; 20 replicates | Ch. 4 setup, p. 51 | done |
| AL-m9 | Fig. 3.5: do not rely on colour alone | Letters (a)–(d) in cells and legend; caption mentions them | Fig. 3.5, p. 44 | done |
| AL-m10 | Refs [41] [42] [43] [76] [88]: p. → pp. | En-dashes → --; [88] page → « Art. no. 2 » | References, pp. 62–70 | done |
| AL-m11 | Refs [60] Eigen, [72] CppAD, [21] MOSEK: URLs, version | URLs as howpublished; MOSEK @misc + docs URL; Eigen version 3.4.0 (bundled with cvxcore) | References, pp. 62–70 | done |
| AL-m12 | Ref [17] CVX: old version | Note « canonical reference; current release 2.2 » (checked cvxr.com) | References, p. 63 | done |
| AL-m13 | Complexity analysis of the representations (memory, product cost) | Draft D7 (PR #3): storage and symbolic/numeric operation counts against CSR + Gustavson | §3.3.1, p. 45 | done |
| AL-m14 | Future work: re-evaluate only the parameter-dependent subtrees | Implemented in the measured engine (SparseDiffEngine #125): after a parameter update, the numeric pass re-evaluates only the subtrees that contain a parameter. One sentence in §3.4.1. With it, the numeric pass is 3–20 % of a re-solve on the five problems where the tensor is faster; the rest is the conversion to CSC and the cone order, which is now the future-work item | §3.4.1, p. 47; Conclusion §Future, p. 61 | done |
| AL-m15 | Defence Q5: memory of the global layout with many variables | Limitation: global layout costs O(nodes × n) integers (expr.c:54); local layout better for many variables + deep trees | Conclusion §Limitations, p. 60 | done |

## Replies to Legrain that do not change the thesis

Points raised by a second, adversarial reading. We answer them here rather than in the text.

| Point | Reply |
|---|---|
| Why the speedup (ii) | §4.1 now says it: without dense blocks the engine is 1.07× slower in geometric mean, not significant over the suite (p = 0.07), and 2.17× faster than the best CVXPY backend; the split plays no part in a first canonicalization. Most of the speedup therefore comes from the rest of the implementation (C, one Jacobian per node over all variables, no materialized views, no tensor). The dense blocks add about 2× on the problems with dense data and cost 47× on UnconstrainedQP and 5.1× on ConvexPlasticity (Table A.7), so over the suite they are not a net gain. |
| Suite-level significance (J1a) | Over the 25 problems, the geometric mean 0.43 of Table 4.1 has a bootstrap 95 % CI of 0.28–0.70, and a Wilcoxon signed-rank test on the log-ratios gives p = 0.003. The ablation's 1.07× has a CI of 0.71–1.47 (p = 0.07), so it is not significant over the suite. |
| Why the dense blocks raise peak memory (0.85× without them) | The first sentence is now in App. A.4. A dense block stores every entry, including the zeros of a constant that is sparse in fact, e.g. the diagonal of ConvexPlasticity. On OptimalAdvertising (6 GB against 945 MB without dense blocks) the likely cause is per-node caches and work arrays sized by n_vars (250 000 variables), the global-layout overhead stated in the Limitations. **To confirm (William).** The AL-vi profile confirms the global layout as the cause of the time, not of the memory: it was not a memory profile. |
| Split ablation | The 2.56× without the split includes the Python-to-C conversion as well as the symbolic pass. On the two small problems most of it is the conversion (14 % of a first canonicalization, against 1 % for the symbolic pass). Both are what the cached problem avoids. |
| A real non-DPP problem | Now stated in App. A.3.1. ConvexPlasticity is the suite's only non-DPP parametric problem. diffengine re-solves it in 204 ms, against 42 ms for CVXPY recompiling, because 88 % of the re-solve assembles the dense 3000 × 3000 Hessian block built from a diagonal given as a dense array. Without dense blocks it re-solves in 2.3 ms, 18× faster than CVXPY. The fix is a density test before keeping a constant dense (below). |
| Sizes at which runs fail | At s = 2, diffengine exceeds 20 GB on CVaR, SDPSegfault1132 and QuantumHilbertMatrix, and at s = 4 on OptimalAdvertising. COO also fails at CVaR and SDPSegfault1132 s = 2, and every fork backend at QuantumHilbertMatrix s = 2. |
| Slower problems (vi) | Phase shares: UnconstrainedQP 98 % numeric (22.9 s; profiled with `sample` and lldb on .venv-thesis: ((H_H @ E) @ H) @ x is evaluated from the left, the product with H fills a dense 63 504 × 36 Jacobian, and four such real products in `BA_pd_csc_fill_values`, a scalar sparse–dense dot loop, take about 19 600 of 20 300 samples), OptimalAdvertising 90 % symbolic, SDPSegfault1132 48 % symbolic and 48 % numeric, ConvexPlasticity 47 % symbolic (assembly 38 %). Mechanisms now in §4.1 (AL-vi): for OptimalAdvertising, `csr_to_csc_alloc` and `BA_pd_csc_alloc` sweep all 250 000 columns once per minimum term (about 70 % of the profile samples). QuantumHilbertMatrix (0.82, faster) keeps its known inefficiency: `convert_expr` has no memo, so the shared product is converted once per partial-trace term. |
| Where to direct effort | Now in the Conclusion, §Future Research. The backend already stores a constant factor of a matrix product sparse when it has fewer than 5 % nonzeros (`SPARSE_DENSITY_THRESHOLD`), which is why the density sweep recovers at 1 %. The quadratic-objective path (`convert_symbolic_quad_form`) has no such test, so ConvexPlasticity's dense-stored diagonal becomes a dense 3000×3000 block. Setting the threshold from the kernel costs and applying it to the quadratic objective would remove the ConvexPlasticity and density-sweep slowdowns. UnconstrainedQP's slowdown is removed by CVXPY #3524 (now said in the Conclusion). |
| Baseline of Table 4.1 | An earlier draft credited each CVXPY backend with the faster of its times with and without CVXPY #3524, while diffengine always had it. All four backends are now timed without #3524: diffengine from the first M2 sweep (fork 35e81b1, the same engine 4f42e05) on the five problems where #3524 fires, CVXPY 1.9.2 as released. This lowers the headline from 2.5× to 2.3× (21 of 25 faster, not 20), makes UnconstrainedQP 11.8× slower and QuantumHilbertMatrix faster, and turns the dense-block ablation from 1.27× (significant) to 1.07× (not significant). Memory: 1.02× CPP, 0.96× COO, 1.42× SCIPY in geometric mean (was 0.87, 0.83, 1.22). |
| Q1, matrix-free | §2.2 now says when matrix-free pays off and places permuted dense between an operator and CSR. We materialize because the solvers CVXPY calls by default factorize a matrix built from A and P. Matrix-free wins for very large problems with fast transforms and first-order solvers. A permuted dense block sits between the two: a materialized matrix that keeps the operator's structure, its selectors and its dense block. |
| Q7, BLAS and binaries | sparsediffpy is a compiled C extension, so wheels are still built per platform. It links against the platform BLAS (Accelerate on macOS, OpenBLAS on Linux through CMake's FindBLAS); unlike cvxcore it needs no C++ toolchain or Eigen. **William: confirm the wheel strategy.** |
