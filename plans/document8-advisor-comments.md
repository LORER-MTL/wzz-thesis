# Advisor review of Document 8_ALL_6206.pdf — comment log and dispositions

Review received 2026-08-19 (handwritten ink on PDF pages 6 and 42–64 = abstract + thesis
pages 29–51). Extracted by rendering the ink pages; archived here with what was done about
each comment. Overall tone: positive ("Great. Strong lit review, very well detailed";
"I find the style of this chapter [4] good, I suggest replicating it to Chapter 3").

## Abstract (p. vi)
| # | Comment | Disposition |
|---|---------|-------------|
| 1 | More context + details, up to a full page; "keep this somewhere — perfect for the paper" | PARTIAL by design (William): added ~3 sentences, not a full page. Tight paper version archived in `plans/abstract_paper_version.md`. |
| 2 | "add context" at opening | DONE — new opening sentence on modelling languages. |
| 3 | "Since" → "Because" | DONE. |
| 4 | "detail a bit more" (compilation cost) | DONE via items 2/6. |
| 5 | "no — say that we build it" (SparseDiffEngine authorship) | DONE — "We built SparseDiffEngine … and the new backend on top of it." |
| 6 | "more info on sparsity" | DONE — symbolic pass sentence now includes buffer allocation + fixed patterns. |
| 7 | "add numbers" | DONE — 21/25 fastest, 2.7× geometric-mean speedup. Résumé mirrored. |

## Lit review §2.3 (pp. 29–32)
| # | Comment | Disposition |
|---|---------|-------------|
| 8 | `.nl` line-break / spacing | DONE — non-breaking ties `a~\texttt{.nl}`. |
| 9 | Define "translator" and "driver" like the MOI bridge sentence | DONE — "the system splits the work between two programs, which the AMPL documentation calls the translator and the driver." |
| 10 | AMPL/JuMP intro ¶s: "double check if repetitive with before" | CHECKED, no change — ch. 1 has one-line previews (5-Introduction.tex:112–129), ch. 2 is the detailed review; complementary, not duplicated. |
| 11 | "written in the AMPL language itself" — custom language? | DONE — "The name AMPL denotes both the modelling language and the commercial system." |
| 12 | "Listing" wording standard? + refer to each listing explicitly in text | Wording KEPT (standard LaTeX/IEEE; caption format matches Figure/Table). Explicit references added for Listings 2.2–2.5; 2026-08-20 follow-up: Listings 1.1–1.3 and 2.5 were still introduced by a sentence running through the block ("...in CVXPY code is" / "...as" / trailing comma); now each is cited by number in a complete sentence before the block. Listings 3.1–3.3 already were. |
| 13 | `b` segment "font?" | NO CHANGE — already `\texttt{b}`, intentional (.nl segment name). |
| 14 | Unclear margin note near "MP matches second-order… cones" | DONE (best reading: cross-ref) — now "the second-order and exponential cones of §1.2.1". |
| 15 | "ref 2.4?" near epigraph declaration | DONE — "as in Listing 2.4" added. |
| 16 | "problem (1.5)" → "(1.5)" | DONE. |
| 17 | **Add §2.4 Research gap** | DONE 2026-08-21 — headed §2.4 "Research gap" with tab:systems-summary (AMPL, JuMP, CasADi, CVXPY backends, diffengine × coefficients obtained by / reused across the family / repeated at every solve) and three ¶s: declared vs derived coefficients, cost of a parameter change, the two CVXPY gaps + hand-off to ch. 3 + why ch. 4 compares against the CVXPY backends only. History: 3-¶ draft 2026-08-19 → cut 2026-08-20 for an unheaded synthesis ¶ (R1) → R1 withdrawn 2026-08-21. Archives: plans/research_gap_cut.md, plans/modeling_systems_table_cut.md. 2026-08-21 (later): prose rewritten in William's framing as a four-system summary (how the data is obtained / what a parameter change costs / hand-off to ch. 3: same symbolic-numeric split as CasADi, direct one-pass computation instead of sweeps, two-pass parameters new vs the CVXPY backends, dense blocks + kernels pay without parameters). Table kept, JuMP row retouched (additive parameters in place, any through ParametricOptInterface). JuMP parameter ¶ added to §2.3 (Parameter set, p*x quadratic, POI substitutes), verified against jump.dev manual. Second version archived in plans/research_gap_cut.md. FINAL shape (2026-08-21 evening): ¶1 two ways to obtain the data (CasADi NLP-centred, qpsol QPs; CVXPY composes linear operators = differentiating; AMPL/JuMP declared coefficients, no expression retained), ¶2 parameter changes (CasADi two phases + one sweep per colour; CVXPY DPP tensor else nothing cached; AMPL translator rewrites .nl, driver reads; JuMP in place, POI for p*x), ¶3 gap scoped to the four ("None of the four combines the two-phase split with direct computation") + ch. 3 method (two phases like CasADi, direct one pass; vs CVXPY backends dense structure, dense storage and computation) + table ref. Table: caption "How the four modelling languages and SparseDiffEngine obtain and reuse the coefficients", de-articled cells, SparseDiffEngine row label on two lines, engine cell "structured direct differentiation". JuMP parameter text folded into the §2.3 bridge ¶ (ParametricOptInterface.jl, "an extension"). |

