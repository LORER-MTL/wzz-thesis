# AD Differentiation Taxonomy — Notes for the Literature Review

**Purpose.** Working notes for the related-work / background section on algorithmic
differentiation (AD). These capture the taxonomy, the dependency structure between its
axes, and the framing decisions for the write-up. The goal of the section is to locate
the thesis's contribution (vectorized + direct + sparse, coloring-free) within the space
of differentiation methods.

---

## 1. The four axes

The standard way to organize differentiation methods is along four choices:

1. **Granularity** — scalar vs. vectorized graph. Are graph nodes elementary scalar
   operations (`+`, `*`, `sin`) or array/tensor operations (matmul, conv)?
2. **Direction / association order** — forward vs. reverse. The order in which the
   chain-rule product is associated.
3. **Access** — direct vs. oracle. Is the Jacobian/Hessian assembled explicitly, or
   accessed only through matrix–vector products (JVP / VJP)?
4. **Storage** — sparse vs. dense. Is the resulting matrix represented sparsely or densely?

**Key caveat: these are NOT four independent switches.** Presenting them as a clean
2×2×2×2 of 16 configurations oversells their independence and invites the objection
"then why four axes at all?" The honest structure is *two roughly-free axes and two
entangled ones*, with a specific directional dependency chain (Section 3).

---

## 2. Defining forward vs. reverse *without* coupling

