# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Polytechnique Montréal thesis/dissertation LaTeX template supporting both Master's and PhD documents in French or English. The current configuration is for a Master's thesis in Electrical Engineering.

## Build Commands

```bash
make              # Compile to PDF (runs pdflatex + bibtex with auto-reruns)
make pdf          # Same as make
make draft        # Compile in draft mode (shows overflow boxes, no images)
make final        # Compile in final mode
make clean        # Remove intermediate files (.aux, .log, .bbl, etc.)
make all_clean    # Clean including dia/ and gnuplot/ subdirectories
make images       # Pre-generate all diagrams and plots
make show         # Compile and open with XDVI viewer
make archive      # Create dated backup tarball
```

The Makefile handles the full LaTeX compilation cycle: multiple pdflatex runs, bibtex for bibliography, and regenerates TOC/references until stable.

## Document Architecture

**Main entry point:** `Document.tex` - includes all chapter files and controls document assembly.

**Chapter organization (numbered files):**
- `0-Definitions_Etudiant.tex` - Student metadata, jury members, keywords (primary customization point)
- `1-Dedicace.tex` through `9-Annexes.tex` - Content chapters

**Language selection:** Set `\Langue` variable in `Document.tex` (line 27) to `french` or `english`.

**Style/formatting:**
- `MemoireThese.sty` - Institutional formatting (margins, spacing, chapter headings)
- `IEEEtran.bst` / `IEEEtran-francais.bst` - Bibliography styles
- `modules/` - Supporting LaTeX packages (soulutf8, aeguill, etc.)
- `defs.tex` - Custom math/text macros (e.g., `\eg`, `\ie`, `\Expect`, `\argmin`, `\prox`)

## Image Pipeline

Images are generated from source files in subdirectories with their own Makefiles:

- `dia/` - Dia diagram files (`.dia` → `.png`/`.eps`)
- `gnuplot/` - Gnuplot scripts (`.gp` → `.png`)

The main Makefile triggers these automatically. Graphics search path: `./`, `./dia/`, `./gnuplot/`.

## Bibliography

- Source: `Document.bib` (BibTeX format)
- Cite with `\cite{key}` commands
- IEEE numbered style [1], [2], etc.
- Language-appropriate style selected automatically

## Key Customization Points

For thesis content, edit only:
1. `0-Definitions_Etudiant.tex` - Author info, title, jury, degree type (M/D)
2. Chapter files (`5-Introduction.tex`, `6-Revue_litterature.tex`, `7-Theme*.tex`, `8-Conclusion.tex`)
3. `Document.bib` - Add bibliography entries
4. `defs.tex` - Add custom macros as needed

## Dependencies

Required: pdflatex, bibtex, dia (for diagrams), gnuplot (for plots)
