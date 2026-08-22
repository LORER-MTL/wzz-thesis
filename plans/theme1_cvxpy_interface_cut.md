# Cut from §3.4 "CVXPY interface" (2026-08-10 restructure)

Section restructured into "Problem interface" with subsections "Stacking the constraint
Jacobians" (engine side, new figure) and "The CVXPY backend" (class outline listing).
Material below was removed verbatim, with the reason for each cut.

## Intro paragraphs (binding line counts, DNLP two-paths framing)

Reason: line counts of the bindings are irrelevant; the intro should not refer to DNLP.

```latex
The engine is a C library, and \texttt{sparsediffpy} is the Python extension module that
exposes it, written against the C interfaces of \texttt{Python} and \texttt{NumPy}. It
declares one function per atom constructor and the problem-level entry points. Three thousand
lines of binding code cover the engine, and none of them mention \texttt{CVXPY}.

Everything specific to \texttt{CVXPY} is in a converter that turns a canonicalized problem
into an engine graph. Two paths build the graph in the same way and differ in what they
read from it. The nonlinear programming interface \cite{cederberg2025disciplined} builds a
graph from the smooth reformulation of a problem. The canonicalization backend, named
\texttt{diffengine} and selected by passing \texttt{ignore\_dpp=True} to \texttt{CVXPY},
builds a graph from the conic form and extracts the problem data from it, in place of the
matrix stuffing pass of \S\ref{sec:matrix-stuffing}.
```

## Subsection "Converting a problem" (sec:theme1-conversion)

Reason: implementation details of the converter (dispatch-table size, dictionaries,
constant folding, representation choice) add little; only the cone order of the constraint
roots and the leaf offsets survive, compressed into the backend subsection.

```latex
\subsection{Converting a problem}\label{sec:theme1-conversion}

The conversion is a single pass over the tree. The children of a node are converted first,
and the name of the atom selects the engine constructor to call on their handles. The
table behind this selection has about fifty entries, one for each atom of \texttt{CVXPY}
that the engine implements. A subtree that contains neither a variable nor a parameter is
evaluated once and folded into a constant leaf, because canonicalization leaves such subtrees
in place.

Variable and parameter leaves are looked up in two dictionaries, built before the pass
from the inverse data that \texttt{CVXPY} produces when it stacks the variables of the
problem. A variable leaf stores its column offset in the stacked variable vector, the
offsets of Figure~\ref{fig:column-offsets}, and the engine uses this offset as the first
column of the selection Jacobian. A parameter leaf stores its offset in the flattened
parameter vector~$\gvec{\theta}$, where \texttt{update\_params} reads its new values. The
dictionaries are keyed by identity, so every occurrence of a variable converts to the same
node, and the trees of the objective and of the constraints become one graph.

The conversion also chooses the representations of
\S\ref{sec:theme1-matrix-representations}. A multiplication by problem data passes
sparse data as a CSR triple and dense data as a dense block, which the atom later places in a
permuted dense Jacobian. A dense array with mostly zero entries is passed as a CSR triple
instead. A sum of several terms converts to a balanced tree of binary
additions, so the depth of the graph grows with the logarithm of the number of terms.

The objective converts to one root, and each constraint contributes one root per argument,
in the order in which \texttt{CVXPY} groups the cones: zero, nonnegative, second-order,
semidefinite, exponential, and power. That order fixes the row blocks of the constraint
Jacobian assembled in \S\ref{sec:theme1-problem-assembly}, and the cone of each block is
recorded on the \texttt{CVXPY} side rather than in the engine.
The five constraint roots of the running example \eqref{eq:example} yield the row blocks
of~$[\mmat{A}\ \mvec{b}]$ in Figure~\ref{fig:matrix-stuffing}.
```

## Equation eq:extract-at-zero

Reason: the derivatives at the origin are obvious; replaced by one prose sentence.

