# Advisor style guide (from the 2026-07-30 annotated intro PDF)

Conventions extracted from Antoine's handwritten pass on `Document 2_ALL_2097.pdf` (front matter
+ Chapter 1). Chapter 1 now follows all of these. **Apply the same pass to chapters 2–5**
(`6-Revue_litterature.tex`, `7-Theme1.tex`, `7-Theme2.tex`, `8-Conclusion.tex`) — status of each
rule below.

## 1. Math notation  [macros done; bold sweep of ch. 2–5 PENDING]

| Object | Notation | LaTeX |
|---|---|---|
| Number sets | blackboard | `\reals`, `\integers`, `\complex`, `\symm` (now `\mathbb` via `defs.tex`) |
| Vectors (latin) | bold lowercase | `\mvec{x}` → **x** |
| Matrices | bold uppercase | `\mmat{A}` → **A** |
| Vectors (greek) | bold via `bm` | `\gvec{\theta}` → **θ** (scalars like µ stay plain) |
| Cones / general sets | calligraphic | `\cone{K}` → 𝒦 |
| Transpose | `^\top`, never `^T` | `\mvec{x}^\top \mmat{P} \mvec{x}` |
| Euler's number | upright | `\mathrm{e}^x` |

- Declare the variable under minimize: `\underset{\mvec{x} \in \reals^n}{\mbox{minimize}}`.
- State domain → codomain when first introducing any function
  (`f_i : \reals^n \times \reals^p \to \reals`); give dimensions of every new symbol
  (`q \in \reals`, `\mvec{u} \in \reals^n`).
- Element-wise vector inequalities use `\ge` / `\le`; reserve `\succeq` for PSD/cone orders.
  Say "where the inequalities are applied element-wise" when introducing them.
- **Bold sweep status**: ch. 1 DONE; ch. 2 (lit review) DONE 2026-07-31 (incl. figures/tables;
  interior atom renamed g → φ to avoid clashing with the data vector **g**). Ch. 3 (Theme 1)
  DONE 2026-07-31: index vectors bolded per William — the permuted-dense triple reads
  $(\mmat{X}, \mvec{r}, \mvec{c})$; scalar entries ($A_{r_i,c_j}$, $r_{B,k}$, $x_{00}$) stay
  plain, row slices take the bold base ($\mmat{A}_{3,:}$); code listings untouched.
  REMAINING: `7-Theme2.tex` — case by case, needs semantic judgment (S can be a set,
  u a scalar), do NOT regex it. `\reals`/`\symm` already render `\mathbb` everywhere.

## 2. Language  [ch. 1 + mechanical sweep of other chapters DONE; ch. 3 since/emph/"simply"
pass DONE 2026-07-31 — \emph{kernel} now lives at its §3.3 definition, not the roadmap]

- **Canadian English**: modelling, modeller, colouring, coloured, colour, labelled, labour,
  behaviour. (Do not touch bib keys, `\ref`/`\label` names, TikZ `color=`, code listings.)
- Causal **"since" → "because"** ("since" only for time).
- No italic `\emph` on ordinary terms (family, instance, lossless, sparse, cache-friendly,
  forward/reverse mode, curvature, …). Italics survive only for truly load-bearing definitions
  (atoms, epigraph, Smith form, reductions, oracle) — when in doubt, drop it.
- Avoid GenAI-sounding filler ("tedious and error-prone", "practitioners of optimization");
  prefer plain, specific wording ("the math" → "the mathematical formulation").
- "black box" → "blackbox"; "split in two" → "split into two"; "by hand" (for derivations) →
  "analytically".

## 3. Structure  [ch. 1 DONE; ch. 2 subsections added 2026-07-31; ch. 3 DONE 2026-07-31
(all 16 \paragraph gone: Atom classes / The expression node promoted to §3.1.1–3.1.2, the other
14 folded to prose and kept as comments, incl. the References head to match ch. 2; no
subsubsections per William); check ch. 4–5]

