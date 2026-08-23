# Advisor feedback — tracker and rebuttals

Started 2026-08-20. One place to remember what the advisor asked for, what was done, what is
still open, and where William wants to push back (with the text to send). The per-comment logs
stay where they are:

- `plans/document8-advisor-comments.md` — Document 8 review (2026-08-19), comments 1–46 with
  dispositions.
- `plans/litreview_advisor_comments_deferred.md` — Documents 4/5 review (2026-08-12), lit review.
- `plans/advisor-style-guide.md` — notation scheme (mathbb / bold vectors), 2026-07-30.

Conventions: one row per item. Status is one of TODO / DONE / KEPT (no change, reason given) /
REBUT (disagree, text drafted below) / DISCUSS (undecided, bring to next meeting).

## 1. Open items (things he told me to fix that are not settled)

| Date | Where | Advisor ask | Status | Notes |
|------|-------|-------------|--------|-------|
| 2026-08-19 | Abstract | Expand to up to a full page, more context and details | PARTIAL | ~3 sentences added, deliberately not a page. Paper version in `plans/abstract_paper_version.md`. Decide whether to say so explicitly or expand further. |
| 2026-08-19 | Abstract | "more info on sparsity" (comment 6) | DISCUSS | Unclear what he meant. First reading added "allocates every buffer" + "fixed patterns"; the buffer clause was cut 2026-08-21 (William). Ask at next meeting, see R6. |
| 2026-08-19 | §2.4 | Add a "Research gap" section closing the lit review | DONE 2026-08-21 | Headed §2.4 "Research gap" added: two-axis summary table (tab:systems-summary, AMPL/JuMP/CasADi/CVXPY backends/diffengine) + three ¶s (coefficients declared vs derived, cost of a parameter change, the two CVXPY gaps). R1 withdrawn. Chapter intro trimmed, its "why only CVXPY backends in ch. 4" sentence moved to the end of §2.4. |
| 2026-08-19 | ch. 4 | 3 runs too few, suggested 100–350 | REBUT (done), REVISED 2026-08-22 | Kept 3-run medians where they exist (Table 4.2 problems + CP). Provenance check 2026-08-22: the 17 parameter-free rows of Table 4.1 are single measurements (one run, 2026-08-08), so the caption now says so and the variance sentence moved to §4.2 where the replicates are. Evidence in log item 41 and R3. Expect a follow-up question at the defence. |
| 2026-08-19 | ch. 3 intro | "Not clear what the contribution is" (comments 18/19) | DONE, see R8 | Read as: not clear what is ours vs what existed (CVXPY, Eigen, BLAS, Gustavson), not that the ideas were unclear. Fixed by the new intro ("the C library we built", "Our contributions lie in the implementation. Firstly… Secondly…", "Neither the split nor the two classes exists in CVXPY's backends") and the we-voice in §3.1/§3.3/§3.4. No bulleted contribution list (house style). |
| 2026-08-19 | ch. 3 | Replicate ch. 4 "we" style across ch. 3; §3.1 "sounds like a user" | DONE 2026-08-22 | §3.1: first sentence stays descriptive ("SparseDiffEngine is a small C library…"), then "We implement each atom…" (expr.h/subexpr.h pair descriptive); §3.2, §3.3, §3.3.1, §3.4 carry "we" at the head of each part. See R9. |
| 2026-08-19 | §3.3.2 | Reorganize "Caching structure across solves" | KEEP, re-read | Rewritten (split once → patterns / layouts / maps → payoff). Biggest prose change of the pass, William to read closely before it is committed. |
| 2026-08-19 | Table 3.2 | Define the notation in the caption, with dimensions (his ink: "(A ∈ R^?×?, B ∈ R^?×? etc.)") | DONE / REBUT on dimensions, see R10 | Caption now defines A (Jacobian operand), B (data matrix), d (data vector), D = diag(d). No dimensions given on purpose: the kernels are written for general matrices, the sizes depend on the atom and the problem. |
| 2026-08-19 | Table 3.2 | "What happens if others are needed? OR is that all what DCP allows for?" (comment 28) | DONE, see R11 | Second reading is the right one: the ten kernels cover the whole library, so every atom a canonicalized DCP problem produces is covered. The hypothetical "an atom outside the ten would add a kernel" sentence was cut 2026-08-22. |
| 2026-08-19 | eq. (3.2) | "Is this notation introduced earlier?" (r_B, r_A, S_{r_B}…, comment 30) | DONE 2026-08-22 | The triple and the selectors are defined in §3.2.2 / (3.1); the letter subscripts were implicit. Now stated at (3.2): "the transposed product of A = (X_A, r_A, c_A) and B = (X_B, r_B, c_B) expands, with the selector matrices of (3.1), to…". Nothing to rebut. |
| 2026-08-19 | ch. 3 end | Wrap-up + transition | DONE 2026-08-22 | Now a headed §3.5 Summary (recap ¶ + the two design choices and hand-off), matching §2.4 and §4.3. R5 moot. |
| 2026-08-19 | Listings | Is "Listing" standard? Reference every listing in the text | DONE | Standard (listings package default, IEEE/ACM). All 11 listings now cited by number before the block. |
| 2026-08-19 | Clarabel | "already cited?" | KEPT | Re-cite at first named use is normal for numbered styles. |
| 2026-08-19 | §2.3 JuMP | Hint (margin, unnumbered) to combine the three opening ¶s of the JuMP subsection | REBUT | Kept separate, see R7. |