## Theme 1 / ch. 3 (pp. 33–44)
| # | Comment | Disposition |
|---|---------|-------------|
| 18 | Chapter opening: introduce chapter, claim contributions clearly | DONE — new intro ¶: "This chapter presents SparseDiffEngine, the C library we built…", "Our contributions lie in the implementation", closing "Neither the split nor the two classes exists in CVXPY's backends." |
| 18a | (p. 33, re-decoded 2026-08-22) "other sense than mathematically possible?" under "Mathematically," | DONE 2026-08-22 — adverb dropped, "The engine computes the same derivatives as…"; the shared-maths point is carried by "Both apply the chain rule" and the contrast by "Our contributions lie in the implementation". |
| 18b | (p. 33) "possible" struck at the end of ¶1 ("BLAS subroutines when possible") | DONE 2026-08-22 — hedge dropped, read with his "assert advantage" note. |
| 18c | (p. 33) roadmap ¶: "yes, but not sure the purpose, add context" | DONE — covered by the new opening sentence (what the engine is for); the roadmap itself marked "yes". 2026-08-22: "where we focus much of our attention on" → "in particular" (William's cleanup, not advisor). |
| 19 | Contribution not visible across §3.1–3.3; replicate ch. 4 "we" style | DONE — we-voice pass (§3.2 "We store…", "We define…"). 2026-08-22 re-check: §3.1, §3.3 and §3.4 still had no first person (the §3.1 "We wrote" had not survived); added lightly: §3.1 "We wrote / We define / We implement" (REVERTED same day at William's request, see item 20), §3.3 "We implement each kernel as a pair", §3.3.1 "We select the kernel … by double dispatch", §3.4 "We collect … / We wrote everything specific to CVXPY". |
| 20 | §3.1 sounds like a user, not the author | DONE (William's version, 2026-08-22) — §3.1 opener stays "SparseDiffEngine is a small C library…" (authorship already claimed in the chapter intro), one code-layout sentence carries "we": "We implement each atom in its own file" (the expr.h/subexpr.h pair stays descriptive so the two sentences match). See rebuttal R9. |
| 21 | Avoid "(Table X)"/"(Figure X)" parentheticals; reference floats in prose | DONE across ch. 2–4 (as visualized in / as shown in / as in / described in). |
| 22 | "(NLP)" already defined? | DONE — was re-expanded; now plain `\ac{NLP}` (first use is ch. 1). |
| 23 | "constructor" never defined | DONE — defined at first use in §3.1.1. |
| 24 | e.g./punctuation in quadratic-atoms list | DONE — "such as … or …" phrasing. |
| 25 | "Transposition" unclear | DONE — "The transpose of a permuted dense matrix swaps…". |
| 26 | Eigen vs scipy "C vs Python?" | DONE — "the two sparse libraries behind CVXPY's backends differ on it." |
| 27 | Table 3.2 caption: define A/B notation; "conic path"? | DONE — caption defines A, B, d, D; "conic path" replaced with "atoms of a canonicalized DCP problem". |
| 28 | "what happens if others are needed? OR is that all what DCP allows for?" | DONE (revised 2026-08-22, William) — the hypothetical sentence ("An atom with an operation outside the ten would add a kernel of its own…") was cut; the answer is the second reading: "The ten operations of Table 3.2 cover the whole library" (verified by grep over src/atoms on 2026-08-10), so every atom a canonicalized DCP problem produces is covered. |
| 29 | "double dispatch" — standard wording? | DONE — defined inline ("the pair formed by the representations of both operands selects the implementation"). |
| 30 | Eq (3.2) notation introduced earlier? | DONE — "with the selector matrices of (3.1)"; 2026-08-22: the letter subscripts made explicit, "the transposed product of A = (X_A, r_A, c_A) and B = (X_B, r_B, c_B) expands … to". |
| 30a | (p. 40, re-decoded 2026-08-22) comma inserted: "In practice, the symbolic pass intersects…" | DONE 2026-08-22. |
| 30b | (p. 41, re-decoded 2026-08-22) "numeric vs. symbolic?" beside "the numeric phase only fills the stored pattern", and "and the numeric?" beside the first ¶ of §3.3.2 | DONE — "phase" → "pass" for the engine's passes (2026-08-22), and the reorganized §3.3.2 gives each cached kind its numeric counterpart. |
| 31 | **§3.3.2 hard to follow, reorganize; define and group** | DONE — rewritten: split defined once → three cached kinds (sparsity patterns / block layouts / index maps), each with its numeric counterpart → payoff-across-solves ¶. Also since→because, "every buffer is also allocated". 2026-08-22: engine's own "numeric/symbolic phase" → "pass" (Gustavson's "symbolic phase" kept). Precision pass 2026-08-22 (William read): "structural atoms" defined at first use (move or add entries of the child Jacobian), three-kinds list stated once, "This caching pays off" framing opener cut, "expression graph" → "tree", "other binary affine" → "remaining affine", kron → broadcast (table-consistent). Same day: payoff ¶ MOVED to §3.4.1 as the reason for the affine-tree skip, and corrected against the engine (problem.c:445-453, 522): the skip is per affine constraint tree, not per atom, and a parameter update re-evaluates every tree (the per-subtree claim was the deferred constant-skip plan, not the engine). §3.3.2 now ends on the index-map ¶ + fig:sum-idx-map. fig:sparse-product-passes added 2026-08-22 (William's request): two-panel symbolic/numeric figure for C = AB in the fig:sum-idx-map style, "no search / no insertion" wording replaced by the figure reference and one plain-language sentence ("It does not have to find which entries of the product exist or where they are stored, and computes each one directly"). Figure redesigned same day after William's read (first version: shaded rows + union note, cells overlapped): top panel A × B = pattern of C (positions as ∗), bottom panel C with the six dot products listed, cells inner sep=0; kept under \floatpagefraction so it is not forced onto its own page, and fig:sum-idx-map moved directly after it in the source so the two share one float page (p. 44). |
| 32 | "handled by CVXPY" — ref? | DONE — "as part of the canonicalization frontend of §2.1". 2026-08-22 (William): the label was wrong, §2.1 is matrix stuffing, not the frontend. Verified in cvxpy/reductions/dcp2cone/cone_matrix_stuffing.py (group_constraints / ordered_constraints / ConeDims live in ConeMatrixStuffing, which then calls the backend): William prefers "frontend" = everything CVXPY does before the canonicalization backend is called (matches CVXPY's own canon_backend terminology), so the original sentence is back ("handled by CVXPY, as part of the canonicalization frontend of §1.2.2"; the "before the backend is called" variant was reverted as harder to read), and §3.1.1 (quadratic atoms) now reads "by the canonicalization frontend of §1.2.2". Only the pointer changed (§2.1 → §1.2.2). |
| 33 | Chapter wrap-up + transition; recall diff with lit | DONE, trimmed 2026-08-20 — closing ¶ keeps the two design choices vs §2.1 backends and the hand-off to ch. 4; the recap sentence ("This chapter described the engine from…") was dropped as framing (house style). Rebuttal R5. 2026-08-22: promoted to a headed §3.5 "Summary" (label sec:theme1-summary) so ch. 3 closes like §2.4 and §4.3; new first ¶ recaps the chapter in four sentences (split and buffers / three representations and ten kernels / diffengine backend and parameter update), second ¶ is the unchanged wrap-up. R5 moot. 2026-08-22 (later, William: "connect back to the lit review and transition to ch. 4"): ¶2 rewritten to echo §2.4 ¶3 (no reviewed system combines the two-phase split with direct computation; the engine does both, two passes as CasADi §2.2, direct computation in one pass instead of sweeps; two further choices vs the CVXPY backends §2.1; ch. 4 previewed as §4.1 single canonicalization vs backends, §4.2 repeated solves vs the tensor of §2.1.2). Committed in 4fe21b0. **TO REVISIT** later the same day at William's request. |
| 34 | Misc: leaf-node comma, "exactly as in Fig 3.3", (4,…,7) ellipsis | DONE — "two kinds of leaf node, the variable and the parameter"; "exactly as in"; "columns 4 to 7". |

## Results / ch. 4 (pp. 45–50)
| # | Comment | Disposition |
|---|---------|-------------|
| 35 | Be explicit this is what you built; diffengine vs SparseDiffEngine case | DONE — "This chapter measures the system we built in Chapter 3… whose lower-case name distinguishes it from the SparseDiffEngine library underneath it." William's extension: SCIPY backend named after scipy.sparse and COO backend named after the coordinate format, both clarified at first introduction in §2.1; conclusion's stray `SciPy` → `SCIPY`. |
| 36 | Why get_problem_data only? | DONE — "We exclude the solver because the choice of backend affects only canonicalization." |
| 37 | Clarabel "already cited?" | KEPT — cited in ch. 1 in a solver list; re-cite at first named use is standard for numbered styles. |
| 38 | Figure 4.1: (a)/(b) panels, legend boxes | DONE — fig_profiles_combined regenerated with "(a) canonicalization time" / "(b) peak memory" titles and a single legend (top panel); caption and in-text refs now Figure 4.1a/4.1b. Patch lives in Jacobian-accumulation/canonicalization/plot_thesis_figures.py. 2026-08-22 (William, per the advisor's arrows): panel tags moved BELOW each panel (second line of the x label, so tight_layout keeps them inside the canvas) and legend labels set in typewriter (`$\mathtt{}$`, CM fontset) to match \texttt{} in the prose. |
| 39 | "With t_{p,s} the time" → "Let … be" | DONE. |
| 40 | Explain performance profile | DONE — two sentences of intuition (whole-suite comparison; value at τ=1; where the curve reaches 1). |
| 41 | **3 runs too few; 100–350?** | PUSHED BACK with evidence (William's call): kept 3-run medians where they exist, added variance sentence to ch. 4 intro — typical deviation 3–5% from median, larger blips were transients not reproduced by single-problem probes. Computed from results/repl/*_param_rep{1,2,3}.json (median dev 3.4%, 90th pct 8.7%) and the 07-24 replication run notes. **2026-08-22 provenance check (William asked whether the variance is big enough to mention):** every Table 4.1 cell was matched to its source file. Only the rows of the seven Table 4.2 problems (+ ConvexPlasticity) are medians of three runs (results/repl/*_param_rep{1,2,3}.json, CP retime = median of six); the 17 parameter-free rows are single measurements, cell-for-cell from results_backends_fork_bridge_20260808.txt (the harness `_cold_compile` times get_problem_data once per cell). The old caption "medians of three runs except where marked" was therefore wrong for 17 rows. Spread where replicates exist: cold runs deviate from their median by 3.4% (median), 7.5% (90th pct), two outliers (FactorCov COO DPP-path 36%, ParamSmall diffengine 18%); re-solves ≥ 0.1 s within 0.3–6.7%, sub-ms re-solves swing 10–70% (timer noise). Against the median of the three runs of the suite on different days (07-11, 07-24, 08-08; different engine builds for diffengine) the printed 08-08 value sits 6.5% off (median), 16% (90th pct), worst OptimalAdvertising diffengine 2.36 vs 5.1–5.2 earlier (likely a build change) and SlowPruning 3.01 vs 2.15–2.25; only CVaR flips winner (1.01 vs 0.95, a tie either way), 17-row geomean 0.32 vs 0.34. **Decision (b), applied 2026-08-22:** intro variance sentences CUT; Table 4.1 caption now "rows of the seven problems of Table 4.2 and of ConvexPlasticity are medians of three runs except where marked, all other rows are single measurements", † note "single measurement in a row that would otherwise be a median", ‡ note "median of six measurements on a later build…"; variance sentence moved to §4.2 ("three runs agree within 7% on every re-solve time above 0.1 s, and within 8% on the first canonicalization times, except for one COO run on FactorCovarianceModel and one diffengine run on ParamSmallMatrixStuffing"). Option (a), re-running the 17 rows twice more on the thesis builds (.venv-upstream still 1.9.2, diffengine needs the pinned ca08a26d1 + sparsediffpy 0.7.0 rebuilt since .venv is now the dev fork), was offered and declined. R3 updated. **Later the same evening, William: "no meaningful difference between runs, report all instances, else take the lowest" → full per-cell report in plans/variance_report_20260822.md; decision (ii): replicated cells now print the FASTEST of the three runs (26 of 45 cells moved by 1–2 in the last digit; Table 4.2 ratios 0.29/0.29/0.81/1.97/2.00; Table 4.1 geomean 0.3558 still 0.36, abstract 2.8× unchanged, 21/25 fastest, 17 > 2×, max ratio 2.48), CP ‡ = fastest of six retimes 0.85 (ratio 2.48), CP old-build sentence 2.07 → 2.03 s (min of the pinned-build runs). Captions/notes say "fastest of three runs"; §4.2 sentence "Except where marked, each entry is the fastest of three runs. The three runs agree within 7%…". FIGURE FIX found on the way: fig:profiles(a) was drawn from the 07-24 engine run + 08-08 upstream run (not the table's cells; OptimalAdvertising 2.7× in the figure vs 1.05 in the table, SimpleFullyParametrizedLP diffengine 1.35 s transient). plot_thesis_figures.py now has _thesis_table_cells(): 17 parameter-free rows from the 08-08 bridge run, five replicated rows + CP CVXPY columns = fastest of three, CP diffengine = fastest of six retimes, dagger rows pinned (CPP from the 08-11 ND file, SCIPY/COO from the 08-08 big-parameter file, diffengine from the fork big-parameter JSON). All 25 figure cells now equal the table at 2 dp. Dagger-row CPP cells switched to the archived 08-11 file values (SimpleFullyParametrizedLP 2.29 → 2.22, ParametrizedQP 11.89 → 11.51; the old numbers were unarchived live probes, ratios unchanged). Profile prose: CVXPY backends cover "92–96%" at τ≈8 (was 88–96). images/profiles_combined_thesis.pdf regenerated; memory panel unchanged. plot script change left uncommitted in Jacobian-accumulation. Then (William: "remove the daggers too"): † marks removed from both tables, run protocol stated once in the chapter intro ("Each entry … is a single measurement, except for ConvexPlasticity and five of the seven parametric problems, for which we repeated the measurement three times and report the fastest run"), captions and notes carry no run statements any more, §4.2 names SimpleFullyParametrizedLP and ParametrizedQP as the two single-run rows before the 7%/8% sentence.** |
| 42 | Discuss the slow rows (both tables) | DONE — §4.1: CVaR/OptimalAdvertising = ties within spread; SDPSegfault1132 = constant-data copies; ConvexPlasticity = dense-ingested diagonal. 2026-08-20: the dev-build timing sentence (0.9 s, 2.6×) was cut from the thesis because the table is measured on the released build and the dev build regresses Yitzhaki/FactorCov 3–5×; the fact stays in the retiming note below. §4.2: names SVM + FactorCovarianceModel, SVM's parameter = single regularization weight touching one coefficient. |
| 43 | Table 4.2 "no bold?" in first-canonicalization columns | DONE — caption states diffengine is fastest on every problem there, so no bold. |
| 44 | §4.3 bullets: point to specific evidence | DONE — each bullet cites its table/figure and the specific numbers (within ~2× re-solve; two timeouts; 24/25). |
| 45 | Punctuation around CVXPYgen/CVXPYlayers | DONE — parenthetical → ", for example …". |

## Conclusion (p. 51)
| # | Comment | Disposition |
|---|---------|-------------|
| 46 | "no empty section" between chapter heading and §5.1 | DONE — one-sentence chapter overview added. |

## Second pass (same day, self-review + William's go-ahead)
- Thesis p. 42 marks decoded at high resolution: circled "(Figure 3.7)" (fixed earlier) plus a
  swoosh tying "The Hessian follows the same split" back to the previous ¶ — first read as a
  "same split as what?" complaint and fixed with "…the same split between structure and values";
  re-read 2026-08-22 (William) as the editor's run-on mark: the three-sentence Hessian ¶ is now
  merged into the problem-level split ¶ and the sentence is back to "The Hessian follows the
  same split." (unambiguous inside one ¶).
- "translator"/"driver" wording VERIFIED against AMPL sources: mp.ampl.com titles its section
  "Solver drivers"; "AMPL-translator" is the standard name for the model processor (Gay,
  Sol-format docs). Sentence kept.
- §2.4 tightened: "sparse formats reviewed in §2.1" → "sparse libraries of §2.1" (matches what
  §2.1 actually reviews); the AMPL/JuMP gap sentence now says they "store coefficients the user
  has already written, and leave the reformulations that canonicalization automates to the user
  or the solver" (the old "presuppose the conic form" was wrong for AMPL).
- §4.1 ConvexPlasticity: tense fixed (ingests); banned word "routes" → "stores … in";
  kernel-completeness sentence corrected to "implemented for each representation it must
  support" (binary kernels dispatch on pairs, so "once per representation" was wrong).
- Résumé polished: "accélération d'un facteur 2,7 en moyenne géométrique"; "un temps comparable
  à celui de la mise en cache".

## ConvexPlasticity retiming (William's request, 2026-08-19)
The current dev checkout (fork cvxpy 1.10.0.dev95+gce554d88 + sparsediffpy 0.7.0 in
Jacobian-accumulation/.venv) has the sparse-aware converter
(converters.py routes mostly-zero dense constants to make_sparse_left_matmul / sparse
quad_form). Retimed cold canonicalization, 3 runs each:
- ConvexPlasticity DIFFENGINE: 0.85 / 0.87 / 0.94 s (median ≈ 0.9 s; was 2.07 s) → fix confirmed, reported in §4.1 prose. Table 4.1 row kept at the pinned-build 2.07 for build consistency.
- **REGRESSION FOUND**: Yitzhaki DIFFENGINE 2.33–2.48 s on the dev build vs 0.48–0.51 s on the thesis build (CPP unchanged at ~3.5 s, so it is not machine noise). FactorCovarianceModel similarly 2.8 s vs 0.87. Do NOT re-run the whole table on this checkout; investigate the regression first (suspect: the new mostly-zero routing or the 1.10 rebase).
- 2026-08-21 UPDATE (William's decision, after being offered re-timing on PR #3448 head or re-running the whole column): Table 4.1 ConvexPlasticity row now carries the dev-build retime, 0.91 s / ratio 2.63, marked ‡ with a table note ("later build of the diffengine branch that converts the mostly-zero dense constant of the quadratic form to sparse form"). Geomean 0.37 → 0.36 (geomean of the 25 printed ratios: 0.368 → 0.356; the 2-dp-times method gives 0.3535, i.e. 0.35, so the printed-ratio value was kept as the one a reader can reproduce from the table). Abstract 2.7× → 2.8×, résumé 2,7 → 2,8, §4.1 prose "within 7×" → "within 3×" and the CP sentences reworded to point at the note (William to line-edit). fig:profiles top panel regenerated with the same CP override (plot_thesis_figures.py CP_RETIME_DIR; raw retimes copied to Jacobian-accumulation/canonicalization/results/retime_cp_quadform_20260819/); memory panel unchanged (no memory re-measurement; CP already excluded there by the CVXPY floor).

## 2026-08-21 late session, lit review final pass (not advisor comments, William's own cleanup)
- §2.4 Research gap rewritten in William's framing (see item 17 FINAL); table gained an
  "Expression storage" column (scalar / scalar / scalar SX or matrix MX / vectorized / vectorized).
- Chapter intro: example sentences (CasADi sweeps, AMPL/JuMP scalarize, CVXPY vectorized) restored
  from fcb1ca3; parenthetical section refs removed from the roadmap; "These differences are
  summarized in §2.4" closes the intro ¶. §2.1 closing hand-off sentence cut (now only in §2.4).
- Naming: `\texttt{SCIPY}`/`\texttt{COO}` = backends, `\texttt{scipy.sparse}` = library, COO = format,
  stated in brackets in the §2.1 backend list; COO introduced in ch. 1 via `\ac{COO}` (acro
  "Coordinate"), CSR/CSC first uses switched to `\ac`, later "coordinate format" → "COO format".
- Acronyms now used through the macro at first use: QP (intro 77), AD (intro 102), COO, CSR, CSC.
- Verified against source: CVXPY picks COO for DPP problems with total parameter size >= 1000
  (DPP_PARAM_THRESHOLD, #3031), so "at least 1000 parameter entries in total".
- Overfull box in fig:scalar-vs-vectorized fixed (node f at x=5.65); all lit-review lines <= 100
  chars except two `% \paragraph` comment lines. Zero overfull boxes in the whole build.
- Table placement (William: table sat alone on p.35): JuMP trimmed on p.33 so §2.4 starts there
  and tab:systems-summary lands on p.34 with the §2.4 prose. Cuts: copy_to ¶ last sentence
  folded ("..., with no expression graph to visit and no differentiation."); the nonlinear-path
  ¶ removed, its one load-bearing fact kept as "Only the nonlinear path of JuMP retains
  expression graphs, and differentiates them by sparse AD." at the end of the copy_to ¶ (the
  "MOI representation is general" and "stored as scalar coefficients ... one term per nonzero"
  sentences went without replacement, the latter is covered by the chapter intro and ¶2);
  fixed-bounds fallback clause dropped from the parameter sentence; the two \addlinespace
  removed from the table. Table cells and §2.4 prose unchanged. Ch. 3 now starts on p.35.
