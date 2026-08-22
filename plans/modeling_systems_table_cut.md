# Cut: `tab:modeling-systems` (chapter 2 closing table)

> 2026-08-21: reinstated in rebuilt form as `tab:systems-summary` in the new §2.4 Research gap
> (columns: coefficients obtained by / reused across the family / repeated at every solve;
> rows AMPL, JuMP, CasADi, CVXPY backends, diffengine unbolded). The version below is the
> original cut table, kept for the record.

Removed 2026-08-07 from the end of `6-Revue_litterature.tex`, along with its one-sentence
introduction. Cut for now, not rejected outright.

**Why it was cut.** It was never set up as a summary of the chapter, so it arrived as a table
the reader had no reason to expect. The bolded **This thesis** row reads as a claim rather than
a description, which is out of register for a literature review. The chapter intro (lines
11–18) already states the same three-way classification in prose, so nothing was lost by
removing it.

**What would have to change to bring it back.** It needs a setup sentence framing it as a
summary of all the methods reviewed in the chapter, not just a caption. The **This thesis** row
needs rethinking, either dropped so the table describes only reviewed systems, or moved to
Chapter 3 where the engine is actually presented. It also lacks a short caption for the List of
Tables, unlike `tab:views-copies`, which is why `\ref{sec:Theme1}` leaked into `Document.lot`.

**Introducing sentence that was removed:**

```latex
Table~\ref{tab:modeling-systems} closes the chapter by classifying the reviewed systems by the
origin of their coefficients.
```

**Table, verbatim:**

```latex
\begin{table}[htbp]
\centering
\footnotesize
\setlength{\tabcolsep}{5pt}
\caption{The reviewed systems and the engine of Chapter~\ref{sec:Theme1}, grouped by the origin of
their problem-data coefficients: stored as the user typed them, detected at runtime, or
differentiated out of an expression graph.}
\label{tab:modeling-systems}
\begin{tabular}{@{}l l p{4.6cm} p{4.6cm}@{}}
\toprule
\textbf{System} & \textbf{Coefficients} & \textbf{Sparsity known from} & \textbf{Extraction cost} \\
\midrule
\texttt{JuMP}
  & stored
  & the stored term lists
  & one copy of the term lists (\texttt{copy\_to}) \\
\texttt{AMPL}
  & stored\textsuperscript{a}
  & partial separability of the expression graphs
  & \texttt{.nl} write and ASL read \\
\addlinespace
\texttt{CasADi} \cite{andersson2019}
  & detected
  & pattern propagation, then colouring
  & compressed sweeps \\
\addlinespace
\texttt{CVXPY} \cite{diamond2016cvxpy}
  & differentiated
  & carried by the sparse coefficient matrices
  & bottom-up pass over the conic-form trees \\
\textbf{This thesis}
  & \textbf{differentiated}
  & \textbf{closed form, per atom}
  & \textbf{bottom-up pass over the conic-form trees} \\
\bottomrule
\end{tabular}

\vspace{0.5ex}
\raggedright\footnotesize
\textsuperscript{a}\,Linear parts only; the nonlinear parts are matched to cones or
differentiated in the solver process.
\end{table}
```

Note: the AMPL row's footnote is now stale. After the 2026-08-07 AMPL pass, the nonlinear parts
are described as handled by MP (cone matching) or ASL (reverse-mode AD), not "in the solver
process". The **Extraction cost** cell would also need updating, since "ASL read" is now only
one of the two driver libraries.