## 2. Rebuttals (text ready to send or to raise in a meeting)

### R1 — §2.4 "Research gap" (comment 17)

Position: the content already exists in three places (thesis goal at the end of §1.1,
contribution statement opening ch. 3, first paragraph of the conclusion), and a gap section
turns the neutral, descriptive lit review into an argument against AMPL/JuMP and the detection
methods. Proposal: close ch. 2 with a short synthesis paragraph (three starting points, no
argument), keep the gap in the ch. 3 opening, restate the synthesis in the conclusion.
Fallback if he wants a visible heading for the jury: one-paragraph §2.4 limited to the synthesis.

Draft message:

> Regarding the "Research gap" section (§2.4): I drafted it and I'd like to propose a different
> placement. Written out, the section repeats what is already stated in three places: the thesis
> goal at the end of §1.1, the contribution statement opening Chapter 3, and the first paragraph
> of the conclusion. It also pulls the literature review away from the neutral, descriptive tone
> we settled on, since the gap has to be argued against AMPL/JuMP and the detection methods
> rather than stated about them. My suggestion is to close Chapter 2 with a short synthesis
> paragraph (the three starting points that produce the same coefficient matrices, without
> arguing for one), keep the gap itself in the Chapter 3 opening where the contributions are
> claimed, and state the synthesis again in the conclusion. If you prefer a visible "gap"
> heading for the jury, I can keep a one-paragraph §2.4 limited to that synthesis. Would either
> of those work for you?

Status: not sent. 2026-08-20: William chose the proposal. §2.4 heading and argument removed,
replaced by an unheaded synthesis paragraph closing ch. 2; the two gaps now sit in the
conclusion's first paragraph. Cut text archived in plans/research_gap_cut.md.
WITHDRAWN 2026-08-21: William chose to follow the advisor after all. The headed §2.4 is back,
built around a two-axis summary table (how the coefficients are obtained / what a parameter
change costs) rather than an argument against AMPL/JuMP, so the tone concern is moot. Nothing
to send.

### R2 — "Listing" wording (comment 12)

Position: "Listing" is the standard term in English technical writing (default of the LaTeX
`listings` package, used by IEEE/ACM/Springer), and "Algorithm" is reserved for pseudocode,
which is how the thesis already splits them. Caption format matches Figure/Table. No change.

### R3 — Number of benchmark runs (comment 41)

