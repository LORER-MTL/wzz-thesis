# Defence timing card — 2026-10-02, ~30 minute slot

Written 2026-09-17. The deck is **55 shown slides in 37 frames**, which is what the footer of
the built PDF says (`37 / 37` on the last one); the 17 backups after `\appendix` are not
presented and are not budgeted here.

**The per-frame table was re-synced to the deck on 2026-09-22**, frame by frame, from the
footer numbering of the built PDF. Every row below is a frame that exists; the slide counts are
the overlay beats the deck actually has. See the last notes for what moved.

Two corrections came out of that re-sync, and they are the reason the Example section is longer
here than in every previous version of this card. *Parameters in CVXPY* and *Parameters in the
CVXPY backend* have been in the deck since 2026-09-21 and **were never given a row**: the
section was budgeted for seven frames and has nine, so about a minute and a quarter of the
Example was simply unaccounted for. And *A CVXPY example* is one beat, not two. Both are fixed
below.

The decision behind this card was **nothing is cut**, and it has now been walked back four
times. The largest is the last: on 2026-09-22 the deck went from **two contributions to one**.
The matrix representations are the talk; the two-pass split, the parameter maps and the
parametric results are backups 13–16. That is a decision about the clock, not about the work —
see the Notes. The Introduction and the Example still twin each other on convex optimization,
DCP and the modelling language, and both copies stay: cutting the Introduction's DCP slide would
leave a thesis titled *"…for Disciplined Convex Programming"* that never defines the term.

Total budget below: **27:25** in a **35-minute** slot (updated 2026-09-30; it was 25:25 in a
slot believed to be 30 minutes, and the practice run on that deck took about 30). Earlier:
25:25, leaving just under five minutes of slack in a 30-minute slot. Do not treat that as a surplus to fill. Roughly half of it is the price of having one
argument instead of two, and the other half is what the corrected Example rows say was being
overspent all along.

## Checkpoints — the only numbers to watch on the day

| At the end of | Elapsed |
|---|---|
| Title, *Optimization in practice*, first outline | 1:15 |
| **Introduction** | **7:25** |
| **Example** | **14:45** |
| **SparseDiffEngine** | **20:35** |
| **Results** | **25:00** |
| **Conclusion** | **27:25** |

If the Introduction has not ended by 7:25, do not try to make it up by talking faster later —
drop to the sprint pace on the Example's first three slides, which are built for it.

The first row is no longer just the title: *Optimization in practice* is now shown **before**
the first outline frame, so the deck opens on a picture and the outline is the third thing on
screen. Its 0:50 is budgeted inside the Introduction block below, not on top of it.

## Per-frame budget

`sprint` = one sentence, then move. `walk` = the figure has to be traced.
Slides = overlay beats, so a two-beat frame is two clicks.

