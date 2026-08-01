# Plan: AD Background Section + Contribution Framing

A plan for the automatic-differentiation background section of the thesis, plus the
conceptual framing of the contribution. Written to be self-contained so it can be acted
on without the surrounding conversation.

---

## 0. The one-sentence thesis of the whole section

> Coloring compresses an opaque oracle; vectorization lets you stop using the oracle, and
> it is *that* — not vectorization itself — that makes the compression unnecessary, in the
> regime where structured propagation doesn't densify.

Everything below exists to build up to this and to defend it.

---

## 1. The conceptual frame: two orthogonal axes

The section's job is to establish that these two axes are **independent**, and that the
literature tends to conflate "we have vectorized graphs" with a particular assembly
paradigm when the real choice lives on the second axis.

- **Axis A — Granularity:** scalar vs vectorized. How big is one node, and how much
  structure does a single local Jacobian carry?
  - Scalar node → local Jacobian is a scalar partial.
  - Vectorized node → local Jacobian is a *structured* matrix (diagonal for elementwise,
    block/Kronecker for matmul, low-rank, etc.).
- **Axis B — Assembly paradigm:** black-box **oracle** (probe with seed vectors + compress
  via coloring) vs white-box **direct propagation** (compose structured local Jacobians
  directly). **This is the axis the contribution turns on.**

Key load-bearing claim: coloring lives on Axis B (it operates on the oracle), so it is
**granularity-agnostic** — it applies to vectorized graphs too. Proof point: JAX has fully
vectorized graphs and *still* colors (`sparsejac`) when it wants an assembled sparse
Jacobian. So vectorization alone does **not** remove the need for coloring.

The active ingredient is **"no oracle," not "vectorized."** Refusing the oracle is what
removes coloring's reason to exist.

Refinement worth keeping: vectorization still *matters*, because on a scalar graph "direct
propagation" degenerates into propagating a 0/1 dependency pattern — i.e. just sparsity
*detection*. Vectorization upgrades direct propagation from propagating a *pattern* to
propagating *algebraic structure*. So vectorization is the enabler, not the cause.

---

## 2. Section ordering (keep vectorized/direct LATE)

Build the full black-box pipeline at its strongest first, so that when direct propagation
sidesteps it, the contrast is *felt* rather than asserted. Moving vectorization earlier
would orphan "direct" from "vectorized" behind the coloring block and defuse the punchline
before the reader feels the cost it avoids.

1. **Scalar differentiation** — granularity; node = elementary op, edge = scalar partial;
   taping (ADOL-C, CppAD: runtime trace, can reach millions of nodes) vs source
   transformation (Tapenade: same scalar granularity, emits code at compile time, no
   runtime graph). *(Revised paragraph already drafted and correct.)*

2. **Forward and reverse modes** — accumulation order via associativity; forward scales
   with #inputs `n`, reverse with #outputs `m`; reverse favored for few outputs (single
   gradient). Optimal accumulation order on a general graph is NP-complete; this dissolves
   for the small structured graphs used later. *This paragraph sets up the cost that
   everything later either pays or avoids.*

3. **Oracle-based differentiation** — JVP (`Jv`, forward seed) and VJP (`Jᵀw`, reverse
   seed), ~one function eval each, never forms the matrix; matrix-free / oracle view is the
   dominant one (gradient methods, Krylov solvers need only the action). Optimization is the
   exception: needs the matrix explicitly → recover by probing (`n` unit seeds → columns in
   forward, `m` unit seeds → rows in reverse). Prohibitive when many rows/cols.
   **Add one sentence** flagging that coloring (next) operates on this oracle and is
   therefore granularity-agnostic.

4. **Graph coloring** — frame explicitly as *black-box compression for an opaque oracle*.
   - *Jacobian:* structurally orthogonal columns (no shared nonzero row) can be recovered in
     one JVP; minimize probes = distance-1 coloring of the column-intersection graph
     (CPR 1974; Coleman–Moré; Gebremedhin–Manne–Pothen). NP-hard, greedy works well; `n`
     probes → `p` ≈ max nonzeros per row.
   - *Hessian:* symmetry lets an entry be read from either side → **star coloring** and
     **acyclic coloring** use fewer colors than naive Jacobian coloring. A second, distinct
     coloring theory layered on top.

5. **Sparse derivatives** — the standard oracle pipeline assembled in one place:
   **detect** (sparsity pattern, e.g. operator overloading with dependency bit-sets /
   SparseConnectivityTracer) → **color/compress** → **probe** (seeded AD passes) →
   **decompress**. Cite the "stronger/better/faster" paper. Optionally flag CasADi here with
   a forward reference.

6. **Vectorized differentiation** — richer local Jacobians carrying algebraic structure;
   contrast a single vectorized op (one node, known structured derivative rule) against its
   scalar unrolling (`mn` scalar nodes). Possibly cite the matrix/vector-calculus rules paper
   the derivative rules are based on.

7. **Direct differentiation** — the white-box paradigm: compose structured local Jacobians
   directly, bypassing the entire detect/color/probe/decompress pipeline. Kwok et al. and
   Zou–Jiang land here (stats and control respectively). **State the reframing here:** it is
   abandoning the oracle — not the presence of vectorization — that removes coloring; point
   back at `sparsejac` as proof that vectorization alone doesn't.

---

## 3. Conclusions about what the contribution actually is