Position: kept 3-run medians where they exist. Typical deviation from the median 3–5 %
(median 3.4 %, 90th percentile 7.5 % over results/repl/*_param_rep{1,2,3}.json); the few
larger deviations were transients that single-problem probes did not reproduce. 100–350 runs
at up to 20 min per canonicalization is not feasible for the slow problems.

Revised 2026-08-22 after a provenance check (log item 41): only the seven Table 4.2 problems
and ConvexPlasticity have three runs; the 17 parameter-free rows of Table 4.1 are single
measurements from the 2026-08-08 run, which reproduced two earlier runs of the suite (07-11,
07-24) within 6.5 % (median) / 16 % (90th pct) of the three-run median, with no conclusion
moved (17-row geomean 0.32 vs 0.34, CVaR the only winner flip and a tie either way). The
thesis now says this plainly: Table 4.1 caption distinguishes the median rows from the single
measurements, the variance sentence sits in §4.2 (re-solves above 0.1 s within 7 %, first
canonicalizations within 8 % but for two runs). If he presses: the honest answer is "three
runs for the parametric problems, one run for the rest, the earlier runs agree within the
stated spread", not "medians everywhere". Later 2026-08-22 (William): replicated cells report
the fastest of the three runs, since the spread is immaterial (per-cell report in
plans/variance_report_20260822.md); fig:profiles(a) rebuilt from the same cells as Table 4.1.

### R4 — Abstract length (comment 1)

Position: added context, authorship ("We built…"), sparsity detail, and numbers, but kept it
under a page on purpose. If he insists, the material to expand with is the paper version in
`plans/abstract_paper_version.md`. Note: adding the numbers (comment 7) reverses the earlier
"no results in the abstract" choice of 2026-08-14; the advisor's ask wins here.

### R5 — Chapter 3 wrap-up (comment 33)

Position: the closing paragraph keeps what the advisor asked for, the recall of the difference
with the reviewed backends and the transition to chapter 4, but not a recap sentence ("This
chapter described the engine from its expression nodes up to…"). House style: no framing
sentences, each claim once. If he wants the recap back it is one sentence.

WITHDRAWN 2026-08-22: the wrap-up was promoted to a headed §3.5 "Summary" with a four-sentence
recap ¶, because ch. 2 and ch. 4 both close on a headed section and a summary section may
summarize without breaking the framing rule. Nothing to send.

### R6 — Abstract "more info on sparsity" (comment 6)

Position: William does not know what the advisor meant. Candidate readings: (a) say *how*
the sparsity patterns are found (directly from the expression structure, no detection or
colouring), (b) say that the patterns are fixed across solves and only the values change,
(c) say why sparsity matters here (the matrices are large and mostly zero). The abstract
currently covers (b) ("fills new values into the fixed patterns") and half of (a) ("computes
both matrices directly from the expression structure"); the "allocates every buffer" clause
added on 2026-08-19 was cut on 2026-08-21 as noise. Bring the three readings to the meeting
and let him pick; each is one sentence, none needs more.

### R7 — JuMP subsection opening paragraphs (unnumbered hint, Document 8)

Position: keep the three paragraphs (overview / how MOI stores coefficients / running example)
separate. Every reviewed system in §2.3 follows the same three beats: AMPL is overview →
translator and driver → `.nl` format → example, CasADi is overview → SX/MX graphs → Jacobian
assembly. JuMP matches that shape, and merging would make it the one subsection without it.
The first paragraph is description (origin, users, solver count, MOI as the layer) and the
second is mechanism (macros rewrite on entry, typed term lists, function-in-set); merged they
run ~17 lines on two topics. The third is the example beat and is followed by two listings,
each introduced by its own sentence (comment 12), so it needs its own block regardless.

Draft message:

> On the suggestion to merge the opening paragraphs of the JuMP subsection: I kept them
> separate so that the three systems in §2.3 read in the same three beats (what the system is,
> how it holds the coefficients, the running example). AMPL and CasADi follow that shape, and
> the first two JuMP paragraphs are different kinds of content, description versus the MOI
> storage mechanism. The third introduces the two listings. Merging would make JuMP the one
> subsection that reads differently. I'm happy to tighten the hand-off between the first two
> paragraphs instead if the seam is what bothered you.

Status: not sent. 2026-08-21: hand-off tightened anyway (¶1 now ends on the solver count,
MOI sentence moved before it), so the offer in the last line is already done.

### R8 — Chapter 3 contribution "not clear" (comments 18/19)

Position: the Document 8 opening ("Mathematically, SparseDiffEngine computes the same
derivatives as CVXPY's backends… The differences are in the implementation") never said that
we wrote the library, and §3.1 read like a user manual ("The expression node is defined in
expr.h"). A reader outside the project could take ch. 3 for a description of an existing C
library, the way §2.3 describes AMPL or CasADi. So the comment is about authorship and what
is new, not about the ideas being unclear. William's reaction ("it seems pretty clear to me")
is expected: he knows what is his, and the text he re-read already carried the fix.

What answers it now: chapter intro sentences 1 ("the C library we built"), 5 ("Our
contributions lie in the implementation. Firstly… Secondly…") and last ("Neither the split
nor the two classes exists in CVXPY's backends"), plus first person at the head of §3.1,
§3.3, §3.3.1 and §3.4 (2026-08-22). Same fix family as item 20 (§3.1 voice) and item 35
(ch. 4 "be explicit this is what you built").

The p. 41 version of the note ("So far, not clear (3.1, 3.2, 3.3) what is your contribution,
new vs. exists in lit. If new, should be easier to see it.") adds the "vs. lit" half. Where
that comparison lives: §2.4 (four-system table; two phases shared with CasADi, direct
composition shared with CVXPY, dense blocks and the two-pass parameters new), the ch. 3 intro
(neither the two-phase approach nor the two classes exists in CVXPY's backends), and §3.5.
Inside ch. 3 the borrowed pieces are named as such (CSR of §1.4.2, Gustavson's algorithm
cited, BLAS dgemm, Eigen/scipy as the backends' libraries). The one literature contrast not
in the text is blocked storage vs. permuted dense (supernodal/multifrontal, BSR/OSKI), cut
from §3.2.2 on 2026-08-09 by William because it raised questions a methodology chapter does
not need (plans/theme1_related_work_cut.md).

William's view (2026-08-22): the comment is not true of the current text. Assessment: it
was a fair presentation comment on Document 8 (no authorship markers in §3.1–3.3, "the
differences are in the implementation" without "ours"), and it is answered now.

If raised again: point at the intro sentences and §2.4. Do not add a bulleted contribution
list; flat prose is the house style and the two contributions are already named in order.
Fallback, only if he insists on a literature contrast inside §3.2.2: the two load-bearing
sentences of the cut paragraph ("In these systems the blocks are discovered in the data.
Here they are known from canonicalization."), without the five citations.

Draft message, if he asks again:

> On "not clear what is new vs. what exists": the chapter now opens by stating the two
> contributions and that neither exists in CVXPY's backends, the new representations are
> introduced as ours where they are defined, and §3.5 restates the two differences. The
> comparison with the other systems sits in §2.4, which closes the literature review with
> the table of how each obtains and reuses the coefficients, so that chapter 3 stays a
> description of the engine. The pieces we reuse (CSR, Gustavson's algorithm, BLAS) are
> named and cited where they appear.

Status: nothing to send, addressed in the text. 2026-08-22.

### R9 — §3.1 voice (comment 20)

Position: the first sentence of §3.1 ("SparseDiffEngine is a small C library, around
seventeen thousand lines…") stays descriptive, because the intro two paragraphs earlier
already says "our C library", "Our contributions lie in the implementation", "We introduce
two new matrix classes". One code-layout sentence carries the first person ("We implement each atom in its own
file"; the expr.h/subexpr.h pair stays descriptive so the two match), as do
the heads of §3.2, §3.3 and §3.4 (we store, we define, we implement each kernel as a pair, we
select by double dispatch, we collect, we wrote everything specific to CVXPY).

If raised again: "We wrote SparseDiffEngine as a small C library…" on the first sentence is
the one remaining change.

Status: nothing to send. 2026-08-22.

### R10 — Table 3.2 notation and dimensions (comment 27)

Position: the caption defines the four symbols by role (A the Jacobian operand, B a data
matrix, d a data vector, D = diag(d)), which is what was missing. It does not give
dimensions, because the kernels operate on general matrices: the same BA kernel multiplies a
Jacobian with n_vars columns and as many rows as the node has entries by whatever data
matrix the atom carries, and A, B take different sizes at every call site. Writing
A ∈ R^{m×n}, B ∈ R^{p×m} in the caption would introduce three symbols used nowhere else in
the chapter, and would conflict with m, n already used in §3.2.2 for the global dimensions
of one permuted dense matrix. Dimensions are stated where they matter, in (3.1) and (3.2).

Draft message, if he asks again:

> On Table 3.2: I defined A, B, d and D in the caption. I left the dimensions out on
> purpose, because the kernels are written for general matrices whose sizes depend on the
> atom and the problem, so there is no fixed m × n to state. The only requirement is
> conformability, and the places where sizes matter, equations (3.1) and (3.2), state them.

Status: nothing to send. 2026-08-22.

### R11 — Are the ten kernels all that DCP needs? (comment 28)

Position: yes. The ten operations of Table 3.2 cover the whole library, all ~45 atoms
including the NLP-only classes, verified by grep over SparseDiffEngine/src/atoms on
2026-08-10 (every Jacobian routine calls one of the ten _alloc/_fill_values pairs). A
canonicalized DCP problem reaches the engine with affine atoms and quadratic forms only
(§3.1.1), a subset of that, so no atom it can produce needs a kernel outside the table. The
text states it as "The ten operations of Table 3.2 cover the whole library". The earlier
answer to the first half of the question ("an atom with an operation outside the ten would
add a kernel of its own") was a hypothetical about a library that does not exist and was
cut on 2026-08-22.

Draft message, if he asks again:

> On the kernels table: the ten operations are all the library needs. Every atom in
> SparseDiffEngine, including the nonlinear ones used only by CVXPY's NLP interface,
> computes its Jacobian through one of them, and a canonicalized DCP problem only produces
> affine atoms and quadratic forms, which is a subset. So there is no atom that DCP allows
> and the table does not cover.

Status: nothing to send. 2026-08-22.

## 3. Recurring asks (his style rules, so they stop coming back)

- Reference floats in prose, never "(Figure X)" / "(Table X)" parentheticals.
- Say "we built / we wrote" where it is our work; no user-manual voice in ch. 3.
- No empty section between a chapter heading and its first \section.
- Define a term at first use (translator, driver, constructor, double dispatch).
- "Since" (causal) → "Because".
- Chapter wrap-up paragraph + transition to the next chapter.
- Be concrete about slow rows in any results table.