A common error is to define the modes by their cost ("forward = n passes, reverse =
m passes"). That is **not** the definition — it is what the modes look like only when
combined with oracle access and a dense target. The intrinsic definition is purely about
association order.

Write the function as a composition `f = f_L ∘ ... ∘ f_1`, so the Jacobian factors:

```
J = J_L · J_{L-1} · ... · J_1
```

Matrix multiplication is associative, so the product can be bracketed two ways:

- **Forward mode** — right-to-left: `J_L (J_{L-1} (... (J_2 J_1)))`. Accumulates from
  inputs toward outputs, same direction as primal evaluation. No tape needed.
- **Reverse mode** — left-to-right: `((... (J_L J_{L-1}) ...) J_1)`. Accumulates from
  outputs back toward inputs. Runs opposite to primal order, so it must store
  intermediates (the Wengert tape) to replay backward.

That is the entire distinction: **order of association / direction of traversal.** No
mention of n, m, passes, JVP/VJP, or sparse/dense is needed to state it.

**The n/m asymmetry is intrinsic but changes form depending on the access axis:**

- Under **oracle** access it appears as the *number of sweeps*: ~n JVPs (forward) or
  ~m VJPs (reverse).
- Under **direct** access it appears as the *width of the object carried per node*:
  n-wide forward (each node carries ∂vᵢ/∂x), m-tall reverse (each node carries ∂y/∂vᵢ),
  with a single sweep either way.

So forward is inherently input-dimension-flavored (n governs it), reverse is
output-dimension-flavored (m governs it). That flavor is part of each mode's identity.
What was *not* intrinsic — and was the original conflation — is the specific cost claim
"n passes," which requires oracle + dense to even be a sentence.

---

## 3. The dependency structure (the load-bearing part)

The axes split into free and entangled groups:

**Roughly free:**
- *Scalar/vectorized* and *forward/reverse* are close to orthogonal to everything. Any
  configuration admits both choices. (Forward/reverse carries its n/m flavor, but that's
  a property *within* the axis, not a dependency *between* axes.)

**Entangled — and the entanglement is directional, not a mutual blob:**

```
vectorized  →  readable structural sparsity  →  direct-sparse  →  coloring unnecessary
```

- *Direct/oracle* is **nearly degenerate in the dense regime**: direct is just the oracle
  seeded with the full identity (I_n forward, I_m reverse), batched into one pass. The
  axis barely exists in dense.
- It becomes a **real, load-bearing distinction only in the sparse regime**:
  - **oracle-sparse** = compress via coloring → seed with compressed vectors → decompress.
  - **direct-sparse** = carry genuinely sparse derivative objects through the graph; never
    form the dense width-n object; no coloring at all.

**Cross-couplings that leak even through the "free" axes:**

- *Vectorized* is what makes the sparsity pattern readable from operation structure. At
  scalar granularity, structural sparsity needs a separate detection pass. Vectorization
  is what *unlocks* direct-sparse-without-coloring — so granularity gates whether
  direct-sparse is even attractive.
- *Forward/reverse* leaks into *how* you compress under oracle+sparse: forward wants
  column coloring, reverse wants row coloring, symmetric Hessians want
  bidirectional/star coloring.

**Framing takeaway.** The non-independence is not a flaw in the taxonomy — it *is* the
thesis. If the axes were perfectly orthogonal, every cell would be reachable and there'd
be nothing to contribute. The contribution is exactly one coupling: vectorized
granularity → structural sparsity readable → go direct-and-sparse → coloring unnecessary.
Present the axes as a *coordinate system for locating methods*, state the dependency
chain explicitly up front, and the contribution falls out as a *path* through the space
that the standard route structurally cannot take. Framing the axes as independent and
then claiming a contribution creates a tension a sharp reviewer will catch.

---

## 4. Conditioning on sparse (the optimization focus)

Optimization problem data is large and sparse, so the section emphasizes sparse
derivatives. Conditioning on sparse collapses the space substantially — but the collapse
is partial and directional. What survives:

- **Direct/oracle goes from degenerate to the LIVE axis.** Sparsity is precisely what
  *activates* this distinction. This inversion is worth foregrounding.
- **Scalar/vectorized stops being free** and co-varies with direct/oracle — by
  *attractiveness*, not logical force. The two attractive corners bundle into two
  coherent strategies:
  - **scalar + oracle + coloring** — the standard literature route (sparsity detection
    pass, then bicoloring; e.g. ADOL-C).
  - **vectorized + direct + colorless** — the thesis route.
- **Forward/reverse stays genuinely free**, narrowing to "which dimension you
  compress/index." In optimization it's *dictated by the derivative object*:
  - objective gradient (1×n) → reverse
  - constraint Jacobian → driven by m vs. n
  - Lagrangian Hessian (n×n symmetric) → typically reverse-over-forward with
    symmetry-aware (star) coloring

**The honest count.** Not 16 cells. The *attractive* region is ~two coherent strategies,
modulated by a forward/reverse sub-choice. The taxonomy table wants **two columns
(standard vs. proposed)**, annotated by forward/reverse and by derivative object — not a
sprawling grid.

**The honest caveat — do not claim the off-diagonal cells don't exist:**
- *vectorized + oracle + sparse* is real (JAX-style `jvp`/`vjp` on tensor graphs).
- *scalar + direct + sparse* is possible with a bolt-on detection pass.

They're just *unmotivated* — neither sits at a cost frontier. The defensible claim is
"the attractive region is small," NOT "the grid is small." A reviewer respects the first
and pokes the second.

---

## 5. Why dense is still presented

Dense is **not a competing choice** — it is the *foil that makes the sparse distinction
legible*. Its roles:

- **Contrast.** The only way to show direct/oracle is a real axis is to exhibit it
  *collapsing* in dense (direct = batched-oracle) and *splitting* in sparse. Without the
  dense baseline, a reader takes "direct" for a synonym of batched-oracle and the axis
  looks vacuous.
- **Baseline.** Dense sets the cost baseline against which the sparse methods are measured.

So: dense = baseline and contrast; sparse = the premise; the actual *choice* lives almost
entirely in the direct/oracle split that only sparsity activates.

---

## 6. Suggested section structure

1. Introduce the four axes as a coordinate system (not independent switches).
2. Brief survey: numerical and symbolic differentiation, then AD as the middle ground.
   - Note the Laue (2019) point: symbolic differentiation over a DAG with common
     subexpressions performs the same operations as reverse-mode AD. This is the cleanest
     motivation for putting symbolic and algorithmic methods in one taxonomy — they are
     not separate species once subexpressions are shared.
3. Define forward vs. reverse intrinsically (association order; Section 2), *then*
   introduce the n/m flavor and how it manifests under oracle vs. direct.
4. State the dependency chain explicitly (Section 3) — the single highest-leverage
   sentence: *vectorized → structural sparsity → direct → coloring-free.*
5. Condition on sparse (Section 4): dense as baseline where direct/oracle degenerates;
   sparsity activates direct/oracle and pulls scalar/vectorized into co-variation;
   collapse into two attractive strategies; forward/reverse as orthogonal,
   object-driven sub-choice.
6. Taxonomy table: two strategy columns, annotated by forward/reverse and object.

---

## 7. Key references to anchor claims

- **Baydin et al. (2017)** — AD survey; the four-choices framing / general landscape.
- **Griewank & Walther, *Evaluating Derivatives* (2008)** — canonical AD reference;
  scalar + oracle tradition; expression swell of naive symbolic; machine-precision
  argument for AD.
- **Gebremedhin, Manne & Pothen, "What Color Is Your Jacobian?" (2005)** — the canonical
  reference for sparsity detection + coloring (column/row/star/bidirectional). Near-
  mandatory cite for the sparse-derivative claims. Builds on Curtis–Powell–Reid and
  Coleman–Moré.
- **Laue (2019), "On the Equivalence of Automatic and Symbolic Differentiation"** —
  symbolic-over-DAG ≡ reverse-mode AD.

(Verify exact citation keys against the thesis `.bib`; tool references below should be
checked for currency before citing, as the AD tooling landscape moves quickly.)

---

## 8. Open items / TODO for Claude Code

- [ ] Draft the four-axes-as-coordinate-system paragraph, framed as coupled from the
      start (prevents the "why four axes" objection downstream). Highest-leverage
      paragraph in the section.
- [ ] Build the taxonomy table: two columns (standard scalar+oracle+coloring vs. proposed
      vectorized+direct+colorless), rows annotated by forward/reverse and derivative
      object. Optionally a wider tool-survey grid (ADOL-C, Tapenade, CppAD, JAX, PyTorch,
      Enzyme, ForwardDiff.jl + SparseDiffTools) mapped onto the four axes — verify each
      tool's current positioning before committing.
- [ ] Draft the dense-as-baseline / sparse-activation paragraphs (Sections 4–5).
- [ ] Reconcile citation keys with the thesis bibliography.
