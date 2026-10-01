# Deck comments: the advisor's annotated PDF (2026-09-29)

Source: `presentation_ALL_9457.pdf`, the build of `presentation.tex` from the working tree of
2026-09-29 (69 pages), annotated by hand on an iPad. The ink is flattened, so there are no PDF
annotations to extract, and every comment below was read off the page. Pages are PDF pages;
slide numbers are the footer's. Line numbers are as of the working tree on 2026-09-29 and will
drift.

Timings written on the deck: **7:00** at Canonicalization (slide 9), **16:03** at CSR (23),
**25:10** at Performance profile (30), **30:31** at Thank you (34). That is five minutes over the
25:25 budget of `plans/defence_timing.md`, with the Results section on pace and the
Introduction/Example running long.

---

## Cross-cutting

- [x] **Punctuation.** On about 25 frames the advisor added `;` at the end of every bullet and
  `.` after the last one, and a `.` after display equations (`g_j(x) = 0.`, `∈ K.`, `x ≥ 0.`).
  Apply this to every presented itemize and display. Sub-bullets follow the same rule inside
  their own list. Slide 18's lead ("…values of the parameters") takes a `:` since a listing follows.
- [x] **`\texttt`** for the solver names on slide 6 (Gurobi, MOSEK, COPT, Clarabel, SCS, HiGHS)
  and for "CVXPY" on the Atoms lead (slide 13). Also fix the plain "CVXPY" in the CSR bullet
  (circled on slide 23). Use `\cvxpy{}`.
- [x] **Slide count.** "start appendix here to remove from slide count" (References, p51): move
  `\appendix` and the backup footline to before the References frames.
- [x] **"modeling" vs "modelling"** (circled on Takeaways): the deck says "modelling" everywhere
  else. The two titles in References stay as their authors spelled them.

## Per frame

- [x] **Title** (p1). "October 2nd" → "October 2, 2026". "Research director" → "Research
  supervisor" (the advisor wrote "supervisor or advisor"). "→ add jury": list the jury from
  `0-Definitions_Etudiant.tex` (Le Digabel, president; Lesage-Landry, supervisor; Legrain,
  member).
- [x] **Convex optimization in practice** (p9–12, slide 6). "bigger if possible": the frame
  ran at `\fitfig`'s 0.70\textheight cap. Raise the cap for this frame.
- [x] **Canonicalization** (p18, slide 9). "contributions should be stated at this point, even if
  not all is introduced". → A new **Contributions** frame closes the Introduction, right after
  *Problem statement*. It gives the thesis's §1.5 list, stated in the deck's vocabulary.
  **Decision taken:** after *Problem statement* rather than straight after *Canonicalization*,
  so the contributions land once the backend's job is on screen; it is still at ~8:00.
- [x] **Problem statement** (p20, slide 10). "à quoi fait référence ça?", with arrows from "left:"
  and "right:" to the two figures. → The bullets name the two figures ("the forest of
  expression trees", "the matrix") instead of pointing by position.
- [x] **Fitting with regularization** (p22, slide 12). "Example:" → retitled "Example: fitting
  with regularization".
- [x] **Canonicalization: the backend / Parameters in the CVXPY backend** (p27, p29). "distinction
  between scalar and vector/matrix 0s and 1s?" → block zeros print as bold **0**; the scalar
  entries 1 and −1 stay upright.
- [x] **Overview** (p32–33, slide 22). "why C? Be ready for an answer to this. Part of your title,
  so it should be argued." → one grey line on the frame (the thesis's own reason,
  7-Theme1.tex:937-942: small, no dependency beyond BLAS, control over memory and formats,
  callable from Python and any other language), and a Q&A answer below. "overview for intro,
  contributions (statement) for core of presentation": the Introduction now carries the
  contributions frame, so Overview keeps its role as the opener of the core section.
- [x] **Benchmark setup** (p45, slide 29). "ignore_dpp=True: what is that? and why set to this
  here?" → a grey comment in the listing plus a line under it: DPP caching off, so every
  backend does a full canonicalization; the parametric comparison is separate (backup 15).
- [x] **Performance profile** (p46, slide 30). "thicker for presentation?", "box on". →
  Regenerate deck copies of the two profiles with thicker lines and a full axes frame
  (`images/*_deck.pdf`). The thesis figures stay untouched.
- [x] **Peak memory** (p47, slide 31). "bigger, same size as previous and same comments" → the
  deck copy at the same 0.72\textwidth. "C00 (zero-zero) versus letter O?": in this typewriter
  font, COO reads as C-zero-zero. → In the legends, use the sans font for backend names; on
  the slides, say it out loud once on Setup. (No font change in the deck body: every
  `\texttt` would move.)
- [x] **Takeaways** (p49, slide 33). "goal: learn how CVXPY works internally", marked "provide the
  necessary background, not teach you about CVXPY; that's not a contribution". → The summary
  lists contributions: the matrix representations, the split, the backend and the benchmark.
