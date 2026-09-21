# Deck comments — Example

Working checklist for the comments left in `presentation.tex`. One entry per turn: make the
edit, `make presentation`, confirm, tick the box. Line numbers are as of the working tree on
2026-09-20 and will drift as entries are done.

**Do D-F3E (the reorder) first** if it is taken — it moves four frames at once and every other
entry in this file is easier to verify afterwards.

---

## [x] D-F3E — reorder the section

### `:900` (on F3e "Atoms")
> at the end, I am not a huge fan the ordering anymore.
> maybe this should go before the cvxpy example? then its cvxpy example?
> and then we show the expression tree with DCP kind of there. although we don't really go over
> the DCP rules explicitly.

Proposed order:

| now | after |
| --- | --- |
| F3 problem | F3 problem *(+ the convexity line from F3a)* |
| F3a convexity | — *(merged)* |
| F3c CVXPY example | F3e Atoms |
| F3b expression tree | F3c CVXPY example |
| F3e Atoms | F3b Expression tree |
| B2 frontend | B2 frontend |
| B3 backend | B3 backend |
| I4 structure | I4 structure |

**Knock-ons.**
- The F1/F2 "twin" pairing with the Introduction breaks. You have already said that mirroring
  is not necessary (see `:800`), so this is accepted, not a cost.
- F3e's closing grey line — *Which is what `cp.Parameter(nonneg=True)` was for* — becomes a
  forward reference. The `:934` entry cuts that line anyway, so do the two together.
- After the reorder, read the four frames in sequence and confirm nothing forward-references:
  `nonneg=True`, "problem family", and the atoms table all move relative to each other.

---

## [x] F3 "Fitting with regularization" — `presentation.tex:780`

### `:797`
> here I don't like the last bullet point.

That is the *problem family / problem instance* bullet.

**Decision D-F3.** The vocabulary is load-bearing: PC0 and the whole parametric section assume
it, and B3 beat 2 already says "the whole problem family". **Recommendation:** cut it here,
and introduce the two words on B3 beat 2, where the parameters are on screen. Tracked in the
B3 entry below.

---

## [x] F3a "Convex optimization" — `presentation.tex:805` — merge into F3

### `:800`
> I think the idea to mirror the introduction is very neat but also maybe not completely
> necessary. we need to make time for the contributions.
> I think we can combine the following and the previous slide to save time and make the flow
> smoother.
> I also don't like the curly with the convex below. we should just say that it is a variation
> on one of the oldest convex problems.

- Delete F3a as a frame. **−1 frame.**
- On F3, add one line under the display: *a variation on one of the oldest convex problems:
  least squares, with a regularizer.*
- Drop the two `\underbrace{...}_{convex}` curlies entirely.

The convexity argument then rests on the atoms table and the expression tree.

---

## [x] F3c "A DCP-based modelling language" — `presentation.tex:819`

### `:818` — title
> CVXPY example maybe? I think that's a preferred title.

→ `\begin{frame}[fragile]{A CVXPY example}` (or plain `CVXPY`).

### `:846` — cut the bullets
> I don't like this bullet point and the one after it. we can just cut them.

Both bullets go; the frame becomes title + listing.

**Say aloud instead:** `nonneg=True` is what makes the `mul` row of the atoms table work. No
bullet will carry it after this cut, and after D-F3E the atoms slide comes *first*, so this is
the slide that closes that loop.

**Also lands here (from `deck-comments-03-parametric.md`, D-PC0):** the regularization-path
loop from PC0, as a second overlay on this listing, looping over both `g` and `mu`. Do that
entry from the parametric file, not this one.

---

## [x] F3b "Disciplined convex programming" — `presentation.tex:854`

### `:853` — title
> maybe this should be expression tree? or something like that for the title?

→ `Expression tree`.

### `:863` — grey annotations beside the nodes
> we can steal the style from the thesis to put the underlying expression in gray next to the
> node? maybe only for the top one? or where you see fit? honestly the norm can go to the left
> and mul to the right, so worth trying for both.

**Do not reuse `\annotatedop`.** It reserves a `\phantom` copy of its second argument, which
doubles every node's width — that is exactly why it was stripped out of this figure when it
was lifted from `5-Introduction.tex:382-410`.

