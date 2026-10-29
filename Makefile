# Makefile for LaTeX files

# Original Makefile from http://www.math.psu.edu/elkin/math/497a/Makefile

# Copyright (c) 2005 Matti Airas <Matti.Airas@hut.fi>

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

TEXINPUTS += :./dia:./gnuplot:./images:./modules
export TEXINPUTS

SRC	= Document.tex
LATEX	= latex -output-format=dvi
PDFLATEX= pdflatex
BIBTEX	= bibtex
XDVI	= xdvi -paper us
DVIPDF  = dvipdfm -p letter

COPY     = if test -r $(<:%.tex=%.toc); then cp $(<:%.tex=%.toc) $(<:%.tex=%.toc.bak); fi
RERUN    = "(There were undefined (references|citations)|Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"


$(SRC:%.tex=%.pdf): $(SRC) $(SRC:%.tex=%.bib) images $(shell ls -1 images/*.eps 2> /dev/null)
	$(COPY); $(PDFLATEX) $(SRC)
	@egrep -c $(RERUNBIB) $(SRC:%.tex=%.log) && ($(BIBTEX) $(SRC:%.tex=%); $(COPY); $(PDFLATEX) $(SRC)); true
	@egrep -q $(RERUN) $(SRC:%.tex=%.log) && ($(COPY);$(PDFLATEX) $(SRC)); true
	@egrep -q $(RERUN) $(SRC:%.tex=%.log) && ($(COPY);$(PDFLATEX) $(SRC)); true
	@if cmp -s $(SRC:%.tex=%.toc) $(SRC:%.tex=%.toc.bak); then true; else $(PDFLATEX) $(SRC); fi
	@rm -f $(SRC:%.tex=%.toc.bak)
	@egrep -i "(Reference|Citation).*undefined" $(SRC:%.tex=%.log); true

$(SRC:%.tex=%.dvi): $(SRC) $(SRC:%.tex=%.bib) images $(shell ls -1 images/*.eps 2> /dev/null)
	$(COPY); $(LATEX) $(SRC)
	@egrep -c $(RERUNBIB) $(SRC:%.tex=%.log) && ($(BIBTEX) $(SRC:%.tex=%); $(COPY); $(LATEX) $(SRC)); true
	@egrep -q $(RERUN) $(SRC:%.tex=%.log) && ($(COPY);$(LATEX) $(SRC)); true
	@egrep -q $(RERUN) $(SRC:%.tex=%.log) && ($(COPY);$(LATEX) $(SRC)); true
	@if cmp -s $(SRC:%.tex=%.toc) $(SRC:%.tex=%.toc.bak); then true; else $(LATEX) $(SRC); fi
	@rm -f $(SRC:%.tex=%.toc.bak)
	@egrep -i "(Reference|Citation).*undefined" $(SRC:%.tex=%.log); true

images:
	@if [ -d dia ]; then cd dia; ${MAKE} -s -j 2; fi
	@if [ -d gnuplot ]; then cd gnuplot; ${MAKE} -s -j 2; fi

show: $(SRC:%.tex=%.dvi)
	@$(XDVI) $< &

%.pdf:	%.dvi
	@$(DVIPDF) -z9 -o $@ $<

pdf: $(SRC:%.tex=%.pdf)

clean:
	@rm -f *.aux *~ $(SRC:%tex=%){dvi,pdf,bbl,blg,log,out,lof,lot,loa,toc,app}

# The defence slides. Kept separate from the $(SRC) rules on purpose: final/draft edit
# line 1 of Document.tex and clean's substitution only ever matched Document.
# Three runs: two for the \tableofcontents outline frames, and a third for nicematrix.
# The \CodeBefore cell shading of the permuted-dense figures is placed from coordinates
# written to the .aux on the previous run, so whenever a page is added or removed the
# panels come out missing (or, inside a scalebox, adrift) until one more run settles them.
presentation: presentation.tex
	${PDFLATEX} -interaction=nonstopmode presentation.tex
	${PDFLATEX} -interaction=nonstopmode presentation.tex
	${PDFLATEX} -interaction=nonstopmode presentation.tex

# The rebuttal and the examiner reports live in feedback/; the rebuttal reads ../Document.aux.
rebuttal: feedback/rebuttal.tex
	cd feedback && ${PDFLATEX} -interaction=nonstopmode rebuttal.tex
	cd feedback && bibtex rebuttal
	cd feedback && ${PDFLATEX} -interaction=nonstopmode rebuttal.tex
	cd feedback && ${PDFLATEX} -interaction=nonstopmode rebuttal.tex

# Changes since the version sent to the jury (21b013b), for the final-deposit review.
# The old revision is exported and built first so both sides have a .bbl for --flatten
# to inline; otherwise the bibliography shows up as deleted. Needs a built Document.bbl.
# Tables are diffed as whole blocks: markup inside a rewritten tabular breaks pdflatex.
DIFFREV = 21b013b
DIFFOLD = .diff-$(DIFFREV)
DIFFNEW = .diff-new
# \BEQ and \EEQ are expanded on both sides so that latexdiff sees equation environments.
# With --math-markup=whole, a changed equation shows as the old one in red, then the new one
# in blue, instead of losing deleted matrices and leaving stray red symbols.
DIFFEQ = perl -pi -e 's/\\BEQ\b/\\begin{equation}/g; s/\\EEQ\b/\\end{equation}/g'
diff: $(SRC:%.tex=%.pdf)
	@rm -rf $(DIFFOLD) $(DIFFNEW); mkdir $(DIFFOLD) $(DIFFNEW)
	git archive $(DIFFREV) | tar -x -C $(DIFFOLD)
	-cd $(DIFFOLD) && $(MAKE) -s > /dev/null 2>&1
	cp *.tex $(SRC:%.tex=%).bbl $(DIFFNEW)/
	rm -f $(DIFFNEW)/$(SRC:%.tex=%)-diff.tex
	cd $(DIFFOLD) && $(DIFFEQ) $$(ls *.tex | grep -v '^defs.tex$$')
	cd $(DIFFNEW) && $(DIFFEQ) $$(ls *.tex | grep -v '^defs.tex$$')
	latexdiff --flatten --math-markup=whole --config="PICTUREENV=(?:picture|DIFnomarkup|tikzpicture|tabular|longtable)[\w\d*@]*" \
	  $(DIFFOLD)/$(SRC) $(DIFFNEW)/$(SRC) > $(SRC:%.tex=%)-diff.tex
	# Additions in plain blue, without the wavy underline.
	perl -pi -e 's/\\color\{blue\}\\uwave\{#1\}/\\color{blue}#1/; s/\\color\{blue\}\\uwave\]/\\color{blue}]/' $(SRC:%.tex=%)-diff.tex
	-$(PDFLATEX) -interaction=nonstopmode $(SRC:%.tex=%)-diff.tex > /dev/null
	-$(PDFLATEX) -interaction=nonstopmode $(SRC:%.tex=%)-diff.tex > /dev/null
	cp $(SRC:%.tex=%)-diff.pdf feedback/
	@rm -rf $(DIFFOLD) $(DIFFNEW)

diff_clean:
	@rm -rf $(SRC:%.tex=%)-diff*.{tex,aux,bbl,blg,log,out,lof,lot,loa,toc,pdf} .diff-*

rebuttal_clean:
	@rm -f feedback/rebuttal.{aux,log,out,pdf}

presentation_clean:
	@rm -f presentation.{aux,log,nav,out,snm,toc,vrb,auxlock,pdf}

all_clean: clean
	@if [ -d dia ]; then cd dia; ${MAKE} clean; fi
	@if [ -d gnuplot ]; then cd gnuplot; ${MAKE} clean; fi

archive: all_clean
	@tar cjf Backup`date '+%Y%m%d'`.tar.bz2 images/* dia/* gnuplot/* *.{tex,sty,bst} Makefile

final:
	@head -n 1 $(SRC) | grep -q draft && (echo '1s/draft/final/'; echo 'w') | red $(SRC) > /dev/null 2>&1; true
	${MAKE}

draft:
	@head -n 1 $(SRC) | grep -q final && (echo '1s/final/draft/'; echo 'w') | red $(SRC) > /dev/null 2>&1; true
	@${MAKE}

help:
	@echo "Template LaTeX pour mémoires et thèses"
	@echo
	@echo "Utilisation:    make [options]"
	@echo
	@echo "  make            (Re)compilation du fichier LaTeX"
	@echo "  make pdf        Génération d'un fichier PDF"
	@echo "  make final      (Re)compilation du fichier LaTeX en mode Final"
	@echo "  make draft      (Re)compilation du fichier LaTeX en mode Draft"
	@echo "  make show       (Re)compilation et démarrage de XDVI"
	@echo "  make clean      Effacement des fichiers générés par LaTeX"
	@echo "  make all_clean  Effacement des fichiers générés par LaTeX et autres répertoires"
	@echo "  make archive    Génération d'un fichier archive avec la date du jour"
	@echo "  make images     Génération de toutes les images"
	@echo

.PHONY	: diff diff_clean show clean all_clean pdf archive final draft help images presentation presentation_clean rebuttal rebuttal_clean
