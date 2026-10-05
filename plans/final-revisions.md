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
| J1a | Statistical significance (p-values) of every numerical test | Per problem: Mann–Whitney, Holm-adjusted; suite: Wilcoxon signed-rank + bootstrap CI of the geometric mean. `*` on significant ratios in Tables 4.1, 4.2; p in Table 4.5 and App. D | §4.1, §4.2, §4.4, §4.6, App. D | done (prose; numbers pending) |
| J1b / AL-ii | Ablation: separate the two contributions (time, memory) | New §4.6: NO_DENSE (cold, 25 problems) and the 2×2 dense × split on the re-solves (7 DPP); memory sentence + App. D table; 4th Discussion observation | §4.6, App. C, D | done (prose; numbers pending) |
| J1c | More instances (random parameters, modified instances) | Each replicate draws new parameter values from its own seed; the extra families of App. B.1 at several sizes and five seeds | §4.1, §4.7, App. B.1 | done (prose; numbers pending) |
| J1d / AL scaling | Sensitivity to problem characteristics (size, % sparsity) | New §4.7: lasso n × density sweep, scaling of huber / advertising / factor_cov; figure placeholder | §4.7, App. B.1 | done (prose; numbers and figure pending) |
| J1e / AL-iii | Non-DPP problems: DPP versus non-DPP gain against CVXPY | New §4.5: lasso and factor_cov in DPP / non-DPP / parameter-free variants, Table 4.4; 1st Discussion observation now cites it | §4.5, App. B.1 | done (prose; numbers pending) |
| J2 / AL-i | Related literature: matrix-free, CVXcanon, CVXGEN, Convex.jl 0.16, antecedents, Pyomo APPSI, DNLP delineation | Drafts D1–D7 (PR #3). Legrain 3e (dense blocks in sparse formats) moved to an informal App. A, one pointer sentence left in §3.2 (results PR) | Ch. 1–3, App. A | done (draft) |
| J3 | AI-use declaration | New front-matter page with the text of ai-usage-wzz.md as is (to be condensed later) | front matter, p. vii | done (draft) |
| AL-iv | Repeated measurements, mean ± std | 20 replicates in fresh processes (5 above 30 s); tables in mean ± std | §4.1, Table 4.1, App. C, D | done (prose; numbers pending) |
| AL-v | Dimensions of every instance | Landscape Table B.1: description, m, n, nnz(A), nnz(P), params, DPP (deck values; regenerate from the dims of the final runs) | App. B | done (draft) |
| AL-vi | Time by phase, explaining the underperforming problems | New §4.3 with Table 4.3 (phases) on CVaR, OptimalAdvertising, SDPSegfault1132, ConvexPlasticity; detail in App. E | §4.3, App. E | done (prose; numbers pending) |
| AL-vii | Explicit statement of the correctness check against the existing backends | §4.1 paragraph (1e-9 relative, first and after update, against CPP); per-problem Table C.1 | §4.1, App. C | done (prose; results pending) |

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
| SLD13 | p. 49: SCIPY is fastest on three problems, not at most two | « more than three problems (SCIPY, counting the three-way tie) »; recount after the new runs | §4.1 | done |
| SLD14 | p. 51: the 0.01 ratio on UnconstrainedQP needs a comment | Paragraph in §4.2: little data (18.6 k nnz), CVXPY backends form each intermediate of a chain of complex products as generic sparse; marked CHECK until the phase data confirms | §4.2 | done (draft; check) |
| SLD15 | p. 52: Table 4.2 diffengine times equal Table 4.1's, and 0.001 s rounding hides the ratios | Re-solves now in ms; text says the diffengine first-canonicalization column repeats Table 4.1 because it builds no tensor | §4.4 | done (prose; numbers pending) |

## Legrain, other minor corrections

| ID | Request | Response | Where | Status |
|---|---|---|---|---|
| AL-m1 | Attribute the symbolic/numeric split to sparse factorization first (p. 3, p. 46) | Davis and Gustavson cited before the NLP interfaces in the Intro's approach paragraph, §1.5, the Ch. 3 opening and §3.5 | §1, §1.5, Ch. 3, §3.5 | done (draft) |
| AL-m2 | Table 2.2: qualify the AMPL/Pyomo row (Pyomo persistent interfaces) | Draft D6 (PR #3): Pyomo persistent interfaces after the .nl sentence, note under the table | §2.4 | done (draft) |
| AL-m3 | §1.5, §3.1: delineate the contribution relative to DNLP | | §1.5, §3.1 | needs William |
| AL-m4 | p. 48: PR #3448 merged 9 Sept 2026 (opt-in, parameter-free); parametric path not yet merged | Merged 9 Sept 2026, opt-in, parameter-free; parametric path not yet integrated (verified via GitHub API) | Ch. 4 setup | done |
| AL-m5 | Ch. 4: the author contributed to the SCIPY and COO backends | One sentence in the setup | Ch. 4 setup | done |
| AL-m6 | p. 52: « faster than cvxcore on 24 of the 25 » | « faster than cvxcore on 24 of the 25 » | §4.3 | done |
| AL-m7 | p. 46: harmonize the « main contribution » with §1.5 and the Ch. 3 opening | Matrix classes are the main contribution, the split comes second, everywhere: §1.5 item 1 names both, the Ch. 3 opening is reordered, §3.5 was already in this order | §1.5, Ch. 3, §3.5 | done (draft) |
| AL-m8 | p. 48: number of repetitions and the BLAS implementation | Apple M2, Accelerate, single-threaded; 20 / 5 replicates | §4.1, App. C | done (versions pending) |
| AL-m9 | Fig. 3.5: do not rely on colour alone | Letters (a)–(d) in cells and legend; caption mentions them | Fig. 3.5 | done |
| AL-m10 | Refs [41] [42] [43] [76] [88]: p. → pp. | En-dashes → --; [88] page → « Art. no. 2 » | bib | done |
| AL-m11 | Refs [60] Eigen, [72] CppAD, [21] MOSEK: URLs, version | URLs as howpublished; MOSEK @misc + docs URL; Eigen version 3.4.0 (bundled with cvxcore) | bib | done |
| AL-m12 | Ref [17] CVX: old version | Note « canonical reference; current release 2.2 » (checked cvxr.com) | bib | done |
| AL-m13 | Complexity analysis of the representations (memory, product cost) | Draft D7 (PR #3): storage and symbolic/numeric operation counts against CSR + Gustavson | §3.3 | done (draft) |
| AL-m14 | Future work: re-evaluate only the parameter-dependent subtrees | Future work: mark parameter-dependent subtrees in the symbolic pass, skip the rest | Conclusion §Future | done |
| AL-m15 | Defence Q5: memory of the global layout with many variables | Limitation: global layout costs O(nodes × n) integers (expr.c:54); local layout better for many variables + deep trees | Conclusion §Limitations | done |