| # | Frame | Slides | Budget | Pace |
|---|---|---|---|---|
| | Title | 1 | 0:15 | — |
| | Outline (×5, one per section) | 5 | 0:10 each | sprint |
| **Introduction** | | **19** | **7:05** | |
| 1 | Optimization in practice — *before the first outline* | 3 | 0:50 | |
| 2 | Convex optimization | 2 | 0:40 | |
| 3 | Conic form | 1 | 0:25 | sprint |
| 4 | Convex optimization in practice | 4 | 1:30 | walk |
| 5 | Disciplined convex programming | 2 | 0:45 | |
| 6 | DCP-based modelling languages | 3 | 0:35 | sprint |
| 7 | Canonicalization | 2 | 1:10 | walk |
| 8 | Problem statement | 2 | 1:10 | walk — the two pictures, then click for the derivative |
| **Example** | | **9** | **7:10** | |
| 9 | Fitting with regularization | 1 | 0:40 | |
| 10 | Atoms | 1 | 0:40 | walk |
| 11 | A CVXPY example | 1 | 0:45 | |
| 12 | Expression tree | 1 | 0:55 | walk |
| 13 | Canonicalization: the frontend | 1 | 0:40 | sprint |
| 14 | Canonicalization: the backend | 1 | 1:10 | walk |
| 15 | Parameters in CVXPY | 1 | 0:40 | |
| 16 | Parameters in the CVXPY backend | 1 | 0:35 | |
| 17 | Structure in the problem data | 1 | 1:05 | walk |
| **SparseDiffEngine** | | **8** | **5:40** | |
| 18 | Overview | 2 | 1:00 | the boxes, then the two structures they are for |
| 19 | Compressed sparse row | 1 | 0:40 | punchline first |
| 20 | Permuted-Dense matrix | 2 | 1:15 | walk |
| 21 | Algorithms | 1 | 0:50 | the ten names, then the three representations |
| 22 | Two passes | 1 | 0:55 | walk — the figure, then the two bullets |
| 22b | What the symbolic pass stores | 1 | 1:00 | walk — left panel builds the map, right panel follows it |
| **Results** | | **9** | **4:15** | |
| 23 | A known bottleneck | 5 | 0:50 | one capture per click; read only the last one aloud |
| 24 | Setup | 1 | 0:55 | the applications lead, then the call; the `cvxcore` deprecation is spoken here |
| 25 | Performance profile | 1 | 0:55 | the figure does the work; the two numbers under it do not |
| 26 | Peak memory | 1 | 0:35 | sprint — #3072 on the opener is the frame to point back to |
| 26b | Parametric problems | 1 | 1:00 | the closing line first, then point at the two rows the tensor wins |
| **Conclusion** | | **6** | **2:15** | |
| 27 | Takeaways | 2 | 1:00 | |
| 28 | Conclusion | 2 | 1:00 | |
| 29 | Thank you | 1 | 0:15 | |
| 30 | References | 1 | 0:00 | not spoken — it is what is on screen for questions |
| 31 | References (continued) | 1 | 0:00 | the one to be on if the question is about a reference |

## Notes

- **The punchlines are on the slide, once each.** Since 2026-09-22 there is one of them, not
  two: *Overview* opens the engine section on "the goal is to use different representations to
  exploit the different structures in the problem data", and the deck's last line with anything
  on it is "the structure is in the problem already; the engine is what keeps it", which came
  off the cut section close and now closes the Conclusion. The parametric punchline — "the
  structure is computed once; a re-solve is values only" — is on backup 13 with the rest of
  that argument. There is no separate contributions frame, by choice — one existed (`I6`,
  commit `d3ab9fd`) and was cut in `ac78a2c`.
- **Text on slides is deliberately below what is spoken.** A trim pass on 2026-09-17 took the
  main deck from ~1,400 to ~1,180 prose words (figures and code excluded); the detail that came
  off Three observations, Parametric problems, The parameter maps and Future work is meant to be
  said, not read.
- **A second trim, 2026-09-20**, took it down another ~22% on the same measure. The rule was
  that a line stays only if it says something the figure, display or code block cannot, and is
  not already said on another frame. What came off, and is now spoken: the convexity derivation
  on *Convex optimization* (Example), which is display-only now; the reading of the matrix on
  *Structure in the problem data*, which is the matrix alone, full frame; the interpretation
  bullet on *Fitting with regularization*; the `-F`-block cross-reference on *A dense block at
  permuted positions*; and one bullet each from Conic form, CVXPY, Problem statement, A
  DCP-based modelling language, Canonicalization: the frontend / the backend, Canonicalization
  as sparse differentiation, Closed under the operations we need, Two passes and The parameter
  maps. **None of the per-frame budgets above changed** — less text on a slide is not less to
  say, and the whole premise of this card is that the time comes from pace. Every deletion is
  recorded in that frame's `%` comment in `presentation.tex`, which is the deck's only
  speaker-notes mechanism; read them before rehearsing.
- **A follow-up on the same day put two things back**, after reading the trimmed deck: a third
  bullet and a Ben-Tal & Nemirovski source line on *Conic form* (it represents nearly every
  convex program used in practice), and two new beats on frame 4. That is not a reversal of the
  trim — neither is something a figure on the deck already says.
  This entry used to claim a third item, two bullets restored on *Optimization in practice*.
  **That never happened.** The frame carried no bullets in any commit back to `3f62453`; the
  entry, and the frame's own `%` block, both described text that was never written. Bullets
  were finally added there on 2026-09-20 — see the last note.