- Oracle AD (`Jv`/`Jᵀw` + coloring) is a **black-box** method. The contribution is a
  **highly structured white-box opposite** that composes known local Jacobians directly and
  therefore **never goes through the oracle**, so there is nothing for coloring to compress —
  it is bypassed entirely.
- The escape from coloring is **not** caused by having vectorized graphs. It is caused by
  **not using the oracle**. Vectorization is the necessary scaffolding (it makes white-box
  propagation rich enough to be worth doing); refusing the oracle is the active ingredient.
- Correct framing to use in the text (unassailable): "vectorized graphs admit direct
  compositional assembly of the sparse Jacobian, which sidesteps the
  detect–compress–probe–decompress pipeline that coloring lives inside." Avoid the
  knock-down-able framing "vectorized graphs make coloring unnecessary."

### Why JAX/PyTorch use oracle AD anyway (must address this)

The oracle is the *correct default* for a general-purpose system, not an oversight:

- **Target object is the scalar-loss gradient.** For ML, `m = 1`, so one VJP returns the
  whole gradient — there is no matrix to assemble. The oracle is the minimal correct object.
- **The oracle is closed under composition; structured propagation is not.** VJP of a
  composition = composition of VJPs, uniform, no dispatch. Structured propagation mutates
  structure type at every node (diagonal × dense = dense; sparse × sparse densifies),
  requiring dispatch over a combinatorial zoo. Uniformity is what makes a general framework
  tractable.
- **General-purpose ⇒ can't assume structure.** Arbitrary primitives, control flow, dynamic
  shapes. The oracle works regardless of sparsity/structure; direct propagation only pays off
  when structure is known, strong, and fill-in controlled.
- **The matrix is the exception.** Most downstream uses (Krylov, HVPs for CG, gradients)
  want the *action*, not the matrix. So oracle is the default and sparse assembly
  (`sparsejac`) is a bolted-on specialty.

**Conclusion to state:** oracle AD is the right default for a general-purpose system whose
job is scalar-loss gradients and matrix-free linear algebra. Direct structured propagation is
the right tool for the specialized regime where you (a) actually need the assembled matrix,
(b) know the structure a priori, and (c) control fill-in. The contribution lives in that
regime; the field still colors because it optimizes for the general case where (a)–(c) fail.

---

## 4. Load-bearing checks BEFORE committing the claim

1. **Fill-in caveat — do not overclaim.** `J = J_L ⋯ J_1` is a chain of sparse×sparse
   products, and sparse×sparse densifies. The oracle survives precisely because probing only
   ever takes matrix–vector *actions* and never forms an intermediate matrix, so it stays
   cheap even when intermediates would densify, as long as the *final* `J` is sparse.
   Therefore:
   - Direct propagation wins when local structure is strong **and** intermediate fill-in is
     controlled (likely why the cited works target structured stats/control problems).
   - Coloring can still win when the global Jacobian is sparse but intermediates densify.
   - **The defensible contribution is the *characterization of which regime you're in*, not a
     blanket "coloring is obsolete." State the regime explicitly.**

2. **Novelty boundary — confirm against the cited papers.** Find out exactly what Kwok et al.
   and Zou–Jiang claim their methods *avoid*. If "compose structured local Jacobians, skip
   coloring" is already their thesis, then "vectorized ⇒ no coloring" is *their* point, not a
   new one. In that case the remaining contribution is most plausibly one of:
   - the **unifying view** — oracle and direct propagation as the black-box and white-box
     ends of a single assembly spectrum, with **fill-in as the dial** between them;
   - the **Hessian case**;
   - a **broader operation class** than they cover.
   This is the question that decides whether the core idea is yours. Resolve it first.

---

## 5. Relating the two paradigms to the underlying solver (NEW — to draft later)

The oracle-vs-direct split mirrors the classic **matrix-free vs direct** tradeoff in
numerical linear algebra, and the right choice ultimately depends on the downstream
solver/algorithm:

- **Oracle / matrix-free** (`Jv`, `Jᵀw`) pairs naturally with **iterative / Krylov methods**
  (CG, GMRES, etc.) and Hessian-vector products, which only ever need the *action* of the
  operator.
- **Direct / assembled matrix** pairs with **interior-point methods (IPMs) and direct
  (factorization-based) solves**, which need the explicit matrix to factorize.

This is the same tension as matrix-free vs direct methods in linear algebra. A placeholder
paragraph has been added to the section to be filled in once the solver connection is
developed.

---

## 6. Immediate to-dos

- [ ] Read Kwok et al. (`kwok2025vectorised`) and Zou & Jiang (`zou2025vectorized`); write
      down precisely what each claims to avoid (oracle? coloring? detection?).
- [ ] Decide the contribution statement based on §4.2 (likely the unifying spectrum +
      fill-in characterization).
- [ ] Draft paragraphs 4–5 (coloring, sparse) with the explicit "black-box compression for
      an opaque oracle" framing.
- [ ] Draft paragraphs 6–7 (vectorized, direct) ending on the §2/§3 reframing + `sparsejac`
      proof point.
- [ ] Draft the solver-connection paragraph (§5): matrix-free/Krylov vs direct/IPM.
- [ ] State the fill-in regime explicitly wherever the "bypass coloring" claim appears.
- [ ] Confirm the "stronger/better/faster" sparse-AD citation and the matrix/vector-calculus
      rules citation.
