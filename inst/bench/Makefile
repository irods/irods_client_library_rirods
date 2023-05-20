MAX_NUM_FILESIZES = 5

all: main dev markdown

main:
	Rscript run-bench.R $@ $(shell pwd) irods/irods_client_library_rirods HEAD $(MAX_NUM_FILESIZES)

dev:
	Rscript run-bench.R $@ $(shell pwd) $(shell cd ../.. && pwd) local $(MAX_NUM_FILESIZES)

markdown:
	Rscript -e "install.packages(knitr); knitr::knit(file.path(getwd(), 'README.Rmd'), file.path(getwd(), 'README.md'))"

clean:
	rm -f main.tsv dev.tsv