- **Frame 4 was retitled twice**, ending at *Convex optimization in practice*, which twins
  frame 1's *Optimization in practice*. It now runs four beats: algorithms, solvers, then the
  two things its panel assumes and never says — `f_0, f_i` convex / `g_j` affine lights up with
  *how is this verified?*, and then the `compilation` label with *how is this translation
  done?*. Frame 5 (DCP) answers the first immediately; frames 7 and 8 answer the second. Ask
  them, then move — they are the hand-off, not a discussion.
- **Frame 13, *Atoms*, is new in the same follow-up.** It answers the question frame 12's
  tinted expression tree raises and does not settle: where the convex/affine labels come from.
  Six rows of the thesis's `tab:atoms`, with `norm` and `mul` marked because they are the two
  this problem uses, and only the two composition clauses the example needs stated under it.
  The full rule set stays on the backup frame *the DCP rules*, which the overlap is worth:
  that one answers "what exactly are the rules?", this one "what is an atom?".
- **"Canonicalization as sparse differentiation" was cut** in the same follow-up, which is
  where the minute the two additions cost comes back from. Its one bullet was already on the
  backup frame *two ways to get the coefficients*, word for word, and the identity it existed
  to state rides on the accent arrow of *Problem statement*: `sparse derivative` (`matrix
  stuffing` until 2026-09-22 — see the last note) with
  `A = ∂h/∂x` under it. It was briefly un-cut on 2026-09-20, generalized off the running
  example and moved into the Introduction, and then cut again the same day — two frames for
  one idea, and the arrow already carries the payload. That arrow is still the only place the
  derivative framing appears before *A dense block at permuted positions* opens on the word
  Jacobian, so if the phrase is skipped on the day, that slide lands cold.
- **The *CVXPY* frame was cut** in the same follow-up. The narrowing it existed to make is now
  a bullet of its own on *DCP-based modelling languages* — "CVXPY (Python), the one this thesis
  targets", in polyblue — and its evidence (over ten years, 6 M downloads a month, 4.5 k
  citations) is the backup *why CVXPY*. Note this reverses the decision recorded at the top of
  this card, which kept the frame so that *Problem statement*'s closing claim would not be
  unearned; the bullet is what now earns it, and the backup is there if the jury presses.
- **A third pass on the Introduction, 2026-09-20**, from a read-through of the section. It is
  one frame shorter — 48 shown slides in 35 frames — and the section goes 7:35 → 7:05. Three
  changes:
  - ***Optimization in practice* opens the deck**, before the first outline frame, so the talk
    starts on the picture it lives inside and the outline reads as a route through a landscape
    already seen. It is the only frame outside a section, which costs nothing: `\AtBeginSection`
    still fires the Introduction's outline immediately after it. It also gains its first two
    bullets — the formulation says what you want, not how to compute it; the modelling language
    is the bridge between the formulation and the solver — and a white annotation on the
    formulation → solver arrow naming that bridge. The annotation was a sixth box of the chain
    first; as a stage it widened the chain by a quarter and shrank every label on the slide,
    and it claimed a parity with `modelling` and `solver` that this early frame cannot yet
    earn. Two lines were considered and not written, and are meant to be said instead:
    "everything after it is mechanical", and "this talk is not about how to model problems, nor
    how to solve them, but everything in between".
  - ***Compilation* is cut.** It drew the frontend/backend panel generically so that
    *Canonicalization* could re-draw it with CVXPY's labels and nothing would move — the better
    half of the gesture, but it took two frames to make. Its languages box (AMPL `.nl`, JuMP
    MOI, CVXPY expression trees) is now the second of *Canonicalization*'s three beats, hung off
    the same box it hung off there; the accent backend arrow moves to beat three so the
    punchline still lands last. Not carried over: the grey "in DCP-based languages this step is
    called canonicalization", which *DCP-based modelling languages* already lands, and what
    AMPL and JuMP do instead of canonicalizing, which is the backup *two ways to get the
    coefficients*. Net −0:55 against +0:15.
  - ***Problem statement* is redrawn, not resized.** Still one frame, still 1:05, but the
    functional conic form on the left is now a forest of unlabelled expression trees, one per
    cone constraint, and the six shaded blocks on the right are scattered dots inside the same
    row and column bands. The old version carried the display, the block structure and the
    thesis's goal at once and did too much; the forest says what the backend actually walks,
    and the dots say the one thing shaded blocks cannot, which is that it is sparse. The
    sentence to speak is that the forest *is* that matrix, cut into rows and columns. The
    trees are deliberately unlabelled — the Example draws a real one, with atoms in it, on
    *Disciplined convex programming*. One bullet came off in the redraw, "it computes that
    Jacobian sparsely, which is what the name is for": say it off the arrow when
    SparseDiffEngine is named.
