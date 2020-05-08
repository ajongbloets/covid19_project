
.PHONY = clean

%.html: %.Rmd
	Rscript -e "rmarkdown::render(\"$<\")"

all: reports/corona_watch/corona_watch.html reports/nice/nice.html

clean:
	rm -f reports/corona_watch/corona_watch.html
	rm -f reports/nice/nice.html
