# Rebuttal notes for Antoine

Replies to advisor comments, to be sent by message. One entry per comment.

## "only DCP?" — is canonicalization specific to DCP-based languages? (5-Introduction.tex, §1)

**Comment location:** intro sentence "In DCP-based languages, this translation process is
called canonicalization."

**Short answer:** yes, within optimization modelling languages the *name* is specific to the
DCP family, so the sentence is precise as written.

**Evidence:**

- The DCP line of work defines the term: the CVXPY rewriting paper (Agrawal, Verschueren,
  Diamond & Boyd, *A rewriting system for convex optimization problems*, 2018) describes two
  phases, *analysis* (find a suitable solver) and *canonicalization* (rewrite the problem into
  that solver's standard form). CVX, CVXR, and Convex.jl inherit the same usage.
- Non-DCP modelling languages each use a different word for the same modeller-to-solver step:
  - **AMPL**: "translation" — the translator writes the model to a `.nl` file (Gay).
  - **Pyomo**: "transformations" and problem "writers".
  - **JuMP / MathOptInterface**: "bridges" for reformulation and `copy_to` for extraction;
    the MOI paper never calls this canonicalization.
  - **YALMIP**: "compiling"/"exporting" the model; docs speak of converting the problem to
    the solver's format.
  - **GAMS**: "model generation".
- The *word* itself is older and generic: compiler infrastructure uses it for rewriting an IR
  into a canonical form to simplify later passes (LLVM `instcombine`, MLIR's canonicalization
  pass), and computer algebra speaks of canonical forms of expressions. The DCP languages
  borrowed this compiler sense: rewriting an expression tree into a canonical (conic) form.
  So the concept is general, but as the established name for the modelling-language-to-solver
  translation, it belongs to the DCP ecosystem.

**Proposed resolution:** keep the sentence as written. It already scopes the term correctly
("In DCP-based languages, this translation process is called canonicalization"), which is
exactly the qualification the comment asks about.

References: [Agrawal et al. 2018 (arXiv:1709.04494)](https://arxiv.org/abs/1709.04494),
[MLIR canonicalization docs](https://mlir.llvm.org/docs/Canonicalization/).

## "can we be broader?" — goal statement beyond CVXPY compilation time (5-Introduction.tex, §1)

**Comment location:** intro sentence "The main goal of this Master's thesis is to reduce the
compilation time of \texttt{CVXPY}."

**Short answer:** the narrow statement is deliberate; I would prefer to keep it.

**Reasoning:**

- The contribution is a concrete one: a coefficient extraction engine for CVXPY, benchmarked
  against CVXPY's existing backends. Stating a broader goal (accelerating convex modelling
  languages in general) would promise more than the thesis demonstrates.
- I would rather state early and plainly that the focus is improving CVXPY, making it faster
  and better, than dress the goal up. A narrow, verifiable goal is easier to defend than a
  broad one.
- The broader context is not lost: the background chapter situates the work among sparse AD,
  matrix stuffing, and the other modelling languages (AMPL, JuMP), and the techniques
  (symbolic/numeric phase split, structure reuse across a problem family) transfer to other
  DCP-based languages. That transferability belongs in the conclusion / future work, not in
  the goal statement.

**Proposed resolution:** keep the sentence as written.

## "is that a common wording?" — "standard convex cones" (5-Introduction.tex, §Conic reformulation)

**Comment location:** "each $\cone{K}_i$ is one of the standard convex cones: the zero,
nonnegative, second-order, power, exponential, and positive semidefinite cones."

**Short answer:** the wording is established in the solver/modelling-software literature, but
the *list* it names differs between the mathematical literature and the solver convention; our
sentence follows the solver convention, which is the right one for this thesis.

**Evidence:**

- Solver convention (what we follow): *Projections onto Spectral Matrix Cones* (Boyd group,
  arXiv:2511.01089) writes "After canonicalization, the problem is expressed using the
  so-called *standard cones*, which are the nonnegative cone, the second-order cone, the
  positive semidefinite cone, and the three-dimensional exponential and power cones."
  SCS, Clarabel, and CVXPY enumerate the same list (plus the zero cone for equalities) as the
  cones a general-purpose conic solver accepts.
- Mathematical convention: Ben-Tal & Nemirovski's *Lectures on Modern Convex Optimization*
  (the reference we cite in that paragraph's vicinity) organizes conic programming around
  three generic cones only: nonnegative orthant (LP), Lorentz/second-order (CQP), and positive
  semidefinite (SDP) — the symmetric cones of interior-point theory. Exponential and power
  cones entered as *nonsymmetric* cones later, largely driven by solver support (ECOS, SCS,
  MOSEK 9); the zero cone is a solver-API device for equality constraints, usually left
  implicit in the math literature.

**Resolution (applied):** reworded to "one of the standard cones supported by general-purpose
conic solvers", which attributes the list to the solver convention and matches the
literature's "standard cones" exactly.

## "où avez-vous soumis?" — venue of the CVXPY 1.9 survey paper (5-Introduction.tex, §CVXPY)

**Comment location:** "a recent paper surveys the new canonicalization and modelling features
introduced between versions 1.1 and 1.9 \cite{zhang2026cvxpy}."

**Answer:** the paper was submitted to ACM Transactions on Mathematical Software (TOMS) and is
under review. The bibliography entry cites the arXiv preprint (arXiv:2606.14891) and will be updated
to the journal version once published. We prefer not to name the venue in the thesis text
itself, since the status may change before the defence.

## "(t_2, x) other way?" — ordering of the second-order cone tuples (5-Introduction.tex, §Example)

**Comment location:** the canonicalized example, "$(t_1, \mmat{F}\mvec{x}-\mvec{g}) \in
\cone{K}_{\mathrm{soc},m+1}$" and "$(t_2, \mvec{x}) \in \cone{K}_{\mathrm{soc},n+1}$".

**Short answer:** the ordering is correct as written; the scalar comes first in the solver
convention, which the thesis defines and follows consistently.

**Evidence:**

- The thesis defines the cone with the scalar first when it introduces it
  (§Conic reformulation): $\cone{K}_{\mathrm{soc}} = \{(t, \mvec{x}) \in \reals \times
  \reals^n : \|\mvec{x}\|_2 \le t\}$, so the example matches the definition.
- Every solver-side convention we target puts $t$ first:
  - SCS: second-order cone $\{(t, s) \in \reals \times \reals^k : \|s\|_2 \le t\}$;
  - Clarabel: SecondOrderCone $\{(t, x) \in \reals^n : \|x\|_2 \le t\}$;
  - MathOptInterface: SecondOrderCone $\{(t, x) \in \reals^{\text{dim}} : t \ge \|x\|_2\}$;
  - MOSEK's quadratic cone ($x_1 \ge \|x_{2:n}\|_2$) and CVXPY's \texttt{SOC(t, X)}
    constraint follow the same ordering.
- The reverse order $(\mvec{x}, t)$ appears in the mathematical literature (Boyd &
  Vandenberghe define the norm cone as $\{(\mvec{x}, t) : \|\mvec{x}\| \le t\}$), which is
  likely the source of the annotation. Since the thesis canonicalizes toward solver input,
  we follow the solver convention.

**Proposed resolution:** keep the tuples as written.
