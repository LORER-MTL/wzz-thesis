# Tensor-cost and amortization sections (cut from ch. 4, 2026-08-10)

Cut from `7-Theme2.tex` during the chapter-wide cleanup: the whole subsection "The cost of
building the parameter tensor" (`sec:bench-tensor`, `tab:tensor-cost`) and the whole
subsection "When the parameter tensor repays itself" (`sec:bench-amortize`,
`tab:param-amortize`). The chapter was also flattened at the same time (no subsections
anywhere; setup subsections merged into one flat §Benchmark Setup).

**Why:** William judged the chapter overly detailed and asked for the amortization table
to go entirely. With the amortization question gone, the tensor-cost table's main job
(setting up "when does the tensor repay itself") disappears with it. The facts from it
that still carry weight survive as prose in §Parametric problems: the tensor costs
cvxcore/SCIPY 18–60x on the problems with tens of thousands of parameter entries, both
fail outright on SimpleFullyParametrizedLP and ParametrizedQP, COO builds it at no extra
cost, and that degradation is what CVXPY's 1000-entry COO substitution rule avoids.

Facts that exist ONLY here (not in the surviving chapter): the per-backend tensor-cost
ratios (27.7/60.2/17.8/23.7, geometric means 2.82/3.34/0.95), the ConvexPlasticity
not-DPP-under-the-solving-chain special case, the amortization arithmetic (break-even at
19/33 re-solves for the stuffing problems, immediate for the scalar-parameter problems,
25/32 re-solves for the tensor to overtake diffengine, "never" on three problems), and the
observation that the engine caches the compiled program and re-evaluates only
parameter-dependent coefficients, recovering most of what the tensor buys warm. If a
committee member asks "but DPP exists to amortize", the amortization table is the answer;
resurrect from here.

**Update 2026-08-11:** the tensor-cost data is back in the chapter, in absolute form: William
asked for the DPP-path times alongside the ignore_dpp times, and then for one merged table,
so `tab:param-cold` now has two columns per backend (DPP / no DPP, seconds, medians of the
same `repl/upstream_param_rep{1,2,3}.json` runs; `\small` + 3pt tabcolsep to fit) plus the
diffengine and Ratio columns, with a prose paragraph carrying the 18/28x (cvxcore), 24/58x
(SCIPY), COO-free, 1000-entry-substitution, and ConvexPlasticity-not-DPP facts. The ratio-form table below and the amortization
subsection remain cut. The DPP≈ignore_dpp equality on the 1-2-entry problems was
re-verified live on 2026-08-11 (fresh-process single shots: FactorCovarianceModel CPP
5.50 vs 5.56 s; SVM SCIPY 9.02 vs 8.92 s; control ParamSmallMatrixStuffing CPP 8.19 vs
0.32 s).

Smaller prose cuts made in the same pass (not reproduced verbatim): the X vs X_ND no-op
agreement check (geomeans 0.99/1.02/1.01, individual pairs 0.74–1.18), the bit-identical
verification detail (problem names; the max|Δ|=0 / 5.6e-17 claim survives compressed in
setup), the replication-trust paragraph after tab:param-cold (its 1–8 % / 1–4 % / 3–19 %
numbers moved to setup), the "had they been omitted the geometric mean would have been
worse" sentence, the ConvexPlasticity measurement-history sentence (earlier sweeps
measured diffengine against itself because the fork routes the unpinned column to
diffengine on that problem), and the 6.8x/7.8x SCIPY-vs-cvxcore margins on
SDPSegfault1132/Cajas.

## Cut content, verbatim

### §The cost of building the parameter tensor

