# Proposals: design and results, without attributing the speedup

Framing: the thesis describes the design choices and their motivation, and reports the
measured results and the ablation plainly. It doesn't claim which component produces the
speedup. Design rationale ("we keep dense blocks so that BLAS can process them") stays as
motivation. Only sentences that link a component to the measured speedup change.

Nothing below is applied yet. Mark each proposal (P1–P8) **yes**, **no** or **edit**.

---

## P1. Abstract (`3-Abstract.tex`) and résumé (`3-Resume_sujet.tex`): the re-solve sentence

Current, abstract:
> Re-solving a parametrized problem therefore costs only one numeric pass.

Proposed:
> A re-solve of a parametrized problem therefore skips the symbolic pass.

Why: "costs only one numeric pass" is a cost claim, and §4.2 measures the numeric pass at 3–20 %
of a re-solve. The proposed sentence describes what the design does.

Current, résumé:
> Pour un problème paramétrique, seule la phase numérique est répétée d'une résolution à l'autre.

Proposed: **no change.** It already says what is repeated and makes no claim about cost. Ch. 3
(`7-Theme1.tex:927`, "involves only the numeric pass") likewise describes the engine's work, so
it stays.

## P2. Ch. 3 opening (`7-Theme1.tex:22–24`): the "other design decisions"

Current:
> Other important design decisions differ from \texttt{CVXPY}'s backends. We made them for
> simplicity, but together with the implementation in C, they account for most of the speedup
> measured in \S\ref{sec:bench-oneshot}. Every node carries one Jacobian …

Proposed:
> Other important design decisions differ from \texttt{CVXPY}'s backends. We made them for
> simplicity. Every node carries one Jacobian …

Why: this is the clearest attribution in the thesis, and none of these choices was ablated.

## P3. Ch. 3 summary (`7-Theme1.tex:963`)

Current:
> This chapter presents our approach to canonicalizing optimization problems faster.

Proposed:
> This chapter presents our approach to canonicalizing optimization problems.

Minor. "Faster" is a result claim placed before the results.

## P4. §4.1, the "further experiments" paragraph (`7-Theme2.tex:174–185`): against CVXPY

Current (middle part):
> … The dense blocks make it $1.4$ to $3.0$ times faster on ten problems, but $47$ and $5.1$
> times slower on UnconstrainedQP and ConvexPlasticity. Without them, \texttt{diffengine} is
> still $2.17$ times faster than the best \texttt{CVXPY} backend, so most of the speedup comes
> from the rest of the implementation; the split plays no part, since a first canonicalization
> runs each pass once. …

Proposed:
> … Against the best \texttt{CVXPY} backend, the dense blocks take \texttt{diffengine} from
> about $3$ to about $7$ times faster on six problems with dense data, and from $4$ times faster
> to $11.8$ times slower on UnconstrainedQP (Table~\ref{tab:app-nodense}). Over the suite,
> \texttt{diffengine} is $2.17$ times faster than the best \texttt{CVXPY} backend without them
> and $2.33$ times with them. The split is not ablated here, since a first canonicalization
> runs each pass once. …

Why: the effect is stated against the reference the reader cares about, CVXPY, using the
numbers of the extended Table A.7 (P7). It shows the large gain where the data is dense and
the large loss on UnconstrainedQP side by side, without attributing the rest of the speedup.
"So most of the speedup comes from the rest of the implementation" is dropped. The rest of the
paragraph (the Wilcoxon test, sizes, density, memory limit) stays.

The numbers behind it (`results/thesis-final/facts.json`, `ablation.nodense_vs_best` and
`nodense_cold`), as ratios to the best CVXPY backend, with / without dense blocks:
- LeastSquares, HuberRegression, SimpleQP, FactorCovarianceModel, SVMWithL1Regularization and
  Yitzhaki: 0.14–0.17 / 0.27–0.37, i.e. 5.9–7.1× against 2.7–3.7× faster.
- ConeMatrixStuffing and SmallMatrixStuffing: 0.30 / 0.81–0.89. The 3× gain on these two,
  whose A is close to diagonal, is unexplained. Expect a question.
- SDPSegfault1132 1.35 / 2.36; SimpleLP 0.18 / 0.25; 13 problems barely move (0.97–1.23).
- CVaR 0.66 / 0.42; ConvexPlasticity 6.94 / 1.36; UnconstrainedQP 11.76 / 0.25.

