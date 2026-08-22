# Chapter 3 review record (archived 2026-08-09)

William's inline review comments on `7-Theme1.tex` and the resolution of each, moved out of the
`.tex` source so the chapter reads clean. Every item below was already resolved in the prose
before archiving; nothing here is outstanding. Anchors are the section and the paragraph the
comment sat next to.

---

## §3.1 Overview of the engine

**Closing paragraph of the overview (`problem.c` collects the objective and constraints).**

> I feel like the word oracle hasn't been used much before here.
> let's maybe say the derivatives?

-> resolved: "oracle" is never defined in ch. 1-2, so it is now gone from ch. 3 (here, the
chapter intro, the atom-classes paragraph, and the API section).

## §3.1.1 Atom classes

**Opening paragraph (canonicalization leaves the objective affine or quadratic).**

> I think we should double check the second sentence.
> there are more ways to get a quadratic objective than the quad form.
> I should double check the code for that there?
> there could be some power and multiplication atoms that are being used instead.

-> resolved: checked `cvxpy/reductions/qp2quad_form/canonicalizers`. `QUAD_CANON_METHODS`
registers `power`, `quad_over_lin`, `huber` and `QuadForm`, and each canon function returns a
`SymbolicQuadForm`, so the other quadratic atoms are gone by the time the objective is
assembled. The sentence now says this instead of asserting "only".

## §3.1.2 The expression node

**Opening paragraph (what an expression node stores).**

> this first sentence is a bit too long, I don't particularly like it.
> also I dont like using n_vars in a sentence like this.
> maybe it can be a separate one where we say n_vars refers to the number
> of columns of all the variables in the problem?

-> resolved: split into two sentences, `n_vars` now gets its own definition.

**Paragraph after the `expr` listing (trees built bottom up, reference counting).**

> maybe instead of through another parent we can say was already init before?

-> resolved.

**Leaf-nodes paragraph.**

> this paragraph might be a bit too detailed, especially the sentence about the parameter
> id and offset, let's maybe not got into that much detail?
> also I dont know about the last sentence, is it really insightful?

-> resolved: parameter id/offset detail cut, and the last sentence cut (it repeated the chapter
intro and 1.1).

## §3.2 Matrix representations

