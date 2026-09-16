# "Dense and sparse matrices" slide — cut from presentation.tex on 2026-09-14

Written and then cut the same day, at the user's request ("I don't like the dense and sparse
matrix slide"). The `% --- B5` derivatives placeholder frame was cut in the same pass, because
the defence will not cover CasADi.

The slide paired the dense/sparse storage contrast (compressed from `5-Introduction.tex:699-746`
and `5-Introduction.tex:889-897`) with Simon Boehm's matrix-multiplication optimization ladder,
to argue that a tuned dense kernel is specialist work somebody else has already done and our job
is to make our data reach it.

Two things worth keeping if the argument is rebuilt in another shape:

- The bar chart is drawn by hand, not with pgfplots. `xbar` + `xmode=log` bases its bars at
  x=1 rather than at `xmin`, so they overshoot the axis and overwrite the y tick labels, and
  `point meta=x` prints the *logarithm* (8.41, 7.39, ...) instead of the millisecond value.
- No `\cite`: the deck sets `\bibliographystyle` but has no `\bibliography`, and the
  `presentation` Makefile target runs pdflatex twice with no bibtex. Attribution is the grey
  line at the bottom of the frame.

Numbers, from <https://siboehm.com/articles/22/Fast-MMM-on-CPU> (1024^3 fp32, one desktop CPU):
naive loops 4481 ms, compiler flags 1621, loop order 89, L1 tiling 70, threads 16, NumPy/MKL 8.

The cut LaTeX, verbatim:

```latex
\end{frame}

% --- B6 -------------------------------------------------------------------------
%  The storage contrast, and the argument for leaning on somebody else's kernel.
%  Sources: 5-Introduction.tex:699-746 (dense storage, the BLAS levels, why level 3 is
%           fast), 5-Introduction.tex:889-897 (sparse products access memory irregularly;
%           sparse formats are a poor fit for dense data).
%  The bar chart is Boehm's optimization ladder for a 1024^3 fp32 product. Log x: the
%  ladder spans 4481 ms to 8 ms, and a linear axis makes the bottom four bars invisible.
%  `bar shift=0pt' on both \addplots so the two-colour split does not offset the bars.
%  No \cite: the deck has \bibliographystyle but no \bibliography, and the `presentation'
%  Makefile target runs pdflatex twice with no bibtex. Attribution is the grey line below.
\begin{frame}{Dense and sparse matrices}
\vspace{-1ex}
\begin{columns}[T,onlytextwidth]
\begin{column}{0.47\textwidth}
{\small\bfseries dense}
\begin{itemize}\scriptsize
  \item one contiguous array; an entry's position comes from its indices, so there are no
        index arrays
  \item BLAS is a specification, and a tuned implementation ships with every machine
        (\texttt{OpenBLAS}, \texttt{MKL}, \texttt{Accelerate})
  \item level 3 does cubic work on quadratic data: every entry loaded is reused many times,
        so cache blocking and SIMD pay off
\end{itemize}
\vspace{1.5ex}
{\small\bfseries sparse (CSR / CSC)}
\begin{itemize}\scriptsize
  \item three arrays: \texttt{idxptr}, \texttt{cols}, \texttt{vals}
  \item every nonzero costs an index load and an indirect access; contiguous reads, SIMD and
        cache tiling do not apply
  \item a dense block stored sparse triples its storage and runs far slower than the
        equivalent BLAS call
\end{itemize}
\end{column}
\begin{column}{0.51\textwidth}
\centering
% Bars drawn by hand rather than with a pgfplots log axis: `xbar' + `xmode=log' bases
% its bars at x=1, not at xmin, so they overshoot the axis, and `point meta=x' prints the
% logarithm instead of the millisecond value. Bar length is 0.52cm per unit of ln(v/4);
% the adjustbox is a guard, so a wider label can never push the figure past the column.
\adjustbox{max width=\linewidth}{%
\begin{tikzpicture}[x=1cm, y=1cm]
  \foreach \i/\len/\val/\lab/\col in {%
      0/3.65/4481/naive loops/polyblue!75,
      1/3.12/1621/compiler flags/polyblue!75,
      2/1.61/89/loop order/polyblue!75,
      3/1.49/70/{+ L1 tiling}/polyblue!75,
      4/0.72/16/{+ threads}/polyblue!75,
      5/0.36/8/{NumPy (MKL)}/pdRowC} {
    \node[font=\scriptsize, anchor=east]            at (0,-0.5*\i) {\lab};
    \fill[\col] (0.1,-0.5*\i-0.14) rectangle (0.1+\len,-0.5*\i+0.14);
    \node[font=\scriptsize, text=black!60, anchor=west]
      at (0.1+\len+0.09,-0.5*\i) {\val\,ms};
  }
  \draw[black!30] (0.1,0.26) -- (0.1,-2.76);
\end{tikzpicture}}

\vspace{-1ex}
{\scriptsize\color{black!55} milliseconds, log scale. the orange bar is what you get for free}
\end{column}
\end{columns}

\vspace{1ex}
\onslide<2->{%
\begin{center}\small\color{polyblue}
$280\times$ of hand tuning to come within $2\times$ of \texttt{MKL} --- and
\texttt{OpenBLAS}'s inner kernel is thousands of lines of hand-written assembly.
\\[0.6ex]
\textbf{We do not write kernels. We arrange the data so that an existing one can be called.}
\end{center}}

\vfill
{\scriptsize\color{black!55}\raggedright
Simon Boehm, \emph{Fast Multidimensional Matrix Multiplication on CPU from Scratch} (2022). \\
\href{https://siboehm.com/articles/22/Fast-MMM-on-CPU}
     {\texttt{siboehm.com/articles/22/Fast-MMM-on-CPU}}
\quad $1024^3$ fp32, one desktop CPU.\par}
\end{frame}
```
