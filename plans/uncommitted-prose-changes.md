# Prose changes from the 2026-08-19 advisor pass, left uncommitted for William's review

Verdicts 2026-08-20 (plan executed): everything below is KEPT except three trims: ch. 3 roadmap
sentence "Each section describes one layer…" dropped; ch. 3 wrap-up recap sentence dropped (R5);
ch. 4 §4.1 dev-build timing sentence (0.9 s, 2.6×) cut. §2.4 replaced by a synthesis ¶ (R1).

Mechanical part committed 2026-08-20 as 6b9aa93. Everything below is still only in the working
tree (`git diff` against 6b9aa93). Each line: where, what, which advisor comment
(# = item in plans/document8-advisor-comments.md). Move a line to plans/advisor-rebuttal.md
only when William says so.

## Abstract / résumé (#1–#7)
- Opening sentence on modelling languages added; "Since" → "Because"; "We built
  SparseDiffEngine … and the new backend on top of it"; symbolic pass "allocates every buffer",
  numeric pass "fills new values into the fixed patterns"; numbers added (25 problems, fastest on
  21, 2.7× geometric-mean speedup, re-solves comparable to parameter caching). Résumé mirrors it.
  Deliberately NOT a full page (#1 PARTIAL).

## Lit review, ch. 2
- §2.3 AMPL: "The name AMPL denotes both the modelling language and the commercial system" (#11);
  translator/driver paragraph rewritten to define both terms (#9).
- §2.4 Research gap, three paragraphs, new (#17). Under discussion, see rebuttal R1.

## Ch. 3
- Chapter opening rewritten: "This chapter presents SparseDiffEngine, the C library we built…",
  "Our contributions lie in the implementation", closing "Neither the split nor the two classes
  exists in CVXPY's backends" (#18).
- Roadmap: "Each section describes one layer of the engine…"; "Next, we".
- We-voice: "We wrote SparseDiffEngine as a small C library…" (§3.1), "We store the Jacobian…",
  "We define a permuted dense matrix…", "We define a stacked permuted dense matrix…" (#19, #20).
- Constructor defined at first use: "Each atom also has a constructor, the C function that
  allocates its expression node" (#23).
- Eigen vs scipy: "and the two sparse libraries behind CVXPY's backends differ on it" (#26).
- Kernels: "An atom with an operation outside the ten would add a kernel of its own, implemented
  for each representation it must support" (#28).
- §3.3.2: new fig:sparse-product-passes (symbolic/numeric panels of a sparse product), 2026-08-22.
- §3.3.2 Caching structure across solves reorganized: split defined once → three cached kinds
  (sparsity patterns / block layouts / index maps) → payoff ¶ (its framing opener cut 2026-08-22)
  (#31).
- Chapter wrap-up paragraph after Listing 3.3: two design choices vs §2.1 backends, hand-off to
  ch. 4 (#33).

## Ch. 4
- Chapter opening: "This chapter measures the system we built in Chapter 3. We compare our
  canonicalization backend diffengine, whose lower-case name distinguishes it from the
  SparseDiffEngine library underneath it…" (#35).
- "We exclude the solver because the choice of backend affects only canonicalization" (#36).
- Variance sentences: median of three runs, 3–5 % typical deviation, larger deviations were
  transients (#41, pushed back on 100–350 runs). 2026-08-22: CUT from the intro; Table 4.1
  caption/notes now distinguish the median rows (Table 4.2 problems + CP) from the 17 single
  measurements; variance sentence moved to §4.2 (re-solves above 0.1 s within 7 %, first
  canonicalizations within 8 % but for two runs). See log item 41. Later 2026-08-22: replicated
  cells switched to the FASTEST of three runs (Tables 4.1/4.2, captions, notes, §4.2 sentence),
  CP ‡ fastest of six (0.85, ratio 2.48), CP old-build 2.03 s, dagger-row CPP cells to the
  archived file values (2.22 / 11.51), fig:profiles(a) rebuilt from the table's cells,
  profile prose 92–96 %. Geomean 0.36 and abstract 2.8× unchanged. Daggers removed from both
  tables; protocol sentence in the chapter intro instead.
- §4.1 slow rows: CVaR/OptimalAdvertising ties within spread; SDPSegfault1132 constant-data
  copies; ConvexPlasticity dense-ingested diagonal, dev build 0.9 s ≈ 2.6× CVXPY backends,
  Python-side reductions dominate (#42).
- 2026-08-21: Table 4.1 ConvexPlasticity row → 0.91 s / 2.63 (‡ later-build note), geomean 0.36,
  §4.1 "within 3×", CP sentences point at the note; abstract/résumé 2.8×; fig:profiles regenerated.
- Performance profile explained: "A performance profile compares the backends over the whole
  suite at once"; "Let t_{p,s} be…" (#39); value at τ=1 and where the curve reaches 1 (#40);
  "of the suite" → "of the problems".
- §4.2: names SVMWithL1Regularization and FactorCovarianceModel; SVM parameter = single
  regularization weight touching one coefficient; "nevertheless" (#42).
- §4.3 bullets 1–2: evidence added (re-solve within ~2× of the tensor while ignoring the ruleset;
  two tensor builds timed out, every first canonicalization slower than the split) (#44).

## Conclusion
- Whole chapter drafted (summary ¶s, Limitations, Future Research with Maros–Mészáros and
  PGLib-OPF); one-sentence overview before §5.1 (#46).

## Also uncommitted
- Document.pdf (built from the full working tree).
- plans/advisor-rebuttal.md, plans/document8-advisor-comments.md update, this file.
