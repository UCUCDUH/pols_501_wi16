RSCRIPT ?= Rscript
RSCRIPT_OPTS ?=

DEPLOY_DIR = ../web/files/lessons/

RMD_FILES = $(wildcard *.Rmd)
HTML_FILES = $(RMD_FILES:%.Rmd=%.html)
R_FILES = $(wildcard *-template.R)
INCLUDES = $(wildcard _include/*.html)

build: $(HTML_FILES)

%.html: %.Rmd _output.yaml $(INCLUDES)
	$(RSCRIPT) $(RSCRIPT_OPTS) -e "rmarkdown::render('$<', output_file='$@')"

deploy:
	[ -d "$(DEPLOY_DIR)" ] || mkdir -p $(DEPLOY_DIR)
	-cp $(HTML_FILES) $(DEPLOY_DIR)
	-cp -R *_files  $(DEPLOY_DIR)
	-cp -R libs $(DEPLOY_DIR)
	-cp $(R_FILES) $(DEPLOY_DIR)

.PHONY: build deploy
