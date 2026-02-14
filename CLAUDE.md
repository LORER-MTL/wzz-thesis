# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Master's thesis (Polytechnique Montréal, Electrical Engineering) on building a lightweight coefficient extractor in C for convex optimization problems. The thesis covers CVXPY canonicalization, expression tree traversal, and extracting constraint matrices/vectors from optimization formulations. Written in English using a bilingual Poly Montréal LaTeX template.

## Build Commands

```bash
make              # Compile to PDF (runs pdflatex + bibtex with auto-reruns)
make draft        # Compile in draft mode (shows overflow boxes, no images)
make final        # Compile in final mode
make clean        # Remove intermediate files (.aux, .log, .bbl, etc.)
make all_clean    # Clean including dia/ and gnuplot/ subdirectories
make images       # Pre-generate all diagrams and plots
```

The Makefile handles the full LaTeX compilation cycle: multiple pdflatex runs, bibtex for bibliography, and regenerates TOC/references until stable.

## Document Architecture

**Main entry point:** `Document.tex` — includes all chapter files and controls document assembly.

**Language selection:** Set `\Langue` in `Document.tex` (line 27) to `french` or `english`. Currently `english`.

**Chapter files and their content:**
- `0-Definitions_Etudiant.tex` — Student metadata, jury members, keywords
- `5-Introduction.tex` — Research context and goals
- `6-Revue_litterature.tex` — Literature review (historical background, modeling languages, DPP/DCP, canonicalization)
- `7-Theme1.tex` — "Setting the stage" (expression trees, linear operators, CVXPY internals)
- `7-Theme2.tex` — "Handling parameters" (tensor approach for parametric optimization)
- `7-Theme3.tex` — "Benchmark results"
- `8-Conclusion.tex` — Conclusion

**Style/formatting:**
- `MemoireThese.sty` — Institutional formatting (margins, spacing, chapter headings)
- `defs.tex` — Custom math/text macros (`\eg`, `\ie`, `\Expect`, `\argmin`, `\prox`, `\hutchpp`, etc.)
- `modules/` — Supporting LaTeX packages (soulutf8, aeguill, etc.)

## Writing Conventions

- Wrap lines at ~100 characters for readability in diffs
- Chapter titles use `\Chapter{TITLE}` (all caps, from `MemoireThese.sty`), not standard `\chapter`
- Acronyms defined in `4-Sigles_Abrev.tex` using the `acronym` package; use `\ac{ABBR}` for first occurrence
- TikZ is used extensively for figures (expression trees, diagrams); libraries loaded: `arrows.meta`, `positioning`, `shapes`, `calc`
- The `blkarray` package is available for block matrices with row/column labels
- SI units use the `siunitx` package (`\SI{}{}`, `\si{}`)
- Bibliography: `Document.bib` (BibTeX), IEEE numbered style, cite with `\cite{key}`

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

## Dependencies

Required: pdflatex, bibtex, dia (for diagrams), gnuplot (for plots)
