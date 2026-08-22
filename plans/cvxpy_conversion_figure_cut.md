# Figure 3.7 (fig:cvxpy-conversion) — cut 2026-08-10

Cut from `7-Theme1.tex` §3.4 during the 3.3/3.4 restructure. The TikZ graph redrew the
running example's trees already shown in `fig:conic-form-tree` (ch. 2), and the roots table
was folded into one prose sentence pointing at `fig:matrix-stuffing`. Restore by pasting the
block below back after the roots/cone-order paragraph and reinstating the reference sentence
"Figure~\ref{fig:cvxpy-conversion} shows the graph and the roots of the running example."

```latex
\begin{figure}[htbp]
\centering
\begin{tikzpicture}[
  atom/.style={draw=black!70, rounded corners=2pt, font=\small\ttfamily, inner sep=3pt},
  var/.style={draw=black!70, circle, font=\small, inner sep=1pt, minimum size=7mm},
  par/.style={draw=black!70, font=\small, inner sep=3pt},
  tag/.style={font=\scriptsize\itshape, inner sep=1pt},
  ed/.style={-{Latex[length=1.8mm]}, black!70},
]
\node[atom] (obj)  at (0.2,0)     {add};
\node[tag]  at (0.2,0.55) {objective};
\node[atom] (mul)  at (2.1,-1.35) {param\_scalar\_mult};
\node[var]  (t1)   at (-0.6,-2.9) {$t_1$};
\node[par]  (mu)   at (1.4,-2.9)  {$\mu$};
\node[var]  (t2)   at (2.9,-2.9)  {$t_2$};
\node[tag]  at (-0.6,-3.5) {$r_1$};
\node[tag]  at (2.9,-3.5)  {$r_3$};

\node[atom] (cadd) at (7.1,0)     {add};
\node[tag]  at (7.1,0.55) {$r_2$};
\node[atom] (lm)   at (5.9,-1.35) {left\_matmul $[\mmat{F}]$};
\node[atom] (neg)  at (8.9,-1.35) {neg};
\node[var]  (x)    at (5.4,-2.9)  {$\mvec{x}$};
\node[par]  (g)    at (8.9,-2.9)  {$\mvec{g}$};
\node[tag]  at (5.4,-3.5) {$r_0,\ r_4$};

\foreach \p/\c in {obj/t1, obj/mul, mul/mu, mul/t2, cadd/lm, cadd/neg, lm/x, neg/g}
  \draw[ed] (\p) -- (\c);
\end{tikzpicture}

\vspace{2ex}
\begin{tabular}{@{}llll@{}}
\toprule
& Root & Rows & Cone \\
\midrule
objective & $t_1 + \mu t_2$ & & \\
$r_0$ & $\mvec{x}$                       & $0, \ldots, n-1$          & $\reals^n_+$ \\
$r_1$ & $t_1$                            & $n$                       & $\cone{K}_{\mathrm{soc},m+1}$ \\
$r_2$ & $\mmat{F}\mvec{x} - \mvec{g}$    & $n+1, \ldots, n+m$        & $\cone{K}_{\mathrm{soc},m+1}$ \\
$r_3$ & $t_2$                            & $n+m+1$                   & $\cone{K}_{\mathrm{soc},n+1}$ \\
$r_4$ & $\mvec{x}$                       & $n+m+2, \ldots, 2n+m+1$   & $\cone{K}_{\mathrm{soc},n+1}$ \\
\bottomrule
\end{tabular}
\caption{The conic form of the running example \eqref{eq:example}, whose expression trees are
in Figure~\ref{fig:conic-form-tree}, after conversion. The atoms are the engine nodes, the
circles are variables and the boxes are parameters, and \texttt{left\_matmul} holds the data
matrix~$\mmat{F}$ as a dense block. The variable~$\mvec{x}$ is converted once and reached
from three places, so the four trees form one graph. The table lists the roots in the order
the constraints are grouped, which is the order of the row blocks of~$[\mmat{A}\ \mvec{b}]$
in Figure~\ref{fig:matrix-stuffing}.}
\label{fig:cvxpy-conversion}
\end{figure}
```
