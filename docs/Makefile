PDF = Bayes.pdf

build: $(PDF)

deploy: build
	[ ! -d "../web/files/docs" ] && mkdir ../web/files/docs
	cp *.pdf ../web/files/docs/

%.pdf: %.Rmd
	RScript -e 'rmarkdown::render("$^", output_format="pdf_document", output_file="$@")'

%.pdf: %.tex
	latexmk -xelatex $^
