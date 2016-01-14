SHELL = bash
RSCRIPT ?= Rscript
RSCRIPT_OPTS ?=

DEPLOY_DIR = ../web/files/lessons/

RMD_FILES = $(wildcard *.Rmd)
HTML_FILES = $(RMD_FILES:%.Rmd=%.html)

build: $(HTML_FILES)

%.html: %.Rmd _output.yaml
	$(RSCRIPT) $(RSCRIPT_OPTS) -e "rmarkdown::render('$<', output_file='$@')"

deploy: build
	- [ ! -d "$(DEPLOY_DIR)" ] && mkdir -p $(DEPLOY_DIR)
	-cp $(HTML_FILES) $(DEPLOY_DIR)
	-cp -R *_files  $(DEPLOY_DIR)
	-cp -R libs $(DEPLOY_DIR)

.PHONY: build deploy
