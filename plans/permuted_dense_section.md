# Thesis plan: the `permuted_dense` matrix class

> **Target location:** 7-Theme1.tex, "Fundamental data structures" section (per the Theme1
> restructure, this section covers the expr struct + polymorphic matrix vtable + leaf nodes;
> the chapter intro already announces "we will focus much of our attention on the
> permuted-dense matrix"). The dispatching material (§Dispatching below) overlaps with the
> "Atom implementations" dispatch table; decide the split when drafting. Saved 2026-07-14;
> no Theme1 edits made yet.

Plan for the thesis section explaining `permuted_dense` (PD) — the core matrix
representation of the diff engine. Code references: `src/utils/permuted_dense.c`,
`include/utils/permuted_dense.h`, `include/utils/matrix.h`,
`src/utils/permuted_dense_linalg.c`, `src/utils/matmul_dispatchers.c`.

## Section skeleton

1. **Motivation.** Dense data placed at scattered global indices is the dominant
   structure in derivatives of structured programs: dense problem data
   (`left_matmul`'s A, `quad_form`'s Q) gets embedded into the global variable
   space and pushed through structural atoms.
2. **Definition** + scattered-block figure; the selector factorization
   `A = Srᵀ X Sc`.
3. **Closure.** Structural atoms (index figure) and products (selector algebra
   display); sparsity phase vs. value phase; the alloc/fill protocol.
4. **Why BLAS**, with the kron-as-reshape identity as centerpiece.
5. **Polymorphism and double dispatch**; type-closure table; dispatch tricks.
6. **Bridge** to `stacked_pd` as the closure of PD under block operations.

## Core framing

Present PD as a *factored representation*, not a storage format:

```
A = Srᵀ X Sc,   X ∈ R^{m0×n0} contiguous row-major,
Sr ∈ {0,1}^{m0×m}, Sc ∈ {0,1}^{n0×n}  (selector matrices from row_perm/col_perm)
```

Everything falls out of selector algebra:

- **Transpose**: swap perms, transpose block (`transpose_pd_alloc` is a
  constructor call with arguments swapped).
- **Products**: `BᵀA = S_cBᵀ X_Bᵀ (S_rB S_rAᵀ) X_A S_cA`. The middle factor is a
  0/1 row-set-intersection matrix: sparsity analysis of a matmul reduces to a
  sorted-set intersection of integer arrays. Equal row sets → identity → one
  `dgemm`; partial overlap → gather matching rows, then one `dgemm`
  (fast/slow paths in `BTA_pd_pd_fill_values`).
- **Weighted Gram (Hessian workhorse)**: `AᵀDA = Scᵀ Xᵀ (Sr D Srᵀ) X Sc`, and
  `Sr D Srᵀ = diag(d[row_perm])` — the big diagonal compresses. One `dscal`
  pass + one `dgemm` (`ATDA_pd_fill_values`).

Slogan: **the permutations are metadata; the arithmetic is dense.** FLOP counts
depend only on block sizes, never on global dimensions.

## Lifecycle (where PDs form and flow)

1. **Birth — dense problem data.** `new_permuted_dense_full` (identity perms):
   `left_matmul.c:334`, `quad_form.c:444`.
2. **Embedding — perms become non-trivial.** `quad_form` on a leaf variable
   places the n×n block 2wQ at the variable's slice of the global space:
   `perm[i] = var_id + i` (`quad_form.c:279-285`). *The perm embeds a local
   dense object into the global index space without materializing zeros.*
3. **Propagation — closure.** Chain-rule products and structural atoms
   (`index`, `promote`, `broadcast`, `diag_vec`, `sum` partitions, `transpose`)
   all map PD → PD. Structural atoms are pure index arithmetic on perms plus
   `memcpy` on rows of X — zero FLOPs. `diag_vec` relocates rows to positions
   i(n+1) by rewriting `row_perm` only.

Also narrate the **alloc/fill split**: sparsity (`*_alloc`, perms + workspace
sizing) once at init; per-iteration `*_fill_values` touch only X and are
allocation-free by policy (`kernel_dwork` pre-sizing in every `_alloc`).

## LaTeX figures

### Fig A — definition (scattered block vs. compact block)

m=6, n=7, row_perm=(1,3,4), col_perm=(0,2,5), 0-based to match implementation.

```latex
% preamble: \usepackage{nicematrix,tikz}
\[
A \;=\;
\begin{pNiceMatrix}[margin]
\CodeBefore
  \begin{tikzpicture}
    \foreach \r in {2,4,5}
      \foreach \c in {1,3,6}
        \fill[blue!12] (row-\r-|col-\c) rectangle
          (row-\the\numexpr\r+1\relax-|col-\the\numexpr\c+1\relax);
  \end{tikzpicture}
\Body
\cdot & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\
x_{00} & \cdot & x_{01} & \cdot & \cdot & x_{02} & \cdot \\
\cdot & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\
x_{10} & \cdot & x_{11} & \cdot & \cdot & x_{12} & \cdot \\
x_{20} & \cdot & x_{21} & \cdot & \cdot & x_{22} & \cdot \\
\cdot & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot
\end{pNiceMatrix}
\qquad
X \;=\;
\begin{pNiceMatrix}[margin]
\CodeBefore \rectanglecolor{blue!12}{1-1}{3-3} \Body
x_{00} & x_{01} & x_{02} \\
x_{10} & x_{11} & x_{12} \\
x_{20} & x_{21} & x_{22}
\end{pNiceMatrix}
\]
\[
r = (1,3,4), \quad c = (0,2,5), \qquad
A = S_r^\top X S_c, \quad
(S_r)_{k,\,r_k} = 1,\; (S_c)_{k,\,c_k} = 1.
\]
```

Message: same values, two coordinate systems; (r, c) is the change of
coordinates.

### Fig B — the index case

Same A, indices = (3, 0, 4, 3), C = A[indices, :] is 4×7. Per
`index_pd_alloc`/`fill_values`:

- output row 0 ← global row 3 = block row 1
- output row 1 ← global row 0 → structurally zero (`row_inv[0] = -1`), dropped
- output row 2 ← global row 4 = block row 2
- output row 3 ← global row 3 = block row 1 (duplicated)

So C has row_perm = (0,2,3), the **same** col_perm, X_C rows = (X₁, X₂, X₁).

```latex
\[
C = A[(3,0,4,3),\,:] \;=\;
\begin{pNiceMatrix}[margin,last-col]
\CodeBefore
  \rectanglecolor{blue!12}{1-1}{1-1}\rectanglecolor{blue!12}{1-3}{1-3}\rectanglecolor{blue!12}{1-6}{1-6}
  \rectanglecolor{blue!12}{3-1}{3-1}\rectanglecolor{blue!12}{3-3}{3-3}\rectanglecolor{blue!12}{3-6}{3-6}
  \rectanglecolor{blue!12}{4-1}{4-1}\rectanglecolor{blue!12}{4-3}{4-3}\rectanglecolor{blue!12}{4-6}{4-6}
\Body
x_{10} & \cdot & x_{11} & \cdot & \cdot & x_{12} & \cdot & \leftarrow A_{3,:} \\
\cdot  & \cdot & \cdot  & \cdot & \cdot & \cdot  & \cdot & \leftarrow A_{0,:} = 0 \\
x_{20} & \cdot & x_{21} & \cdot & \cdot & x_{22} & \cdot & \leftarrow A_{4,:} \\
x_{10} & \cdot & x_{11} & \cdot & \cdot & x_{12} & \cdot & \leftarrow A_{3,:}
\end{pNiceMatrix}
,\qquad
X_C = \begin{pmatrix} X_{1,:} \\ X_{2,:} \\ X_{1,:} \end{pmatrix}
\]
```

Shows all three behaviors in one figure: dropped row, duplicated row, column
structure inherited untouched. Caption notes cost: sparsity = one O(k) scan
of `row_inv`; values = three `memcpy`s; zero FLOPs.

### Fig C — selector algebra for products

```latex
\[
B^\top A
= S_{c_B}^\top X_B^\top \underbrace{\left(S_{r_B} S_{r_A}^\top\right)}_{\text{row-set intersection}} X_A S_{c_A}
\quad\Longrightarrow\quad
B^\top A = S_{c_B}^\top \left(\tilde X_B^\top \tilde X_A\right) S_{c_A}
\]
```

Output perms (c_B, c_A) are known before any values exist → all sparsity
allocated at init, allocation-free fills forever after.

## The BLAS argument

- X contiguous row-major ⇒ every value-phase op is level-1/3 BLAS (`dgemm`,
  `dscal`, `dcopy`) at near-peak FLOP rates.
- Same matrix as CSR ⇒ AᵀDA becomes a Gustavson-style sparse-sparse product:
  irregular indexed access, scatter workspace, branchy loops, no
  vectorization. Same FLOPs (the block is genuinely dense), order-of-magnitude
  worse per FLOP. Point: dense-in-disguise data should reach dense kernels;
  PD is what un-disguises it.
- Concrete exhibit: `ATDA_pd_fill_values` = `dcopy` + m0 `dscal`s + one
  `dgemm` of shape (n0, n0, m0).
- **Kron-as-reshape** (`permuted_dense_vtable_block_left_mult_vec`,
  `permuted_dense.c:356-376`): p consecutive length-n blocks in memory *are* a
  row-major p×n matrix X̃, and

  ```latex
  y = (I_p \otimes A)\,x \iff \tilde Y = \tilde X A^\top,
  ```

  so a nominally pm×pn operator is applied with **one** `dgemm`, zero data
  movement, Kronecker product never formed.

## Dispatching

Three concrete types behind `matrix` (`matrix.h`): `sparse_matrix` (CSR),
`permuted_dense`, `stacked_pd` (vertical union of PDs, disjoint row sets —
closure of PD under `kron(I_p, A) @ J`).

- **Unary ops: vtable (single dispatch).** transpose, index, broadcast,
  ATA/ATDA, DA, to_csr, …
- **Binary ops: double dispatch.** BᵀA depends on both operand types;
  `matmul_dispatchers.c` dispatches on type flags of B, then A → 3×3 kernel
  grid. Textbook multiple dispatch in C.
- **Type closure.** PD·PD → PD, PD·CSC → PD, sparse·sparse → sparse.
  Structured types are sticky — dense structure never silently degrades to
  generic sparse.
- **Keep the structured operand on the dispatch key.** `quad_form` computes
  JᵀQJ as (QJ)ᵀJ so the PD product sits in the dispatched slot
  (`quad_form.c:296-300`).
- **Kernel-count reduction via transpose identities.** Missing combos derived
  through (AᵀB)ᵀ-style identities (`BTDA_csc_pd` lineage,
  `permuted_dense_linalg.c:525`).
- **Structural short-circuits.** Non-overlapping perms → product empty at
  alloc time (`has_overlap`); fill is a no-op forever. The representation
  proves "these subexpressions touch disjoint variables" by set arithmetic.
- **Fast/slow paths on perm equality.** Identical perms → `dgemm` on operand
  buffers directly; partial overlap → sorted intersection + gather + `dgemm`,
  all workspace pre-sized at alloc.
- **Zero-copy sparse interop.** `to_csr` builds structure once and aliases its
  value array to X — sparse consumers always see live values (matching
  un-aliasing in `permuted_dense_free`). Same spirit: lazy `transpose_cache`.

---

## Draft prose (section opening)

> ### The permuted dense matrix
>
> The Jacobians and Hessians that arise from differentiating structured
> programs are rarely "sparse" in the classical sense of scattered, isolated
> nonzeros. Far more often they are *dense in disguise*: a dense block of
> values — problem data, or a product of such data — placed at a subset of
> rows and columns of a much larger index space. A quadratic form $x^\top Q x$
> over a 50-dimensional variable inside a 10{,}000-dimensional problem
> contributes a Hessian that is a $50 \times 50$ dense block at a known
> location, and zero everywhere else. Storing such a matrix in a
> general-purpose sparse format is correct but wasteful in a subtler way than
> memory: it forces every subsequent product through sparse kernels, whose
> irregular memory access forfeits the hardware efficiency the dense block
> would otherwise admit.
>
> The engine therefore represents these matrices in factored form. A
> *permuted dense* matrix is a triple $(X, r, c)$ with
> $X \in \mathbb{R}^{m_0 \times n_0}$ a contiguous dense block and
> $r, c$ sorted index vectors, representing
> \[
>   A = S_r^\top X S_c \in \mathbb{R}^{m \times n},
>   \qquad A_{r_i,\, c_j} = X_{ij},
> \]
> where $S_r$ and $S_c$ are the selector matrices whose rows are the rows of
> the identity indexed by $r$ and $c$ (Figure A). All other entries of $A$ are
> structurally zero and never stored.
>
> The representation earns its keep through two properties. First, it is
> *closed* under every operation the engine performs: transposition,
> row indexing, broadcasting, and — via the selector algebra developed below —
> the products $B^\top A$ and $A^\top D A$ of the chain rule all map permuted
> dense matrices to permuted dense matrices. Second, it cleanly separates
> structure from values: the index vectors are metadata, manipulated by
> integer set operations whose cost depends only on $m_0$ and $n_0$, while all
> floating-point work happens on contiguous dense blocks and is delegated to
> level-3 BLAS. The permutations carry the sparsity; the arithmetic never
> sees it.

---

## Follow-ups

- Draft the closure/products subsection (selector algebra + fast/slow path).
- Standalone compilable `.tex` with Figures A–C to verify rendering
  (`nicematrix` + `tikz`).
- Decide where `stacked_pd` gets treated: one bridge paragraph here vs. its
  own section.
