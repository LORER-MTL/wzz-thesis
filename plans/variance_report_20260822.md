# Run-to-run spread, every cell that has more than one run (2026-08-22)

Columns: runs | median | min | max deviation of a run from the median | (max-min)/min.

## A. Same-protocol replicates (three runs of the harness, results/repl/*_param_rep{1,2,3}.json), plus the 2026-08-08 run of the same cell as a fourth point where it exists

### A1. Table 4.1, parametric rows (ignore_dpp path)

| problem | column | 3 runs (s) | 08-08 run | median | min | max dev | spread |
|---|---|---|---|---|---|---|---|
| ParamSmallMatrixStuffing | CPP | 0.284, 0.279, 0.281 | 0.285 | 0.281 | 0.279 | 0.9% | 1.8% |
| ParamSmallMatrixStuffing | SCIPY | 0.506, 0.499, 0.503 | 0.486 | 0.503 | 0.499 | 0.7% | 1.3% |
| ParamSmallMatrixStuffing | COO | 0.498, 0.492, 0.492 | 0.501 | 0.492 | 0.492 | 1.3% | 1.3% |
| ParamSmallMatrixStuffing | diffengine | 0.252, 0.214, 0.209 | 0.204 | 0.214 | 0.209 | 18.1% | 21.0% |
| ParamConeMatrixStuffing | CPP | 0.195, 0.181, 0.181 | 0.183 | 0.181 | 0.181 | 7.6% | 8.0% |
| ParamConeMatrixStuffing | SCIPY | 0.344, 0.320, 0.320 | 0.326 | 0.320 | 0.320 | 7.5% | 7.7% |
| ParamConeMatrixStuffing | COO | 0.335, 0.324, 0.324 | 0.333 | 0.324 | 0.324 | 3.4% | 3.4% |
| ParamConeMatrixStuffing | diffengine | 0.149, 0.142, 0.144 | 0.137 | 0.144 | 0.142 | 4.0% | 5.3% |
| SimpleScalarParametrizedLP | CPP | 4.744, 4.543, 4.555 | 5.148 | 4.555 | 4.543 | 4.1% | 4.4% |
| SimpleScalarParametrizedLP | SCIPY | 4.285, 4.116, 4.081 | 4.716 | 4.116 | 4.081 | 4.1% | 5.0% |
| SimpleScalarParametrizedLP | COO | 4.312, 4.246, 4.203 | 4.758 | 4.246 | 4.203 | 1.6% | 2.6% |
| SimpleScalarParametrizedLP | diffengine | 1.025, 1.042, 1.035 | 0.992 | 1.035 | 1.025 | 0.9% | 1.6% |
| SVMWithL1Regularization | CPP | 11.142, 11.207, 11.249 | 13.542 | 11.207 | 11.142 | 0.6% | 1.0% |
| SVMWithL1Regularization | SCIPY | 8.307, 8.244, 8.313 | 9.317 | 8.307 | 8.244 | 0.8% | 0.8% |
| SVMWithL1Regularization | COO | 9.782, 9.792, 10.097 | 10.407 | 9.792 | 9.782 | 3.1% | 3.2% |
| SVMWithL1Regularization | diffengine | 1.866, 1.897, 1.858 | 1.683 | 1.866 | 1.858 | 1.7% | 2.1% |
| FactorCovarianceModel | CPP | 5.322, 5.415, 5.259 | 5.429 | 5.322 | 5.259 | 1.7% | 3.0% |
| FactorCovarianceModel | SCIPY | 4.320, 4.528, 4.217 | 4.514 | 4.320 | 4.217 | 4.8% | 7.4% |
| FactorCovarianceModel | COO | 4.790, 4.665, 4.403 | 4.824 | 4.665 | 4.403 | 5.6% | 8.8% |
| FactorCovarianceModel | diffengine | 0.918, 0.862, 0.873 | 0.963 | 0.873 | 0.862 | 5.2% | 6.5% |