```latex
\subsection{The cost of building the parameter tensor}
\label{sec:bench-tensor}

Table~\ref{tab:tensor-cost} reports, for each stock backend, the ratio of its DPP time to
its \texttt{ignore\_dpp} time on the same problem in the same environment. The ratio
isolates the tensor: numerator and denominator differ only in whether one is built.

\begin{table}[htbp]
\centering
\caption[Cost of building the parameter tensor, by backend]{Cost of building the
parameter tensor. Each entry is the backend's DPP time divided by its
\texttt{ignore\_dpp} time on the same problem; values above $1$ mean the tensor is more
expensive than constructing the data directly. Measured in the stock environment.}
\label{tab:tensor-cost}
\begin{tabular}{l r r r r}
\toprule
Benchmark & \#par.\ entries & \texttt{CPP} & \texttt{SCIPY} & \texttt{COO} \\
\midrule
ParamSmallMatrixStuffing    & 90\,450 & \textbf{27.7} & \textbf{60.2} & 0.82 \\
ParamConeMatrixStuffing     & 40\,300 & \textbf{17.8} & \textbf{23.7} & 0.80 \\
ParametrizedQP              & 14\,406\,000 & --- & --- & 0.99 \\
SimpleFullyParametrizedLP   & 1\,000\,000 & --- & --- & 0.98 \\
SimpleScalarParametrizedLP  & 1       & 1.04 & 1.01 & 1.11 \\
FactorCovarianceModel       & 2       & 1.01 & 1.03 & 0.99 \\
SVMWithL1Regularization     & 1       & 0.97 & 0.92 & 0.96 \\
ConvexPlasticity            & ---     & 1.01 & 1.01 & 1.01 \\
\midrule
\textbf{Geometric mean}     &         & \textbf{2.82} & \textbf{3.34} & \textbf{0.95} \\
\bottomrule
\end{tabular}
\end{table}

The tensor is not intrinsically expensive: it is expensive \emph{for two of the three
backends}. \texttt{CPP} and \texttt{SCIPY} pay $18$--$60\times$ on the two problems with
tens of thousands of parameter entries, while \texttt{COO} pays nothing anywhere --- on
those same problems building the tensor is marginally \emph{cheaper} than building the
data directly. This is precisely what \texttt{COO}'s coordinate-format tensor is designed
for, its operations scaling with the number of stored nonzeros rather than with the
parameter dimension (\S\ref{sec:bg-sparse}). On the two problems with the largest
parameter counts the degradation is not merely a slowdown but an outright failure, which
is why those four cells are blank: pinned to \texttt{cvxcore},
\textsc{SimpleFullyParametrizedLP} terminates the worker process, on both the stock and
the development environment, and an attempt to measure \textsc{ParametrizedQP} the same
way ended with the entire benchmark run being killed. \texttt{SCIPY} fails on both as
well --- it crashes the worker on the first and was still running on the second after
\SI{77}{\minute} --- reproducing the same two failures recorded in earlier sweeps.
\texttt{COO} completes both without difficulty.

This explains the substitution rule of \S\ref{sec:bench-two-baselines}. \texttt{CVXPY}
switches to \texttt{COO} above $1000$ parameter entries because that is exactly the regime
in which the other two backends degrade. A consequence worth stating explicitly is that
the default path never pays the tensor penalty: it routes around it. \textsc{ConvexPlasticity}
is a further special case --- it is not DPP under the criterion the solving chain applies,
so parameters are substituted regardless of the flag and all three columns coincide.
```

### §When the parameter tensor repays itself

```latex
\subsection{When the parameter tensor repays itself}
\label{sec:bench-amortize}

The tensor exists to be reused. Its cost is paid once and recovered over subsequent
re-solves, so the honest question is not which construction is faster but after how many
re-solves the investment breaks even. Table~\ref{tab:param-amortize} answers it: the
break-even count is the extra cost of building the tensor divided by the saving it yields
per re-solve.

\begin{table}[htbp]
\centering
\caption[Amortization of the parameter tensor]{Amortization of the parameter tensor.
``Extra cold'' is the DPP construction time minus the direct construction time; ``saved''
is the per-re-solve advantage of applying a cached tensor over reconstructing from
scratch. ``Break-even'' is their quotient, in re-solves. The last column gives the same
count for \texttt{diffengine} against the tensor.}
\label{tab:param-amortize}
\begin{tabular}{l r r r r}
\toprule
Benchmark & Extra cold (s) & Saved / re-solve (s) & Break-even & vs \texttt{diffengine} \\
\midrule
ParamConeMatrixStuffing     & 3.07 & 0.162 & 19 re-solves & never \\
ParamSmallMatrixStuffing    & 7.61 & 0.234 & 33 re-solves & never \\
SimpleScalarParametrizedLP  & 0.63 & 4.28  & immediate    & never \\
FactorCovarianceModel       & 0.97 & 4.20  & immediate    & 25 re-solves \\
SVMWithL1Regularization     & 3.80 & 8.66  & immediate    & 32 re-solves \\
\bottomrule
\end{tabular}
\end{table}

Two regimes appear. Where the parameters are a handful of scalars, the tensor is
essentially free to build and saves seconds on every re-solve, so it pays for itself
immediately; a workflow that re-solves even once should use it. Where the parameters are
large, building the tensor costs seconds and saves only fractions of one, and $19$ to $33$
re-solves are needed before it is worthwhile.

Against \texttt{diffengine} the comparison is more favourable still. On three of the five
problems \texttt{diffengine} is faster both cold and warm, so no number of re-solves lets
the tensor overtake it; on the remaining two it would take $25$ and $32$ re-solves. The
engine occupies a middle position by construction: it never builds a tensor, so it never
pays for one, but it caches the compiled program and re-evaluates only the
parameter-dependent coefficients, which recovers most of what the tensor buys. Since these
counts compare across the two environments of \S\ref{sec:bench-setup}, and the engine
environment is the slower of the two, they understate \texttt{diffengine}'s position.
```

