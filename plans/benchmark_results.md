# Thesis Chapter 4 — benchmark results (working document)

Single source of truth for the results chapter (`7-Theme2.tex`). Assembled 2026-07-11.
A later writing session should be able to work from this file alone.

## ⚠️ Machine discrepancy (decide before finalizing §4.1)

§4.1 currently claims: MacBook Pro (13-inch, M2, 2022), 8-core Apple M2, 24 GB RAM,
macOS 26.3. The machine the 2026-07-11 re-run actually ran on is:
**MacBook Pro 15-inch 2018 (MacBookPro15,1), Intel Core i7-8850H @ 2.60 GHz (6c/12t),
16 GB RAM, macOS 15.7.7**. The old ms-scale numbers in the .tex match neither this
re-run nor the PR #3348 tables and their provenance is unknown — presumably the M2
laptop. **Either re-run the suite on the M2 and keep §4.1, or adopt the 2026-07-11
numbers below and rewrite §4.1's hardware paragraph.** All numbers in this document
are from the Intel machine unless labeled otherwise.

## Configuration of the 2026-07-11 re-run

- MacBook Pro (15-inch, 2018), 6-core Intel Core i7-8850H @ 2.60 GHz, 16 GB RAM,
  macOS 15.7.7.
- Python 3.14.4, CVXPY `1.10.0.dev93+g4402def70` (branch `pr-c-resolve-caching` of the
  diff-engine fork, commit `fa4cd3886`), NumPy 2.4.4, SciPy 1.17.1 (§4.1 says SciPy 1.16 —
  update), `sparsediffpy` 0.7.0
  (dev build = upstream `7e7678e` + PR #104 cherry-picks; the #104 canary test
  `test_symbolic_quad_matrix_refreshes_through_cache` passes).
- CasADi 3.7.2 (PyPI wheel, cp314).
- All timing runs single-threaded: `OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1
  MKL_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1`.
- Timing target: `prob.get_problem_data(solver=cp.CLARABEL)` (CPP baseline, default DPP
  path) vs `prob.get_problem_data(solver=cp.CLARABEL, ignore_dpp=True)` (C engine).
  On this branch the ignore_dpp path caches the engine program, so warm re-solves
  re-evaluate the expression tree at new parameter values instead of rebuilding.

### Commands (reproduce)

```bash
# Tables 4.1 + 4.2 (cvxpy repo, branch pr-c-resolve-caching):
OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1 \
BENCH_BACKENDS=CPP,DIFFENGINE,DE_DPP BENCH_OUT=results_thesis_rerun_20260711.txt \
.venv/bin/python benchmarks/run_upstream_benchmarks.py

# Table 4.3 (same repo):
.venv/bin/python benchmarks/casadi_compare.py --verify        # small-size matrix equality
.venv/bin/python benchmarks/casadi_compare.py --verify-full   # benchmark-size matrix equality
.venv/bin/python benchmarks/casadi_compare.py --time          # timing table
```

**PUBLISHED (2026-07-12): the full harness + probes + reference results now live in
https://github.com/SparseDifferentiation/Jacobian-accumulation under `canonicalization/`**
(cited via a footnote in §4.1). That repo is the citable/reproducible home; this file
remains the thesis-side working notes.