### A2. Table 4.2, first canonicalization (DPP path for CPP/SCIPY/COO, ignore_dpp for diffengine)

| problem | column | 3 runs (s) | 08-08 run | median | min | max dev | spread |
|---|---|---|---|---|---|---|---|
| ParamSmallMatrixStuffing | CPP | 8.139, 7.777, 7.829 | 7.896 | 7.829 | 7.777 | 4.0% | 4.7% |
| ParamSmallMatrixStuffing | SCIPY | 30.008, 29.056, 29.200 | 29.303 | 29.200 | 29.056 | 2.8% | 3.3% |
| ParamSmallMatrixStuffing | COO | 0.405, 0.404, 0.411 | 0.411 | 0.405 | 0.404 | 1.6% | 1.8% |
| ParamSmallMatrixStuffing | diffengine | 0.252, 0.214, 0.209 | 0.204 | 0.214 | 0.209 | 18.1% | 21.0% |
| ParamConeMatrixStuffing | CPP | 3.297, 3.156, 3.176 | 3.248 | 3.176 | 3.156 | 3.8% | 4.5% |
| ParamConeMatrixStuffing | SCIPY | 7.993, 7.691, 7.630 | 7.710 | 7.691 | 7.630 | 3.9% | 4.8% |
| ParamConeMatrixStuffing | COO | 0.278, 0.266, 0.264 | 0.268 | 0.266 | 0.264 | 4.4% | 5.3% |
| ParamConeMatrixStuffing | diffengine | 0.149, 0.142, 0.144 | 0.137 | 0.144 | 0.142 | 4.0% | 5.3% |
| SimpleScalarParametrizedLP | CPP | 4.873, 4.679, 4.683 | 5.347 | 4.683 | 4.679 | 4.1% | 4.2% |
| SimpleScalarParametrizedLP | SCIPY | 4.238, 4.155, 4.150 | 4.765 | 4.155 | 4.150 | 2.0% | 2.1% |
| SimpleScalarParametrizedLP | COO | 4.566, 4.485, 4.485 | 5.274 | 4.485 | 4.485 | 1.8% | 1.8% |
| SimpleScalarParametrizedLP | diffengine | 1.025, 1.042, 1.035 | 0.992 | 1.035 | 1.025 | 0.9% | 1.6% |
| SVMWithL1Regularization | CPP | 10.999, 11.134, 11.148 | 13.118 | 11.134 | 10.999 | 1.2% | 1.4% |
| SVMWithL1Regularization | SCIPY | 8.209, 8.213, 8.265 | 8.579 | 8.213 | 8.209 | 0.6% | 0.7% |
| SVMWithL1Regularization | COO | 9.630, 9.624, 9.714 | 9.988 | 9.630 | 9.624 | 0.9% | 0.9% |
| SVMWithL1Regularization | diffengine | 1.866, 1.897, 1.858 | 1.683 | 1.866 | 1.858 | 1.7% | 2.1% |
| FactorCovarianceModel | CPP | 5.115, 4.917, 5.258 | 5.486 | 5.115 | 4.917 | 3.9% | 6.9% |
| FactorCovarianceModel | SCIPY | 4.251, 4.154, 4.474 | 4.652 | 4.251 | 4.154 | 5.2% | 7.7% |
| FactorCovarianceModel | COO | 4.661, 6.454, 4.762 | 4.762 | 4.762 | 4.661 | 35.5% | 38.5% |
| FactorCovarianceModel | diffengine | 0.918, 0.862, 0.873 | 0.963 | 0.873 | 0.862 | 5.2% | 6.5% |

### A3. Table 4.2, re-solve (each run's value is already the mean of three consecutive re-solves)

