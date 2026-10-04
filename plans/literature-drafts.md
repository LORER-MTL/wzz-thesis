# Literature drafts for the final corrections (J2, Legrain i and AL-m2, AL-m13)

Drafts for review. None of this is in the thesis yet. Each entry gives where it goes, the
LaTeX text, what was verified and how, and anything that needs a decision from William
(marked **Q**). These are new drafts. The reverted text in `legrain-rebuttal.md` was used
only as a checklist of what to cover.

---

## D1. CVXcanon, the ancestor of `cvxcore` (Legrain 3b)

**Where:** `6-Revue_litterature.tex`, the `cvxcore` bullet of the backend list (~line 462).

```latex
\item the C++ backend \texttt{cvxcore} keeps one sparse matrix per parameter slice and
loops over the slices at every operator. It began as \texttt{CVXcanon}~\cite{miller2015cvxcanon},
a C++ library written to replace the Python matrix stuffing of early versions of
\texttt{CVXPY}, and was renamed \texttt{cvxcore} in 2018.
```

**Verified:**
- The rename: CVXPY commit `d139dbabb` (2018-05-13), "renamed cvxcanon to cvxcore". Its
  headers still carry `CVXCANON_H`.
- The CVXcanon README (github.com/cvxgrp/CVXcanon) describes it as a canonicalization library
  with a C++ interface for CVXPY ≥ 0.3.0.
- The report title and authors are as Legrain gives them. **Q:** I could not find the PDF of
  the report itself. Do you have it, or should the entry cite the repository instead?

---

## D2. Matrix-free modelling, the opposite answer (Legrain 3a, "most valuable addition")

**Where:** `6-Revue_litterature.tex`, a new paragraph right after "Our approach in
Chapter~\ref{sec:Theme1} addresses these limitations." (~line 510), at the end of §2.1.

```latex
Diamond and Boyd answer the same question with the opposite
approach~\cite{diamond2016matrixfree}. Instead of forming~$\mmat{A}$, they represent the
problem as a graph of abstract linear operators, each available only through its forward and
adjoint products. Structure such as Kronecker products, convolutions, and dense blocks is
then never expanded into a sparse matrix, and forming the problem data costs nothing.
This representation serves first-order and Krylov-based solvers, which need only products
with~$\mmat{A}$ and~$\mmat{A}^\top$, and it pays off on very large problems built from fast
transforms. The solvers that \texttt{CVXPY} calls by default factorize a matrix built
from~$\mmat{A}$ and~$\mmat{P}$: interior-point solvers such as \texttt{Clarabel}, and
operator-splitting solvers such as \texttt{SCS} and \texttt{OSQP} in their default direct
mode. They need these matrices explicitly. We therefore keep the explicit matrix, and reduce
the cost of forming it. The permuted dense representations of Chapter~\ref{sec:Theme1} sit
between the two approaches: they are materialized, so a solver can factorize them, but they
keep part of the operator structure, a dense block together with the row and column
selectors that place it.
```

**Verified:**
- Crossref, DOI 10.1007/978-3-319-42056-1_7: "Matrix-Free Convex Optimization Modeling",
  Diamond and Boyd, in *Optimization and Its Applications in Control and Data Sciences*,
  Springer Optimization and Its Applications, pp. 221–264, 2016.

**Q:**
- Legrain writes that the approach "never went beyond a research fork". I left that out
  because I can't verify it. If you know it's true, add: "This approach was not adopted in
  the released versions of `CVXPY`."
- The draft says OSQP's default mode is direct (a factorization). That is the default
  (`qdldl`), but please confirm you're happy naming OSQP here.

---

## D3. CVXGEN, the first answer to the parametric problem (Legrain 3c)

**Where:** `6-Revue_litterature.tex`, after the CVXPYgen sentence (~line 486).

```latex
\texttt{CVXPYgen} follows the earlier code generator
\texttt{CVXGEN}~\cite{mattingley2012cvxgen}, which generates a custom C solver for a family
of small quadratic programs, and was the first answer to the cost of repeatedly solving a
parametric problem.
```

**Verified:**
- Crossref, DOI 10.1007/s11081-011-9176-9: *Optimization and Engineering* 13(1):1–27,
  issue of 2012 (online in November 2011).

**Q:** "the first answer" is Legrain's phrasing. A safer version would be "an early answer".

---

## D4. Convex.jl 0.16, another answer within DCP (Legrain 3d)

**Where:** `6-Revue_litterature.tex`, after D2, in the same section. It belongs with how
modelling languages form A, not in the Introduction's list of languages.

