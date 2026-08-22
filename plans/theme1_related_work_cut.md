# Blocked-storage related-work paragraph (cut from §3.2.1, 2026-08-09)

Cut from `7-Theme1.tex` §3.2.1 (`sec:theme1-permuted-dense`), where it sat between the
`fig:pd-motivation` figure and the definition of the permuted dense triple.

**Why:** it raises more questions than it answers in a methodology chapter (what is a
supernode, what is a multifrontal factor, what does autotuning select) and none of them are
needed to read the permuted dense representation. Its one load-bearing claim — the engine
knows its blocks from canonicalization rather than discovering them in the data — is
already implicit in the surrounding text. Moving it to the literature review was rejected:
William does not want ch. 1 or ch. 2 reopened for this.

Bib entries left in `Document.bib` (unused is harmless): `duff1983multifrontal`,
`demmel1999supernodal`, `liu1992multifrontal`, `im2004sparsity`, `vuduc2005oski`. All five
appeared ONLY in this paragraph, so cutting it removes them from the printed bibliography.

If the paragraph is ever wanted back, the contrast to preserve is the last two sentences,
not the citations.

Cut content, verbatim (post-cleanup wording of 2026-08-09):

```latex
Mixing dense blocks into sparse storage appears in several settings. Supernodal and
multifrontal solvers gather dense submatrices of a sparse factor and process them with
level-3 BLAS \cite{duff1983multifrontal, demmel1999supernodal}, a family of methods surveyed
in \cite{liu1992multifrontal}. Blocked sparse formats store the matrix in fixed-size dense
blocks, and autotuning chooses the block size from the matrix itself
\cite{im2004sparsity, vuduc2005oski}. In these systems the blocks are discovered in the data.
Here they are known from canonicalization, which is what makes it possible to keep them in a
dedicated representation from the start.
```

Original wording before the 2026-08-09 style pass (semicolons, "exploit"):

```latex
Mixing dense blocks into sparse storage appears in several settings. Supernodal and
multifrontal solvers gather dense submatrices of a sparse factor and process them with
level-3 BLAS \cite{duff1983multifrontal, demmel1999supernodal}; see also the survey
\cite{liu1992multifrontal}. Blocked sparse formats and autotuned kernels exploit small
dense blocks found in the matrix \cite{im2004sparsity, vuduc2005oski}. In these systems the
blocks are discovered in the data; here they are known from canonicalization, which is what
makes it possible to keep them in a dedicated representation from the start.
```