| problem | column | 3 runs (s) | 08-08 run | median | min | max dev | spread |
|---|---|---|---|---|---|---|---|
| ParamSmallMatrixStuffing | tensor | 0.0050, 0.0048, 0.0048 | 0.0048 | 0.0048 | 0.0048 | 3.6% | 4.0% |
| ParamSmallMatrixStuffing | diffengine | 0.0014, 0.0014, 0.0016 | 0.0021 | 0.0014 | 0.0014 | 10.9% | 12.7% |
| ParamConeMatrixStuffing | tensor | 0.0032, 0.0028, 0.0028 | 0.0028 | 0.0028 | 0.0028 | 14.5% | 14.7% |
| ParamConeMatrixStuffing | diffengine | 0.0014, 0.0008, 0.0008 | 0.0009 | 0.0008 | 0.0008 | 67.5% | 67.9% |
| SimpleScalarParametrizedLP | tensor | 0.3239, 0.3037, 0.3037 | 0.4834 | 0.3037 | 0.3037 | 6.7% | 6.7% |
| SimpleScalarParametrizedLP | diffengine | 0.2503, 0.2474, 0.2485 | 0.3067 | 0.2485 | 0.2474 | 0.7% | 1.2% |
| SVMWithL1Regularization | tensor | 0.2518, 0.2539, 0.2690 | 0.2922 | 0.2539 | 0.2518 | 6.0% | 6.8% |
| SVMWithL1Regularization | diffengine | 0.4955, 0.4999, 0.4964 | 0.6108 | 0.4964 | 0.4955 | 0.7% | 0.9% |
| FactorCovarianceModel | tensor | 0.1441, 0.1414, 0.1392 | 0.1448 | 0.1414 | 0.1392 | 1.9% | 3.5% |
| FactorCovarianceModel | diffengine | 0.2869, 0.2909, 0.2787 | 0.3359 | 0.2869 | 0.2787 | 2.9% | 4.4% |

### A4. ConvexPlasticity diffengine, later build (six runs, results/retime_cp_quadform_20260819)

runs 0.854, 0.945, 0.869, 0.909, 0.912, 1.036 | median 0.910 | min 0.854 | max dev 13.8% | spread 21.2%

## B. The 17 parameter-free rows of Table 4.1: one run each in the printed table (2026-08-08). The same cells exist in two earlier runs of the suite on other days. Engine builds differ between days for the diffengine column (07-11: main+#107 pr102 build; 07-24: engine 4172c5e; 08-08: thesis build ca08a26d1 + sparsediffpy 0.7.0). CPP/SCIPY/COO never touch the engine, so their cross-day spread is machine noise plus cvxpy fork-vs-upstream offset (1.03-1.21x, see bridge file).

