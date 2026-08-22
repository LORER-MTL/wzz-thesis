# Advisor comments on the literature review — resolution log

Source: annotated PDFs `Document 4_ALL_5596.pdf` and `Document 5_ALL_6674.pdf`
(~/Downloads, received 2026-08-12). All comments are now addressed; this file records what
was done, in two passes on 2026-08-12.

## Pass 1: matrix stuffing (§2.1), chapter intro, global typography

- §2.1 reordered per the in-source TODO: Composing linear operators → Parameter caching →
  Example (now ends with the parameter-map passage and hosts fig:param-map-dpp and
  fig:param-map-evalparams) → new subsection Backends and limitations (sec:ms-backends).
- `\vect`/`\diag` are `\mathrm` operators (defs.tex), not bold.
- Single hyphen for matrix-vector, matrix-matrix (en-dash only for name pairs); `~\cite`
  ties chapter-wide; DPP/JVP/VJP acronym expansions lowercased (both blocks in
  4-Sigles_Abrev.tex).
- Wording: "On the other hand" cut; roadmap "coefficient storage during the pass, and
  caching of the problem data"; "the derivative of a vectorized expression";
  "(Figure X)" → "as shown in Figure X"; captions "of (1.5)" not "of problem (1.5)";
  "subtree; the tradeoff" split; "In cvxcore, the views"; CVXPYgen sentence reworded
  (map entries written into the generated C source as constants); limitations merged into
  one paragraph; §2.1.1's opening paragraphs merged; `ignore_dpp=True` → "the option
  `ignore_dpp`" (killed the marked overfull).

## Pass 2: sparse AD (§2.2) + jargon sweep

- §2.2.1 opening rewritten: "sweep" defined at first load-bearing use ("A sweep visits
  every node once and applies the chain rule at each"), "a traversal" dropped (advisor:
  "what is a traversal?", "not sure I follow").
- Citation added: "recover the full sparse matrix from multiple matrix-vector
  products~\cite{griewank2008evaluating}" (the advisor's "~[Ref]").
- Accumulation sentence: cite moved onto "accumulation~\cite{griewank1991markowitz}",
  "(Figure 2.9)" → "as shown in Figure 2.9", semicolon split into two sentences.
- "(Figures 2.7 and 2.8)" → "as shown in Figures 2.7 and 2.8".
- "amortized" → "spread" (advisor flagged it as a financial term).
- Circled mark on ADOL-C/CppAD resolved (William): wrap tool names in `\texttt{}`;
  also fixed the inconsistent plain `Eigen` in §2.1.4 to `\texttt{Eigen}`.
- Noun "traversal" swept as jargon (William's call): JuMP subsection "no expression graph
  to visit"; intro's array/column sentences now "read"/"run over". The verb "traverse" is
  fine — "traverse the tree" kept in the intro's expression-tree sentence.

## No action

- CasADi code listing environment (already a captioned, unbreakable lstlisting).
- Backend bullets' consequence clauses (added 2026-08-11).
- "nice figs!" on fig:jacobian-coloring — praise only.
