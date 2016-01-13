RSCRIPT ?= Rscript
RSCRIPT_OPTS ?=

RMD_FILES = $(wildcard *.Rmd)
HTML_FILES = $(RMD_FILES:%.Rmd=%.html)

build: $(HTML_FILES)

%.html: %.Rmd
	$(RSCRIPT) $(RSCRIPT_OPTS) -e "rmarkdown::render('$^', output_file='$@')"
