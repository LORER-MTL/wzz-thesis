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
- **Pending sweep, ch. 2–5**: bold the problem-data symbols (A, P, b, c, x, θ, F, J, H, …)
  case by case — needs semantic judgment (S can be a set, u a scalar), do NOT regex it.
  `\reals`/`\symm` already render `\mathbb` everywhere via `defs.tex`.

## 2. Language  [ch. 1 + mechanical sweep of other chapters DONE]

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

## 3. Structure  [ch. 1 DONE; check ch. 2–5]

- **Continuous prose, not run-in `\paragraph{}` headings** ("draft a continuous text instead of
  a sequence of isolated topics"). Fold the heading's content into a topic sentence.
  Ch. 1 keeps only two: "Our approach." and "Example of reformulations." (not struck by advisor).
- Contributions + thesis outline are the **last** section of the intro; outline is a
  `\subsection`.
- Merge short single-example paragraphs into their parent paragraph.

## 4. Cross-references  [ch. 1 DONE; check ch. 2–5]

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

## 6. Open questions (grep `TODO(advisor)` — 13 in ch. 1 files)

broader thesis goal · represent-vs-solve for conic solvers · "only DCP?" · matrix-stuffing ref ·
canonicalization-time ref · survey venue ("où avez-vous soumis?") · cvxpy URL needed? ·
"standard convex cones" wording · (t, x) SOC tuple order · Hessian transpose remark ·
numerical-diff subsubsection option · illegible O(·) margin note · unclear "v0.9" note ·
NSERC/Stanford acknowledgement wording (in `2-Remerciements.tex`).
