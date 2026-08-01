# Cut: "Sparse automatic differentiation in Julia" subsection

Cut from `6-Revue_litterature.tex` (§ Sparse derivatives from detected structure) on
2026-07-25, when the user decided to simplify the lit review to one detailed sparse-AD system
(CasADi). Kept elsewhere: the `hill2025sparser` citation in the detect-compress-propagate
paragraph, the "Julia sparse AD (Hill--Dalle)" rows in `tab:ad-landscape` and the chapter-end
summary table, and the `hill2025illustrated` pointer in the section's References paragraph.
Restore from here if the subsection is ever wanted back (e.g. for the defense).

```latex
\subsection{Sparse automatic differentiation in Julia}
\label{sec:julia-ad}

The Julia sparse-AD stack developed by Hill and Dalle \cite{hill2025sparser, hill2025sct} is the
state of the art of the detect--compress--propagate scheme described above, packaged as three
composable libraries: \texttt{SparseConnectivityTracer} detects the sparsity pattern,
\texttt{SparseMatrixColorings} compresses it, and \texttt{DifferentiationInterface} drives the
compressed sweeps through any Julia AD backend.

\paragraph{Sparsity detection.}
Detection works by operator overloading. The function is evaluated once on \emph{index-set
tracers}: input $x_j$ starts as the singleton $\{j\}$, and every operation returns the union of
the index sets of its arguments. The index sets of the outputs are the rows of the Jacobian
pattern; a second-order tracer propagates index pairs the same way and yields the Hessian
pattern. The tracers carry no values, so the pattern is \emph{global}: it holds at every input
and is computed once per function.

\paragraph{Compression and propagation.}
\texttt{SparseMatrixColorings} compresses the pattern with greedy distance-2 and star colorings,
and \texttt{DifferentiationInterface} propagates one compressed seed per color
through the chosen backend, then scatters the recovered values into the sparse matrix.
All three stages are bundled into a preparation object, computed once and reused across
evaluations:
\begin{lstlisting}
using DifferentiationInterface, SparseConnectivityTracer, SparseMatrixColorings
import ForwardDiff

backend = AutoSparse(AutoForwardDiff();
    sparsity_detector  = TracerSparsityDetector(),
    coloring_algorithm = GreedyColoringAlgorithm())
prep = prepare_jacobian(f, backend, x)  # detect + color, once
J = jacobian(f, prep, backend, x)       # compressed sweeps, repeated
\end{lstlisting}
```

Also cut at the same time, the pre-table comment:

```latex
% we should maybe find more in julia?
% there's like enzyme and whatnot. but maybe they are all just the same?
```
