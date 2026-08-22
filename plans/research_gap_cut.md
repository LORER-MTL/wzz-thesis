# §2.4 Research gap (cut 2026-08-20, replaced by an unheaded synthesis paragraph)

> 2026-08-21: a rebuilt §2.4 "Research gap" was reinstated (William's decision to follow the
> advisor): two-axis summary table tab:systems-summary + three paragraphs. The text below is the
> superseded first draft, kept for the record.

Added per advisor comment 17 (Document 8 review, 2026-08-19). Cut because it repeated the gap
already stated in §1.1, the ch. 3 opening, and the conclusion, and argued against AMPL/JuMP in a
chapter written to describe systems on their own terms. Rebuttal R1 in plans/advisor-rebuttal.md.
The two-gaps content moved to the conclusion's first paragraph.

```latex
%%
%%  RESEARCH GAP
%%  (section added per advisor review of 2026-08-19)
\section{Research gap}
\label{sec:research-gap}

The systems of this chapter obtain the same object, the coefficient matrices of an optimization
problem, from three different starting points. The backends of \S\ref{sec:matrix-stuffing}
canonicalize expression trees and cache a parameter-to-data tensor. The methods of
\S\ref{sec:computing-derivatives} treat the problem as an arbitrary program, detect the sparsity
of its derivatives, and recover the matrices by seed sweeps. \texttt{AMPL} and \texttt{JuMP}
store the coefficients as the user declares them, so no extraction step remains to accelerate.

For \texttt{CVXPY}, this literature leaves two gaps. First, the parameter-to-data tensor is the
only cached form of canonicalization. The cache exists only for problems that conform to the
\ac{DPP} ruleset of \S\ref{sec:ms-parameters}, and no backend caches anything for the remaining
problems. Second, canonicalization guarantees structure that the backends do not use. The
sparsity patterns are fixed across a problem family, and the data matrices place dense blocks,
but all three backends compute through the general-purpose sparse libraries of
\S\ref{sec:matrix-stuffing}.

Neither of the other two starting points closes these gaps. \texttt{AMPL} and \texttt{JuMP}
store coefficients the user has already written, and leave the reformulations that
canonicalization automates to the user or the solver. The detection methods probe for a
sparsity pattern that
canonicalization already knows. Chapter~\ref{sec:Theme1} presents an engine built on the
remaining combination. It extracts the coefficients from the expression trees themselves, with
the structure guaranteed by canonicalization computed once by a symbolic pass and reused by a
numeric pass at every parameter change.
```

## 2026-08-21 second version (replaced later the same day by William's summary framing)

Three paragraphs that stood between the heading and tab:systems-summary:

```latex
The systems of this chapter differ in how the coefficients are obtained. \texttt{AMPL} and
\texttt{JuMP} read them from the model as the user declares them. The translator writes them to the \texttt{.nl} file and the \texttt{JuMP}
macros store them as term lists, so extraction is a file read or a copy and involves no
derivative. \texttt{CasADi} and \texttt{CVXPY} derive the coefficients from an expression graph
by differentiation. \texttt{CasADi} treats the graph as an arbitrary program, detects the
sparsity of its Jacobian by propagating seeds, and compresses the seeds by colouring. The
backends of \texttt{CVXPY} know the Jacobian of every conic-form atom in closed form and compose
them in one bottom-up pass.

The systems also differ in what a parameter change costs. \texttt{AMPL} folds the parameter
values into the instance, so a change requires a new \texttt{.nl} file and a new read. \texttt{JuMP} modifies the stored term
lists in place, through the modification interface of \ac{MOI} or through parameter variables
whose value the solver substitutes, and the solver receives the change without a
rebuild~\cite{moidocs, jumpdocs}. \texttt{CasADi} keeps the parameters as symbols, builds the
sparsity pattern, the colouring, and the derivative function once, and repeats one seed sweep
per colour at every evaluation. \texttt{CVXPY} caches the parameter-to-data tensor of
\S\ref{sec:ms-parameters}, and a re-solve costs one sparse matrix-vector product per map, but
only for problems in the \ac{DPP} ruleset. Outside it, the whole pass is repeated at every
change.

For \texttt{CVXPY}, two gaps remain. The structure of the canonicalized problem is fixed across
the family but cached only through the \ac{DPP} tensor, and the three backends store and
compute that structure through general-purpose sparse libraries, which cannot use the dense
blocks it contains. The engine of Chapter~\ref{sec:Theme1} keeps the conic-form trees as input
and closes both gaps. A symbolic pass computes the structure of every problem once, a numeric
pass fills in the values at every parameter change, and the dense blocks are stored in dense
form. Because the engine and the backends of \texttt{CVXPY} share their input and differ only
in this computation, Chapter~\ref{sec:Theme2} compares against these backends only.
Table~\ref{tab:systems-summary} summarizes the comparison.
```
