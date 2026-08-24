# Why SDPSegfault1132 is fastest on SCIPY (high-level, 2026-08-22)

Table 4.1: CPP 64.8 s, SCIPY 9.5 s, COO 43.0 s, diffengine 13.2 s (ratio 1.39). Profiles run
2026-08-22 with cProfile on get_problem_data (CLARABEL, ignore_dpp): SCIPY 8.9 s and CPP 61 s
in canonicalization/.venv-upstream (cvxpy 1.9.2); diffengine 25 s in .venv (dev fork, which
is slower than the pinned build on this problem; the pinned build gave 13.2 s).

## The problem
G is a 99x99 PSD variable (4 950 free entries after symmetry). V is a DENSE 100x99 constant
(x*ones + [0; I], first row y), so vec(V G V^T) = (V kron V) vec(G) is a fully dense
10 000 x 4 950 map: 49.5 M coefficients. The expression
A + B - 2 V G V^T - D  (A = kron(e, diag(VGV^T)^T), B = its transpose)
uses V G V^T three times. Measured (SCIPY backend, equality-constraint probe):
- V G V^T alone            -> A has 49 504 950 nnz
- kron(e, diag(VGV^T)^T)   -> 49 504 950 nnz
- A + B - 2 VGV^T - D      ->  1 014 156 nnz
So the dense intermediates CANCEL almost entirely in the sum (it is the Gram-to-distance
identity D_ij = G_ii + G_jj - 2 G_ij: the x*ones parts of V drop out). Every backend pays
for three dense 49.5 M-coefficient intermediates; none can see the cancellation in advance.

## Where the time goes
- SCIPY 8.9 s: 8.6 s in build_matrix -> process_constraint; 3.4 s scipy csr matmul (the
  V kron V products), 3.0 s in _rmul_kronecker (scipy kron), the rest csr additions. All of
  it is scipy's C routines, one pass over the small tree (17 accumulate calls), and csr
  addition prunes exact zeros, so the 1 M-nnz result is cheap to format for the solver.
- CPP 61 s: 43.4 s INSIDE _cvxcore.build_matrix (the C++ tensor build: its own sparse
  tensor code handles the dense V kron V products coefficient by coefficient and is ~5x
  slower than scipy's csr kernels here), then 5 s csr_sort_indices + sum_duplicates on the
  returned COO and 7 s conic_solver.format_constraints.
- COO 43 s: not profiled; python/numpy coordinate ops with concatenation and duplicate
  summation on the same 3 x 49.5 M entries.
- diffengine (dev build 25 s; pinned 13.2 s): symbolic pass init_jacobian_coo 5.6 s,
  numeric pass eval_jacobian_vals 7.2 s (three dense 49.5 M-entry Jacobian blocks built,
  filled and summed; peak memory 7.1 GB on the pinned build), then ~4 s coo_tocsr, 2.8 s
  encode_cone_tensors, 5.5 s format_constraints. The dense block representation is the wrong
  tool when the dense maps cancel only at the final sum.

## Takeaway for the thesis text
§4.1 already says: "canonicalization is dominated by moving large blocks of constant data
into the problem matrices, and the numeric pass copies these blocks in full." Accurate. The
sharper statement, if wanted: the Jacobian of V G V^T is dense (49.5 M entries) and appears
three times, the three copies cancel to 1 M nonzeros only in the final sum, and SCIPY wins
because its csr kernels do the 150 M coefficient operations in C once and prune the zeros
in the addition. Possible engine improvement (future work): detect affine combinations of
the same dense block and combine coefficients before materialising.

## Deeper dig (same day, William: "is it the pruning of zeros?")
Instrumented the fork's DiffEngineExtractor (dev build, .venv) and SCIPY (upstream) on the
three sub-expressions, equality-constraint probe, CLARABEL, ignore_dpp:

| expression | engine symbolic / numeric / to_csc / rest | engine pattern -> numerically nonzero | SCIPY build_matrix / format | final nnz |
|---|---|---|---|---|
| V G V^T | 2.8 / 1.3 / 1.8 / 28.8 s | 49.5 M -> 49.5 M | 15.7 / 8.2 s (44.7 total) | 49.5 M |
| kron(e, diag(VGV)^T) | 2.5 / 2.2 / 2.2 / 29.2 s | 49.5 M -> 49.5 M | - | 49.5 M |
| A + B - 2VGV - D | 7.8 / 7.4 / 3.1 / 11.7 s | 49.5 M -> 1.01 M (zero residues: none, |v|<1e-12 count 0) | 9.5 / 0.1 s (10.0 total) | 1.01 M |

Findings: (1) the engine's sum keeps the 49.5 M-entry union pattern and 48.5 M values are
EXACT zeros after cancellation; they are dropped only in CVXPY's cone formatting (scipy csr
matmul emits nonzero sums only) -> ~15 s tail for the engine vs 0.1 s for SCIPY, whose
csr_binop addition prunes at the "+". (2) The engine's own passes on the sum (7.8 + 7.4 s)
are slower than SCIPY's build (9.5 s) because merging/adding three dense 49.5 M operands
into one generic sparse pattern is the expensive part; per single dense block the engine is
faster (4.1 s vs 15.7 s). (3) Neither can see the cancellation in advance. Engine-side fixes:
drop exact zeros when emitting a one-shot result (cheap, removes the tail), or combine affine
combinations of the same sub-expression symbolically (CSE + linear combination, bigger).

Geomeans from Table 4.1 cells (diffengine over backend): CPP 0.249 (4.0x, faster on 24/25),
SCIPY 0.335 (3.0x, 21/25), COO 0.280 (3.6x, 23/25), best-of-three 0.353.