- Ch. 2 numbered structure (2026-07-31): §2.1 Derivative rules / Coefficient storage /
  Parameter caching / The canonicalization backends; §2.2 Oracle differentiation / Graph
  colouring / CasADi (direct differentiation demoted to a closing paragraph of Graph
  colouring, cut archived in plans/direct_diff_subsection_cut.md); §2.3 AMPL / JuMP
  (unchanged). A high-level content pass of ch. 2 is planned before it goes back to Antoine.
  De-AI prose sweep of ch. 2 DONE 2026-07-31 (~45 rewrites: colon tics, zingers, roadmap
  formulas, cute verbs; "walk" renamed to "pass" chapter-wide per William).

- **Continuous prose, not run-in `\paragraph{}` headings** ("draft a continuous text instead of
  a sequence of isolated topics"). Fold the heading's content into a topic sentence.
  Ch. 1 keeps only two: "Our approach." and "Example of reformulations." (not struck by advisor).
  Removed headings are preserved as `% \paragraph{...}` comments (ch. 1 + ch. 2, 2026-07-31)
  so they can be brought back if wanted.
- Fine structure is reintroduced with NUMBERED headings only; never unnumbered run-in
  headings. §1.3 differentiation methods are subsections 1.3.1–1.3.3; a new §1.2.3 Example
  subsection holds the canonicalization example (2026-07-31).
  The §1.4 subsubsections (Storage / The BLAS; Storage formats / Matrix products) were tried
  and REMOVED 2026-07-31 (William's preference: flowing prose there); `secnumdepth=3` in
  `Document.tex` is now vestigial — no subsubsections remain in any chapter.
- Contributions + thesis outline are the **last** section of the intro (Antoine:
  "dernière sub-section de l'intro"). The outline `\subsection` heading was removed
  2026-07-31 per William; the outline paragraph now opens "The rest of this thesis is
  organized as follows." — Antoine may ask for the heading back.
- Merge short single-example paragraphs into their parent paragraph.

## 4. Cross-references  [ch. 1 DONE; ch. 3 DONE 2026-07-31 (~60 nbsp added; ^T → ^\top ×18;
Identity~\eqref{eq:kron-reshape} referent fixed, its TODO resolved); check ch. 2, 4–5]

- Never a bare number: `Figure~\ref{}`, `Table~\ref{}`, `\eqref{}` for equations.
- Chapters are "Chapter~\ref{}", never `\S`; `\S` only for sections/subsections.
- Non-breaking space before math symbols: `matrix~$\mmat{A}$` ("espace insécable").
- Cite each source once per discussion; drop repeat citations on later mentions
  (AMPL/Pyomo/JuMP in ch. 1).
- Introduce every acronym before use (`\ac{}`); keep BOTH the `\acro` block and the longtable
  in `4-Sigles_Abrev.tex` in sync (SIMD was missing — added).

## 5. Punctuation details

- Bullet lists: end items with `;`, second-to-last `; or`, last `.`.
- `\emph{e.g.},` with a comma.
- Parenthetical asides the advisor turned into prose: "(also known as X)" → ", also known as X,".
- Multi-part display equations: commas between the parts, closing punctuation on the equation.

## 6. Open questions (grep `TODO(advisor)` — 2 left as of 2026-07-31)

broader thesis goal (rebuttal entry written) ·
NSERC/Stanford acknowledgement wording (`2-Remerciements.tex`).

Resolved 2026-07-31 (see `plans/antoine-rebuttal.md` for the replies to send): represent-vs-solve
(reworded) · "only DCP?" (kept, rebuttal) · matrix-stuffing ref (cite zhang2026cvxpy) ·
canonicalization-time ref (cite agrawal2019dpp; also cite agrawal2018rewriting at the term) ·
survey venue (ACM TOMS, rebuttal) · "standard convex cones" (reworded to solver convention) ·
Hessian transpose (stated $\mmat{H}^\top$ + symmetry) · "v0.9" note (advisor's PhD-era CVXPY
version; comment dropped) · (t, x) SOC order (verified correct, solvers put t first; rebuttal) ·
O(·) margin note (sidestepped: reworded to "cubic number of operations on a quadratic amount
of data", no big-O) · cvxpy URL (removed from Contributions; backend claim in the list stands).
