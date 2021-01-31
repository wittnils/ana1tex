# Latex Makefile using latexmk
# Modified by Dogukan Cagatay <dcagatay@gmail.com>
# Originally from : http://tex.stackexchange.com/a/40759
# Copied from: https://gist.github.com/dogukancagatay/2eb82b0233829067aca6
#
# Change only the variable below to the name of the main tex file.
PROJNAME=main
BUILDDIR=build

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: $(PROJNAME).pdf all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: $(PROJNAME).pdf

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

%.table: %.gnuplot
	gnuplot $< && mv $(@F) $(BUILDDIR)/

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interactive=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

$(PROJNAME).pdf: $(PROJNAME).tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode --shell-escape --enable-write18" -output-directory=$(BUILDDIR) -use-make $<

cleanall:
	latexmk -C -output-directory=$(BUILDDIR)

clean:
	latexmk -c -output-directory=$(BUILDDIR) && cd $(BUILDDIR) && rm *.table *.gnuplot

#rm -v $(BUILDDIR)/$(PROJNAME).aux $(BUILDDIR)/$(PROJNAME).log $(BUILDDIR)/$(PROJNAME).fls $(BUILDDIR)/$(PROJNAME).fdb_latexmk