# CasADi qpsol listing + dense-block worst case (cut from §2.2.3, 2026-08-04)

Cut from `6-Revue_litterature.tex` §2.2.3 (sec:casadi) on 2026-08-04, per William's
directive: the subsection leaned too much on the QP solver interface and our experimental
angle. Rewritten holistically (strengths on CasADi's own terms); the thesis-setting relation
is now 1–2 factual sentences.

Context for possible reuse: Theme 2 no longer benchmarks against CasADi (cross-system
benchmarks cut 2026-07-24). The dense-block clique argument (a dense m×n block forces
min(m,n) colours) is a candidate for Theme 1's motivation if a "why not sweeps here" argument
is ever needed there. The parametric LS side benchmark (benchmarks/parametric_least_squares.py,
diff engine vs CasADi conic QP) is the only remaining experimental contact with CasADi.

Cut content, verbatim:

```latex
This is how
\texttt{CasADi}'s own \texttt{qpsol} interface recovers the problem data of a quadratic
program, by differentiating the model without invoking a solver:
\begin{lstlisting}[language=Python]
import casadi as cs
z, th = cs.MX.sym("z", n), cs.MX.sym("th", p)
f, g = objective(z, th), slacks(z, th)  # lowered conic model
c = cs.substitute(cs.gradient(f, z), z, 0)
P = cs.jacobian(cs.gradient(f, z), z)   # Jacobian of the gradient
A = -cs.jacobian(g, z)
b = cs.substitute(g, z, 0)
data = cs.Function("data", [th], [P, c, A, b])
\end{lstlisting}

% \paragraph{The dense-block worst case.}  (heading removed per advisor style; kept for reference)
A dense $m \times n$ block in the problem data makes every pair of its columns collide in some
row, so the column intersection graph restricted to the block is a clique and no colouring can
use fewer than $\min(m,n)$ colours. The sweep count therefore grows to the full dimension of
the block, even when the assembled matrix is mostly sparse. Lowered conic
problems routinely contain dense blocks, so this worst case determines the cost of coefficient
extraction in the setting of this thesis. Vectorized input does not reduce the number of
sweeps, because the structure known to the modelling layer is only recovered at runtime.
```
