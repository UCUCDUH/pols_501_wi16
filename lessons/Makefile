RSCRIPT ?= Rscript
RSCRIPT_OPTS ?=

RMD_FILES = $(wildcard *.Rmd)
HTML_FILES = $(RMD_FILES:%.Rmd=%.html)

build: $(HTML_FILES)

%.html: %.Rmd _output.yaml
	$(RSCRIPT) $(RSCRIPT_OPTS) -e "rmarkdown::render('$<', output_file='$@')"

deploy: build
	-cp $(HTML_FILES) ../web/files
	-cp -R *_files  ../web/files
	-cp labs.css ../web/files