- **2026-09-21 — *Dispatch* becomes two frames, and this card was re-synced to the deck.**
  The method section's `Dispatch` frame — a ten-kernel table beside three bullets — is now two
  twinned frames, *Dispatch: a data vector* and *Dispatch: a dense block*: a three-node
  expression tree on the left, the kernel each node dispatches to on the right, walked bottom-up
  one node per beat with the node and its kernel lit together. The second is the argument: the
  same tree over dense data turns permuted dense at the product and stays there, which the
  `result` column says in three tags. The table itself is the backup *the ten kernels*, together
  with the two claims two worked paths cannot make — that ten kernels cover the library, and
  that the dense form is absorbing, which is about binary operands. Net +1 frame, +4 shown
  slides, +1:35 on the section.
  The same pass corrected rows that had drifted through the restructures of 2026-09-20, which is
  why the numbering below shifts by one from the Example onward: the sections are Introduction /
  Example / SparseDiffEngine / Results / Conclusion; *Closed under the operations we need* and
  *The same problem, a hundred times* are gone; *Overview*, *What this buys* and *Peak memory*
  are on the main line; the Example's Introduction-twinning frames are now *A CVXPY example* and
  *Expression tree*; and *Three observations* + *Future work* are one *Conclusion* frame. Every
  budget for a frame that still exists is unchanged. The budgets for the new and merged frames —
  frames 11, 12, 16, 19, 20, 24, 27, 29 — are estimates and have not been rehearsed.
- **2026-09-21, second entry — a concision pass on the five frames written that day.** *Overview*
  (renamed from *The engine* the same morning), the two *Dispatch* frames, *What this buys* and
  *Conclusion* were written after the 09-20 trim and had not been held to its rule. They go from
  ~268 prose words to ~176, and from 75 words inside the figures to 9. What came off: every card's
  grey second line on both *Dispatch* frames, the grey note under each box on *Overview* and its
  second bullet, and one clause from each bullet on *What this buys* and *Conclusion*, whose five
  bullets are all kept — each is an ask recorded in `deck-comments-04-conclusion.md`. Two grey
  clauses were promoted into a card's main line rather than cut: `r = (0,1)` and `one dgemm`, both
  on *Dispatch: a dense block*. Three geometry consequences, all in the frames' `%` blocks: `kcard`
  gained `minimum height=0.95cm`, because one-line cards inside the tree's unchanged 15mm rhythm
  read as ribbons; both closing lines were shortened rather than one being cut, and *a dense
  block*'s lead lost its cross-reference, because the frames are vertically centred and the twins
  must flip without moving — they now sit at the same height, which they did not before; and the
  `\vspace` under a halved bullet block grew on *What this buys* (5ex → 7ex) and *Conclusion*
  (2.5ex → 4ex). **No budget and no beat count changed.** Every deletion is in that frame's `%`
  comment, as before.
- **2026-09-22 — the two *Dispatch* frames become one, *One kernel per representation*.** The
  twinned tree-walks lasted a day. They were a traversal where the claim is a comparison: six
  shown slides and 1:35 spent arriving at the sentence *a kernel has one implementation per
  representation*, which is one row of a three-row table read across. The new frame names three
  of the ten kernels — `index`, `BA` and `add` — against two representation columns: copy the
  column indices / intersect `r`; Gustavson / one `dgemm`; and, for `add`, one cell spanning both
  columns, so the absence of a dense implementation is visible rather than asserted. It is static,
  one slide, no `\fitfig` and no overlay, and it is the only frame in the section that can be read
  at a glance. Net −1 frame, −5 shown slides, −0:50 on the section, and the checkpoints from
  SparseDiffEngine onward move up by that much. Both kernel backups stay: *the ten kernels* is the
  inventory behind the number, *which kernel runs on which pair* is still the operand-pair answer.
  What is now **spoken** over the table is what the twins used to draw — `sum(d * x)`, whose every
  intermediate stays CSR, and `(Bx)[(0,3)]`, which turns dense at the product and keeps the block
  through the index. It is in the frame's `%` comment, as always.
