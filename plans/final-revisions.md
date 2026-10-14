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
The **Where** column gets the section and page in the new PDF once an item is done.

## Required (jury and Legrain)

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| J1a | Statistical significance (p-values) of every numerical test | We tested every comparison with a two-sided Mann–Whitney test, Holm-adjusted across the 25 problems. All differences are significant. On every problem the replicates of the two backends do not overlap, so every adjusted p-value equals the smallest attainable with 20 replicates, 1.7×10⁻⁶. Significant ratios are starred in Tables 4.1 and 4.2, and the p-values are listed in Appendix B. Significance counts for the ablation are in Table B.5. | §4.1–4.3, App. B | done |
| J1b / AL-ii | Ablation: separate the two contributions (time, memory) | App. B.1, pointed to from §4.2 and §4.3: two contrasts, reported as measurements: no dense blocks on the first canonicalization (25 problems, with memory) and no split on the re-solves (7 DPP); per-problem values in App. B | §4.2, §4.3, App. B.1 | done |
| J1c | More instances (random parameters, modified instances) | Each replicate draws new parameter values from its own seed; nine suite problems and the lasso family rescaled to five sizes, five problems at five densities | §4.1, App. A.1, B.2 | done |
| J1d / AL scaling | Sensitivity to problem characteristics (size, % sparsity) | App. B.2, pointed to from §4.2: ten families at five sizes (Table B.6), five problems at five densities (Table B.7) | §4.2, App. A.1, B.2 | done |
| J1e / AL-iii | Non-DPP problems: DPP versus non-DPP gain against CVXPY | §4.3.1: lasso and factor_cov in DPP / non-DPP / parameter-free variants, Table 4.3; 1st Discussion observation cites it | §4.3.1, App. A.1 | done |
| J2 / AL-i | Related literature: matrix-free, CVXcanon, CVXGEN, Convex.jl 0.16, antecedents, Pyomo APPSI, DNLP delineation | Drafts D1–D7 (PR #3). Legrain 3e (dense blocks in sparse formats): two cited sentences in §3.2 and where our blocks differ; the informal appendix was dropped | Ch. 1–3 | done (draft) |
| J3 | AI-use declaration | New front-matter page with the text of ai-usage-wzz.md as is (to be condensed later) | front matter, p. vii | done (draft) |
| AL-iv | Repeated measurements, mean ± std | 20 replicates in fresh processes (10 above 30 s, never reached); tables in mean ± std | §4.1, Table 4.1, App. B, C | done |
| AL-v | Dimensions of every instance | Landscape Table B.1: description, m, n, nnz(A), nnz(P), params, DPP (checked against the dims of the final runs) | App. A | done |
| AL-vi | Time by phase, explaining the underperforming problems | One paragraph at the end of §4.2 on the five slower problems (ConvexPlasticity, QuantumHilbertMatrix, OptimalAdvertising, SDPSegfault1132, UnconstrainedQP); phase table and the two case studies in App. D | §4.2, App. D | done (one CHECK comment in App. D) |
| AL-vii | Explicit statement of the correctness check against the existing backends | §4.1 paragraph (1e-9 relative, first and after update, against CPP); per-problem Table B.1 | §4.1, App. B | done |

## Le Digabel, minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| SLD1 | p. vii: « librairie » → « bibliothèque » | « bibliothèque logicielle » (also meets AL's « logiciel ») | Résumé | done |
| SLD2 | p. xv: consistent case in the acronym list | All expansions lowercase except proper nouns (AMPL, MathOptInterface, Jacobian), in both lists | Sigles | done |
| SLD3 | p. 2: convexity in x suffices, not in (x, θ) | Convex (resp. affine) in x for every fixed θ | §1.1 | done |
| SLD4 | pp. 2–3: link between m in (1.2) and m₁, m₂ in (1.1) | Sentence after (1.2): m ≠ m₁+m₂ in general (vector constraints, auxiliary rows/variables); cone count in (1.3) renamed r | §1.1, §1.3 | done |
| SLD5 | p. 4: are x_i, θ_i scalars or vectors? | x_j ∈ ℝ^{n_j}, θ_j ∈ ℝ^{p_j}, with n = Σn_j, p = Σp_j | §1.2 | done |
| SLD6 | p. 7: [27] is an arXiv report, not a paper | « A recent report » ([27] = zhang2026cvxpy, confirmed against a fresh .bbl) | §1.3 | done |
| SLD7 | p. 20 and elsewhere: non-breaking spaces (cleveref) | All 41 \eqref after a breakable space now tied with ~ (\ref/Figure~ were already tied); cleveref not needed | all chapters | done |
| SLD8 | p. 21, Fig. 2.4: key « -1 » unexplained | Caption: −1 is CVXPY's id for the constant column, labelled 1 in both layouts | Fig. 2.4 | done |
| SLD9 | p. 39: m and n reused | Stacked-PD subsection uses k×q expression, B ∈ ℝ^{r×k}; perf-profile count is N | §3.2.3, §4.1 | done |
| SLD10 | pp. 41–42: B is data in Table 3.2 but a Jacobian in Fig. 3.5 | Table 3.2 caption and dispatch text: B is data in BA, a second Jacobian in sum_matrices/BTA/BTDA (checked against quad_form.c) | Table 3.2, §3.3.1, Fig. 3.5 | done |
| SLD11 | p. 41: for BA the outer selector also changes | BA written out as its own equation (3.3); text says both selectors of B swap roles, result at rows r_B | §3.3.1 | done |
| SLD12 | p. 46: Listing 3.2's « Ax + b ∈ K » differs from (1.2) | Text says the class stores Ax + b ∈ K and CVXPY negates A to get (1.2); showstringspaces=false | §3.4 | done |
| SLD13 | p. 49: SCIPY is fastest on three problems, not at most two | Recounted on the final runs: no CVXPY backend is fastest on more than two | §4.1 | done |
| SLD14 | p. 51: the 0.01 ratio on UnconstrainedQP needs a comment | Paragraph in §4.2: the chain of constant products, confirmed by CVXPY #3524 (the rewrite takes CPP from 1.95 s to 0.013 s); the ratio is now 1.20 against the best-of-both baseline | §4.2 | done |
| SLD15 | p. 52: Table 4.2 diffengine times equal Table 4.1's, and 0.001 s rounding hides the ratios | Re-solves now in ms; text says the diffengine first-canonicalization column repeats Table 4.1 because it builds no tensor | §4.4 | done |

## Legrain, other minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| AL-m1 | Attribute the symbolic/numeric split to sparse factorization first (p. 3, p. 46) | Davis and Gustavson cited before the NLP interfaces in the Intro's approach paragraph, §1.5, the Ch. 3 opening and §3.5 | §1, §1.5, Ch. 3, §3.5 | done (draft) |
| AL-m2 | Table 2.2: qualify the AMPL/Pyomo row (Pyomo persistent interfaces) | Draft D6 (PR #3): Pyomo persistent interfaces after the .nl sentence, note under the table | §2.4 | done (draft) |
| AL-m3 | §1.5, §3.1: delineate the contribution relative to DNLP | | §1.5, §3.1 | needs William |
| AL-m4 | p. 48: PR #3448 merged 9 Sept 2026 (opt-in, parameter-free); parametric path not yet merged | Merged 9 Sept 2026, opt-in, parameter-free; parametric path not yet integrated (verified via GitHub API) | Ch. 4 setup | done |
| AL-m5 | Ch. 4: the author contributed to the SCIPY and COO backends | One sentence in the setup | Ch. 4 setup | done |
| AL-m6 | p. 52: « faster than cvxcore on 24 of the 25 » | « faster than cvxcore on 22 of the 25 » (final runs) | §4.6 | done |
| AL-m7 | p. 46: harmonize the « main contribution » with §1.5 and the Ch. 3 opening | Same order everywhere, with no "main contribution": the matrix classes first, the split second, in §1.5 item 1, the Ch. 3 opening and §3.5 | §1.5, Ch. 3, §3.5 | done (draft) |
| AL-m8 | p. 48: number of repetitions and the BLAS implementation | Apple M2 (24 GB, macOS 26.5.1), Accelerate, single-threaded; 20 / 10 replicates; versions in App. B | §4.1, App. B | done |
| AL-m9 | Fig. 3.5: do not rely on colour alone | Letters (a)–(d) in cells and legend; caption mentions them | Fig. 3.5 | done |
| AL-m10 | Refs [41] [42] [43] [76] [88]: p. → pp. | En-dashes → --; [88] page → « Art. no. 2 » | bib | done |
| AL-m11 | Refs [60] Eigen, [72] CppAD, [21] MOSEK: URLs, version | URLs as howpublished; MOSEK @misc + docs URL; Eigen version 3.4.0 (bundled with cvxcore) | bib | done |
| AL-m12 | Ref [17] CVX: old version | Note « canonical reference; current release 2.2 » (checked cvxr.com) | bib | done |
| AL-m13 | Complexity analysis of the representations (memory, product cost) | Draft D7 (PR #3): storage and symbolic/numeric operation counts against CSR + Gustavson | §3.3 | done (draft) |
| AL-m14 | Future work: re-evaluate only the parameter-dependent subtrees | Future work: mark parameter-dependent subtrees in the symbolic pass, skip the rest | Conclusion §Future | done |
| AL-m15 | Defence Q5: memory of the global layout with many variables | Limitation: global layout costs O(nodes × n) integers (expr.c:54); local layout better for many variables + deep trees | Conclusion §Limitations | done |
