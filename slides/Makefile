DEPLOY_DIR = ../web/files/docs/

build: statistical-modeling.pdf 2016-02-18.pdf

deploy: build
	[ -d "$(DEPLOY_DIR)" ] || mkdir -p $(DEPLOY_DIR)
	cp *.pdf $(DEPLOY_DIR)

%.pdf: %.md
	pandoc -t beamer -s $^ -o $@


%.pdf: %.tex
	latexmk -xelatex $^

