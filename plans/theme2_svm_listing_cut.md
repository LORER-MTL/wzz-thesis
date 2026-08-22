# Cut: SVM L1 code listing from §4.2 (2026-08-13)

Cut at William's request the same day it was added ("I finally dont like the code
listing"). The explanation paragraph after tab:param-tensor stays; only the listing was
removed and the paragraph's first SVM sentence reworded from "Listing~\ref{lst:svm-l1}
shows the formulation of ..." to "In \textsc{SVMWithL1Regularization}, ...".

Removed LaTeX:

```latex
\begin{lstlisting}[language=Python, caption={The \textsc{SVMWithL1Regularization} problem
in \texttt{CVXPY}.}, label=lst:svm-l1]
# data: X (25000 x 500, dense), labels Y (25000 x 1)
beta = cp.Variable((n, 1))
v = cp.Variable()
lambd = cp.Parameter(nonneg=True)
loss = cp.sum(cp.pos(1 - cp.multiply(Y, X @ beta - v)))
reg = cp.norm(beta, 1)
problem = cp.Problem(cp.Minimize(loss/m + lambd*reg))
\end{lstlisting}
```

Source: cvxpy_benchmarks/benchmark/svm_l1_regularization.py (Boyd short course problem).
Verified facts that motivated the paragraph (keep even without listing): lambda reaches
exactly 1 problem-data coefficient; FactorCovariance gamma reaches nnz(P) (~87.5k at full
size), Lmax 1 entry; both problems ~99% constant data.
