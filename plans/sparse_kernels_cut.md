# Sparse matrix kernels block — cut from 7-Theme1.tex on 2026-07-21

History: this block was first trimmed out of the intro's background section, parked at the
top of Theme1 §Fundamental data structures, and then cut entirely (user decision, planning
session of 2026-07-21). The intro's §Sparse matrices (5-Introduction.tex, sec:bg-sparse)
already covers COO/CSR/CSC and the CSC-as-CSR-of-transpose fact with the Gustavson citation,
so part of this duplicated it. If the Theme1 dispatch section later needs Gustavson's
algorithm explained (sparse×sparse fallback kernel), add a trimmed paragraph to
sec:bg-sparse instead of restoring this wholesale.

The cut LaTeX, verbatim:

```latex
\paragraph{Sparse matrix kernels.}
The engine's generic sparse type stores matrices in the CSR and CSC formats of
\S\ref{sec:bg-sparse}; the following paragraphs present the kernels it uses on them,
continuing the example matrix $S$ of \eqref{eq:sparse-matrix}.

The CSC arrays of a matrix read exactly as the CSR arrays of its transpose: compressing the
columns of $S$ is the same as compressing the rows of $S^T$. For \eqref{eq:sparse-matrix},
\begin{lstlisting}[language=C]
int  idxptr[] = {0,  1,      3,      5,  6};
int    rows[] = {1,  0,  2,  1,  2,  1};
double vals[] = {2,  1,  5,  3,  6,  4};
\end{lstlisting}
is at once the CSC representation of $S$ and the CSR representation of $S^T$. Transposition
requires no sorting: one pass over the nonzeros counts the entries of each column to build the
new \texttt{idxptr}, and a second pass scatters the entries into place, $O(m + n +
\mathrm{nnz})$ time in total \cite{gustavson1978two, davis2006direct}. The entries of each
output row come out sorted by column, so transposing twice is also the standard way to restore
a matrix with unordered indices to canonical form.

In CSR a matrix-vector product computes each output entry as a sparse dot product, gathering
from $x$ row by row:
\begin{lstlisting}[language=C]
/* y = S @ x, with y zeroed */
for (int i = 0; i < m; i++)
{
    for (int k = idxptr[i]; k < idxptr[i + 1]; k++)
    {
        y[i] += vals[k] * x[cols[k]];
    }
}
\end{lstlisting}
In CSC the roles reverse: the loop visits column $j$ and \emph{scatters} the products
$\texttt{vals[k]} \cdot x_j$ into \texttt{y[rows[k]]}, accumulating the output instead of
gathering the input.

% TODO maybe clean this up and make it a bit more visual? Otherwise make sure to
% read it more thoroughly and make some edits so that it is clearer.
Gustavson's algorithm \cite{gustavson1978two} computes $C = AB$ with both operands in CSR, row
by row: row $i$ of $C$ is the sum of the rows of $B$ selected and scaled by the nonzeros of row
$i$ of $A$, merged in a dense accumulator $w$. Take $C = S S^T$, where $S^T$ in CSR is the
transpose arrays above. Row $2$ of $S$ holds $5$ at column $1$ and $6$ at column $2$, so row $2$
of $C$ is $5 \cdot (\text{row 1 of } S^T) + 6 \cdot (\text{row 2 of } S^T)$: the first term sets
$w[0] = 5$ and $w[2] = 25$, the second sets $w[1] = 18$ and grows $w[2]$ to $61$. The cost is
one multiplication per term merged, but the output indices appear in the order they are first
touched, here $[0, 2, 1]$; transposing twice sorts them when canonical form is needed.

The alternative is to compute each entry as a sparse dot product,
$c_{ij} = (\text{row } i \text{ of } A) \cdot (\text{column } j \text{ of } B)$, which asks for
$A$ in CSR and $B$ in CSC; for $C = S S^T$ both roles are served by the CSR arrays of $S$ alone.
Entries whose row and column share no index are structural zeros and cost only the scan:
$c_{01} = 0$ since rows $0$ and $1$ of $S$ have no common column, while rows $1$ and $2$ meet at
column $2$, giving $c_{12} = 3 \cdot 6 = 18$. This form rescans its operands for every candidate
entry, where Gustavson's merge touches each term once; in exchange it needs no accumulator and
produces each row sorted.
```
