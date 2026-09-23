# Deck comments — Parametric canonicalization

> **Note.** This section no longer exists. Under D-SEC option 3 its method frames moved into
> `SparseDiffEngine` and its results into the new `Results` section. The entries below are
> kept as the record of what was changed on each frame.

Working checklist for the comments left in `presentation.tex`. Line numbers are as of the
working tree on 2026-09-20 and will drift as entries are done.

The section title question (`:1406`) is **D-SEC**, decided in
`deck-comments-02-single-canon.md`.

---

## [x] D-PC0 — PC0 "The same problem, a hundred times" — `presentation.tex:1413`

### `:1409`
> I don't like the wording for this slide, just showing the code could be enough.
> we could even loop over both g and mu in this snippet.
> actually on second thought why don't we include this snippet in the example section? it fits
> better there anyways I think.

Move the listing into the Example section, looping over both `g` and `mu`, and delete PC0. The
parametric section then opens on PC1 "Two passes", whose lead sentence already makes the
fixed-structure claim:

> The sparsity patterns are fixed across a problem family: a parameter changes the *values* of
> the problem data, never its *structure*.

**Decision D-PC0 — where in the Example section?**

| | | Δ frames |
| --- | --- | --- |
| (a) | second overlay on the CVXPY-example frame (F3c), so the loop appears under the same listing | −1 net |
| (b) | its own short frame after F3c | 0 net |

**Recommendation: (a).** The Example section is the one being trimmed for time, and the loop
is three lines on top of code that is already on screen.

**Watch:** F3c is `[fragile]` and its listing already overrides `aboveskip`/`belowskip` to keep
the recall strip out of the title. Adding three lines on an overlay needs the space reserved on
beat 1, or the strip moves between beats.

**Also note:** if D-F3 (in `deck-comments-01-example.md`) cuts "problem family / problem
instance" from F3, the phrase must be alive by the time PC1 uses it. B3 beat 2 is where it
lands.

---

## [x] PC1 "Two passes" — `presentation.tex:1450`

No comments. Unchanged.

## [x] PC2 "What the symbolic pass stores" — `presentation.tex:1488`

No comments. Unchanged.

---

## [x] PC3 "The parameter maps" — `presentation.tex:1586`

### `:1600`
> but what is a parameter slice?

On the `cvxcore` bullet — *one sparse matrix per parameter slice*. Either define it in three
words on the bullet, or reword to *one sparse matrix per parameter*. The second is simpler and
loses nothing the slide goes on to use.

Source if a definition is wanted: `6-Revue_litterature.tex:458-470`, the three backends and
how each represents the parameter axis.

### `:1601` — optional, not scheduled
> honestly we could consider having a backup slide where we try to show more visually how each
> backend works, but it might be a waste of time too potentially.

Parked. Revisit only if everything else is done and there is slack. The three bullets already
distinguish the backends in one line each.

---

## [x] R3 "Parametric problems" — `presentation.tex:1611` — promote the memory results

### `:1644`
> we should definitely show the memory issue on the results, I think otherwise it's not really
> fair, we could be misleading the audience into believing our approach is much better.

The peak-memory panel already exists as backup **B4** — "Backup: peak memory",
`presentation.tex:2275`, which is panel (b) of `fig:profiles`. Promote it into the main deck.

- **Where:** after R2 "Performance profile", so the two profiles sit together and the memory
  cost is stated in the same breath as the speed win.
- **What it says:** SCIPY is lowest on 16 of 25, `\de{}` runs about 1.4× it. That line
  currently lives in R4's "downsides" block (`:1670`) — when it moves here, check it is not
  said twice (see `deck-comments-04-conclusion.md`, D-R4).
- **Δ frames: +1.** This is the one addition in the whole plan that is about being fair rather
  than about time. Worth the slide.

**Source:** `7-Theme2.tex:61-82` (the profiles) and `:77-82` (the memory numbers).

---

## Reopened — 2026-09-22. The section is demoted, not deleted.

The note at the top of this file says the section no longer exists as a section. As of today its
frames no longer exist in the **presented deck** either. They are backups 13–16.

> `presentation.tex`, on *Two passes*:
> let's put everything related to the two passes in the backup
> I decided I want to focus solely on the first and more important contribution.
> the matrix classes. I won't have time to talk about everything.
>
> on *The parameter maps*: cut this please. i will only briefly mention the backends and
> their implementations.
>
> on *Parametric problems*: cut these results.