- **2026-09-22, second entry — the deck goes from two contributions to one.** This is the
  largest cut the card has recorded. *Two passes*, *What the symbolic pass stores* and *The
  parameter maps* are demoted to backups 13–15, *Parametric problems* to backup 16, and *What
  this buys* is cut outright. Net **−4 frames, −5 shown slides, −4:45**. The reason is the
  clock and only the clock: the talk had two arguments to make in under half an hour and could
  not make both at the pace the figures need. What stays is the matrix representations, end to
  end.
  - **The setup stays in the Example.** *Parameters in CVXPY* and *Parameters in the CVXPY
    backend* are not demoted. They are what make "the sparsity pattern is fixed across a
    problem family" mean anything, and B3b is the only slide in the deck where a parameter is
    visible inside `[A b]`. Without them the demoted backups would be shown cold to a room that
    has never seen a `cp.Parameter`.
  - **The Conclusion says the re-solve claim in one line** — "faster first canonicalization on
    24 of 25, and re-solve caching without DPP" — and stops. That line is deliberately an
    invitation: backups 13–16 are the answer to the question it raises, in order (the split,
    what the split stores, what CVXPY does instead, the numbers).
  - **The limits beat is cut** from the Conclusion. Both limits point at the parametric
    machinery, and stating the cost of a mechanism the room has not been shown makes the
    question harder to answer, not easier. Both are still said out loud if the Q&A goes there;
    backup 12 is the frame behind the first of them.
  - **What replaces it** is SC4's punchline, which had nowhere else to go and is the only
    sentence in the deck that is not said on some other frame.
  - **The engine section was rewritten in the same pass**, from the read-through comments in
    `presentation.tex`. *Overview* now says what the library is before it says what is new
    about it, and each of the three boxes carries a sketch of what that representation looks
    like; "generic sparse" is just "sparse" everywhere in the deck now. *Permuted-Dense matrix*
    is redrawn with the block on non-adjacent rows and non-adjacent columns, because the
    thesis's contiguous 4 × 2 figure teaches the wrong thing about `r` and `c`, and the
    selector-matrix definition is cut in favour of the sentence it was standing in for.
    *One kernel per representation* — one day old — is now *One operation, two kernels*: the
    same product `C = BA` and the two C entry points side by side, a CSR one and a
    permuted-dense one, because the claim was never a list, it was a substitution.
  - **A References frame is the last presented slide**, after *Thank you*, so it is what is on
    screen during questions. It is budgeted at 0:00 and is not spoken. BLAS and Gustavson are
    now cited where they are used, and CVXPY is cited for the first time.
- **2026-09-22, third entry — two small things from a second read of the built deck.**
  - ***`matrix stuffing` is not introduced.*** The accent arrow of *Problem statement* now reads
    `sparse derivative` over `A = ∂h/∂x`. The term of art is what the literature calls the step
    (`5-Introduction.tex:83-86`) and it is still in the thesis, but that arrow was the only
    place the deck would ever have used it, and a name the talk does not go on to need costs
    the room more than it gives. `sparse derivative` says the same thing in the words the line
    underneath then writes down, and it is what the section title and the word Jacobian both
    land on later. If someone from the floor says "matrix stuffing", that is the right answer
    and it is the same step.
  - ***Every modelling language named on a slide is now cited.*** *DCP-based modelling
    languages* lists five systems and, until today, cited one of them. The grey line carries
    all five in the bullet's own order — Grant and Boyd (2008) for CVX, Udell et al. (2014),
    Fu et al. (2020), Löfberg (2004), Diamond and Boyd (2016) — and References goes from nine
    entries to thirteen across **two frames**, seven then six, full width at `\footnotesize`.
    One column on one frame needed `\scriptsize`; two columns on one frame broke every entry
    into three short lines. Both reference frames are budgeted at 0:00 and neither is spoken:
    the first is what the deck sits on during questions, the second is where it goes if the
    question is about something on it. That is the one frame the deck gained today against the
    four it lost.
    Note the CVX citation is `grant2008graph`, the Grant & Boyd paper, not the `cvx` software
    entry, whose author field in `Document.bib` is "CVX Research, Inc.".
  **No budget changed** for either.
