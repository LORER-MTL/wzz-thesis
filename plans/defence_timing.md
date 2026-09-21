# Defence timing card — 2026-10-02, ~30 minute slot

Written 2026-09-17. The deck is **55 shown slides** (36 frames; the 13 backups after
`\appendix` are not presented and are not budgeted here).

**The per-frame table was re-synced to the deck on 2026-09-21**, frame by frame, from the
footer numbering of the built PDF. Every row below is a frame that exists; the slide counts are
the overlay beats the deck actually has. See the last note for what moved.

The decision behind this card was **nothing is cut**, and it has since been walked back twice,
both times for the same reason — a frame whose whole job was already being done elsewhere. The
Introduction and the Example still twin each other on convex optimization, DCP and the
modelling language, and both copies stay: cutting the Introduction's DCP slide would leave a
thesis titled *"…for Disciplined Convex Programming"* that never defines the term. What has
gone is the CVXPY slide and, on 2026-09-20, *Compilation* — see the Notes. Otherwise the time
still comes from pace, not from cuts.

Total budget below: **26:40**, leaving about three and a quarter minutes of slack in a 30-minute
slot. The method section grew and the Example and the Conclusion shrank; the net is about a
minute against the first version of this card.

## Checkpoints — the only numbers to watch on the day

| At the end of | Elapsed |
|---|---|
| Title, *Optimization in practice*, first outline | 1:15 |
| **Introduction** | **8:05** |
| **Example** | **13:35** |
| **SparseDiffEngine** | **21:30** |
| **Results** | **24:40** |
| **Conclusion** | **26:40** |

If the Introduction has not ended by 8:05, do not try to make it up by talking faster later —
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
| **Introduction** | | **18** | **7:05** | |
| 1 | Optimization in practice — *before the first outline* | 3 | 0:50 | |
| 2 | Convex optimization | 2 | 0:40 | |
| 3 | Conic form | 1 | 0:25 | sprint |
| 4 | Convex optimization in practice | 4 | 1:30 | walk |
| 5 | Disciplined convex programming | 2 | 0:45 | |
| 6 | DCP-based modelling languages | 3 | 0:40 | sprint |
| 7 | Canonicalization | 2 | 1:10 | walk |
| 8 | Problem statement | 1 | 1:05 | walk |
| **Example** | | **9** | **5:30** | |
| 9 | Fitting with regularization | 1 | 0:40 | |
| 10 | Atoms | 1 | 0:40 | walk |
| 11 | A CVXPY example | 2 | 0:45 | |
| 12 | Expression tree | 1 | 0:55 | walk |
| 13 | Canonicalization: the frontend | 1 | 0:30 | sprint |
| 14 | Canonicalization: the backend | 2 | 1:10 | walk |
| 15 | Structure in the problem data | 1 | 0:50 | walk |
| **SparseDiffEngine** | | **15** | **7:55** | |
| 16 | Overview | 1 | 0:45 | |
| 17 | Compressed sparse row | 1 | 0:40 | punchline first |
| 18 | A dense block at permuted positions | 2 | 1:05 | walk |
| 19 | Dispatch: a data vector | 3 | 0:50 | walk |
| 20 | Dispatch: a dense block | 3 | 0:45 | walk — the twin, so it goes faster |
| 21 | Two passes | 1 | 0:55 | |
| 22 | What the symbolic pass stores | 1 | 1:15 | walk |
| 23 | The parameter maps | 1 | 0:50 | |
| 24 | What this buys | 2 | 0:50 | |
| **Results** | | **4** | **3:10** | |
| 25 | First canonicalization | 1 | 0:55 | |
| 26 | Performance profile | 1 | 0:45 | sprint — the figure does the work |
| 27 | Peak memory | 1 | 0:35 | sprint |
| 28 | Parametric problems | 1 | 0:55 | |
| **Conclusion** | | **3** | **2:00** | |
| 29 | Conclusion | 2 | 1:45 | |
| 30 | Thank you | 1 | 0:15 | |

## Notes

- **The punchlines are on the slide, once each.** Single canonicalization opens on "New matrix
  classes for the structure the problem data already has, and kernels that dispatch on them";
  Parametric canonicalization lands "the structure is computed once; a re-solve is values only"
  as the second bullet of its first slide. There is no separate contributions frame, by choice —
  one existed (`I6`, commit `d3ab9fd`) and was cut in `ac78a2c`.
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
  to state rides on the accent arrow of *Problem statement*: `matrix stuffing` with
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
- **If rehearsal still runs long**, the zero-risk headroom is the four per-section outline frames
  (`presentation.tex:84-89`): about two minutes, and nothing in the deck cross-references them.
  They are kept by choice and the revert is one line.
- The backup slides are numbered separately ("backup 7 / 13") so a request from the floor can be
  answered by number.