## P5. Discussion (`7-Theme2.tex:294–295`): the last sentence of the DPP paragraph

Current:
> With our approach, a similar speedup can be obtained through the symbolic and numeric split
> without enforcing any rules about how parameters appear in the problem formulation.

Proposed:
> With our approach, a parametric problem is re-solved without building the tensor and without
> any rules about how its parameters appear, at re-solve times within a factor of four of the
> tensor on the \ac{DPP} problems of the suite.

Why: "a similar speedup" isn't what Table 4.2 shows. The tensor's re-solve is 30–70× faster
than its own first canonicalization, and `diffengine`'s about 2×. The proposed sentence states
what was measured.

## P6. Response table (`plans/final-revisions.md`), reply "Why the speedup (ii)"

Current:
> §4.1 now says it: without dense blocks the engine is 1.07× slower … Most of the speedup
> therefore comes from the rest of the implementation (C, one Jacobian per node over all
> variables, no materialized views, no tensor). The dense blocks add about 2× on the problems
> with dense data and cost 47× on UnconstrainedQP and 5.1× on ConvexPlasticity (Table A.7), so
> over the suite they are not a net gain.

Proposed:
> §4.1 and Table A.7 report the ablation against CVXPY without interpreting it. Over the suite,
> the engine is 2.17× faster than the best CVXPY backend without dense blocks and 2.33× with
> them; the difference between the two is 1.07× and not significant (Wilcoxon p = 0.07). Per
> problem the effect is large in both directions. On six problems with dense data, the dense
> blocks take the engine from about 3× to about 7× faster than CVXPY. On UnconstrainedQP they
> take it from 4× faster to 11.8× slower, and on ConvexPlasticity from 1.4× to 6.9× slower.
> The split plays no part in a first canonicalization. We do not attribute the remaining
> speedup to one component: the engine is one design, and only the dense blocks and the split
> have switches that can be turned off.

## P7. Table A.7 (`9-Annexes.tex`, `tab:app-nodense`): add the comparison with CVXPY

Add two columns after the existing ratio: the ratio of `diffengine` to the best CVXPY
backend, with and without the dense blocks, under a `\multicolumn{2}{c}{to best \texttt{CVXPY}}`
header (sub-headers "with", "without"). The geometric-mean row gets $0.43$ and $0.46$. The
values come from `facts.json`, so no new runs are needed. Add one sentence to the caption: "The
last two columns are the ratio of \texttt{diffengine} to the best \texttt{CVXPY} backend of
Table~\ref{tab:oneshot-compile}, with and without the dense blocks." Generate the column in
`thesis_numbers.py` (benchmarks repo), so the table stays reproducible.

## P8. §5.2 (`8-Conclusion.tex`, the re-solve paragraph): the conversion cost applies to both paths

Current:
> … most of a re-solve goes to converting the engine's output to the solver's format
> (\S\ref{sec:bench-param}), although the sparsity patterns do not change between re-solves.
> Computing this conversion once, in the symbolic pass, would let a re-solve write the new
> values directly into the final matrices.

Proposed: append one sentence.
> The re-solve of the tensor rebuilds its matrices in the same way, so the same change would
> speed up both.

Why: the profiles of 16 Oct show that the conversion is 70–95 % of the tensor's re-solve as
well. A precomputed gather would bring both close to their core cost: the numeric pass for
`diffengine` and one sparse matrix-vector product for the tensor. Without this sentence, a
reader could take the future-work item as an advantage of `diffengine` over the tensor.

Response table, "Where to direct effort": add the measured bound. A precomputed gather
reproduces A exactly and reduces the estimated `diffengine` re-solve to 10–190 ms on the five
problems where the tensor is faster today. Applied to the tensor as well, it would leave the
tensor as fast or faster on all five (estimated from the two profiles).

## Left unchanged, and why

- **Abstract and Introduction, contribution 1:** "keeps the dense blocks … and processes them
  with BLAS". This describes the design, not its effect.
- **Ch. 3 opening:** "The first exploits the fact that the data … is … structured, with dense
  blocks". This is design motivation.
- **Conclusion:** "No modelling language … keeps dense blocks as they are. To address this, we
  built …". This states the research gap and the design response, not a measured gain.
- **§4.3:** "cvxcore can be replaced" and "little reason to use cvxcore". These are a separate
  question (how strong the replacement claim is), not attribution. They are listed in the review
  for William and not part of this framing.
