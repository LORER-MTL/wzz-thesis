# Advisor review of Document 9_ALL_2594.pdf — comment log and dispositions

Final review round, received 2026-08-28 (handwritten red ink, flattened into the PDF, on
~45 of the 78 pages — title page through the references). Extracted by rendering the pages
at 200 dpi (400 dpi re-reads for ~15 hard marks). Overall tone positive ("Very nice
plots!"). PDF page = printed page + 13 from ch. 1 onward.

Global decisions for this round (William, 2026-08-28): pattern marks applied as GLOBAL
sweeps across ch. 1–5; float placement uses [tb]-style specifiers, never [h]/[H]
(advisor's convention, provisional — William may revert); PD/sPD naming kept, with a
disambiguating caption remark.

## Global sweeps

| # | Comment | Disposition |
|---|---------|-------------|
| G1 | "no emph" on defined terms (marked: problem data, expression tree, atoms, Smith form, epigraph, reductions, lightweight) | DONE — all seven de-italicized; full `\emph` audit of ch. 1–5 found only one other, the résumé's "\emph{open source}" (French italicizing a loanword, KEPT). |
| G2 | "mathbf" on vector/matrix 0, 1, F (marked at (1.2), (1.4), (1.5), (1.6), prose x ≥ 0, the 0 leaf of Fig. 1.2(b), the map F) | DONE except the map — new `\zeros` macro in defs.tex next to `\ones`; all marked 0/1 sites bolded incl. the TikZ leaf. Map-F bolding REVERTED to italic $F$ (William, 2026-08-29): bold uppercase F already denotes the running example's data matrix `\mmat{F}` throughout ch. 1-2, so bolding the generic map makes two different objects typographically identical (and the components F_i stay italic under the scheme anyway). To raise with the advisor, or rename the map to a non-colliding letter if he insists. |
| G3 | commas ending display equations (marked at (1.1), (1.2), (1.4), (1.6), (1.10), and (1.5)'s constraint line) | DONE at every marked site. Note (1.10): the comma after the matrix S is mid-sentence ("the matrix [S] is stored…"); applied per the mark, flag if it reads oddly. |
| G4 | "uniformize caps of acronyms. I prefer no caps." | DONE — 4-Sigles_Abrev.tex long forms lowercased in BOTH the `\acro` block and the longtable (AD, AML, ASA, COO, CSC, CSR, DAG, DCP, LP, NLP, QP, SIMD, SOCP, SDP). Kept capitalized as proper names: AMPL, ASL, BLAS, MOI, MPS; JVP/VJP keep "Jacobian". No literal capitalized expansions remain in prose. |
| G5 | causal "since" → "because" (marked §3.5 and §5.2) | DONE — both; grep found the only other "since"s are temporal (kept). |
| G6 | non-breaking spaces on wrapping refs/numbers ([14], (1.1), Level 1) | DONE — `~\cite`, `~\eqref`, `Level~1` (+ level~2/3). Rebuilt PDF re-checked. |

## Front matter

| # | Comment | Disposition |
|---|---------|-------------|
| 1 | Title page "vérifier les langues" | DONE — `\moisDepot` August → Août (title page is French; the macro's only use is Document.tex:220). |
| 2 | Acknowledgements: `[source]` circled, "update." | OPEN — William to supply the scholarship funder; placeholder kept. |
| 3 | Résumé "sous une forme proche des mathématiques" — "sounds weird in both French and English", advisor floats "proche de celle analytique" | DONE, variant wording — "sous une forme proche de sa formulation mathématique" (mirrors ch. 2's "close to its mathematical statement"; "analytique"/closed-form would say something else). Abstract mirrored ("close to their mathematical formulation"). Flag if he wants his exact wording. |
| 4 | Résumé "Manque la motivation. Research gap avant de dire comment tu le résous." | DONE — three sentences inserted before "Nous présentons": no current implementation takes the derivative view / the parameter map is expensive and rule-restricted / everything else recompiles in full. Abstract mirrored. |
| 5 | Résumé "+1 phrase pour conclure → comment l'approche permet l'amélioration" | CUT (William, 2026-08-29, knowingly overriding the advisor) — first trimmed to "Both results follow from the two-phase split." (the fuller version repeated the mid-abstract mechanism sentences almost verbatim), then cut entirely: the bare causal claim "doesn't do anything." Both texts now end on the results sentences. If the advisor re-raises: the attribution is already in the body ("Re-solving a parametrized problem therefore costs only one numeric pass" ties results to the split). Also same-day in the motivation block: "restrictive rules" → cut the rules clause entirely ("which is expensive to build."), since no rules were introduced in the abstract. |
| 6 | Abstract "motivation. 2nd not done as of now!" under the Jacobian/Hessian sentence | DONE via item 4's insertion, read as "state that nobody does this yet" ("None of the current implementations takes this perspective"). Interpretation uncertain — William should confirm "2nd not done" wasn't about the Hessian half. |

## Chapter 1 (5-Introduction.tex)

| # | Comment | Disposition |
|---|---------|-------------|
| 7 | "the composition rules" → "the or a set of" | DONE — "a set of composition rules". |
| 8 | "Linear Program (LP)" circled + DCP initials circled | DONE via G4. |
| 9 | "ah yes, what about COP and CPP!!!!" on "can represent and solve nearly every convex program" | DONE — "and solve" dropped; representation is the defensible claim (copositive/completely-positive programs are representable but not tractably solvable). |
| 10 | "clearpage?" before §1.1 | CHECKED, no change — in the rebuilt PDF ch. 1's opening ends naturally and §1.1 starts the next page; no stray gap remains after the float fixes. |
| 11 | "is provided" recast + stray ")" | DONE — "Background on dense and sparse matrix computations is provided in §1.4." as its own sentence; parenthesis gone. |
| 12 | "in functional form" — "ce terme pour abstrait ?" | DONE — "…is written in functional form, meaning the objective and constraints are given as functions of the variables and parameters." |
| 13 | Smith form: "no emph" + "(cite)" | DONE — cite moved onto the term: "into Smith form \cite{smith1996}". |
| 14 | e.g.-parenthetical | DONE — "if a curvature is incompatible, for example when $f_0$ is concave, or cannot be determined". |
| 15 | ℓ₂ norm dash | DONE — "$\ell_2$-norm atom". |
| 16 | `sum_largest` "\texttt{}" + mathbf at (1.4) | DONE — `\texttt{sum\_largest}`, `\mvec{w} \ge \zeros`, `q\ones`. |
| 17 | "Here, q acts" comma | DONE. |
| 18 | DPP "not defined." | DONE — first use is now `\ac{DPP}` in §1.2.2, which expands it; this also auto-fixes the §2.1.3 re-definition (see 26). |
| 19 | §1.3 opening: sentence join "and" | DONE — semicolon → ", and" (house style bans semicolons anyway). |
| 20 | Hessian via gradient: "→ and transposing it?" | REVERTED (William, 2026-08-29) — the added clause "…and the symmetry makes a transpose of the result unnecessary" was cut as redundant: the preceding sentence already conditions the identity on symmetry ("is symmetric whenever f is twice continuously differentiable, and it is THEN the Jacobian of the gradient"). Answer for the advisor: with the document's index conventions the Jacobian of the gradient is the Hessian transposed, and the C² symmetry the text conditions on is exactly what makes the transpose moot, so the sentence is correct as written. |
| 21 | central difference: "(cut)" over "improves accuracy" | DONE — the accuracy sentence cut; the central variant folded into the following evaluation-count sentence so its mention survives. |
| 22 | Figure float whitespace p. 10 (brackets + "?") | DONE — fig:conic-form-tree (Fig. 1.3) → [tb]; also fig:scalar-vs-vectorized (Fig. 1.4). Verified in rebuild: figures at top, text fills below. |
| 23 | LAPACK "\texttt{}" | DONE. |
| 24 | Level 1 wrap + (1.10) comma | DONE (see G3/G6). |
| 25 | §1.5 "In this Master's thesis," + "In Chapter 3," comma | DONE both. |
| — | p. 16 end-of-line mark after "generic sparse formats and routines." | ILLEGIBLE at 400 dpi — the parenthetical after it was recast per 11, so punctuation is clean; William should check his copy. |

## Chapter 2 (6-Revue_litterature.tex)

| # | Comment | Disposition |
|---|---------|-------------|
| 26 | §2.1.3 DPP re-definition struck, "already I believe" | DONE — automatic once ch. 1's first use became `\ac{DPP}`; §2.1.3's `\ac{DPP}` now prints just "DPP". |
| 27 | Table 2.1 "different style than Table 1.1?" | DONE — bold header row and bold group labels de-bolded (headers plain like every other table; Views/Copies now italic group rows). |
| 28 | Fig 2.8/2.9 gap "continuous flow" + Fig 2.10 float-page whitespace | DONE — figures 2.8, 2.9, 2.10 → [tb]. Verified: 2.8+2.9 share p. 25 with text below; 2.10's page carries the CasADi listing below it. |
| 29 | AMPL "most widely used" — "Ref here" | DONE — cites the AMPL book, new entry `fourer2003ampl` (Fourer, Gay & Kernighan, 2nd ed., Duxbury Press, 2003). |
| 30 | JuMP "most widely used in Julia" — "Ref to a [ref] will be good" | DONE — `\cite{lubin2023jump10recent}` on the claim sentence. |
| 31 | "typed by ^the MOI" | DONE — "typed by the \ac{MOI}" (matches "the \ac{MOI}" at first §2.3.2 use). Follow-up: tiny overfull fixed by "plus a constant" → "and a constant". |
| 32 | Research gap ¶: "good + add why is this desirable" | CUT (William, 2026-08-29, after several rewording rounds) — the added why-sentences only restated what the preceding per-system paragraph already establishes (CasADi: split ⇒ parameter change costs one evaluation; CVXPY: the tensor is the cached mechanism), so the advantage of combining follows directly. If the advisor re-raises: that derivability is the rationale for leaving it implicit. |

## Chapter 3 (7-Theme1.tex)

| # | Comment | Disposition |
|---|---------|-------------|
| 33 | "→ Reiter what this all addresses." after ¶1 | DONE (trimmed 2026-08-29, William disliked the fuller version) — "Together, they address the gap of §2.4." The colon tail restating the gap's content was cut as an echo of §2.4 itself; the pointer is the reiteration. |
| 34 | "potentially same" on ¶2 | NO MERGE — ¶1 (performance contributions) and ¶2 (simplicity decisions) serve different purposes; the reiteration of 33 covers the note's likely intent. Flag if he meant merging. |
| 35 | "This chapter describes the affine atoms" — "section?" | DONE — "The rest of the chapter describes the affine atoms." (§3.1.1 itself doesn't; the chapter does — precise without being wrong either way.) |
| 36 | Table 3.1 "table [tb], not in middle of sentence" | DONE — [tb]; the "Each atom implements three operations…" sentence now runs unbroken, table below it. |
| 37 | Fig 3.4 / Table 3.2 float-page whitespace | DONE — both [tb]; each now shares its page with text. |
| 38 | Fig 3.5 "PD… sounds like positive definite to me" | DONE, trimmed 2026-08-29 — caption keeps the expansion "(PD is permuted dense and sPD is stacked permuted dense)"; the "not to be confused with positive definite" disclaimer cut (William: nobody will confuse it once the expansion is in the caption). Naming kept (William's decision). |
| 39 | Eq (3.2) "why diff assignment?" + inline "bt?" | NO TEXT ADDED (William, 2026-08-29, after two drafts) — display and inline were already identical and the maths checks out (A = S_r^T X S_c ⇒ B^T A = S_{c_B}^T X_B^T S_{r_B} S_{r_A}^T X_A S_{c_A}); the explanatory sentence was drafted twice ("swaps the roles…", then "reverses the order of its three factors…") and cut both times: the expansion is standard transpose-of-product algebra and stands on its own. Answer for the advisor if re-raised: transposing B = S_{r_B}^T X_B S_{c_B} reverses the factors and transposes each, so S_{r_B}'s transpose cancels. The `\mathclap` underbrace fix KEPT (mathtools now loaded in Document.tex). |
| 40 | Fig 3.6 columns "more space if possible, ressembles a single eq." | DONE — `\qquad` between the two aligned equation columns. |
| 41 | §3.4 "be more explicit that this is something you built." | DONE — "We also wrote \texttt{sparsediffpy}, the Python extension module that exposes…"; the converter/backend sentence already carries "We keep…". Light touch given the §3.1 voice history (doc8 items 19–20) — William to confirm it's enough. |
| 42 | §3.5 "presented a high-level overview" struck, "otherwise you'll be asked for a detailed one", tense | DONE — "This chapter presents our approach…", "we present the kernels". |
| 43 | `(\S2.2.3)` parenthetical scribbled, "outlined in §2.2.3" | DONE — "…of \ac{NLP} solvers outlined in §\ref{sec:casadi}." |
| 44 | "the idea is borrowed" → "process is similar" | DONE — "Although the process is similar, …". |
| 45 | "no emph" lightweight; "since" → "because" | DONE (G1/G5). |

## Chapter 4 (7-Theme2.tex)

| # | Comment | Disposition |
|---|---------|-------------|
| 46 | "know" → "evaluate" | DONE. |
| 47 | Mark near the PR #3448 / benchmark-setup ¶ — first read as "does that impact your comparison?" | REINTERPRETED + CUT (William, 2026-08-29) — William believes the comment says "what about Clarabel". The version-difference sentence added under the first reading was removed. If the Clarabel reading is right, the likely answer is already in the text ("Each measurement runs get_problem_data … We exclude the solver because the choice of backend affects only canonicalization"); William to check the ink — if it instead asks for the Clarabel VERSION, that would be a one-word addition. |
| 48 | CVaR/OptimalAdvertising parenthetical, "namely" | DONE, variant wording (2026-08-29, William disliked "namely") — "It is slower on CVaR and OptimalAdvertising, where the times are similar." Names in prose, no parenthetical, which was the comment's point. |
| 49 | Table 4.1 "in-line" | DONE with [tb] (not [h] — advisor convention per William): table now heads its page with §4.2 text below, gap gone. |
| 50 | Figure 4.1 "Very nice plots!" + "boxed" on both panels | DONE — top/right spines re-enabled in `fig_profiles_combined` (Jacobian-accumulation/canonicalization/plot_thesis_figures.py), regenerated with `--thesis`, PDF copied to images/. Data/styling otherwise unchanged. NOTE: the plot-script change is uncommitted in that repo. |
| 51 | Table 4.2 caption ratio mark ("∂ ?") | DONE — "The ratio is the re-solve time of \texttt{diffengine} over the re-solve time of the tensor." Mark was a symbol + "?"; interpreted as a definition query. |

## Chapter 5 (8-Conclusion.tex)

| # | Comment | Disposition |
|---|---------|-------------|
| 52 | "Master's" capital M | DONE. |
| 53 | Tense to simple present: revisited/taken/implemented/compared/obtained | DONE — "we revisit", "In our work, we take", "we implement", "we compare … and obtain". ("we built SparseDiffEngine" left past — not marked.) |
| 54 | "wrote diffengine" → "propose" | DONE — "We also propose \texttt{diffengine}". |
| 55 | "in Chapter 4" struck → "numerical experiments" | DONE. |
| 56 | "Redéfinir tous les acronymes dans la conclusion" | DONE — `\acresetall` at the chapter top; AD, DPP, QP, NLP re-expand at first ch. 5 use. |
| 57 | Merge CasADi ¶ and AMPL/JuMP ¶ | DONE — paragraph break removed. |
| 58 | "the engine" → name it | DONE — "the Python bindings of \texttt{SparseDiffEngine}". |
| 59 | Cut "We were simply the ones to notice…" and "for anyone reading it" | DONE — and the replacement closer "We hope that this work is insightful and useful in practice." was itself cut on the advisor's later suggestion (William agreed, 2026-08-29, no replacement added). §5.1 now ends on the "Overall, the work in this thesis…" sentence. |
| 60 | §5.2 "+1 phrase high-level, comment fait?" | DONE, reinterpreted (William, 2026-08-29) — "comment fait?" read as asking how the standalone interface would work, not for an application example. The fitting-routine example was replaced with (William's framing): "The user would build the expression trees with the functions of \texttt{sparsediffpy} instead of with \texttt{CVXPY} expressions." |
| 61 | diffengine-default ¶ "plus du dév. que de la recherche" | DONE — opener now concedes it: "The second direction is closer to development than research." Rest unchanged. |
| 62 | "matrix classes" — "like?" | DONE — "the permuted dense matrix classes of Chapter 3". |
| 63 | "Knowing ahead of time… could benefit both steps" — "too generic. Remove and add the high-level step" | DONE — replaced with the concrete step: pass the block structure along with the problem data so presolve/factorization work on the dense blocks directly instead of rediscovering them (the block-aware factorization idea). |
| 64 | "a lot of effort" — "too generic, state what is needed" | DONE — "adapting existing presolve routines and sparse linear system solvers to matrix representations other than the typical sparse matrix." |
| 65 | Long "Ref." arrow before REFERENCES | DONE (best reading: citations for the final ¶'s claims) — `\cite{davis2006direct}` added at the sparse-solver sentence. Flag if he meant the whitespace instead. |

## References (Document.bib)

| # | Comment | Disposition |
|---|---------|-------------|
| 66 | Struck "[Online]. Available:" tails on ~18 entries | DONE globally — `CTLuse_url = "no"` in the `@IEEEtranBSTCTL` entry (one line); web-only resources keep their URL via `howpublished`. |
| 67 | "tu n'utilises pas les abréviations partout. Alors au long." / "no abbreviations" | DONE — ACM Trans. Math. Softw. (×2) → ACM Transactions on Mathematical Software; Numer. Math. → Numerische Mathematik; J. Mach. Learn. Res. → Journal of Machine Learning Research; INFORMS J. on Computing → INFORMS Journal on Computing. Full-file audit found no others. |
| 68 | "for arxiv, verify if published, otherwise cite as a paper but with arxiv No." | DONE, web-verified per entry: **published** — legat2020mathoptinterface (INFORMS J. on Computing 34(2):672–689, 2022), lubin2023jump10recent (Math. Prog. Comp. 15(3):581–589, 2023), clarabel (Math. Prog. Comp., online-first 2026, DOI only), hill2025sparser (Transactions on Machine Learning Research, 2025); **still preprints** (kept with arXiv no.) — ge2022copt, zhang2026cvxpy, cederberg2025disciplined (year fixed 2025→2026), blondel2024elements, Laue2019OnTE (title corrected to the current arXiv v4 "On the Equivalence of Automatic and Symbolic Differentiation", author Sören Laue, Semantic Scholar URL dropped). |
| 69 | [21] "Mosek, not a first name" | DONE — `author = {{MOSEK ApS}}` (both MOSEK entries). Same-class fix applied to [17]: `{{CVX Research, Inc.}}` (printed "I. CVX Research"). |
| 70 | [9]/[10] "tous les auteurs dans thèse" | DONE — bynum2021pyomo full 8-author list + 3rd ed.; hart2011pyomo full 3-author list (verified via Crossref). Only remaining "and others" is guennebaud2010eigen, which is Eigen's own canonical citation (KEPT). |
| 71 | [35] duplicated "ph.D. dissertation." | DONE — note field dropped; same fix applied to grant2004disciplined [15] (same defect, unmarked). |
| 72 | [43] "champaign" → "C" | DONE — `note = {{Champaign, IL}}`. |
| 73 | [64]/[65] CVXPY casing circles | DONE — `{CVXPY}` braced in schaller2022cvxpygen title. |
| 74 | [56] "SIAM?" publisher inconsistency | DONE — Society for Industrial and Applied Mathematics → SIAM (3 entries; SIAM was the majority form). |
| 75 | [20] udell2014convex booktitle | DONE — "2014 First Workshop for High Performance Technical Computing in Dynamic Languages (HPTCDL)" + DOI (Crossref-verified). Same-class fix: lofberg2004yalmip booktitle title-cased. |
| 76 | [75] stroke on "Hessians" | DONE — `{H}essians` braced (Gebremedhin entry; also gay1996more "{H}essian"). |
| 77 | [77] "amplpy" circled | DONE (best reading) — its internal annotation note ("Python interface to…", printed lowercased in the entry) removed; title bracing already correct. |
| 78 | (unmarked, same class) internal annotation notes leaking into printed entries | DONE — removed from gay2005writing, gay1997hooking, gay1991automatic, gay1996more, amplpy, hill2025illustrated, asv. Kept the real notes (Champaign, arXiv numbers, COIN-OR expansion, Maple version). |
| 79 | Misc casing (unmarked, same class) | DONE — `{SymPy}`/`{P}ython` (sympy2017), `{CVXR}`/`{R}` (Fu_2020), `{P}ython` (hart2011pyomo), `{MathOptInterface}`, `{JuMP}` braced in the converted entries. |

## Residual items for William

- `[source]` scholarship name in acknowledgements (item 2).
- Illegible insertion at Intro p. 3 end of line (after "generic sparse formats and routines.").
- Confirm readings: abstract "2nd not done as of now!" (item 6), §3.4 authorship strength
  (41), ¶-merge intent (34), "Ref." arrow (65), résumé wording variant (3).
- Uncommitted plot-script change in Jacobian-accumulation (boxed spines, item 50).

Build: `make` clean, no undefined citations, one 0.9 pt overfull (invisible). All
float/whitespace complaints re-checked visually in the rebuilt PDF.
