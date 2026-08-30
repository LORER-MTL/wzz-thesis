# Philipp Schiele's review (Document_Pschiele.pdf) — comment log and dispositions

12 typed highlight comments (author "ps"), received 2026-08-28, on the dedication and
Chapter 1. His PDF was built from an older tree than main@32ca030 — three comments were
already fixed in the source before this round (verified against the current files).

| # | Page | Comment | Disposition |
|---|------|---------|-------------|
| 1 | 3 | "period?" (dedication line end) | ALREADY FIXED — 1-Dedicace.tex:17 ends with the period; his PDF predates it. |
| 2 | 14 | "Can refer to as DSL" (embedded modelling languages) | DONE — "modelling languages embedded in general-purpose programming languages, a form of domain-specific language, have gained popularity." Spelled out, no new acronym. |
| 3 | 15 | Rough transition "often called … / just CVXPY" | DONE — next sentence now names the context switch: "In \texttt{CVXPY}, the first solve of a problem family forms and caches a parameter tensor…". |
| 4 | 15 | "intuition for this? P is quite intuitive, but for A…" | DONE — added: "Each row of A holds the coefficients of one scalar constraint, and these coefficients are the partial derivatives of that constraint with respect to the entries of x." |
| 5 | 16 | Pyomo "writes them more slowly" — "remove or add data" | DONE — clause CUT ("…through .nl files, among other formats."). Matches the lit-review-tone rule (no cost claims about reviewed systems). |
| 6 | 16 | "which two" ("We review both these modelling languages") | DONE — "We review \texttt{AMPL} and \texttt{JuMP} in §2.3." |
| 7 | 19 | sum_largest LP "a bit of a leap… the LP is the dual of the naive formulation. Perhaps cite von Neumann" | DONE — added: "These conditions are obtained by linear programming duality \cite{vonneumann1947maximum}, as the sum of the k largest entries is itself the optimal value of a small LP \cite{boyd2004convex}." Von Neumann cited per Philipp (2026-08-29, William's call): new bib entry `vonneumann1947maximum` (Collected Works Vol. VI, Taub ed., Pergamon 1963, pp. 27–28, note on the 1947 IAS working paper). |
| 8 | 20 | parameters — "did they exist from the beginning?" | REVERTED (William, 2026-08-29) — "from the start" removed, sentence back to "and support for parameters, which lets compilation work be reused…". |
| 9 | 24 | "is rounding the precise technical term?" | DONE — "round-off errors" (standard finite-difference terminology, truncation vs. round-off). |
| 10 | 26 | "Perhaps 'C-Style' and 'Fortran-Style'" | DONE — "…so the two orders are also called C-style and Fortran-style." (Figure 1.5 already labels them "(C)"/"(Fortran)".) |
| 11 | 27 | COO values "doesn't have to be floating point… any datatype" | DONE — "floating point value array" → "value array" (the C listing still shows `double`, as one concrete instance). The COO-naming half of his comment was already fixed (\ac{COO} at first use). |
| 12 | 28 | "Introduce COO?" | ALREADY FIXED — §1.4.2 introduces "the \ac{COO} format, also called the triplet format" at first use; his PDF predates it. |