- [x] **Thank you** (p50): the advisor's expected questions go into Q&A prep (below).
- [x] **Backup 4, DPP** (p56). "ignore dpp → true? looks like no DPP, no?" → bullet 3 now says
  what `ignore_dpp=True` does in one clause, and that it is the path of the main benchmark.
- [x] **Backup 6, research gap** (p58). "is the two-split really advantageous, or is it the matrix
  format that does the job?" → Q&A prep. There is no on-slide change: the honest answer
  needs the ablation (Legrain item ii), which has not been run.
- [x] **Backup 10, addition** (p62). A "?" on "The dense representations are sticky in the other
  direction". → Reworded plainly.
- [x] **Backup 15, parametric** (p67). "why worse?" on SVMWithL1Regularization and
  FactorCovarianceModel → Q&A prep. The grey line under the table stays.
- [ ] **Timing.** Five minutes over. Not cut in this pass: which frames go is your call. The
  first candidates are the ones the budget card already marks as twins between Introduction
  and Example.

---

## Q&A prep: the advisor's questions, with the answers the thesis supports

**Why C?** The title says so, so have the argument ready. The engine is a small library, about
17k lines, with no dependency but BLAS (7-Theme1.tex:37, :937-942). Writing the matrix classes
ourselves is what made permuted dense possible at all: Eigen and scipy.sparse fix the formats
and kernels, which is the limitation of §2 (6-Revue_litterature.tex:492-497). C gives full
control over allocation, which is what lets the numeric pass allocate nothing. And a C ABI
binds from Python (`sparsediffpy`) and from any other modelling language, whereas C++ would
tie it to one ABI and a template library. It is also the language of the solvers it feeds.

**Is the benchmark sensitive to the choice of solver?** No. `get_problem_data` stops before the
solver is called, and the solver is excluded from every number (7-Theme2.tex:44-47). The
solver only fixes the target cone format, and Clarabel's is the standard one (P, A, b, c,
cones). A different conic solver changes only the formatting step, which is the same for all
four backends.

**DPP?** Disciplined parametrized programming: see backup 4. The main benchmark passes
`ignore_dpp=True`, so every backend does a full canonicalization with the parameter values
substituted: a like-for-like one-shot comparison. The DPP path (the cached tensor) is compared
separately, on the seven parametric problems (backup 15).

**Why not advantageous on 4 problems?** (CVaR, OptimalAdvertising, SDPSegfault1132,
ConvexPlasticity; backup 16.) On CVaR and OptimalAdvertising the times are within 5% of the
best backend, so it is a tie. On SDPSegfault1132 and ConvexPlasticity, processing dense
constant data dominates (7-Theme2.tex:56-59). SDPSegfault builds three dense 10 000 × 4 950
intermediates that cancel in the sum, and SCIPY's csr kernels do that case well
(`plans/sdpsegfault_analysis_20260822.md`). ConvexPlasticity takes 0.35 s against 0.85 s:
a small problem where the fixed cost of the engine shows.

**How sensitive to dimension?** Be honest: the suite is fixed-size, and there is no scaling
study. Instance dimensions are Legrain item (v) and are not yet in the thesis
(`plans/legrain-deferred-experiments.md`). What can be said: the symbolic cost of a dense
block scales with its rows and columns, not its entries. See the complexity count drafted in
`plans/legrain-rebuttal.md` (i-f).

**Is it the split or the matrix format that does the job?** Not separated yet. On the one-shot
benchmark the split does not help: there is a single solve, so the symbolic pass is pure
overhead. There the gain is the format and the direct assembly. On re-solve the split is the
whole gain: one numeric pass. The ablation that isolates the formats is Legrain item (ii).

**Why is re-solve worse on SVMWithL1Regularization and FactorCovarianceModel?** Their data is
almost all constant, with a few scalar parameters. The tensor re-solve touches only the
parameter columns, but the numeric pass recomputes every value on the path, constants
included. This is the backup *what the two-phase split costs*.

---

## Applied 2026-09-30

Everything above is in `presentation.tex` except **Timing**. The build is clean: 70 pages,
no overfull boxes. Notes:
- The new *Contributions* frame and the *Example:* retitle add about 40 s, so the deck is now
  a little further over the budget than the advisor's 30:31.
- Profiles: `images/{performance,memory}_profile_deck.pdf`, from
  `Jacobian-accumulation/canonicalization/plot_deck_profiles.py`. The time series is read off
  Table 4.1. The raw replicate files `results/repl/` aren't in the local checkout. The script
  reproduces 21/25 for diffengine, the same as the thesis. The memory series comes from the
  raw results, as in the thesis.
- COO vs C00: fixed in the figure legends (sans font). In the slide text, `\texttt{COO}`
  still looks like C-zero-zero in this typewriter font. Say it once, or decide on a
  deck-wide font change.
