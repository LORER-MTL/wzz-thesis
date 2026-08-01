# Direct differentiation subsection — cut 2026-07-31

The short-lived §2.2.3 "Direct differentiation" subsection was demoted the same day it was
created: William preferred §2.2 to keep the title "Sparse derivatives from detected structure"
and treat direct assembly as a mentioned alternative rather than a structural peer. The
content was compressed into a closing paragraph of §2.2.2 Graph colouring; the landscape
table (tab:ad-landscape) stays in place. Cut prose below, in case it is wanted back (the
O(k^2) analysis in particular may be useful in Theme 1 or the defence).

## Original text (from 6-Revue_litterature.tex, before compression)

```
Direct assembly (\S\ref{sec:bg-derivatives}) needs neither sweeps nor colouring: each node
carries its whole derivative object, and one pass over the graph combines them into $\mmat{J}$.
On a scalar graph the cost is prohibitive. The derivative work at a node is proportional to
the gradient it carries, not to the $O(1)$ operation it performs, and every intermediate
materializes a gradient of its own: the inner product $y = a_1 x_1 + \cdots + a_k x_k$ unrolls
into $k-1$ running partial sums whose gradients grow from one nonzero to $k$, so direct
propagation costs $O(k^2)$ against $O(k)$ for one sweep. The affine expressions of
canonicalized problems are dominated by such sums.
Direct assembly on scalar graphs is therefore rare: \emph{vertex elimination} (also called
\emph{cross-country} accumulation) forms $\mmat{J}$ by eliminating the intermediate vertices of the
linearized graph, but the optimal elimination order is intractable
\cite{griewank2008evaluating, naumann2008optimal}, and the scalar symbolic graphs of
\texttt{CasADi} build derivative expressions node by node in the same spirit \cite{casadidocs}.
Vectorization removes the obstruction: a node is a whole matrix operation, its local
derivative is a structured block rather than a $0/1$ dependency, and the graph shrinks from
millions of scalar operations to a few structured nodes, so carrying a sparse matrix per node
is affordable. Recent works apply this idea in statistics \cite{kwok2025vectorised} and
optimal control \cite{zou2025vectorized}.
On a vectorized graph, direct propagation is cheaper when the local blocks are structured and
intermediate fill-in stays bounded; the oracle with colouring is cheaper when the intermediates
densify.
Which assembly is preferable follows the solver that consumes the result: the conic
solvers targeted in this thesis require the matrix explicitly as data, which the direct approach
produces.
```

## Content dropped entirely in the compression (not just shortened)

- The O(k^2) vs O(k) inner-product analysis (why scalar direct propagation is quadratic).
- "The affine expressions of canonicalized problems are dominated by such sums."
- CasADi's scalar symbolic graphs building derivative expressions in the vertex-elimination
  spirit (\cite{casadidocs}).
- The fill-in trade-off (direct cheaper when blocks structured and fill-in bounded, oracle
  cheaper when intermediates densify).
