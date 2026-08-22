# §3.3 Computational kernels — cleanup pass (2026-08-10)

Concision/de-duplication pass on §3.3 of `7-Theme1.tex`, matching the §3.2 cleanup style.
Almost everything removed was an intra-chapter restatement (the two-pass re-description in
the kernel definition, the disjoint-product and PD-index-vector items in §3.3.2 that repeated
§3.3.1, the variable-Jacobian example that repeated §3.1.2, caption sentences repeating the
body). Those need no archive. One real cut:

## §3.3.3, the CasADi identity clause

Cut from the sentence linking `eq:extract-at-zero` to matrix stuffing, per the chapter-wide
removal of stacked cross-reference passages. The matrix-stuffing and §sec:bg-derivatives
links stay; this third clause went:

```latex
, and \eqref{eq:extract-at-zero} is the identity
that the \texttt{CasADi} listing of \S\ref{sec:casadi} writes with \texttt{jacobian} and
\texttt{substitute}
```

The listing it points to still exists (`6-Revue_litterature.tex`, sec:casadi), so the clause
can be restored verbatim if the echo is ever wanted back.

## Declined full cuts

Offered and declined by William on 2026-08-10: fig:kernel-dispatch (kept, with the rotated
"type of B" label shifted from x = −2.6 to −3.3 to clear the row headers), eq:pd-product,
fig:sum-idx-map, and the atom name lists in §3.3.2. All stay.
