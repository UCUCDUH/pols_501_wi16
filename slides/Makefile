DEPLOY_DIR = ../web/files/docs/

build: statistical-modeling.pdf

deploy: build
	[ -d "$(DEPLOY_DIR)" ] || mkdir -p $(DEPLOY_DIR)
	cp *.pdf $(DEPLOY_DIR)

%.pdf: %.tex
	latexmk -xelatex $^

