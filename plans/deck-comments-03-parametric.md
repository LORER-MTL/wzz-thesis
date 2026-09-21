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