| Was | Now |
|---|---|
| PC1 *Two passes* | backup 13, *Backup: two passes* |
| PC2 *What the symbolic pass stores* | backup 14, *Backup: what the symbolic pass stores* |
| PC3 *The parameter maps* | backup 15, *Backup: the parameter maps* |
| R3 *Parametric problems* | backup 16, *Backup: parametric problems* |

Each keeps its content unchanged and gains the `% Q: "…"` header every other backup has, naming
the question it answers. They sit immediately after backup 12, *what the two-phase split costs*,
which was already their neighbour in subject. Read in order they are still the whole argument:
the split, what the split stores, what CVXPY does instead, and the numbers.

**Δ: −4 presented frames, −5 shown slides, −4:45.** The reason is the clock and nothing else.
The mechanism is sound and R3's numbers are good — fastest first canonicalization on all seven
parametric problems, re-solve within about 2× the tensor.

**What stays in the presented deck, deliberately:**

- **PC0 *Parameters in CVXPY* and B3b *Parameters in the CVXPY backend*** are **not** demoted.
  They are in the Example section, and they are what make "the sparsity pattern is fixed across
  a problem family" mean anything at all. B3b is the only slide in the deck where a parameter is
  visible inside `[A b]`. Without them the four backups would be shown cold to a room that has
  never seen a `cp.Parameter`. They also, as of the 2026-09-22 re-sync, finally have rows in
  `plans/defence_timing.md` — they had been presented and unbudgeted since 2026-09-21.
- **One line in the Conclusion**: *faster first canonicalization on 24 of 25, and re-solve
  caching without DPP*. That is the whole second contribution, said once. It is meant to invite
  the question that backups 13–16 answer.

**R3's own earlier entry in this file** — promote the memory results, done 2026-09-21 — is
unaffected: *Peak memory* is R2b and is still a presented frame. It was promoted for fairness,
not for the parametric argument, and that reason still holds.

---

## Reopened again — 2026-09-22, sixth pass. One frame comes back

> I actually have more time than I thought, maybe I should include back the parameter stuff?

Partly. **PC1, *Two passes*, is presented again**; the other three stay backups. The demotion
entry above stands as written — it was right about the clock, and the clock changed.

| | then | now |
|---|---|---|
| PC1 *Two passes* | backup 13 | **presented**, last frame of the SparseDiffEngine section, 0:55 |
| PC2 *What the symbolic pass stores* | backup 14 | backup 13 |
| PC3 *The parameter maps* | backup 15 | backup 14 |
| R3 *Parametric problems* | backup 16 | backup 15 |

**Why only one.** You asked for the mechanism, with the numbers as a claim rather than a table —
so R3's two sentences are a single grey line at the bottom of PC1:

> On the seven parametric problems of the suite: the fastest first canonicalization on all seven,
> and a re-solve within about 2× of the cached tensor CVXPY builds.

R3 itself is still the frame to put up if either half is questioned, and *what the two-phase split
costs* is still the honest answer to the two rows where the tensor wins.

**Why at the end of the engine section**, rather than in a section of its own as before: the
section builds three representations and then the algorithms over them, and the split is what
those algorithms are split *by*. SC3's `%` block already carried "each kernel is a pair of
functions, one per pass" (`7-Theme1.tex:384-385`) as a spoken line — this is the frame that line
was standing in for, and it hands straight into the Results.

**DPP stays off the slide**, as when the frame was first written: the presented deck has no
on-slide occurrence of the acronym, so the closing line says "the cached tensor CVXPY builds" and
the word is spoken. Backup *the parameter maps* is what a challenge to that comparison gets.

**One consequence, and it is not cosmetic.** The Conclusion's first bullet read "not covered
today: handling parameters efficiently — the symbolic and numeric split". That is false once this
frame is presented. It now reads *what CVXPY does instead — the parameter-to-data tensor, and what
the split costs against it*, which is still the invitation the dropped re-solve line was, and the
three remaining backups still answer it in order.

**Net: +1 presented frame, +1 shown slide, +0:55.** 23:20 → 24:15, and the SparseDiffEngine,
Results and Conclusion checkpoints all move by that much.