- **2026-09-22, fourth entry — the benchmarks get a motivation, and the Conclusion gets a
  takeaway.** From a read of Karpathy's notes on giving talks: a talk's first job is to make the
  room care about the problem, dense result tables lose them, and the last slide should leave
  them with something they can use. The deck failed all three in the same two places.
  - **Two frames in front of the results.** *Why benchmark?* (0:40, two beats) says why anyone
    should want the numbers: `cvxcore` is C++, is the default, and is deprecated, and neither
    Python backend has shown a decisive speedup — so there is an opening in CVXPY itself — and
    everything so far was argued on a 5×3 example that can be checked by hand. That second
    bullet is the old Conclusion's third, moved to where it is a reason to benchmark rather than
    an epilogue. *Setup* (0:45) is the harness's real `get_problem_data` call, with the
    `canon_backend` switch visible, and the four backends as four boxes carrying the language
    each is written in — C++, Python, Python, C. The machine line moved here off the cut table.
  - ***First canonicalization* is cut**, and its 25-row table is backup 17, *the per-problem
    times*. The two sentences it existed to deliver — fastest of the four on 21 of 25, more than
    twice the best CVXPY backend on 17 — are now the grey line under the performance profile,
    which is why that frame goes 0:45 → 0:55. It is a **swap**: the line it displaced (no CVXPY
    backend is fastest on more than two problems, τ≈8 to cover 92–96%) is spoken, and the line
    count under the figure is unchanged because that frame was 2.3pt overfull once.
  - **The Conclusion is two frames.** *Takeaways* (1:00, two beats) is what the room can use:
    what CVXPY does between `cp.Problem` and the solver, then three practices from writing the
    backend — use a `cp.Parameter` when the same problem is solved again, vectorize where it does
    not cost readability, read the release notes — with the third one's example on beat 2,
    `cp.Variable((n, n), sparsity=(rows, cols))`. *Conclusion* (1:45 → 1:00) keeps only the
    forward-looking half: what was not covered (parameters, efficiently) and what is ahead
    (solvers that accept, or mix, matrix representations), then the same punchline on beat 2.
    Its two backward-looking bullets came off — the Results section had just made both claims.
  - **Two new citations**, both newly named on a slide: `cvxpybenchmarks` (the suite) and
    `clarabel` (the solver). The deprecation on *Why benchmark?* is the speaker's own paper and
    carries no on-slide citation. References goes 13 → 15 entries, still two frames, now 8 and 7.
  - Net **+2 frames, +4 shown slides, +0:55**; 23:05 → 24:00, and the checkpoints from Results
    onward move by that much. The `%` blocks carry what came off each frame, as always — three
    things now live only there: the second benchmark motivation (the split against the parameter
    tensor, which is backups 13–16), the τ≈8 line, and "I hope you now understand better how
    CVXPY, canonicalization, and perhaps even convex optimization work", which is the spoken
    form of the Takeaways lead.