Instead: name the tree nodes (`node[cvx] (root) {$+$}` etc.) and attach separate labels —
`\node[anchor=east, font=\scriptsize, text=black!55] at (norm.west) {...}` to the left of
`norm`, `anchor=west` to the right of `mul` — so the tree's own geometry is untouched.

**Risk.** The picture widens, so `\fitfig` shrinks it. Check the node text is still readable
in the built PDF before keeping both annotations; the root alone may be enough.

---

## [x] F3e "Atoms" — `presentation.tex:904`

Ordering comment is **D-F3E** at the top of this file. This entry is the content cut.

### `:934`
> I don't like this description, it makes the slide a bit dense, we could also remove the
> arrows for the other functions. Let's cut it for now. It can go in some form in the backup
> slides.

- Delete the closing `convex ∘ affine is convex …` paragraph and the grey `nonneg=True` line
  under it.
- With that gone the two `▸` markers point at nothing — drop the marker column too, keeping
  only the polyblue colouring on the `norm` and `mul` rows.
- The composition argument already exists on backup **B-DCP** (`presentation.tex:1727`).
  Extend that frame if anything is missing rather than adding a new backup.

---

## [x] B2 "Canonicalization: the frontend" — `presentation.tex:947`

### `:965`
> maybe first bullet point can be the nonlinear norms are replaced by new variables.
> every constraint is an affine function belonging to a cone.

Straight reword of the two bullets:
1. the nonlinear norms are replaced by new variables
2. every constraint is an affine function belonging to a cone

Drop "epigraph" from the first and the "affine in $(t_1,t_2,\mvec{x})$" tail from the second.
Keep the polyblue on the second half.

---

## [x] B3 "Canonicalization: the backend" — `presentation.tex:973`

Four comments. One entry, they are all wording on the same two beats.

### `:977` — beat-1 lead
> I don't like tthe data falls out, please cut that. we can say that in the conic form we need
> to have one stacked variable.. which can be:

→ *The conic form needs one stacked variable, $\mvec{z} = (t_1, t_2, \mvec{x})$:*

### `:980` — beat-2 lead
> I dont like the wording here, maybe cut.

Reword or drop. **This is where "problem family" lands** if D-F3 cuts it from F3.

### `:1033` — beat-1 bullets **[still open]**
> let's cut both these two bullet points and maybe think about something else to put.
> one other suggestion is to

**Open item — the comment breaks off mid-sentence.** Ask before editing. Candidate
replacement: one line naming where `F` and `g` landed, since that is what the matrix shows.

### `:1044` — beat-2 bullets
> I don't like the wording here, maybe cut it. we should just mention that when we re-solve
> this problem the structure remains fixed and only some values change. this can just be a
> brief mention. and say more on that later. since the goal is just to show that a lot of work
> doesn't need to be repeated.

Beat 2 collapses from three bullets to one line.

---

## [x] I4 "Structure in the problem data" — `presentation.tex:1084`

### `:1141` — the matrix shape
> let's make this matrix less tall and more wide, so it fits better on the slide.

The aspect ratio is forced by the example: $2n+m+2$ rows by $n+2$ columns — 20×8 at $n=5$,
$m=8$. As $n$ grows the ratio tends to **2:1 and cannot go below it**, so the matrix is
structurally tall. Re-picking $n$ and $m$ buys little: $n=8, m=3$ gives 21×10, and $m<n$ makes
$\mmat{F}$ a wide matrix, which is a strange regression to show.

**So the lever is the slide, not the matrix.** Put the matrix in a left column at full height
with the reading of it in a right column — which is what this frame used to do, and which also
answers `:1143` below.

### `:1142` — the arrows
> I think the arrows are also again a bit too high we should leave some room for them to
> operate a bit.

The cone `dim` double-arrows run the full band height with rotated labels at $x=-1.6$. Move
the labels to $x=-2.0$, shorten each arrow by ~0.15 cell at both ends, and add left padding
inside the `adjustbox`.

### `:1143` — motivate the contributions
> also we should remember to motivate well the contributions here maybe?

This frame is the hand-off into the method section. The new right column gets 2–3 lines:

- a dense $-\mmat{F}$ block, two identity diagonals, two lone entries
- every block is the Jacobian of the atom that produced it
- a generic sparse format stores all of it as unrelated (row, column, value) triples

The last line is exactly what the new section-2 overview picks up, so keep the wording
consistent with `deck-comments-02-single-canon.md`.
