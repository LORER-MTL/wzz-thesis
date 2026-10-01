# Legrain revisions — deferred experimental plan (items ii–vi, Appendix A)

All of this happens in the harness `Jacobian-accumulation/canonicalization`, with one pinned
engine commit and the fork `Transurgeon/cvxpy@b7bb765`.

- **(v) Dimensions.** Extend `run_worker` (`run_backend_benchmarks.py:365-373`) to record
  n, m, nnz(A), nnz(P), and the number of parameter objects and entries. Cross-check against
  `results/sparsity_metrics.json`.
- **(vi) Phase breakdown.**
  - Expose the `prob->stats` timers (`SparseDiffEngine/src/problem.c:245-604`) through a
    Python binding (`SparseDiffPy/.../make_problem.h`).
  - Add a BLAS timer under a profile build flag.
  - Add `perf_counter` stages in `DiffEngineExtractor.build/extract` and around cone
    formatting. The pattern to follow is in `probes/probe_hierarchical_trace.py:62-159`.
  - Phases: CVXPY front end / conversion to C / symbolic / numeric (of which BLAS) /
    CSC + formatting.
- **(ii) Ablation.** Add an env var `DIFFENGINE_NO_DENSE`. It raises
  `SPARSE_DENSITY_THRESHOLD` above 1 for constants in `diff_engine/converters.py:67-85`
  and in the `quad_form` branch (141-153). Add a `DIFFENGINE_SPARSE` pseudo-backend.
  Parametric matrices stay dense, which gets a footnote.
- **(iv) Replicates.** Add `BENCH_REPS=5`, each rep in a fresh subprocess, with the JSON
  recording mean, std and raw values. Rerun Tables 4.1 and 4.2.
- **(iii) Non-DPP.**
  - Re-solve experiments on `ConvexPlasticity` and on one purpose-built, clearly non-DPP
    parametric problem.
  - Baseline: CVXPY re-canonicalizing from scratch on every solve.
- **Ch. 4 rewrite** (in `ALblock`):
  - Methodology (reps, pinned versions).
  - A size column and ± column in Table 4.1, plus the ablation column.
  - A new Ablation section.
  - A new "Where the time goes" section on CVaR, OptimalAdvertising, SDPSegfault1132 and
    ConvexPlasticity, reusing `plans/sdpsegfault_analysis_20260822.md`.
  - Non-DPP rows in the re-solve table.
  - Qualify the discussion claims.
- **Appendix A catalogue** (`9-Annexes.tex`; uncomment `Document.tex:328-331`):
  - A landscape `longtable`, one row per problem: the one-sentence summary, n, m,
    nnz(A), nnz(P), parameters, DPP status, time, and a TikZ stacked bar `\phasebar{...}`
    of the phase shares, patterned so it isn't colour-only.
  - The body is generated from the JSON by a script.