- **2026-09-22, fifth entry — *Why benchmark?* is cut, one day after it was written.** The
  motivation stays; the frame does not. It was two bullets and a question with six units of
  whitespace between them — three sentences, no figure, and the deck's own rule is that a line
  stays only if it says something a figure, display or code block cannot. All three are now
  spoken over *Setup*, which opens the section instead and holds the eye for its whole 0:45 on
  a code listing and four boxes: the deprecation of `cvxcore` (said while its box, "C++, the
  default", is on screen) and the 5 × 3 example small enough to check by hand. The question —
  *does keeping the structure pay off on the problems people actually solve?* — is the one part
  kept in writing, as the polyblue lead line of *Setup*. Recorded in that frame's `%` block.
  - **Clarabel is no longer named.** `get_problem_data` stops before the solver, so which one it
    is changes nothing on this slide: the citation came off the footer line, the entry came off
    References (15 → 14, the two frames now 8 and 6), and `cp.CLARABEL` stays in the listing only
    because the call takes a solver. The listing's `chain, inv` are `_, _` for the same reason —
    neither is used, and the eye should land on `canon_backend`.
  - ***One operation, two kernels* is retitled *Algorithms*.** The section now reads as three
    representations and then the algorithms over them; the old title stated the frame's claim,
    which its own lead line states anyway. Nothing else on the frame changed, and its 0:50 and
    its reading — left box, then right box — are unchanged.
  - Net **−1 frame, −2 shown slides, −0:40**; 24:00 → 23:20, and the Results and Conclusion
    checkpoints move up by that much.
- **2026-09-22, sixth entry — the clock gave something back.** After *Why benchmark?* was cut the
  deck came in at 23:20, and two things go back in. Neither is a reversal of an earlier entry.
  - ***Two passes* is restored**, from backup 13, as the last frame of the engine section
    (0:55, one slide). It is the **only** frame of the parametric argument that comes back: *what
    the symbolic pass stores*, *the parameter maps* and *parametric problems* stay backups, and
    the numbers they carry are now one grey line on this frame — fastest first canonicalization on
    all seven, re-solve within about 2× of the cached tensor. It sits after *Algorithms* because
    that frame's `%` block already carries "each kernel is a pair of functions, one per pass" as a
    spoken line, and this is the frame that line was standing in for. DPP stays off the slide.
  - **The Conclusion's first bullet had to change with it.** "not covered today: handling
    parameters efficiently — the symbolic and numeric split" stopped being true the moment the
    split was presented; it now reads "what CVXPY does instead — the parameter-to-data tensor, and
    what the split costs against it", which is still the invitation the dropped re-solve line was,
    and the three remaining backups still answer it in order.
  - ***A known bottleneck* opens the Results** (0:40, two beats). The *Why benchmark?* beat comes
    back as evidence rather than prose: four real CVXPY issues, as four title bars cropped from
    the tracker — #704 (Apr 2019, the tracking issue), #886 (Nov 2019, 1 ms to build the problem
    against 42 s to canonicalize it), #2205 (Aug 2023, a user, **still open**, ~4000 s against
    12 s in MATLAB CVX), #3072 (Jan 2026, 128 MB of problem data, out of memory on 128 GB).
    The layout is a pile, not a list, and it **builds**: one capture per click, each landing on
    top of the last and burying most of it, oldest first. #704 lands straight — it is alone on
    screen for a beat, and a tilt on a single image reads as a mistake rather than as a pile —
    and the three after it come in at a few degrees. What survives of each buried card is its
    title, its number and its status pill. Five beats, so 0:50 rather than 0:40, and the only
    one to read aloud is the last. Two earlier shapes were built and rejected: a fan of whole
    pages (`\fitfig` scaled the titles to about 6 pt) and a flat stack of title bars only
    (legible, but it read as a bibliography rather than as a pile of complaints).
    One LaTeX note, since it will bite anyone who edits the geometry: the picture's bounding box
    is fixed by hand (`\useasboundingbox`). Without it `\adjustbox` measures each beat on its
    own, scales one image to fill the frame, and the pile jumps and resizes under every click. Three of the four are closed
    and two are the maintainers' own — the claim is that this has been tracked since 2019 and is
    still being hit, #3072 being eight months old, not that CVXPY ignores it. Say it that way.
    The frame is behind `\issueshots` in the preamble, which is on; the crops are
    `images/issue-{704,886,2205,3072}.png`. #3072 is also the frame to point back to on *Peak
    memory*, and it is why that slide is worth its 0:35.
  - **The question line went back where it was written.** It was *Setup*'s polyblue lead for one
    afternoon, between *Why benchmark?* being cut and this frame existing; it is beat 2 here now,
    and *Setup*'s lead is its own again.
  - Net **+2 frames, +6 shown slides, +1:45**; 23:20 → 25:05, and every checkpoint from
    SparseDiffEngine onward moves.
