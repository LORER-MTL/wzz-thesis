# Third backend limitation (parameter tensor) — CUT 2026-08-12

Cut from §2.1.4 Backends and limitations (`6-Revue_litterature.tex`), per William: the
explanations weren't clear and he didn't want the lit review to claim the tensor is bad.
The limitations paragraph went back to two ("All three backends share two limitations").
Theme 2 makes the tensor-cost point empirically (setup-time degradation of cvxcore/SCIPY
with parameter count, tensor vs diffengine re-solve table), which stands on its own.

The limitation was added 2026-08-11 and reworded twice on 2026-08-12 before being cut.
Last wording:

> Thirdly, the parameter tensor can be far larger than the problem data it produces.
> It stores one entry for every dependence of a coefficient on a parameter entry, while the
> data stores one entry per nonzero coefficient. A re-solve applies every stored entry,
> whatever the parameter values.

Original wording (2026-08-11):

> Thirdly, the parameter tensor is an intermediate that the problem data does not require.
> It stores one entry for every dependence of a coefficient on a parameter entry, so its size
> can far exceed the number of nonzeros in the data it produces, and a re-solve re-applies
> every stored entry regardless of the parameter values.

If the argument is ever wanted again, Theme 1 (design rationale) or Theme 2 (empirical
discussion) are the natural homes, not the lit review.