Note: the "re-solve columns are means of three re-evaluations" clause in the old protocol
paragraph referred to the amortization data and was cut with it. The raw re-solve timings
remain in the benchmark repo (`canonicalization/` in Jacobian-accumulation).

## Second cleanup pass, same day (setup section)

William then asked for a major cleanup of §Benchmark Setup too ("we don't need to talk
about precision and all these things"). Additional cuts, facts recorded here since they
now appear nowhere in the thesis:

- **Noise/resolution numbers:** a repeated measurement of a single cell varies by 1–8 %,
  a ratio formed within one environment by 1–4 %, a ratio spanning the two environments
  by 3–19 %. The dependent sentence after tab:param-cold ("the ordering is reliable, and
  so is the distinction between 0.2 and 0.8, but 0.76 against 0.79 is not a meaningful
  gap") was cut with it.
- **Systematic offset magnitude:** the engine environment runs 1.03–1.21x slower than
  stock on identical work. Survives qualitatively ("slightly faster... so cross-environment
  comparisons are conservative").
- **ND-object verification:** on ConvexPlasticity, ParamConeMatrixStuffing and
  ParamSmallMatrixStuffing the A matrices agree bit-identically (max|Δ| = 0) and P to
  5.6e-17.
- **Why _ND needs stock CVXPY:** the development fork rejects an explicit backend on the
  ignore_dpp path.
- **Environment detail:** 6-core Intel Core i7-8850H at 2.6 GHz, 16 GB RAM, macOS 15.7,
  Python 3.14, BLAS pinned to one thread; engine env = fork + sparsediffpy 0.7.0 +
  NumPy 2.4 + SciPy 1.17; stock env = CVXPY 1.9.2 + NumPy 2.5 + SciPy 1.18. Only "2018
  MacBook Pro", "single-threaded", "fresh process" and "CVXPY 1.9.2 as released" survive.
  The \cite{numpy} and \cite{2020SciPy-NMeth} citations were dropped from the chapter but
  both are cited elsewhere in the thesis, so the bibliography is unchanged.
- The DPP tensor-vector-product recovery detail and "keeps the expression tree" clause
  were compressed out of the fairness paragraph.

## Fourth cleanup pass, same day (performance analysis trimmed; William to rewrite)

William: "cut down a lot the description of convexplasticity and other performance stuff,
its not well written and I would like to say something of my own." A TODO(william) comment
in `7-Theme2.tex` marks the spot. Cut prose, verbatim:

Margin analysis after tab:param-cold:
> The margin is smaller than on the non-parametric problems ($0.32$), and the reason is
> visible in the table: the two matrix-stuffing problems are small enough
> ($0.14$--$0.21$\,\si{\second}) that fixed overhead in \texttt{CVXPY}'s Python-side
> reduction chain, which every column pays, compresses the achievable ratio. Excluding
> those two, the geometric mean is $0.40$.

Upper-bound reasoning (compressed into one sentence in the chapter):
> \texttt{SCIPY} and \texttt{COO} still bound the comparison: whatever \texttt{cvxcore}
> would have taken, it could only have been slower, so the two ratios shown are upper
> bounds on \texttt{diffengine}'s advantage.

ConvexPlasticity paragraph (chapter keeps one sentence):
> \textsc{ConvexPlasticity} is the one problem in the suite where \texttt{diffengine} is
> clearly beaten, at \SI{2.07}{\second} against \SI{0.35}{\second}. The cause is a
> materialization defect rather than derivative computation. \texttt{diffengine} emits a
> $P$ matrix with $9\,048\,000$ stored entries of which only $33\,000$ are nonzero, a
> $274\times$ padding that \texttt{SciPy} must then re-canonicalize; \texttt{CVXPY}'s
> backends emit exactly the $33\,000$. The remedy is known and discussed in
> \S\ref{sec:Limitations}.

Note: a re-solve table (`tab:param-resolve`) was ADDED in this pass at William's request
(tensor re-apply vs diffengine numeric-pass re-run, medians of the three 2026-08-08
replications; upstream `dpp` / fork `diffengine` strategies of
`run_backend_benchmarks.py`). The old amortization "Saved / re-solve" column was a derived
quantity (nodpp rebuild minus tensor re-solve); the new table reports the raw times.
"Stock backend" wording was also removed chapter-wide (William: not common) in favour of
"\texttt{CVXPY}'s backends" / "unmodified \texttt{CVXPY}".

## Fifth cleanup pass, same day (default column dropped from tab:param-cold)

William questioned why `default` exceeded all three pinned backends. Investigation
(repl JSONs): the column was `CPP_DEFAULT` = no kwargs at all = the **DPP path** (builds
the tensor, not the plain matrices the other columns build), measured in the **fork**
environment (slower), and on ConvexPlasticity the fork routes the unpinned path to
diffengine itself (2.09 ≈ diffengine's 2.07). Three silent caveats in one column; dropped.
The setup paragraph now states only that `CPP` is pinned explicitly because of the
1000-entry COO substitution rule. Dropped values (fork env, DPP path, medians):
FactorCovarianceModel 5.43, SVMWithL1Regularization 11.52, SimpleScalarParametrizedLP
4.74, SimpleFullyParametrizedLP 2.16, ParametrizedQP 10.28, ParamSmallMatrixStuffing
0.43, ParamConeMatrixStuffing 0.29, ConvexPlasticity 2.09.

## Third cleanup pass, same day (§Summary cut wholesale)

William judged the chapter summary not useful; cut entirely, so the chapter now ends on
the ConvexPlasticity paragraph and has three sections. The Conclusion's "Summary of
Works" (unwritten, TODO in `8-Conclusion.tex`) is the intended benchmark recap. The
peak-memory point was appended to the Limitations TODO comment there. Unique facts that
lived only in this summary: **fastest system on 21 of the 25 problems**; the
both-figures-conservative framing (oracle baseline no user has + engine timings from the
slower environment); the wins/level/loses synthesis; the peak-memory sentence.

```latex
\section{Summary}
\label{sec:bench-summary}

Measured against an oracle that selects the best of \texttt{CVXPY}'s three canonicalization
backends for each problem, \texttt{diffengine} constructs the problem data
$3.1\times$ faster on the non-parametric problems and $2.1\times$ faster on the
parametric ones, and it is the fastest system on $21$ of the $25$ problems in the suite.
Both figures are conservative in the same direction: the baseline is an oracle no user
actually has, and the engine's timings come from the slower of the two measurement
environments. Every missing cell in the tables is a stock backend that failed to
complete, and each such omission removes a slow baseline, so the affected ratios also
understate the advantage.

The exceptions are consistent with the design described in Chapter~\ref{sec:Theme1}.
\texttt{diffengine} wins where problem data must be \emph{derived}, because it reads each
atom's Jacobian block off structurally instead of reconstructing it; it draws level where
the work is \emph{copying} a large constant block (\textsc{CVaR},
\textsc{OptimalAdvertising}, \textsc{SDPSegfault1132}), where no structural knowledge
helps; and it loses once, on \textsc{ConvexPlasticity}, to a defect in how a sparse
matrix is materialized rather than to anything about computing derivatives.

Peak memory is measured by the same harness and is not reported here: it does not follow
the timing results, with \texttt{diffengine} markedly heavier on several problems, and it
is taken up separately in \S\ref{sec:Limitations}.
```