```latex
Within the DCP paradigm, \texttt{Convex.jl} has also changed how it forms the problem data.
Since version~0.16, it represents every affine expression as a sparse matrix and an offset
over the variables of the solver, accumulated as the problem is converted to
\ac{MOI}~\cite{convexjl2024release}. Like the backends of \texttt{CVXPY}, it stores the
coefficients in a general-purpose sparse format.
```

**Verified:**
- Release notes, v0.16.0 (21 May 2024): "a substantial rewrite of Convex.jl to integrate
  better with MathOptInterface".
- `src/SparseTape.jl` on master: `SparseAffineOperation` holds a sparse matrix and vector,
  and `SparseTape` holds an operation plus a vector of `MOI.VariableIndex`. This is the
  representation described above.
- The rewrite PR is jump-dev/Convex.jl#504, merged 2023-12-29.

---

## D5. Dense blocks inside sparse matrices: what is borrowed (Legrain 3e)

**Where:** `7-Theme1.tex`, end of the opening paragraph of §3.2 Matrix representations
(~line 129).

```latex
Keeping dense blocks inside a sparse matrix is an old idea. The block compressed sparse row
format stores a matrix as a grid of small dense blocks, as in
\texttt{scipy.sparse}~\cite{2020SciPy-NMeth}, finite-element codes assemble dense element
matrices into a sparse global matrix, and nonlinear least-squares libraries such as
\texttt{Ceres}~\cite{agarwal2023ceres} and \texttt{g2o}~\cite{kummerle2011g2o} store the
block-sparse Jacobians of bundle adjustment as dense blocks processed with dense kernels.
Our representations differ in where the blocks sit. A permuted dense matrix places one block
at arbitrary rows and columns, and a stacked matrix places several at disjoint rows, which
is how dense data appears in the Jacobians of a DCP problem.
```

**Verified:**
- Crossref, DOI 10.1109/ICRA.2011.5979949: Kümmerle, Grisetti, Strasdat, Konolige, Burgard,
  "g2o: A general framework for graph optimization", ICRA 2011, pp. 3607–3613.
- `scipy.sparse.bsr_array` is in the SciPy release that `2020SciPy-NMeth` cites.
- **Not verified:** ceres-solver.org refused the connection. I'll take the citation format
  from the project's own citation page once it is reachable. The usual form is
  `Agarwal, Mierle and The Ceres Solver Team, Ceres Solver, version 2.2, 2023`.

**Q:**
- Finite-element assembly has no citation. Do you want one (e.g., a standard FEM textbook),
  or can it stay as general knowledge?
- Is "is how dense data appears in the Jacobians of a DCP problem" a claim you're comfortable
  making without a reference? It follows from §3.2.2–3.2.3.

---

## D6. Pyomo's persistent interfaces qualify the AMPL row (Legrain 3f, AL-m2)

**Where:** `6-Revue_litterature.tex`, after "so a parameter change requires a new file."
(~line 971). Also a footnote on the AMPL row of Table 2.2.

```latex
\texttt{Pyomo}, which also writes \texttt{.nl} files, avoids this for solvers with an
in-memory interface: its persistent solver interfaces keep the model inside the solver and
update the changed parameters and constraints in place~\cite{pyomopersistent}.
```

Table 2.2 footnote, on "nothing, values folded into the instance":

```latex
\footnote{\texttt{Pyomo}'s persistent interfaces update an in-memory solver model in place
instead (\S\ref{sec:ampl}).}
```

**Verified:**
- The Pyomo documentation (stable, "Solvers" page): `PersistentSolverBase` exposes
  `update_parameters()`, `update_variables()`, `add_constraints()` and
  `remove_constraints()`, which change the solver's model incrementally.
- For Ipopt, the new interface still goes through the NL writer, hence "for solvers with an
  in-memory interface".

---

## D7. Elementary complexity of the representations (Legrain Part 1 §6, AL-m13)

**Where:** `7-Theme1.tex`, after the paragraph that ends "…depends on the sizes of the
blocks and not on the global dimensions." (end of §3.3.1, ~line 540). This makes that claim
quantitative.

