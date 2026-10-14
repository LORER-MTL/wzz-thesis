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
| J1a | Statistical significance (p-values) of every numerical test | We tested every comparison with a two-sided Mann–Whitney test, Holm-adjusted across the 25 problems. All differences are significant. On every problem the replicates of the two backends do not overlap, so every adjusted p-value equals the smallest attainable with 20 replicates, 1.7×10⁻⁶. Significant ratios are starred in Tables 4.1 and 4.2, and §4.1 states the p-value. The ablation ratios are starred per problem in Tables B.3 and B.4, and the counts are in the text of App. B.1. | Ch. 4 intro and §4.1, p. 52; Table 4.1, p. 55; Table 4.2, p. 57; App. B, pp. 75–76 | done |
| J1b / AL-ii | Ablation: separate the two contributions (time, memory) | App. B.1, pointed to from §4.2 and §4.3: two contrasts, reported as measurements: no dense blocks on the first canonicalization (25 problems, with memory) and no split on the re-solves (7 DPP); per-problem values in App. B | §4.1, p. 56; App. B.1, p. 76 | done |
| J1c | More instances (random parameters, modified instances) | Each replicate draws new parameter values from its own seed; all 25 suite problems at three sizes, nine of them and the lasso family at five, five problems at five densities | Ch. 4 intro, p. 52; App. A.1, pp. 71–73; App. B.2, p. 77 | done |
| J1d / AL scaling | Sensitivity to problem characteristics (size, % sparsity) | App. B.2, pointed to from §4.1: all 25 problems at three sizes and ten families at five, in one table (Table B.5), five problems at five densities (Table B.6) | §4.1, p. 56; App. A.1, pp. 71–73; App. B.2, p. 77 | done |
| J1e / AL-iii | Non-DPP problems: DPP versus non-DPP gain against CVXPY | App. C: lasso and factor_cov in DPP / non-DPP / parameter-free variants, Table C.1; §4.2 keeps the 12–13× headline, and the 1st Discussion observation cites App. C | §4.2, p. 57; App. A.1, p. 73; App. C, p. 80 | done |
| J2 / AL-i | Related literature: matrix-free, CVXcanon, CVXGEN, Convex.jl 0.16, antecedents, Pyomo APPSI, DNLP delineation | Drafts D1–D7 (PR #3). Legrain 3e (dense blocks in sparse formats): two cited sentences in §3.2 and where our blocks differ; the informal appendix was dropped | §2.1.3, pp. 23–24 (CVXcanon, CVXGEN); §2.2, p. 25 (matrix-free); §2.3.1, p. 31 (Pyomo); §2.3.2, p. 33 (Convex.jl); §3.2, p. 39 (block-sparse antecedents) | done |
| J3 | AI-use declaration | New front-matter page with the content of ai-usage-wzz.md: same sections and points, letter framing removed, language cleaned up | front matter, p. vii | done |
| AL-iv | Repeated measurements, mean ± std | 20 replicates in fresh processes (10 above 30 s, never reached); tables in mean ± std | Ch. 4 intro, p. 52; Table 4.1, p. 55; App. B, pp. 74–76 | done |
| AL-v | Dimensions of every instance | Tables A.1 (descriptions) and A.2: m, n, nnz(A), nnz(P), params, DPP (checked against the dims of the final runs) | App. A, Tables A.1–A.2, pp. 71–72 | done |
| AL-vi | Time by phase, explaining the underperforming problems | One paragraph at the end of §4.1 on the five slower problems (ConvexPlasticity, QuantumHilbertMatrix, OptimalAdvertising, SDPSegfault1132, UnconstrainedQP), with their phase shares | §4.1, p. 55 | done |
| AL-vii | Explicit statement of the correctness check against the existing backends | Sentence in the Ch. 4 intro (1e-9 relative, first and after update, against CPP). It names the one exception: OptimalAdvertising's generator divides 0/0, so its data holds a NaN. Both backends carry it into A, and diffengine (b = constraints at the origin) also into one entry of b | Ch. 4 intro, p. 52 | done |

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
| SLD14 | p. 51: the 0.01 ratio on UnconstrainedQP needs a comment | The setup states that chains of constant products are reassociated and each CVXPY backend gets the faster of its times with and without this; the ratio is now 1.20, and UnconstrainedQP is covered in the slower-problems paragraph of §4.1 (per-problem times with and without the rewrite in Table B.1) | Ch. 4 intro, p. 51; §4.1, p. 55; Table B.1, p. 74 | done |
| SLD15 | p. 52: Table 4.2 diffengine times equal Table 4.1's, and 0.001 s rounding hides the ratios | Re-solves now in ms; text says the diffengine first-canonicalization column repeats Table 4.1 because it builds no tensor | §4.2, pp. 56–57 | done |

## Legrain, other minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| AL-m1 | Attribute the symbolic/numeric split to sparse factorization first (p. 3, p. 46) | Davis and Gustavson cited before the NLP interfaces in the Intro's approach paragraph, §1.5, the Ch. 3 opening and §3.5 | §1.2, p. 3; §1.5, p. 17; Ch. 3 opening, p. 36; §3.5, p. 49 | done |
| AL-m2 | Table 2.2: qualify the AMPL/Pyomo row (Pyomo persistent interfaces) | Draft D6 (PR #3): Pyomo persistent interfaces after the .nl sentence, note under the table | §2.3.1, p. 31; Table 2.2 (§2.4), p. 35 | done |
| AL-m3 | §1.5, §3.1: delineate the contribution relative to DNLP | §3.1: the engine is joint work with Daniel Cederberg and serves both uses; DNLP differentiates nonlinear atoms at every iterate, this thesis evaluates the affine atoms and the quadratic form to get the problem data; specific to the thesis are the diffengine backend, its re-solve path and the Ch. 4 benchmarks. §1.5 item 1 points there | §1.5, p. 17; §3.1, p. 37 | done |
| AL-m4 | p. 48: PR #3448 merged 9 Sept 2026 (opt-in, parameter-free); parametric path not yet merged | Merged 9 Sept 2026, opt-in, parameter-free; parametric path not yet integrated (verified via GitHub API) | Ch. 4 setup, p. 51 | done |
| AL-m5 | Ch. 4: the author contributed to the SCIPY and COO backends | One sentence in the setup | Ch. 4 setup, p. 51 | done |
| AL-m6 | p. 52: « faster than cvxcore on 24 of the 25 » | « faster than cvxcore on 22 of the 25 » (final runs) | §4.3, p. 57 | done |
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
| Why the speedup (ii) | §4.1 now says it: without dense blocks the engine is 1.27× slower but still 1.95× faster than the best CVXPY backend, and the split plays no part in a first canonicalization. Most of the speedup therefore comes from the rest of the implementation (C, one Jacobian per node over all variables, no materialized views, no tensor). The dense blocks add about 2× on the problems with dense data (Table B.4). |
| Suite-level significance (J1a) | Over the 25 problems, the geometric mean 0.40 of Table 4.1 has a bootstrap 95 % CI of 0.28–0.61, and a Wilcoxon signed-rank test on the log-ratios gives p = 0.001. The ablation's 1.27× has a CI of 1.01–1.55 (p = 0.014). |
| Why the dense blocks raise peak memory (0.87× without them) | A dense block stores every entry, including the zeros of a constant that is sparse in fact, e.g. the diagonal of ConvexPlasticity. On OptimalAdvertising (6 GB against 945 MB without dense blocks) the likely cause is per-node caches and work arrays sized by n_vars (250 000 variables), the global-layout overhead stated in the Limitations. **To confirm (William).** |
| Split ablation | The 2.56× without the split includes the Python-to-C conversion as well as the symbolic pass. On the two small problems most of it is the conversion (14 % of a first canonicalization, against 1 % for the symbolic pass). Both are what the cached problem avoids. |
| A real non-DPP problem | ConvexPlasticity is the suite's only non-DPP parametric problem. diffengine re-solves it in 203 ms, against 43 ms for CVXPY recompiling, because 88 % of the re-solve assembles the dense 3000 × 3000 Hessian block built from a diagonal given as a dense array. Without dense blocks it re-solves in 2.3 ms, 19× faster than CVXPY. The fix is a density test before keeping a constant dense (below). |
| Sizes at which runs fail | At s = 2, diffengine exceeds 20 GB on CVaR, SDPSegfault1132 and QuantumHilbertMatrix, and at s = 4 on OptimalAdvertising. COO also fails at CVaR and SDPSegfault1132 s = 2, and every fork backend at QuantumHilbertMatrix s = 2. |
| Slower problems (vi) | Symbolic-pass shares: OptimalAdvertising 90 %, QuantumHilbertMatrix 63 % (numeric 20 %), SDPSegfault1132 46 % (numeric 49 %), ConvexPlasticity 47 % (assembly 38 %), UnconstrainedQP 43 % of 16 ms. **Mechanism for OptimalAdvertising and QuantumHilbertMatrix to confirm (William);** the likely cause for the first is the n_vars-sized per-node structures above. |
| Where to direct effort | Decide in the symbolic pass whether a constant operand is dense enough to keep as a dense block. This would remove the ConvexPlasticity, CVaR and density-sweep slowdowns. |
| Q1, matrix-free | We materialize because the solvers CVXPY calls by default factorize a matrix built from A and P. Matrix-free wins for very large problems with fast transforms and first-order solvers. A permuted dense block sits between the two: a materialized matrix that keeps the operator's structure, its selectors and its dense block. |
| Q7, BLAS and binaries | sparsediffpy is a compiled C extension, so wheels are still built per platform. It links against the platform BLAS (Accelerate on macOS, OpenBLAS on Linux through CMake's FindBLAS); unlike cvxcore it needs no C++ toolchain or Eigen. **William: confirm the wheel strategy.** |
