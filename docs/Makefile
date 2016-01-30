DEPLOY_DIR = "../web/files/docs"
PDF = Bayes.pdf

build: $(PDF)

deploy: build
	[ -d "$(DEPLOY)_DIR)" ] || mkdir -p $(DEPLOY_DIR)
	cp *.pdf $(DEPLOY_DIR)

%.pdf: %.Rmd
	RScript -e 'rmarkdown::render("$^", output_format="pdf_document", output_file="$@")'

%.pdf: %.tex
	latexmk -xelatex $^
