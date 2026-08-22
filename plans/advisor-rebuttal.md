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
| 2026-08-19 | ch. 4 | 3 runs too few, suggested 100–350 | REBUT (done) | Kept 3-run medians, added variance sentence (3–5 % typical deviation). Evidence in log item 41. Expect a follow-up question at the defence. |
| 2026-08-19 | ch. 3 | Replicate ch. 4 "we" style across ch. 3 | DONE (verify) | We-voice pass done in §3.1–3.2. Re-read §3.3–3.4 for stray passive "is defined/is stored". |
| 2026-08-19 | §3.3.2 | Reorganize "Caching structure across solves" | KEEP, re-read | Rewritten (split once → patterns / layouts / maps → payoff). Biggest prose change of the pass, William to read closely before it is committed. |
| 2026-08-19 | ch. 3 end | Wrap-up + transition | KEPT trimmed | Recap sentence dropped, see R5. |
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

Position: kept 3-run medians. Typical deviation from the median 3–5 % (median 3.4 %, 90th
percentile 8.7 % over results/repl/*_param_rep{1,2,3}.json); the few larger deviations were
transients that single-problem probes did not reproduce. 100–350 runs at up to 20 min per
canonicalization is not feasible for the slow problems. Sentence added in the ch. 4 intro.

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

## 3. Recurring asks (his style rules, so they stop coming back)

- Reference floats in prose, never "(Figure X)" / "(Table X)" parentheticals.
- Say "we built / we wrote" where it is our work; no user-manual voice in ch. 3.
- No empty section between a chapter heading and its first \section.
- Define a term at first use (translator, driver, constructor, double dispatch).
- "Since" (causal) → "Because".
- Chapter wrap-up paragraph + transition to the next chapter.
- Be concrete about slow rows in any results table.