| problem | column | 07-11 | 07-24 | 08-08 (printed) | min | printed vs min | (max-min)/min |
|---|---|---|---|---|---|---|---|
| UnconstrainedQP | CPP | 9.32 | 9.85 | 10.32 | 9.32 | 11% | 11% |
| UnconstrainedQP | SCIPY | 6.47 | 6.96 | 8.52 | 6.47 | 32% | 32% |
| UnconstrainedQP | COO | 12.12 | 12.08 | 13.54 | 12.08 | 12% | 12% |
| UnconstrainedQP | DIFFENGINE | 0.08 | 0.08 | 0.07 | 0.07 | 0% | 10% |
| LeastSquares | CPP | 8.87 | 8.91 | 9.61 | 8.87 | 8% | 8% |
| LeastSquares | SCIPY | 9.16 | 9.16 | 10.08 | 9.16 | 10% | 10% |
| LeastSquares | COO | 10.18 | 10.26 | 10.68 | 10.18 | 5% | 5% |
| LeastSquares | DIFFENGINE | 1.42 | 1.55 | 1.45 | 1.42 | 2% | 9% |
| Yitzhaki | CPP | 3.07 | 3.11 | 3.56 | 3.07 | 16% | 16% |
| Yitzhaki | SCIPY | 2.80 | 2.81 | 3.28 | 2.80 | 17% | 17% |
| Yitzhaki | COO | 3.11 | 3.07 | 3.55 | 3.07 | 16% | 16% |
| Yitzhaki | DIFFENGINE | 0.47 | 0.48 | 0.51 | 0.47 | 8% | 8% |
| HuberRegression | CPP | 10.97 | 10.56 | 12.05 | 10.56 | 14% | 14% |
| HuberRegression | SCIPY | 10.07 | 9.55 | 10.72 | 9.55 | 12% | 12% |
| HuberRegression | COO | 10.61 | 10.47 | 11.60 | 10.47 | 11% | 11% |
| HuberRegression | DIFFENGINE | 1.61 | 1.65 | 1.73 | 1.61 | 8% | 8% |
| SimpleQP | CPP | 10.49 | 10.51 | 11.27 | 10.49 | 7% | 7% |
| SimpleQP | SCIPY | 10.17 | 9.97 | 10.59 | 9.97 | 6% | 6% |
| SimpleQP | COO | 11.23 | 11.00 | 11.97 | 11.00 | 9% | 9% |
| SimpleQP | DIFFENGINE | 1.69 | 1.71 | 1.87 | 1.69 | 11% | 11% |
| SimpleLP | CPP | 30.07 | 30.18 | 37.57 | 30.07 | 25% | 25% |
| SimpleLP | SCIPY | 28.92 | 32.77 | 29.99 | 28.92 | 4% | 13% |
| SimpleLP | COO | 27.23 | 27.45 | 30.96 | 27.23 | 14% | 14% |
| SimpleLP | DIFFENGINE | 5.29 | 5.09 | 6.12 | 5.09 | 20% | 20% |
| TvInpainting | CPP | 3.57 | 3.60 | 3.89 | 3.57 | 9% | 9% |
| TvInpainting | SCIPY | 3.15 | 3.27 | 3.50 | 3.15 | 11% | 11% |
| TvInpainting | COO | 3.31 | 3.35 | 3.57 | 3.31 | 8% | 8% |
| TvInpainting | DIFFENGINE | 1.06 | 1.08 | 1.20 | 1.06 | 14% | 14% |
| Cajas | CPP | 19.66 | 20.14 | 22.67 | 19.66 | 15% | 15% |
| Cajas | SCIPY | 2.92 | 2.69 | 2.91 | 2.69 | 8% | 8% |
| Cajas | COO | 3.17 | 2.79 | 2.89 | 2.79 | 4% | 14% |
| Cajas | DIFFENGINE | 1.06 | 1.06 | 1.07 | 1.06 | 1% | 1% |
| SlowPruning | CPP | 6.88 | 7.05 | 7.69 | 6.88 | 12% | 12% |
| SlowPruning | SCIPY | 6.85 | 7.03 | 7.82 | 6.85 | 14% | 14% |
| SlowPruning | COO | 7.58 | 7.87 | 8.60 | 7.58 | 13% | 13% |
| SlowPruning | DIFFENGINE | 2.15 | 2.25 | 3.01 | 2.15 | 40% | 40% |
| SmallMatrixStuffing | CPP | 6.52 | 6.47 | 6.97 | 6.47 | 8% | 8% |
| SmallMatrixStuffing | SCIPY | 7.20 | 6.63 | 7.09 | 6.63 | 7% | 9% |
| SmallMatrixStuffing | COO | 10.28 | 9.79 | 10.84 | 9.79 | 11% | 11% |
| SmallMatrixStuffing | DIFFENGINE | 2.77 | 2.72 | 2.76 | 2.72 | 1% | 2% |
| QuantumHilbertMatrix | CPP | 3.89 | 3.85 | 4.27 | 3.85 | 11% | 11% |
| QuantumHilbertMatrix | SCIPY | 3.80 | 3.70 | 4.05 | 3.70 | 10% | 10% |
| QuantumHilbertMatrix | COO | 4.47 | 4.35 | 4.75 | 4.35 | 9% | 9% |
| QuantumHilbertMatrix | DIFFENGINE | 1.64 | 1.62 | 1.67 | 1.62 | 3% | 3% (07-24 value was the 0.6.0-engine outlier, excluded in its own file) |
| ConeMatrixStuffing | CPP | 10.34 | 10.68 | 11.06 | 10.34 | 7% | 7% |
| ConeMatrixStuffing | SCIPY | 9.44 | 8.75 | 9.34 | 8.75 | 7% | 8% |
| ConeMatrixStuffing | COO | 16.49 | 16.06 | 16.99 | 16.06 | 6% | 6% |
| ConeMatrixStuffing | DIFFENGINE | 3.76 | 3.75 | 3.95 | 3.75 | 5% | 5% |
| SemidefiniteProgramming | CPP | 5.38 | 5.26 | 5.96 | 5.26 | 13% | 13% |
| SemidefiniteProgramming | SCIPY | 2.31 | 4.40 | 2.43 | 2.31 | 5% | 90% |
| SemidefiniteProgramming | COO | 3.53 | 3.50 | 3.78 | 3.50 | 8% | 8% |
| SemidefiniteProgramming | DIFFENGINE | 1.93 | 1.92 | 2.02 | 1.92 | 5% | 5% (07-24 value was the 0.6.0-engine outlier, excluded in its own file) |
| Murray | CPP | 5.79 | 6.11 | 7.13 | 5.79 | 23% | 23% |
| Murray | SCIPY | 3.73 | 3.74 | 3.87 | 3.73 | 4% | 4% |
| Murray | COO | 3.87 | 3.92 | 4.00 | 3.87 | 3% | 3% |
| Murray | DIFFENGINE | 3.43 | 3.56 | 3.72 | 3.43 | 8% | 8% |
| CVaR | CPP | 34.80 | 35.77 | 35.85 | 34.80 | 3% | 3% |
| CVaR | SCIPY | 27.32 | 26.95 | 24.79 | 24.79 | 0% | 10% |
| CVaR | COO | 26.68 | 25.96 | 26.86 | 25.96 | 3% | 3% |
| CVaR | DIFFENGINE | 25.31 | 26.47 | 24.94 | 24.94 | 0% | 6% |
| OptimalAdvertising | CPP | 6.06 | 5.87 | 6.43 | 5.87 | 10% | 10% |
| OptimalAdvertising | SCIPY | 2.18 | 2.02 | 2.32 | 2.02 | 15% | 15% |
| OptimalAdvertising | COO | 2.08 | 1.99 | 2.25 | 1.99 | 13% | 13% |
| OptimalAdvertising | DIFFENGINE | 5.20 | 5.12 | 2.36 | 2.36 | 0% | 121% |
| SDPSegfault1132 | CPP | 59.75 | 59.45 | 64.84 | 59.45 | 9% | 9% |
| SDPSegfault1132 | SCIPY | 10.12 | 10.01 | 9.51 | 9.51 | 0% | 6% |
| SDPSegfault1132 | COO | 40.14 | 41.46 | 43.00 | 40.14 | 7% | 7% |
| SDPSegfault1132 | DIFFENGINE | 12.47 | 14.10 | 13.21 | 12.47 | 6% | 13% |