- **2026-09-22, seventh entry — a comment pass on six frames, and only one of them costs time.**
  All six changes are additions of *what is already spoken*, which is why five of them are free:
  - ***Canonicalization: the backend*** now carries the constraints beside the objective in its
    dashed box: `(x, t₁, Fx−g, t₂, x) = b − A x̃ ∈ K`, the five groups in the order of the five
    row blocks underneath. The walk was already pointing at each block in turn; the box is the
    thing being pointed at, so 1:10 stands.
  - ***Parameters in the CVXPY backend*** gets the same box, dimmed on the same rule as its
    matrices, with `μ` and `g` left in colour. It names the two glyphs to look for before the eye
    reaches the matrices. Still 0:35.
  - ***Parameters in CVXPY*** and ***Parameters in the CVXPY backend*** each gained a bullet —
    the instance is reused, the structure is fixed, most of the data is constant. All three
    sentences were spoken lines on those frames. 0:40 and 0:35 stand.
  - ***Algorithms*** replaces the two named kernels (`BA_csr_gustavson`, `BA_pdense_dgemm`, names
    that were illustrative rather than the library's) with the ten operations on the left,
    fanning into the three representations. Same 0:50, and the cue changes: the ten names, then
    the three boxes. Gustavson and the BLAS call are **spoken** now, off the frame, and the
    citation line came off with the names — both references stay on *References*, Dongarra cited
    on *Permuted-Dense matrix* and Gustavson on the pair-dispatch backup.
  - ***Setup*** is the one that costs: **0:45 → 0:55**, for a lead line naming what the 25
    problems are — portfolio selection, regression and classification, image inpainting, and more
    — with the suite's repo linked in the footer. It is the sentence that makes 25 a claim about
    convex optimization rather than a count, and it is the chapter's own
    (`7-Theme2.tex:20-22`).
  - Net **+0 frames, +0 shown slides, +0:10**; 25:05 → 25:15. *Results* and *Conclusion* are the
    only checkpoints that move.
- **2026-09-23 — *Overview* gets a second beat, and it is the only overlay in the engine section.**
  The frame's closing line says the goal is to exploit *the different structures in the problem
  data*, and never said which. Beat 2 names them, in the order of the three boxes above:
  **problem level** — the canonicalized data is mostly zeros, which is the sparse box — and
  **block level** — each data matrix enters as a dense block inside it, which is the two tinted
  ones. Both halves are already drawn on the frame in the sketches under the names, so the beat
  names what has been on screen for a beat rather than introducing anything.
  It is `\onslide`, not `\only`: the two lines reserve their room on beat 1 so the boxes do not
  move when they arrive.
  The pair is also the map of the two frames that follow — *Compressed sparse row* takes the
  problem level, *Permuted-Dense matrix* the block level — and of *Structure in the problem
  data*, one section back, where the problem-level half was shown on the running example's own
  `[A b]`.
  Net **+0 frames, +1 shown slide, +0:10**; 25:15 → 25:25, and *SparseDiffEngine*, *Results* and
  *Conclusion* move.
- **If rehearsal still runs long**, the zero-risk headroom is the four per-section outline frames
  (`presentation.tex:84-89`): about two minutes, and nothing in the deck cross-references them.
  They are kept by choice and the revert is one line.
- The backup slides are numbered separately ("backup 7 / 17") so a request from the floor can be
  answered by number. There are **17** of them since the sixth entry below took *two passes* back
  into the talk. Numbering is positional, so everything after it moved up one: *what the symbolic
  pass stores* is now 13, *the parameter maps* 14, *parametric problems* 15, *the per-problem
  times* 16, *how to read a performance profile* 17.
- **2026-09-30: two frames back, for a 35-minute slot.** The practice run of the 35-frame deck
  took about 30 minutes, and the slot is 35. *What the symbolic pass stores* returns right after
  *Canonicalization in two phases* (the box diagram gets one worked example), and *Parametric
  problems* returns at the end of Results, cut to five columns (best CVXPY and diffengine on the
  first canonicalization, cached tensor and diffengine on the re-solve). It is the only evidence
  in the talk for the split that Takeaways claims. Net **+2 frames, +2 shown slides, +2:00**;
  25:25 → 27:25, which against a 30-minute practice means about 32 on the day. The backups are
  now regrouped behind a clickable index, so the backup numbering in the note above is stale:
  ask for a backup by title, or use the index.
