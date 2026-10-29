# Message à Antoine : pourquoi les tableaux supplémentaires restent dans la réponse au jury

Brouillon, à envoyer par message. Pages : `Document.pdf` actuel (branche `thesis-objective-claims`).

---

Bonjour Antoine,

J'ai réfléchi à ta suggestion de mettre tous les résultats dans le mémoire. Je propose de garder
les cinq tableaux marqués « Not in the thesis » dans la réponse au jury seulement, pour trois
raisons. J'ai par contre ajouté au chapitre 4 le tableau de l'effet des blocs denses par
problème (tableau 4.2, p. 56), qui répond directement à la question d'ablation du jury.

1. **Chaque résultat est déjà dans le mémoire.** Les cinq tableaux servent d'appui à des
   résultats que le mémoire énonce en une ou deux phrases, avec leurs chiffres (liste
   ci-dessous). Aucune affirmation du mémoire ne repose sur une mesure qui n'y est pas
   rapportée, et toutes les exigences du jury y ont leur place : les écarts types sont dans
   les tableaux 4.1 à 4.3 et dans les annexes, et les tests statistiques sont décrits au
   début du chapitre 4, où le mémoire indique quels ratios des tableaux sont significatifs.
2. **Ce sont des tableaux de diagnostic.** Je les ai produits pour répondre aux questions du
   jury (pourquoi tel problème est plus lent, quel est l'effet des blocs denses sur la mémoire,
   etc.), pas pour la contribution elle-même. Les mettre dans le chapitre 4 en doublerait la
   longueur et noierait les tableaux principaux.
3. **Ce dont un lecteur a besoin pour reproduire est déjà en annexe** : la description et les
   dimensions des 25 problèmes (annexe A) et les études de taille et de densité (annexe B).

La limite de ce choix est qu'après le dépôt, la réponse au jury n'est pas publique. Le
chapitre 4 (p. 51) renvoie déjà au dépôt public
`SparseDifferentiation/canonicalization-benchmarks`, qui contient les scripts et toutes les
mesures, y compris celles de ces cinq tableaux. Un lecteur peut donc vérifier chaque phrase.

| Tableau de la réponse | Ce que le mémoire en dit |
|---|---|
| Résumé des ablations | §4.1, p. 53, et tableau 4.2, p. 56 : l'effet des blocs denses problème par problème. Les moyennes sur l'ensemble de la suite et l'ablation de la séparation sur les re-résolutions ne sont que dans la réponse (Q2). |
| Mémoire maximale | §4.1, p. 53 et figure 4.1b, p. 55 : 1,04× `CPP`, 0,98× `COO`, 1,45× `SCIPY` en moyenne géométrique ; 0,83× sans blocs denses. |
| Phases des quatre problèmes plus lents | §4.1, p. 52 : la phase dominante et sa part pour chacun (98 %, 89 %, 49/47 %, 47/38 %). |
| Problèmes non DPP | §4.2, p. 57 : 13 à 14× plus rapide que `CVXPY`, et l'exception de ConvexPlasticity. |
| Re-résolution contre recanonicalisation | Réponse à la question Q4 de la soutenance ; le mémoire ne fait pas d'affirmation à ce sujet. |

Si tu tiens à l'un de ces tableaux en particulier, je peux l'ajouter à l'annexe A sans
difficulté : le LaTeX existe déjà.

Merci encore,
William

---

## Before sending

- The public repo does **not** hold the 30-run results yet: in
  `~/Documents/diffengine-canonicalization-benchmarks`, `results/thesis-n30-final/` (ablation,
  memory, phases, no-dense, nondpp tables), `thesis-n30-committee/` and `thesis-n30-no3525/` are
  untracked, and four scripts are modified, on branch `thesis-n30-grid`. Commit, push and merge
  them before sending, since the message says the results are there. The thesis already
  links the repo (`7-Theme2.tex:49-52`), so the thesis itself needs no change.
- "tu" vs "vous": the draft uses "tu".
- Recheck pages after the next build.
