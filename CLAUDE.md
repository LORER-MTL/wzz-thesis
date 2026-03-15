# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Master's thesis (Polytechnique Montréal, Electrical Engineering) on building a lightweight coefficient extractor in C for convex optimization problems. The thesis covers CVXPY canonicalization, expression tree traversal, and extracting constraint matrices/vectors from optimization formulations. Written in English using a bilingual Poly Montréal LaTeX template.

## Build Commands

```bash
make              # Compile to PDF (runs pdflatex + bibtex with auto-reruns)
make draft        # Compile in draft mode (shows overflow boxes, no images)
make final        # Compile in final mode
make clean        # Remove intermediate AND output files (.aux, .log, .bbl, .pdf, etc.)
make all_clean    # Clean including dia/ and gnuplot/ subdirectories
make images       # Pre-generate all diagrams and plots
make archive      # Create timestamped .tar.bz2 backup (runs all_clean first)
```

The Makefile handles the full LaTeX compilation cycle: multiple pdflatex runs, bibtex for bibliography, and regenerates TOC/references until stable.

## Document Architecture

**Main entry point:** `Document.tex` — includes all chapter files and controls document assembly.

**Language selection:** Set `\Langue` in `Document.tex` (line 27) to `french` or `english`. Currently `english`.

**Chapter files and their content:**
- `0-Definitions_Etudiant.tex` — Student metadata, jury members, keywords
- `5-Introduction.tex` — Research context and goals
- `6-Revue_litterature.tex` — Literature review (historical background, modeling languages, DCP, canonicalization)
- `7-Theme1.tex` — "A lightweight coefficient extraction engine" (the core contribution)
- `7-Theme2.tex` — "Benchmark results" (performance/memory comparisons with CVXPY)
- `7-Theme3.tex` — Placeholder (currently empty)
- `8-Conclusion.tex` — Conclusion

**Style/formatting:**
- `MemoireThese.sty` — Institutional formatting (margins, spacing, chapter headings)
- `defs.tex` — Custom math/text macros (`\eg`, `\ie`, `\Expect`, `\argmin`, `\prox`, `\hutchpp`, etc.)
- `modules/` — Supporting LaTeX packages (soulutf8, aeguill, etc.)

## Writing Conventions

- Wrap lines at ~100 characters for readability in diffs
- Chapter titles use `\Chapter{TITLE}` (ALL CAPS argument, macro from `MemoireThese.sty`), not standard `\chapter`. Sections use standard `\section`, `\subsection`, etc.
- Acronyms defined in `4-Sigles_Abrev.tex` using the `acronym` package; use `\ac{ABBR}` for first occurrence. Note: acronyms appear in both an `\acro{}` block and a duplicate `longtable` — keep both in sync when adding/removing acronyms.
- TikZ is used extensively for figures (expression trees, diagrams); libraries loaded: `arrows.meta`, `positioning`, `shapes`, `calc`
- The `blkarray` package is available for block matrices with row/column labels
- Code listings use the `listings` package with Julia as default language (keywords for `MOI`, `JuMP` are pre-configured). Use `\lstset{language=Python}` locally when showing Python/CVXPY code.
- Pseudocode uses `algorithm` + `algpseudocode` (algorithmicx bundle)
- SI units use the `siunitx` package (`\SI{}{}`, `\si{}`)
- Bibliography: `Document.bib` (BibTeX), IEEE numbered style, cite with `\cite{key}`
- Math macros in `defs.tex` follow Boyd & Vandenberghe conventions (e.g., `\reals` for **R**, `\symm` for symmetric matrices, `\dom`, `\epi`, `\prox`)

## Image Pipeline

- `dia/` — Dia diagram files (`.dia` → `.png`/`.eps`)
- `gnuplot/` — Gnuplot scripts (`.gp` → `.png`)
- Graphics search path: `./images/`, `./dia/`, `./gnuplot/`
- Standalone TikZ helpers (`Mvst_compile.tex`, `Circuit_compile.tex`) can be compiled independently to preview complex TikZ figures

## Key Customization Points

For thesis content, edit only:
1. `0-Definitions_Etudiant.tex` — Author info, title, jury, degree type (M/D)
2. Chapter files (`5-Introduction.tex` through `8-Conclusion.tex`)
3. `Document.bib` — Bibliography entries
4. `defs.tex` — Custom macros

## LaTeX Gotchas

- After editing `.bib` entries, run `make` twice (or just `make` — the Makefile auto-detects undefined citations and reruns bibtex).
- The `\Chapter{}` macro expects ALL CAPS text (e.g., `\Chapter{BENCHMARK RESULTS}`). Lowercase will compile but look inconsistent in the TOC.
- When adding a new acronym, update **both** the `\begin{acronym}...\end{acronym}` block **and** the `longtable` in `4-Sigles_Abrev.tex` — they are not auto-synced.
- `\include{}` adds a `\clearpage`; use `\input{}` for mid-chapter includes (e.g., `defs.tex`).

## Dependencies

Required: pdflatex, bibtex, dia (for diagrams), gnuplot (for plots)
