# Tight abstract (pre-Document-8 version) — kept for paper reuse

Advisor (2026-08-19): "keep this somewhere — perfect for the paper; for the thesis add more
context + details." The thesis abstract was expanded; this is the tight version as of that
date.

```latex
We present a new canonicalization backend for \texttt{CVXPY}, a modelling language for convex
optimization. \texttt{CVXPY} compiles a problem written in a form close to the mathematics into
the numerical data a solver accepts. Most of the cost of this compilation lies in converting
symbolic expression trees into the sparse constraint and objective matrices. Since the
constraint matrix is a Jacobian and the objective matrix is a Hessian, the conversion can be
viewed as a sparse differentiation problem. Our backend is built on \texttt{SparseDiffEngine}, a
lightweight open-source C library that computes both matrices directly from the expression
structure. A symbolic pass runs once per problem family and determines the sparsity
patterns of the matrices. A numeric pass fills in new values at every
solve. Re-solving a parametrized problem therefore costs only one numeric pass. This split is an
alternative to \texttt{CVXPY}'s existing caching of parametrized problems, and it places no
restriction on how the parameters enter the problem. We compare the backend with
\texttt{CVXPY}'s three existing backends and show significant speedups on the first
compilation and similar performance on re-solves of parametrized problems.
```

(For the paper, note the abstract authorship fix the advisor wanted anyway: say "we built
SparseDiffEngine", not "built on".)