```latex
The canonicalization backend makes the same calls exactly once, and at the origin. Write
$f_0$ for the objective root and $\mvec{h}$ for the stack of constraint roots. After
canonicalization $\mvec{h}$ is affine and $f_0$ is affine or quadratic, so the evaluation at
the origin gives
\BEQ\label{eq:extract-at-zero}
  d = f_0(\mvec{0}), \qquad
  \mvec{c} = \nabla f_0(\mvec{0}), \qquad
  \mmat{P} = \nabla^2 f_0, \qquad
  \mvec{b} = \mvec{h}(\mvec{0}), \qquad
  \mmat{A} = \nabla \mvec{h}(\mvec{0}),
\EEQ
which is the problem data of \eqref{e:quad-conic-form}.
```

## apply_parameters listing and the unchanged-θ cache

Reason: the snippet shows little, and the thesis should assume parameter values change;
the unchanged-values cache is an API convenience, not a mechanism worth describing.

```latex
On the \texttt{CVXPY} side, new parameter values enter through one method.
\begin{lstlisting}[language=Python]
def apply_parameters(self, id_to_value):
    theta = flatten_and_concatenate(id_to_value)
    if np.array_equal(theta, self.extracted_theta):  # unchanged values:
        return self.P, self.c, self.d, self.A, self.b  # reuse everything
    self.extractor.update_parameters(theta)          # numeric pass only
    self.c, self.d, self.A, self.b, self.P = self.extractor.extract()
    self.extracted_theta = theta
    return self.P, self.c, self.d, self.A, self.b
\end{lstlisting}
Repeated solves at unchanged parameter values return the cached matrices.
```

## refresh_param_values C listing (cut later the same day)

Reason: confusing without having read the code; the paragraph now states the fact in one
English sentence ("An atom whose data contains no parameter is left alone, and keeps the
values written at the first evaluation").

```latex
The update marks the graph, and each atom that carries problem data decides
during its forward pass whether that data must be refreshed. The guard is shown below for
the multiplication by problem data.
\begin{lstlisting}[language=C]
static void refresh_param_values(left_matmul_expr *lnode)
{
    if (lnode->param_source == NULL || !lnode->base.needs_parameter_refresh)
        return;

    lnode->base.needs_parameter_refresh = false;
    lnode->refresh_param_values(lnode);
}
\end{lstlisting}
An atom whose data contains no parameter has no parameter source and returns immediately,
and its data and the Jacobian values built from it keep the values written at the first
evaluation.
```

## Oracle-interface listing (cut later the same day)

Reason: the per-iterate oracle protocol is the NLP solver's view of the `problem` object;
the canonicalization path calls these functions once at the origin, so the block was
tangential to the stacking subsection. §3.4.2's "makes each oracle call once" reworded to
"evaluates the graph once".

```latex
A solver reaches the graph through an oracle interface.
\begin{lstlisting}[language=Python, caption={The oracle interface of the
\texttt{problem} object.}, label=lst:oracle-interface]
rows, cols = oracles.jacobianstructure()  # once, fixed afterwards
f    = oracles.objective(x)     # at each iterate
h    = oracles.constraints(x)
grad = oracles.gradient(x)      # reuses the cached forward values
vals = oracles.jacobian(x)      # aligned with (rows, cols)
\end{lstlisting}
The pattern is determined when the graph is built, and every later call returns a value array
aligned with it. Within an iterate the forward values are computed by the first two calls and
reused by the other two. The Hessian of the Lagrangian is queried the same way.
```

## Closing ignore_dpp contrast and Theme 2 pointer (cut later the same day)

Reason: user did not like ending the chapter on the contrast; the chapter now closes on
the refresh-guard fact.

```latex
On the \texttt{ignore\_dpp} path of \S\ref{sec:ms-parameters}, \texttt{CVXPY}
instead repeats the whole matrix stuffing pass, recomputing every sparsity pattern and
reallocating every buffer, each time a parameter changes. Chapter~\ref{sec:Theme2}
measures what this difference is worth.
```
