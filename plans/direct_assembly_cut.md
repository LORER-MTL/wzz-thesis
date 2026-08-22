# Direct assembly paragraph + tab:ad-landscape (cut from §2.2, 2026-08-04)

Cut from `6-Revue_litterature.tex` §2.2 (sec:computing-derivatives) on 2026-08-04: the lit
review no longer discusses direct assembly, so §2.2 stays a pure review of the
detected-structure / matrix-free approach and ends on CasADi's dense-block worst case.
The design argument for direct assembly belongs in Theme 1 (no-foreshadowing rule), and
`tab:modeling-systems` already positions the thesis at the chapter close.

**Natural future home: Theme 1.** A four-choices positioning table (this thesis =
vectorized / forward / direct / sparse) would support the engine's design argument where it
is made. Decide later, possibly with the advisor.

Bib entries kept in `Document.bib` (unused is harmless): `zou2025vectorized`,
`kwok2025vectorised`, `shaikhha2023sparse`, `naumann2008optimal`, `chi2026torchsla`.
Note: `chi2026torchsla` (torch-sla) appeared ONLY in this table, nowhere else in the thesis.

Cut content, verbatim:

```latex
% \paragraph{Direct differentiation.}  (heading removed per advisor style; kept for reference)
The alternative is \emph{direct} assembly, which forms $\mmat{J}$ itself and needs neither
sweeps nor colouring. Each node stores its whole local derivative, and one pass over the graph
combines them into $\mmat{J}$.
On a scalar graph the stored derivatives grow with every intermediate and the cost is
prohibitive; there the method is known as \emph{vertex elimination}, and its optimal order is
intractable \cite{griewank2008evaluating, naumann2008optimal}.
On a vectorized graph the local derivatives are structured blocks and the graph has few
nodes, so storing a sparse matrix per node is affordable; recent works apply this in
statistics \cite{kwok2025vectorised} and optimal control \cite{zou2025vectorized}.
The conic solvers targeted in this thesis consume the matrix explicitly, which direct assembly
produces.
Table~\ref{tab:ad-landscape} classifies the systems of this section and the direct
alternatives.

\begin{table}[htbp]
\centering
\footnotesize
\setlength{\tabcolsep}{6pt}
\caption{Differentiation methods classified by the four choices of \S\ref{sec:bg-derivatives}.
The methods of the lower block are direct and need no graph colouring, unlike the matrix-free
methods above them; every direct method in the table operates on a vectorized graph.}
\label{tab:ad-landscape}
\begin{tabular}{@{}l c c c c@{}}
\toprule
\textbf{Method / work} & \textbf{Expression type} & \textbf{Mode} & \textbf{Assembly} &
\textbf{Data format} \\
\midrule
ADOL-C, CppAD \cite{griewank1996adolc, bell2012cppad}
  & scalar & both & matrix-free & dense \\
\texttt{CasADi} \cite{andersson2019}
  & scalar / vectorized & both & matrix-free & sparse \\
JAX \cite{jax2018github}
  & vectorized & both & matrix-free & dense \\
\texttt{torch-sla} \cite{chi2026torchsla}
  & vectorized & reverse & matrix-free & sparse \\
Hill and Dalle \cite{hill2025sparser}
  & scalar & both & matrix-free & sparse \\
\addlinespace
Zou and Jiang \cite{zou2025vectorized}
  & vectorized & forward & direct & sparse \\
Kwok et al. \cite{kwok2025vectorised}
  & vectorized & forward & direct & sparse \\
$\nabla$SD \cite{shaikhha2023sparse}
  & vectorized & forward & direct & sparse \\
\textbf{This thesis}
  & \textbf{vectorized} & \textbf{forward} & \textbf{direct} & \textbf{sparse} \\
\bottomrule
\end{tabular}
\end{table}
```