```latex
An elementary count makes this precise. A permuted dense matrix with an
$m' \times n'$ block stores $m'n'$ values and $m' + n'$ indices, whereas the same block in
CSR form stores $m'n'$ values, $m'n'$ column indices, and $m + 1$ row pointers, where $m$ is
the number of rows of the whole matrix. For the product~\eqref{eq:pd-product}, let
$s = |\mvec{r}_A \cap \mvec{r}_B|$ be the number of shared rows. The symbolic pass merges two
sorted index vectors in $O(m_A + m_B)$ operations, and the numeric pass performs
$n_B\, s\, n_A$ multiply-adds in one \texttt{dgemm}. On the same blocks stored as generic
sparse matrices, Gustavson's algorithm performs the same multiply-adds, but its symbolic
pass builds the pattern of the result entry by entry, with $O(n_B\, s\, n_A)$ operations and
one stored index per entry. The dense representations therefore reduce the symbolic work
and the index storage from the number of entries of a block to the number of its rows and
columns. In the numeric pass they keep the operation count, and replace an index-driven
loop by a \ac{BLAS} call, a gain in the constant factor rather than in the asymptotic cost.
For a stacked operand, these counts are summed over the pairs of blocks with intersecting
rows.
```

**Verified:**
- The memory count matches Legrain's.
- The product counts follow (3.2) as written. Gustavson's symbolic phase is
  O(flops) [gustavson1978two].

**Q:** Legrain asked only for "a few lines". Cut the last two sentences if it's too long.

---

## New bib entries (all checked against Crossref or the source, except where noted)

```bibtex
@incollection{diamond2016matrixfree,
  author    = {Diamond, Steven and Boyd, Stephen},
  title     = {Matrix-free convex optimization modeling},
  booktitle = {Optimization and Its Applications in Control and Data Sciences},
  series    = {Springer Optimization and Its Applications},
  volume    = {115},
  editor    = {Goldengorin, Boris},
  publisher = {Springer},
  pages     = {221--264},
  year      = {2016},
  doi       = {10.1007/978-3-319-42056-1_7}
}

@misc{miller2015cvxcanon,
  author       = {Miller, John and Quigley, Paul and Zhu, Jack},
  title        = {{CVXcanon}: Automatic canonicalization of disciplined convex programs},
  howpublished = {Stanford University, \url{https://github.com/cvxgrp/CVXcanon}},
  year         = {2015}
}

@article{mattingley2012cvxgen,
  author  = {Mattingley, Jacob and Boyd, Stephen},
  title   = {{CVXGEN}: a code generator for embedded convex optimization},
  journal = {Optimization and Engineering},
  volume  = {13},
  number  = {1},
  pages   = {1--27},
  year    = {2012},
  doi     = {10.1007/s11081-011-9176-9}
}

@misc{convexjl2024release,
  author       = {{The Convex.jl developers}},
  title        = {{Convex.jl} release notes, v0.16.0},
  howpublished = {\url{https://jump.dev/Convex.jl/stable/release_notes/}},
  year         = {2024}
}

@inproceedings{kummerle2011g2o,
  author    = {K{\"u}mmerle, Rainer and Grisetti, Giorgio and Strasdat, Hauke and
               Konolige, Kurt and Burgard, Wolfram},
  title     = {g2o: A general framework for graph optimization},
  booktitle = {IEEE International Conference on Robotics and Automation},
  pages     = {3607--3613},
  year      = {2011},
  doi       = {10.1109/ICRA.2011.5979949}
}

@misc{agarwal2023ceres,
  author       = {Agarwal, Sameer and Mierle, Keir and {The Ceres Solver Team}},
  title        = {{Ceres Solver}},
  howpublished = {\url{https://github.com/ceres-solver/ceres-solver}},
  note         = {Version 2.2},
  year         = {2023}
}

@misc{pyomopersistent,
  author       = {{Pyomo developers}},
  title        = {{Pyomo} documentation: persistent solver interfaces},
  howpublished = {\url{https://pyomo.readthedocs.io/en/stable/explanation/experimental/solvers.html}},
  year         = {2026}
}
```

- The `volume`/`editor` of `diamond2016matrixfree` (vol. 115, ed. Goldengorin) come from the
  book's front matter as I remember it. Crossref's record omits them. **Q:** I'll check them
  against the Springer page if you'd rather keep them than drop them.
- `ceres` is not yet verified (see D5).
- The CHOLMOD and George & Liu entries of the earlier draft are not needed. The lineage of
  the split is already cited through `davis2006direct` and `gustavson1978two` on the
  `final-contribution-naming` branch.

## Not drafted

- **DNLP delineation (AL-m3)** still waits on your answer about the split (see the chat).
- **Spot comparison with Convex.jl:** Legrain lists it as welcome but not required. Skipped.