Raw outputs archived in `plans/raw/` next to this file (canonical copies; originals in
the cvxpy repo's untracked `benchmarks/`): `results_thesis_final_20260711_pr102.txt`
(the definitive Tables 4.1/4.2 run), the two earlier partial runs + SDP fixups, and
`results_casadi_compare_final.json` / `results_casadi_compare_ext.json` (Table 4.3).

**STATUS 2026-07-12 (later): §4.4 restructured to mirror the cvxcore comparison** — one
section, two tables (`tab:casadi-single`, all 25 rows single-only; `tab:casadi-param`,
8 parametric rows with first extraction + re-solve, ratio on re-solve), condensed
methodology paragraph, 1–2 takeaway sentences per table. The regime analysis, the
star-coloring/`casadi.hessian` DNF story, and the "in defence of CasADi" paragraph were
CUT from the .tex on purpose (user will decide later what to reinstate); their content
survives below under "Reading of the full table", "Why CasADi singles are slow", and
"In defence of CasADi". Remaining for a writing session: the §2.4 coefficient-extraction
section (notes below), and any prose iteration on chapter 4.

## Table 4.1 / 4.2 — re-run of 2026-07-11 (sanity check)

> Main suite completed 2026-07-11 (raw: `results_thesis_rerun_20260711.txt`). Four rows
> pending a follow-up run with a 1200 s timeout (`results_thesis_rerun_20260711_fixups.txt`):
> ConvexPlasticity CPP (harness fix: explicit `canon_backend="CPP"` now raises the intended
> PR-B ValueError for non-DPP parametric problems, so the CPP baseline is timed on the
> default path), SemidefiniteProgramming (engine ran past 240 s), and
> SimpleFullyParametrizedLP + ParametrizedQP (the CPP DPP-tensor first compile ran past
> 240 s — 1 M and 14.4 M parameters respectively).

### Sanity-check verdict

The re-run reproduces the *shape* of the published PR #3348 tables (seconds-scale, same
winners/losers) but NOT the ms-scale numbers currently in `7-Theme2.tex` — those match
neither this machine nor the PR run and should be replaced (or re-generated on the M2 if
that's the machine §4.1 will describe).

### Cold first compile, 2026-07-11 re-run (seconds; ratio = engine/CPP)

| Benchmark | CPP (s) | engine (s) | ratio |
|---|---:|---:|---:|
| ParamSmallMatrixStuffing | 7.84 | 0.203 | 0.026 |
| ParamConeMatrixStuffing | 3.23 | 0.136 | 0.042 |
| Cajas | 19.97 | 1.081 | 0.054 |
| HuberRegression | 10.71 | 1.617 | 0.151 |
| SVMWithL1Regularization | 11.72 | 1.805 | 0.154 |
| Yitzhaki | 2.97 | 0.472 | 0.159 |
| SimpleQP | 10.59 | 1.734 | 0.164 |
| LeastSquares | 26.17 | 4.414 | 0.169 |
| SimpleLP | 90.56 | 16.29 | 0.180 |
| SimpleScalarParametrizedLP | 14.60 | 2.727 | 0.187 |
| TvInpainting | 3.52 | 1.044 | 0.296 |
| SlowPruning | 6.81 | 2.190 | 0.322 |
| ConeMatrixStuffing | 10.49 | 3.676 | 0.350 |
| SmallMatrixStuffing | 6.51 | 2.801 | 0.430 |
| CVaR | 36.56 | 24.05 | 0.658 |
| FactorCovarianceModel | 5.17 | 3.435 | 0.665 |
| OptimalAdvertising | 6.12 | 5.128 | 0.838 |
| Murray | 5.67 | 5.380 | 0.949 |
| SimpleFullyParametrizedLP | 2.09 | 0.473 | 0.226 |
| ParametrizedQP | 10.21 | 2.348 | 0.230 |
| ConvexPlasticity | 2.13 | 2.172 | 1.02 |
| SemidefiniteProgramming | 5.35 | 430.6 | **80.5 ⚠ REGRESSION** |
| **Geometric mean (all 22 rows)** | | | **0.30** |

⚠ SemidefiniteProgramming at 430.6 s was measured on a build WITHOUT SparseDiffEngine
**PR #102** (output-driven sparsity fills in block left-multiply and csr@csc matmul).
**RESOLVED 2026-07-11:** rebuilding sparsediffpy with #102 cherry-picked
(`dev-integration-0.7-plus-102` = 0.7.0-dev + #104 + #102) brings the engine cold compile
to **1.99 s (0.37×)** — matching the PR-era 1.98 s exactly. The PSD path was tripping the
non-output-driven fills. The #104 canary still passes on the combined build.
Consequence for the thesis pin: the engine release used by the final numbers must include
BOTH #102 and #104. SDP-heavy rows re-measured on the #102 build
(`results_thesis_rerun_20260711_sdp_pr102.txt`) — all match the PR-era ratios:

| Benchmark | CPP (s) | engine (s) | ratio | without #102 |
|---|---:|---:|---:|---:|
| SemidefiniteProgramming | 5.49 | 1.93 | **0.35** | 80.5 |
| QuantumHilbertMatrix (kron) | 3.92 | 1.66 | **0.42** | 5.80 |
| SDPSegfault1132 (kron) | 63.95 | 14.75 | **0.23** | 0.27 |

With the fixed SDP row, the 22-row cold geometric mean becomes ≈ **0.24**. Since #102 may
also speed other matmul-heavy rows (CVaR, FactorCovariance, Murray, OptimalAdvertising),
the whole suite is being re-measured on the #102 build; final numbers replace the tables
above when it completes.

Formerly-excluded kron problems (engine 0.7.0 now supports kron via SparseDiffEngine #101 —
the §4.1 exclusion claim is stale; decide whether to include these 3 rows):

| Benchmark | CPP (s) | engine (s) | ratio |
|---|---:|---:|---:|
| UnconstrainedQP (kron) | 9.27 | 0.076 | 0.008 |
| SDPSegfault1132 (kron) | 59.63 | 15.96 | 0.268 |
| QuantumHilbertMatrix (kron) | 3.88 | 22.52 | 5.80 |

### Parametric re-solve, 2026-07-11 re-run (seconds; ratio = cached engine / DPP)

`diffeng` (ignore_dpp re-solve) ≈ `de_cached` (explicit backend, DPP path) everywhere —
the PR-C program cache works; table shows de_cached.

| Benchmark | DPP re-solve (s) | engine re-solve (s) | ratio |
|---|---:|---:|---:|
| ParamConeMatrixStuffing | 0.0029 | 0.0008 | 0.28 |
| ParamSmallMatrixStuffing | 0.0049 | 0.0015 | 0.30 |
| SimpleScalarParametrizedLP | 0.895 | 0.662 | 0.74 |
| ConvexPlasticity | 0.662 | 0.660 | 1.00 |
| SVMWithL1Regularization | 0.271 | 0.509 | 1.88 |
| FactorCovarianceModel | 0.145 | 0.275 | 1.90 |
| SimpleFullyParametrizedLP | 0.224 | 0.121 | 0.54 |
| ParametrizedQP | 1.335 | 1.038 | 0.78 |
| **Geometric mean (all 8 rows)** | | | **0.74** |

Notable improvements vs the old .tex numbers: SVM 1.88× (was 3.72×), ConvexPlasticity
0.99× (was 4.52×), FactorCovariance 1.90× (was 3.39×) — the re-solve geometric mean flips
from 1.18 (worse than DPP) to **0.74 (better than DPP)**. This is the PR-C caching story:
the engine now beats the DPP tensor on 6 of 8 parametric problems and is within 2× on the
other two.

### Previous numbers (in 7-Theme2.tex as of 2026-07-11)

Cold compile (ms), ratio = engine/CPP: Yitzhaki 845/69 = 0.08; Cajas 2154/179 = 0.08;
SimpleQP 2882/295 = 0.10; LeastSquares 2313/263 = 0.11; HuberRegression 2559/298 = 0.12;
SimpleLP 5656/747 = 0.13; SlowPruning 1726/283 = 0.16; SVMWithL1Regularization 2593/411 = 0.16;
TvInpainting 879/164 = 0.19; SimpleScalarParametrizedLP 1066/223 = 0.21;
SimpleFullyParametrizedLP 463/110 = 0.24; ParametrizedQP 2645/631 = 0.24;
ConeMatrixStuffing 2589/819 = 0.32; ParamSmallMatrixStuffing 118/40 = 0.34;
OptimalAdvertising 2202/805 = 0.37; ParamConeMatrixStuffing 69/27 = 0.38;
SmallMatrixStuffing 1633/627 = 0.38; CVaR 7128/6224 = 0.87; FactorCovarianceModel 1157/1117 = 0.97;
Murray 1052/1627 = 1.55; ConvexPlasticity 81/220 = 2.63; SemidefiniteProgramming 995/8886 = 8.90.
Geometric mean 0.32.

Parametric re-solve (ms), ratio on re-solve: ParamSmallMatrixStuffing 2.23/0.65 = 0.29;
ParamConeMatrixStuffing 1.19/0.40 = 0.33; SimpleFullyParametrizedLP 50.8/36.8 = 0.72;
ParametrizedQP 333/309 = 0.93; SimpleScalarParametrizedLP 66.2/67.9 = 1.03;
FactorCovarianceModel 21.3/72.2 = 3.39; SVMWithL1Regularization 40.2/150 = 3.72;
ConvexPlasticity 43.0/194 = 4.52. Geometric mean 1.18.

## Table 4.3 — CasADi comparison

### Methodology (for the §4.4 prose)

- Harness: `benchmarks/casadi_compare.py` (cvxpy repo, untracked).
- CasADi cannot canonicalize DCP atoms, so for fairness it receives the **already-lowered**
  formulation: the same epigraph variables and the same conic rows CVXPY's canonicalization
  produces (cone membership is metadata — the lowered constraint function is affine in the
  stacked variable z even for SOC/SDP problems). We write f(z, p) and the slack expression
  g(z, p) = b − Az as CasADi MX graphs, mirroring CVXPY's row and column order exactly.
- Extraction uses CasADi the way its own `qpsol`/`conic` path recovers QP data from an
  NLP-form model, without invoking any solver:
  `grad = casadi.gradient(f, z)`; `P = casadi.jacobian(grad, z)`; `c = grad|_{z=0}`;
  `A = −casadi.jacobian(g, z)`; `b = g|_{z=0}`; wrapped in
  `F = casadi.Function(p → (P, c, A, b))`. All expressions are **MX** (matrix-valued
  graph); constants are sparse `DM`. SX is never used (it would scalarize these problem
  sizes into tens of millions of nodes).
- **Fairness note (P extraction)**: `casadi.hessian()` — the symmetry-exploiting
  star-coloring path — is pathological on dense Hessian patterns: at n=800 dense P it
  takes 126 s where jacobian-of-gradient produces the identical matrix in ≈2.6 s, and at
  the benchmark's n=1600 it did not finish in 6.5 h. The harness therefore uses the
  faster jacobian-of-gradient idiom, giving CasADi its best path; the `hessian()`
  behavior is reported only as a footnote (profiled stage-by-stage, both `bilin` and
  `xᵀPx` spellings identical; the n=100→800 scaling probe below documents it).
- **single** = AD + Function construction + first numeric evaluation on a freshly built
  MX graph (the analogue of one cold `get_problem_data` on an existing expression tree;
  MX graph construction itself is timed separately and excluded, as CVXPY's timing also
  starts from a built expression tree).
- **re-solve** = one more `F(p_new)` evaluation with fresh parameter values (the analogue
  of the warm cached-engine re-solve).
- Problems: SimpleLP, LeastSquares, SimpleQP, HuberRegression (cold only);
  SimpleScalarParametrizedLP, SimpleFullyParametrizedLP, ParametrizedQP,
  SVMWithL1Regularization (cold + re-solve). Hand-lowerings:
  - LeastSquares/ParametrizedQP: t = Ax − b epigraph, objective tᵀt (P = 2I on t block).
  - HuberRegression: huber(r, M=1) → min uᵀu + 2·sum(t) s.t. r = u + w, |w| ≤ t;
    columns [u, t, w, β].
  - SVM-L1: hinge epigraph h ≥ 1 − y∘(Xβ − v), h ≥ 0; ℓ1 via |β| ≤ s, sum(s) ≤ t;
    columns [h, t, β, v, s]; λ multiplies t in c only.

### Matrix verification

- **Small instances (2026-07-11): all 8 problems MATCH exactly** — P, c, A, b agree
  entry-for-entry (max|diff| = 0, i.e. bit-identical) with
  `get_problem_data(CLARABEL, ignore_dpp=True)`, same row/column order, sparse comparison.
- **Benchmark-size (`--verify-full`, 2026-07-11): all 8 MATCH exactly as well** (max|diff|
  = 0 at full problem sizes, including the 10 M-variable LP and the 14.4 M-parameter QP).
  → §4.4 can state: "the two systems produce bit-identical problem data at every benchmark
  size; the timing columns therefore measure the construction of the same matrices."

### Timing numbers — DEFINITIVE core-8 (2026-07-12, jacobian-of-gradient extraction, #102 build)

Raw: `benchmarks/results_casadi_compare_final.json`. Medians of 3 cold iterations
(ParametrizedQP: median of 3 as well) and 20 re-solves.

Medians; single = AD + Function construction + first evaluation (CasADi) vs cold
`get_problem_data(..., ignore_dpp=True)` (engine); re-solve = one re-evaluation with fresh
parameter values on the warm object. MX graph build time excluded (measured separately,
small). Raw: `benchmarks/results_casadi_compare.json`.

| Problem | CasADi single | engine single | ratio e/c | CasADi re-solve | engine re-solve | ratio e/c |
|---|---:|---:|---:|---:|---:|---:|
| SimpleLP | 38.07 s | 5.02 s | 0.132 | — | — | |
| SimpleScalarParametrizedLP | 4.57 s | 0.98 s | 0.214 | 0.124 s | 0.236 s | 1.90 |
| SimpleFullyParametrizedLP | 2.36 s | 0.48 s | 0.204 | 0.062 s | 0.120 s | 1.95 |
| LeastSquares | 36.55 s | 1.62 s | 0.044 | — | — | |
| SimpleQP | 53.71 s | 1.70 s | 0.032 | — | — | |
| ParametrizedQP | 771.5 s | 2.52 s | 0.0033 | 0.938 s | 0.942 s | 1.01 |
| HuberRegression | 42.35 s | 1.88 s | 0.044 | — | — | |
| SVMWithL1Regularization | 145.5 s | 1.79 s | 0.012 | 0.548 s | 0.491 s | 0.90 |

Geometric means: **single 0.044** (engine ~23× faster on average, range 4.7×–306×);
**re-solve 1.35** (CasADi's fixed-tape VM wins the two pure-LP re-solves ~1.9×; parity on
ParametrizedQP and SVM). SimpleQP is now a real number (53.7 s) with jacobian-of-gradient
extraction instead of the `casadi.hessian()` DNF — keep the DNF + scaling probe as the
star-coloring footnote. All rows: one extraction method, one engine build (#102).

### Coverage extension — full-size verification results (2026-07-12)

- **12 of the 14 new problems MATCH bit-identically at benchmark size** (the four
  matrix-stuffing problems, SlowPruning, Yitzhaki, Murray, Cajas, OptimalAdvertising*,
  FactorCovarianceModel, ConvexPlasticity, TvInpainting, SemidefiniteProgramming).
- ***OptimalAdvertising**: identical except ONE b entry of 251,750 — the upstream data
  recipe itself produces a NaN coefficient (c is rounded to the nearest 1000, an entry
  hits 0, and `c.min()/c[i]` → 0/0 → R[28]=NaN). Both systems reproduce the 1000
  identical NaNs in A; for that row's b, CVXPY propagates IEEE `NaN·0 = NaN` while
  CasADi's structural zeros drop the product (b=0). A nice footnote: with NaN in the
  data, "the problem data" is ill-defined at exactly the entries where IEEE and
  structural-zero semantics diverge. (Comparator is now NaN-aware: identical NaNs count
  as equal; genuine divergences are counted.)
- **CVaR: CasADi extraction DNF at full size (>10.3 h, killed)** — verified bit-identical
  at small size. Mechanism confirmed by stack sample: `casadi::MX::jacobian` assembly
  (get_nz/set_nz with `is_slice2` scans) on the dense 131072×768 scenario block (100.6 M
  nnz, ~770 forced seed sweeps). This is the regime map's dense-block prediction at
  scale; report the row as extraction-DNF with the engine's 25.3 s alongside.

### Kron trio: in Table 4.1 (all 25 rows now); Table 4.3 extension IN PROGRESS

Table 4.1 in the .tex shows all 25 rows (geomean 0.24; kron supported since engine #101).

REVISED REASONING (2026-07-12, after user pushback — the first exclusion rationale was
wrong): the comparison hands CasADi the LOWERED problem, which is real and affine —
partial_trace/partial_transpose are just selection patterns in A and Complex2Real leaves
real variables, so "CasADi lacks those operators" is NOT a valid exclusion argument (a
reviewer would catch it). The true fairness boundary: the CasADi model may use
structural, data-independent permutation/selection slices (as the SDP svec builder
already does) and real-block complex arithmetic, but must NOT be handed a numerically
precomputed lowered coefficient matrix (that would perform the extraction outside the
timed region). Under those rules all three kron problems are being attempted
(`casadi_problems_ext_kron.py`, agent in progress); any that still fails gets excluded
with the precise boundary reason, stated verbatim in §4.4. `ca.kron(DM, MX)` verified to
differentiate correctly in casadi 3.7.2.

### FULL 22-PROBLEM TABLE 4.3 (2026-07-12, definitive; raw: results_casadi_compare_final.json + results_casadi_compare_ext.json)

Single = extraction on the lowered model (CasADi) vs cold `get_problem_data(ignore_dpp)`
(engine). Ratio = engine/CasADi (<1: engine faster). Sorted by single ratio.

| Benchmark | CasADi single | engine single | ratio | CasADi re-solve | engine re-solve | ratio |
|---|---:|---:|---:|---:|---:|---:|
| ParametrizedQP | 771.5 s | 2.52 s | 0.0033 | 0.938 s | 0.942 s | 1.00 |
| FactorCovarianceModel | 250.4 s | 2.05 s | 0.0082 | 3.956 s | 0.567 s | 0.14 |
| SVMWithL1Regularization | 145.5 s | 1.79 s | 0.012 | 0.548 s | 0.491 s | 0.90 |
| SemidefiniteProgramming | 66.4 s | 2.07 s | 0.031 | — | — | |
| SimpleQP | 53.7 s | 1.70 s | 0.032 | — | — | |
| LeastSquares | 36.6 s | 1.62 s | 0.044 | — | — | |
| HuberRegression | 42.4 s | 1.88 s | 0.044 | — | — | |
| Yitzhaki | 8.72 s | 0.47 s | 0.054 | — | — | |
| SlowPruning | 38.8 s | 2.80 s | 0.072 | — | — | |
| TvInpainting | 8.49 s | 1.14 s | 0.134 | — | — | |
| SimpleLP | 38.1 s | 5.02 s | 0.132 | — | — | |
| Murray | 25.9 s | 3.52 s | 0.136 | — | — | |
| SimpleFullyParametrizedLP | 2.36 s | 0.48 s | 0.204 | 0.062 s | 0.120 s | 1.95 |
| SimpleScalarParametrizedLP | 4.57 s | 0.98 s | 0.214 | 0.124 s | 0.236 s | 1.90 |
| Cajas | 4.88 s | 1.12 s | 0.229 | — | — | |
| ConeMatrixStuffing | 6.10 s | 3.94 s | 0.646 | — | — | |
| OptimalAdvertising | 9.47 s | 6.16 s | 0.650 | — | — | |
| SmallMatrixStuffing | 2.77 s | 2.75 s | 0.99 | — | — | |
| ConvexPlasticity | 0.21 s | 2.82 s | 13.7 | 0.010 s | 0.707 s | 70.8 |
| ParamSmallMatrixStuffing | 0.007 s | 0.210 s | 30.8 | 0.7 ms | 2.0 ms | 3.0 |
| ParamConeMatrixStuffing | 0.004 s | 0.143 s | 39.7 | 0.3 ms | 1.1 ms | 3.5 |
| SDPSegfault1132 (kron) | 17.65 s | 14.61 s | 0.83 | — | — | |
| QuantumHilbertMatrix (kron) | 1.41 s | 1.57 s | 1.11 | — | — | |
| UnconstrainedQP (kron, complex) | 0.021 s | 0.074 s | 3.49 | — | — | |
| CVaR | **DNF > 10.3 h** | 25.3 s | — | — | — | |
| **Geometric mean (24 rows, CVaR excl.)** | | | **0.24** | | (8 rows) | **2.19** |

2026-07-12 late update: kron trio added (all verified at full size; UnconstrainedQP via
real-block complex embedding at 7e-14, partial ops as structural index maps). Changed-builder
re-times: ConvexPlasticity casadi 0.133 s single / 6.7 ms re-solve (sparse constants;
engine single moved 2.82→2.29 s, run variance), TvInpainting casadi 8.20 s (unchanged
within noise). The kron/svec PSD problems land at PARITY (0.83–1.11) — structured
permutation-heavy patterns are cheap for CasADi's detection; a good nuance for §4.4.
Raw: `results_casadi_compare_kron.json` (archived in plans/raw/).

Reading of the full table (use this framing in §4.4):
- **Engine wins big exactly where the regime map predicts**: dense constant blocks
  (LeastSquares/Huber/SVM/SimpleQP/FactorCovariance 20–120×, CVaR DNF), dense symbolic
  blocks (ParametrizedQP 306×), dense rows (SDP 32×).
- **CasADi wins where extraction is trivial and the engine's cost is CVXPY-side
  canonicalization** (tiny ParamStuffing problems ~200–300 vars: 30–40×; ConvexPlasticity
  13.7×). IMPORTANT honesty note: the two columns have an intentional boundary asymmetry
  — the engine column includes the full lowering (reduction chain + extraction), the
  CasADi column starts from the hand-lowered model. On tiny problems the engine's
  ~0.15–0.2 s is fixed CVXPY Python overhead, not extraction. Say this explicitly; it is
  the flip side of the design decision that favors CasADi ("we hand it the lowered
  model").
- **Warm re-solve: CasADi is ~2× faster geometric mean (8 parametric rows)** — its
  fixed-tape VM re-evaluation vs the engine re-solve that still traverses CVXPY's
  Python solve path. Exception in the engine's favor: FactorCovarianceModel (0.14, i.e.
  engine 7× faster) — CasADi must re-gather the parameter-dependent P through the dense
  machinery each solve. Exception in CasADi's favor: ConvexPlasticity (70.8×; params land
  only in b, the tape is trivial, while the engine pays per-solve chain overhead).
- Overall geometric mean single 0.185 (engine ≈5.4× faster across the whole suite) — much
  more moderate than the core-8's 23×, BECAUSE the suite includes the tiny-problem rows
  where the boundary asymmetry favors CasADi. Present both numbers with the regime story.

**Coverage extension (2026-07-12): all 22 runnable benchmarks now have CasADi builders**
(`benchmarks/casadi_problems_ext_lp.py`, `casadi_problems_ext_cones.py`), every one
verified bit-identical at small size, including the cone-lowered ones (ConvexPlasticity's
3000 SOC blocks; TvInpainting's (511)²-block SOC layout; the SDP's √2-scaled svec rows —
whose row ordering differs from the symmetric-variable column ordering; FactorCovariance's
parameter-dependent P). Full-size verification + timing in progress. Notable findings for
the thesis/footnotes:
- **CasADi 3.7.2 Jacobian-evaluation bug found** (CVaR lowering): for
  `u + alpha - mtimes(dense_DM, x)` with scalar-broadcast `alpha`, the evaluated Jacobian
  drops all but the first alpha entry (sparsity correct, values wrong; g itself evaluates
  correctly). Worked around with `ca.repmat`; documented in the builder. Consider
  reporting upstream to CasADi with a minimal repro.
- TvInpainting upstream is unseeded; builders pin RandomState(1) replicating the upstream
  draw order so both sides share data (timing unaffected — shapes identical).
- Murray's pairwise-difference matrix (upstream builds it dense, 1.3 GB) is given to
  cvxpy dense (upstream verbatim) but to CasADi as sparse CSC (2 nnz/row) — a deliberate
  concession to CasADi, note it in the table caption.

### SimpleQP DNF: scaling probe (m = 5n, dense P; casadi_extract vs engine, #102 build)

| n | CasADi | engine | ratio |
|---:|---:|---:|---:|
| 100 | 0.06 s | 0.02 s | 3.6× |
| 200 | 0.65 s | 0.02 s | 29.4× |
| 400 | 8.41 s | 0.09 s | 93.7× |
| 800 | 126.6 s | 0.39 s | 320.9× |

Per-doubling growth ×10.8 → ×12.9 → ×15.1, i.e. roughly O(n^3.5–3.9): the dense n×n
Hessian forces star coloring toward ~n seed sweeps, each sweep building a symbolic
expression over an O(n²)-sized graph. At the benchmark's n = 1600 extraction did not
finish in 6.5 h (three timing iterations were requested; report the row as DNF > 6 h and
cite this probe). Raw probe output: scaling numbers above; script
`probe_simpleqp_scaling.py` (session scratchpad — copy into benchmarks/ if wanted).

Findings so far:
- **Cold extraction: engine 5–22× faster** on everything measured. LeastSquares is the
  clean illustration: A contains a dense 7000×2000 block; CasADi must *discover* its
  sparsity by bitvector AD sweeps + coloring (the CasADi paper itself notes pattern
  detection is "often the most expensive step"), while the engine knows every block's
  pattern structurally.
- **SimpleQP is pathological for AD extraction**: the objective's dense 1600×1600 Hessian
  drives star coloring toward ~1600 seed sweeps; extraction did not finish in 6.5 h and
  was killed. Honest reporting: mark DNF, characterize scaling with a small size sweep
  (n = 100/200/400) rather than extrapolating a single number.
- **Warm re-solve: CasADi ~2× faster than the cached engine on the two parametric LPs**
  (fixed-tape VM re-evaluation with no Python in the loop). An honest and useful data
  point — the engine's re-solve still pays CVXPY-side overhead per solve.

## Why CasADi singles are slow — controlled experiments (2026-07-12, for §4.4 discussion)

The lowered problems are affine/quadratic, so the Jacobian *values already sit in the
graph as constants* — yet CasADi must reconstruct A by (a) bitvector sparsity-pattern
detection (64 columns per AD sweep) and (b) greedy distance-2 coloring plus one seed
sweep per color. On a dense m×n block every pair of columns collides, so the coloring
needs the full dimension's worth of sweeps → superlinear cost. The engine reads each
atom's Jacobian block and its pattern off structurally, in O(nnz). Controlled probe
(`ca.jacobian(DM @ x, x)`, pure affine, one mtimes node — symbolic-jacobian time):

| shape | dense | sparse (10 nnz/row, same shape) |
|---|---:|---:|
| 500×250 | 0.06 s | 0.04 s |
| 1000×500 | 0.33 s | 0.02 s |
| 2000×1000 | 2.39 s | 0.02 s |
| 4000×2000 | 18.4 s | 0.04 s |

- **Density, not graph size, drives the cost**: identical expression (one node), 500×
  slower dense vs sparse at 4000×2000. Per-nnz cost grows ≈linearly with the column
  count (0.66 → 1.2 → 2.3 µs/nnz) — the O(nnz·cols/64) detection + n-color sweep
  signature, matching the paper's own note that pattern detection is "often the most
  expensive step."
- **Coloring direction matters**: the transposed (wide, 2000×4000) dense block costs 2×
  the tall one at equal nnz (37.4 vs 18.4 s) — the α=2 forward/reverse heuristic at work.
- **Structured patterns are fine, but with a constant factor**: diagonal at LP scale is
  linear, ≈0.9 µs/nnz — CasADi's hierarchical detection handles it; the engine's whole
  pipeline is still ~5–8× faster there (SimpleLP 38 s vs 5 s), a constant-factor gap.
- **Symbolic (parametric) dense blocks are the worst case**: ParametrizedQP's A depends
  on 14.4 M parameter entries — 771 s vs 2.5 s (306×).
- **Symmetric star coloring compounds it**: `casadi.hessian()` on a dense 1600² P did not
  finish in 6.5 h; jacobian-of-gradient gets the same matrix in ~10 s (the harness uses
  the latter — see fairness note).
- **Re-solve parity is the control**: once the derivative graph exists, both systems
  re-evaluate in comparable time — the entire single-solve gap is derivative
  *construction*, not evaluation.

Regime map for the thesis table: SimpleLP/matrix-stuffing (structured, linear regime,
~5× constant factor) → LeastSquares/Huber/SVM/SimpleQP/CVaR (dense constant blocks,
coloring regime, 20–80×) → ParametrizedQP (dense symbolic block, 306×). Raw probe:
scratchpad `probe_why_slow.py`.

### In defence of CasADi (write this into §4.4 — preempts "too good to be true")

- **Do NOT say "CasADi treats the data as dense."** It is sparse throughout (CCS
  everywhere, per the paper), and probe E2 shows it exploiting sparsity superbly (same
  shape, sparse: 0.04 s vs dense: 18.4 s). The correct statement: CasADi must *discover*
  the Jacobian pattern and *reconstruct* its values through seeded AD sweeps, and on a
  dense block the number of independent probes is information-theoretically forced to the
  full dimension — no coloring can compress a dense pattern. The engine doesn't sweep at
  all: each atom's Jacobian block is known in closed form, pattern and values.
- **Scope**: CasADi targets nonlinear problems where Jacobians vary with the evaluation
  point; there the sweep machinery is necessary. Affine/quadratic canonicalization is a
  degenerate special case. Given its abstraction boundary (derivatives of arbitrary
  expressions via matvec probes), CasADi's behavior is near optimal-in-kind; the engine
  wins by moving the abstraction boundary to per-atom closed-form blocks.
- **Amortization is CasADi's design point, and our table shows it**: warm re-solves —
  CasADi ~1.9× FASTER than the engine on the pure LPs, parity elsewhere. In its intended
  build-once-evaluate-thousands workflow (MPC/OCP, plus C codegen), the one-time
  construction cost is irrelevant. The single column is the CVXPY-user regime, not the
  CasADi-user regime.
- **Decompose the gap**: structured regime = plain constant factor (~5–8×; ~0.9 vs
  ~0.25 µs/nnz — specialized C kernel vs general VM); dense/parametric rows add the
  forced ~dimension-many sweeps. "Constant factor + forced asymptotics," not
  "300× better at the same job."
- **Fairness receipts to cite**: hand-lowered models (CasADi spared the DCP reduction),
  MX graphs, jacobian-of-gradient (we repaired its star-coloring worst case in its
  favor), sparse constants where the structure warranted (Murray), MX graph-construction
  time excluded, outputs verified bit-identical at full size. Sanity anchor: against
  cvxcore the engine is ~4× geomean on the same task — CasADi's larger gap reflects the
  more general problem it solves per extraction, not a broken setup.

## CasADi internals notes (for §2.4 coefficient extraction)

**Primary sources.** [P] = Andersson, Gillis, Horn, Rawlings, Diehl, "CasADi: a software
framework for nonlinear optimization and optimal control," *Math. Prog. Comp.* 11(1):1–36,
2019, DOI 10.1007/s12532-018-0139-4 (verified from the author manuscript on KU Leuven
Lirias). [UG] = CasADi user guide, https://web.casadi.org/docs/. Already cited in the
thesis bib as `andersson2019`.

### 1. SX vs MX expression graphs

- MATLAB-inspired "everything-is-a-matrix" syntax; **all matrices are sparse**, stored in
  compressed column storage (CCS), entries can be structurally nonzero but numerically zero
  ("structural zeros"). [P §2.1–2.2]
- **SX**: each *nonzero element* is defined by scalar-valued operations; DAG node types are
  only symbolic primitive, constant, unary op, binary op. Minimal per-op overhead. [P §2.2]
- **MX**: each node is a *matrix* operation, possibly multi-input/multi-output. Atomic ops
  (Table 1): constant, unary, binary, inner product, transpose, multiply-accumulate
  (`mac(X1,X2,X3)=X3+X1X2`), reshape, projection (changes sparsity), submatrix
  access/assignment, linear solve, horzcat/horzsplit, function call. "Projection" nodes are
  auto-inserted when binary ops meet mismatched sparsity patterns. [P §2.3]
- Parameters have no special node type — `p` is just another symbolic primitive; the NLP
  form is explicitly parametric f(x,p), g(x,p). [P §4.1]
- Docs example: 2×2 matrix product = 8 scalar ops in SX, 2 matrix ops in MX. [UG §3.3–3.4]

### 2. `casadi.jacobian`: source-code transformation + sparsity + coloring

- AD by **source-code transformation**: new symbolic expressions in the same graph
  representation are generated when derivatives are requested. Forward mode = Jacobian×vector,
  reverse = Jacobianᵀ×vector, each at cost comparable to evaluating f; every atomic op has an
  explicit chain rule in the same op set. [P §2.6]
- **Sparsity pattern detection** precedes coloring and "often turns out to be the most
  expensive step": bitvector approach (Giering & Kaminski 2006) — AD sweeps with a single
  bit as datatype packed into 64-bit words, so 64 rows/cols per sweep; a hierarchical
  algorithm colors a coarse 64-group pattern and recurses (paper's Example 1: 100,000²
  tridiagonal Jacobian pattern in 7 sweeps vs 1,563 naive). [P §2.6]
- **Coloring** (Gebremedhin, Manne & Pothen, "What color is your Jacobian?", SIAM Review
  2005): greedy **distance-2 unidirectional** coloring tried both column-wise (forward) and
  row-wise (reverse); default factor **α = 2** weights reverse sweeps as costlier; second
  coloring aborted early if it needs too many colors; largest-first preordering. [P §2.6 Alg. 1]

### 3. `casadi.hessian` and symmetry

- Hessian = Jacobian of the gradient, "preferably exploiting the symmetry"; with symmetry
  known a priori it switches to a greedy distance-2 **star-coloring** algorithm
  (Gebremedhin et al., Alg. 4.1). [P §2.6]
- `[H, g] = hessian(f, x)` returns Hessian and gradient together. [UG §3.9]

### 4. `casadi.Function` and repeated evaluation

- Creating a Function "essentially amounts to topologically sorting the expression graph"
  (depth-first, unlike trace-order tools ADOL-C/CppAD). [P §2.4]
- Evaluation runs in **register-based virtual machines** (one for SX, one for MX); each op
  reads/writes elements (SX) or intervals (MX) of a preallocated **work vector**, sized by
  live-variable analysis with LIFO reuse and in-place ops. No memory allocation during
  numeric evaluation — new parameter values just re-run the fixed instruction tape (why
  re-evaluation is cheap). Contrasts with AMPL's stack-based VM. [P §2.4–2.5]
- Derivative function objects generated at function-call nodes are cached. [P §2.6]

### 5. VM vs code generation

- Alternative backend: self-contained C with no dynamic allocation (embeddable), JIT via
  system compiler or bundled Clang/LLVM; generated code compiled with optimization can be
  4–10× faster than the VMs. [P §2.5; UG ch. 5]

### 6. `qpsol`/`conic` extract QP data exactly as our harness does

- Documented in the paper: when f is quadratic and g linear in x, "AD is used to reformulate
  the problem in form (9), automatically identifying the sparse matrices H and A as well as
  the vectors g, a and ā" (eq. (9): min ½xᵀHx + gᵀx s.t. bounds, a ≤ Ax ≤ ā). [P §4.2]
- High-level `qpsol` takes the same {x, p, f, g} dict as `nlpsol`; low-level `conic` takes
  H/A sparsity patterns at construction, numeric values per solve. [UG §4.6.1–4.6.2]
- → This justifies the harness methodology sentence: our Table 4.3 extraction is exactly
  CasADi's own documented QP-data path, minus the solver.

### Contrast paragraph (draft for §2.4)

CasADi obtains H and A *numerically but exactly*: it lowers the model to a DAG of generic
matrix (or scalar) operations, detects the Jacobian's sparsity pattern by bitvector
propagation, and then uses greedy distance-2 (star) coloring to compress the full
Jacobian/Hessian into a small number of forward/reverse AD sweeps, each realized as a new
expression graph evaluated in a register VM. The structural approach in this thesis instead
exploits that CVXPY's atom library fixes each node's Jacobian block in closed form (and
affinity guarantees constancy w.r.t. z), so sparsity and coefficients are assembled
directly, with no seed sweeps, coloring, or pattern-detection phase. This is not a
deficiency of CasADi but a difference in scope: CasADi must handle arbitrary smooth
nonlinear expressions where the Jacobian genuinely varies with the evaluation point,
whereas canonicalized DPP problems have derivative structure known a priori. In the shared
regime — repeated re-solves with new parameter values — both amortize: CasADi caches
derivative Functions and re-runs a fixed tape; the diff engine re-evaluates only
parameter-dependent coefficient entries.

### Thesis-worthy nuggets

1. Exact terminology to use: "source-code transformation" AD; "bitvector approach" for
   sparsity (64 columns/sweep); "greedy, distance-2, star-coloring" for Hessians; α = 2
   default forward/reverse cost ratio; "register-based virtual machines" with work vectors.
2. The paper itself concedes sparsity *pattern detection* is often the most expensive step
   of Jacobian construction [P §2.6] — a perfect hook: the structural approach gets the
   pattern for free.
3. Positioning: the paper's abstract positions CasADi as more flexible than "AMPL, GAMS,
   JuMP or Pyomo" — useful for placing a modeling-language-level extractor in the landscape.
   (Note: the claim that `jacobian()` is itself a lazy MX graph node could NOT be verified;
   only the caching of generated derivative Functions is verified. Don't write the former.)

## Notes for the writing session

- Table 4.2's "CPP re-solve" column is the DPP-cached tensor re-evaluation (`dpp` strategy);
  the "engine re-solve" column is the cached engine program re-evaluation. Both exclude the
  first solve, which is reported separately (identical to the cold columns of Table 4.1 by
  construction — same measurement).
- Known outliers to discuss in §4.2: SemidefiniteProgramming (engine 8.9× slower — PSD
  lowering cost), ConvexPlasticity and Murray (engine slower cold); CVaR and
  FactorCovarianceModel near parity.
- §4.1 typo in the .tex: `\SI{24} GB` → `\SI{24}{\giga\byte}`.