## C. Cells flagged (a run more than 8% from its median, or printed single value more than 10% above the minimum of the three days)

### Replicates (A)
- Table 4.1 ParamSmallMatrixStuffing diffengine: runs 0.2524, 0.2137, 0.2085 -> max dev 18.1%
- Table 4.2 first ParamSmallMatrixStuffing diffengine: runs 0.2524, 0.2137, 0.2085 -> max dev 18.1%
- Table 4.2 first FactorCovarianceModel COO: runs 4.6608, 6.4538, 4.7625 -> max dev 35.5%
- Table 4.2 re-solve ParamSmallMatrixStuffing diffengine: runs 0.0014, 0.0014, 0.0016 -> max dev 10.9%
- Table 4.2 re-solve ParamConeMatrixStuffing tensor: runs 0.0032, 0.0028, 0.0028 -> max dev 14.5%
- Table 4.2 re-solve ParamConeMatrixStuffing diffengine: runs 0.0014, 0.0008, 0.0008 -> max dev 67.5%
- Table 4.1 ConvexPlasticity diffengine (later build, six runs): runs 0.8545, 0.9452, 0.8685, 0.9089, 0.9118, 1.0360 -> max dev 13.8%

### Cross-day (B), printed 08-08 value > 10% above the min of the three days
- UnconstrainedQP CPP: [9.32, 9.85, 10.32] -> printed is 11% above min
- UnconstrainedQP SCIPY: [6.47, 6.96, 8.52] -> printed is 32% above min
- UnconstrainedQP COO: [12.12, 12.08, 13.54] -> printed is 12% above min
- LeastSquares SCIPY: [9.16, 9.16, 10.08] -> printed is 10% above min
- Yitzhaki CPP: [3.07, 3.11, 3.56] -> printed is 16% above min
- Yitzhaki SCIPY: [2.8, 2.81, 3.28] -> printed is 17% above min
- Yitzhaki COO: [3.11, 3.07, 3.55] -> printed is 16% above min
- HuberRegression CPP: [10.97, 10.56, 12.05] -> printed is 14% above min
- HuberRegression SCIPY: [10.07, 9.55, 10.72] -> printed is 12% above min
- HuberRegression COO: [10.61, 10.47, 11.6] -> printed is 11% above min
- SimpleQP DIFFENGINE: [1.69, 1.71, 1.87] -> printed is 11% above min
- SimpleLP CPP: [30.07, 30.18, 37.57] -> printed is 25% above min
- SimpleLP COO: [27.23, 27.45, 30.96] -> printed is 14% above min
- SimpleLP DIFFENGINE: [5.29, 5.09, 6.12] -> printed is 20% above min
- TvInpainting SCIPY: [3.15, 3.27, 3.5] -> printed is 11% above min
- TvInpainting DIFFENGINE: [1.06, 1.08, 1.2] -> printed is 14% above min
- Cajas CPP: [19.66, 20.14, 22.67] -> printed is 15% above min
- SlowPruning CPP: [6.88, 7.05, 7.69] -> printed is 12% above min
- SlowPruning SCIPY: [6.85, 7.03, 7.82] -> printed is 14% above min
- SlowPruning COO: [7.58, 7.87, 8.6] -> printed is 13% above min
- SlowPruning DIFFENGINE: [2.15, 2.25, 3.01] -> printed is 40% above min
- SmallMatrixStuffing COO: [10.28, 9.79, 10.84] -> printed is 11% above min
- QuantumHilbertMatrix CPP: [3.89, 3.85, 4.27] -> printed is 11% above min
- SemidefiniteProgramming CPP: [5.38, 5.26, 5.96] -> printed is 13% above min
- Murray CPP: [5.79, 6.11, 7.13] -> printed is 23% above min
- OptimalAdvertising SCIPY: [2.18, 2.02, 2.32] -> printed is 15% above min
- OptimalAdvertising COO: [2.08, 1.99, 2.25] -> printed is 13% above min

## D. Decision (2026-08-22, William)

No meaningful run-to-run difference. Replicated cells (five parametric problems in Tables 4.1
and 4.2, ConvexPlasticity) now report the FASTEST of the three runs (six for the CP retime);
the 17 parameter-free rows stay single measurements from the 2026-08-08 run. fig:profiles(a)
rebuilt from the table's cells (plot_thesis_figures.py `_thesis_table_cells`). Cross-day minima
(section B) deliberately NOT used: different days and, for diffengine, different engine builds.
