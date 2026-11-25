# A Lightweight Canonicalization Engine in C for Disciplined Convex Programming

Master's thesis, William Zhang. Polytechnique Montréal, Department of Electrical Engineering,
2026. Supervised by Antoine Lesage-Landry.

📄 **[Thesis (PDF)](WilliamZZ_thesis_final.pdf)** · 🎤 **[Defence slides (PDF)](presentation/presentation.pdf)**

## Summary

Modelling languages such as CVXPY let users write a convex optimization problem close to its
mathematical form, then compile it into the sparse matrices and vectors a solver accepts. In
CVXPY, most of this compilation time goes into turning symbolic expression trees into the
constraint and objective matrices. The constraint matrix is the Jacobian of the problem's affine
functions, and the objective matrix is a Hessian. Compilation is therefore a sparse
differentiation problem, but none of CVXPY's current backends treats it as one. For parametric
problems, CVXPY caches a linear map from parameters to problem data, which is expensive to build.
For every other problem, the full compilation is repeated at every solve.

The thesis presents **SparseDiffEngine**, a lightweight open-source C library, developed jointly
with Daniel Cederberg, that computes these Jacobians and Hessians directly from the expression
structure. It keeps the dense blocks of the problem data in two matrix classes (permuted dense and
stacked permuted dense) and processes them with BLAS. The work is split into two passes, an idea
borrowed from sparse direct factorization and from the interfaces of nonlinear programming
solvers. A symbolic pass runs once per problem and fixes the sparsity patterns, and a numeric pass
fills in new values at every solve. A re-solve of a parametric problem then skips the symbolic
pass, and does not need the rules of disciplined parametrized programming (DPP).

Built on the engine, a new `DIFFENGINE` canonicalization backend for CVXPY was compared with
CVXPY's three current backends on a public suite of 25 problems. The first compilation is fastest
on 21 of the 25 problems, with a geometric-mean speedup of 2.3× over the best current backend. On
the seven parametric problems that CVXPY can cache, re-solves run within a factor of four of
CVXPY's cached path, without building its cache.

## Code and contributions

### SparseDiffEngine (joint work with Daniel Cederberg)
- [SparseDiffEngine](https://github.com/SparseDifferentiation/SparseDiffEngine): the C library
- [SparseDiffPy](https://github.com/SparseDifferentiation/SparseDiffPy): Python bindings, on PyPI as
  [`sparsediffpy`](https://pypi.org/project/sparsediffpy/)
- All repositories: [github.com/SparseDifferentiation](https://github.com/SparseDifferentiation)

### Benchmarks
- [canonicalization-benchmarks](https://github.com/SparseDifferentiation/canonicalization-benchmarks):
  benchmark scripts and all recorded timings from Chapter 4
- [Jacobian-accumulation](https://github.com/SparseDifferentiation/Jacobian-accumulation): the
  experiment harness

### CVXPY integration ([cvxpy/cvxpy](https://github.com/cvxpy/cvxpy))
Merged:
- [#3108](https://github.com/cvxpy/cvxpy/pull/3108) Disciplined nonlinear programming (DNLP)
- [#3365](https://github.com/cvxpy/cvxpy/pull/3365) Dense and parametric `quad_form` bindings to the NLP diffengine
- [#3366](https://github.com/cvxpy/cvxpy/pull/3366) Route super-sparse constant left-matmul to the sparse binding
- [#3447](https://github.com/cvxpy/cvxpy/pull/3447) Kron diffengine converter
- [#3448](https://github.com/cvxpy/cvxpy/pull/3448) Opt-in `DIFFENGINE` canon backend for parameter-free problems
- [#3523](https://github.com/cvxpy/cvxpy/pull/3523) Share the constant-P `quad_form` binding routing
- [#3525](https://github.com/cvxpy/cvxpy/pull/3525) Cone restructuring as a chain reduction and a permutation
- [#3570](https://github.com/cvxpy/cvxpy/pull/3570) Lower products with a vector of ones to sums
- [#3571](https://github.com/cvxpy/cvxpy/pull/3571) Route the conic quadratic objective's constant P by density

Open:
- [#3524](https://github.com/cvxpy/cvxpy/pull/3524) Reassociate matmul chains that end in a constant factor
- [#3586](https://github.com/cvxpy/cvxpy/pull/3586) Split `ConeProg` out of `ParamConeProg`
- [#3587](https://github.com/cvxpy/cvxpy/pull/3587) Respect `keepdims` in the diff engine's `Sum` converter
- [#3588](https://github.com/cvxpy/cvxpy/pull/3588) Keep parameters symbolic for an explicit `DIFFENGINE` backend
- [#3589](https://github.com/cvxpy/cvxpy/pull/3589) Add a `CallbackParamFold` reduction
- [#3590](https://github.com/cvxpy/cvxpy/pull/3590) Default ignore_dpp/non-DPP solves to `DIFFENGINE`
- [#3591](https://github.com/cvxpy/cvxpy/pull/3591) Default to `DIFFENGINE` for parameter-free problems

[All of my CVXPY pull requests →](https://github.com/cvxpy/cvxpy/pulls?q=is%3Apr+author%3ATransurgeon)

### Related paper
- D. Cederberg, W. Zhang, P. Nobel, S. Boyd, *Disciplined Nonlinear Programming*,
  [arXiv:2606.02896](https://arxiv.org/abs/2606.02896), 2026. SparseDiffEngine was first built
  as the differentiation engine of DNLP.

## Building the thesis

```bash
make         # pdflatex + bibtex until references settle → Document.pdf
make clean   # remove intermediate and output files
```
The entry point is `Document.tex`. The chapters are `5-Introduction.tex` through `8-Conclusion.tex`.