**Opening paragraph (how a node's Jacobian is stored).**

> I feel like polymorphic is a standard term in coding, but maybe not for this thesis?
> my advsior will definitely raise questions, let's think of something else to say?
> and we don't need to say its called matrix? I feel like matrix is a pretty self-explanatory
> term right?
> maybe this last sentence can be said earlier?
> Also the second sentence talks about permuted dense before introducing them
> maybe its fine.. but we could reword that sentence, that different atoms
> create different matrices (maybe a bit of an exaggeration since only matmul does it)
> maybe we can re-emphasize that the reason for this is again to take advantage
> of structure in the problem, and that the philosophy is to use BLAS whenever possible.

-> resolved: rewritten. "polymorphic" and the C type name are gone, the default format comes
first, permuted dense is no longer named before it is defined, and the BLAS motivation is
stated. The cost of sparse storage for a dense block is argued once, in the motivation
paragraph of the next subsection, so there is no back-reference here.

## §3.2.1 The permuted dense matrix

**Motivation paragraph.**

> I like the jist of the idea of how we start this subsection.
> but maybe we could think of a better way to present/motivate it?
> we could consider adding a visual of what the jacobian looks like
> just the structure.. it doesn't need to be an actual matrix.

-> resolved: Figure `fig:pd-motivation` added (structure only, no entries), and the closing
sentence now names the concrete cost instead of pointing back at 1.4.3.

> I dont really like the last sentence. It can be worded better, although the content is
> mostly good.

-> resolved.

**Analogies paragraph (supernodal / multifrontal / blocked sparse formats).**

Note left in the source: analogies moved up from the end of the subsection, per the comment
asking to introduce them where the representation is introduced.

**Definition paragraph.**

> maybe this paragraph should start with the definition of a permuted dense matrix?
> also maybe the emph is not necessary? Its in the subsection title.
> also I dont like the first two sentences, we should state it in a different way possibly.

-> resolved: the paragraph now opens with the definition. `\emph{factored form}` is kept
because it is on the advisor's protected list and is referred to again later.

**After the selector-matrix equation.**

> we should maybe show a visual of the selector matrices?
> for another example possibly.

-> resolved: Figure `fig:selector-matrices` writes out both selectors for the same example as
`fig:permuted-dense`, so the two figures can be read side by side.

**Storage paragraph.**

> I dont like the last sentence with the semi-colon, let's maybe clean that up?
> also it doesn't really make sense, what is structure as a standalone here?
> let's also try to make the paragraphs flow a bit better?
> maybe it would be helpful to remove the named paragraphs so that
> we could focus on making the content flow better overall.

-> resolved: semicolon sentence split, "structure" replaced by what is actually computed. The
subsection is now ordered motivation -> analogies -> definition -> storage -> structural
operations -> chain-rule product -> cost -> limitations.

**Structural operations paragraph.**

> I dont like the wording here, every operation we need...
> the rest of the content is quite helpful and useful to talk about.
> this is the key idea, that we can form this mapping.

-> resolved: opening sentence reworded.

**After `fig:permuted-dense-index` (indexing rows outside the block).**

> my question for this example is, is it even realistic?
> when would we ever select a row which is zero in the jacobian?
> I am trying to think of when these things would even happen? but I can't really think
> of any. Is an index_map of the rows -1 even something that happens?

-> resolved: yes. `diag_vec_pd_alloc` in `permuted_dense.c` maps block row `i` to global row
`i*(n+1)` and leaves the other rows structurally zero, so `diag(A @ x)` followed by any row
operation hits the `-1` branch of `index_pd_alloc`. Named in the text above.

**Chain-rule product paragraph.**

Correction recorded during the pass: $\mmat{B}^\top \mmat{A}$ is Hessian accumulation, not the
Jacobian chain rule. Every caller of `BTA_matrices_alloc` / `BTDA_matrices_fill_values` is a
Hessian routine (`quad_form.c:300,346` on the canonicalization path; `multiply.c:167,262` and
`elementwise_full_dom/common.c:108-161` via `ATA_alloc`, both NLP only). The affine path uses
the untransposed product, at `left_matmul.c:127` (`BA_pd_matrices_alloc`); `BA_pd_pd_alloc`
intersects `c_B` with `r_A`.

**Performance paragraph.**

> I dont like the wording contiguous buffers, if we haven't used it before
> let's definitely cut it.

-> resolved.

> maybe we should cite and introduce these analogies when we introduce the
> permuted dense matrix instead of here? what do you think?

-> resolved: that paragraph moved up to the start of the subsection, where the representation
is introduced.

**Limitations paragraph.**

> so is it true that something like A@x + y is stored as CSR?
> if so then there's a bit of an issue because that might actually happen a lot.
> one additional thing is we should try to make this
> flow better and maybe say that the downside? or something like that?
> otherwise the paragraphs currently all just feel like they are jumbled together.
> I'll think about ways to organize things better too.

-> resolved: yes, and it is now stated plainly with `A@x + y` as the example. `add.c` always
allocates a `sparse_matrix` and calls `sum_matrices_alloc`, which goes through `to_csr` on both
operands. The mitigation is real though: `permuted_dense_to_csr` caches a CSR whose value array
aliases the dense block, so the fallback copies no values per evaluation. Paragraph now opens
with the downside, as asked.

## §3.2.2 The stacked permuted dense matrix

**Opening paragraph (the block diagonal operator of `left_matmul`).**

> the operator is never formed sentence seems a bit out of place.
> also we already talk about and present the kron structure in matrix stuffing.
> so maybe we could avoid that here? and refer to it?

-> resolved: the Kronecker structure is now taken from Table `tab:views-copies` rather than
re-derived, and the "never formed" sentence is folded into the one that says what the atom does
instead.

**Paragraph introducing the third representation.**

> I dont like the wording here, starting the identity, this is not proper language.
> I think we should once again start with the definition maybe?
> or similarly to the pd section to begin with a bit of motivation?
> and then show what and when its needed beyond the original pd matrix.

-> resolved: the paragraph now opens with the problem that motivates the third representation,
and the definition follows in the next paragraph.

**Closing paragraph (the three representations).**

> if this paragraph doesn't read well here, feel free to just cut it.

-> kept: it is the last paragraph of the section and the summary that §3.3 builds on. Trimmed
from five sentences to three.

## §3.3 Computational kernels

**Opening paragraph (definition of a kernel).**

> I guess we dont need the emph here either.
> I dont like the colon into three things, for the first sentence.
> maybe just re-iterate that every atom operation has its own kernel?
> im not sure if its true though. Also the alloc and fill notation is not really
> standard english, we could just use symbolic and numeric pass again? then
> you dont need to re-describe what they are right?

-> resolved for the colon and the alloc/fill wording. The `\emph` is kept: the advisor style
guide lists "kernel" among the four surviving italics in this chapter, and this is its defining
occurrence, which is the criterion the guide uses. Checked `include/utils/matrix.h`: a kernel is
per operation and representation, not per atom (ten operations, each an `_alloc` /
`_fill_values` pair, shared by several atoms).

(Update 2026-08-10: the intro paragraph was rewritten and William dropped the `\emph` on
"kernel" for consistency, superseding the italics decision above. The ten operations are now
listed in `tab:kernel-operations`, with per-atom callers verified by grep over
`SparseDiffEngine/src/atoms/`; notable: the `transpose` atom calls the row-indexing kernel,
while the transposition kernel serves the chain rule of `left_matmul` and `multiply`.)

---

## Removed `\paragraph` headings

The advisor's structure rule (`plans/advisor-style-guide.md` §3) replaced run-in `\paragraph`
headings with continuous prose. In Chapter 3, two were promoted to numbered subsections
(**Atom classes** -> §3.1.1, **The expression node** -> §3.1.2) and the rest were folded into
topic sentences. The folded ones were kept as `% \paragraph{...}` comments until this archive:

| Heading | Section |
|---|---|
| Leaf nodes. | §3.1.2 |
| Definition. | §3.2.1 |
| Storage. | §3.2.1 |
| Structural operations. | §3.2.1 |
| The chain-rule product. | §3.2.1 |
| Performance. | §3.2.1 |
| Limitations. | §3.2.1 |
| Definition. | §3.2.2 |
| The three representations. | §3.2.2 |
| Affine atoms. | §3.3.2 |
| Work done once. | §3.3.2 |
| The problem level. | §3.3.3 |
| Parameter updates. | §3.3.3 |

Chapters 1 and 2 keep their heading markers inline; this pass was Chapter 3 only.
