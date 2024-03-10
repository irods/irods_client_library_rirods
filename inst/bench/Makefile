ROOT=$(shell pwd)

all: rest http

rest:
	Rscript run-bench.R $@ '$ROOT/posts/rirods-0-2-0/data' irods/irods_client_library_rirods HEAD http://localhost/irods-rest/0.9.3

http:
	Rscript run-bench.R $@ '$ROOT/posts/rirods-0-2-0/data' martinschobben/irods_client_library_rirods dev local http://localhost:9001/irods-http-api/0.2.0

clean:
	rm -f '$ROOT/posts/rirods-0-2-0/data/rest-files.csv' '$ROOT/posts/rirods-0-2-0/datarest-files.csv'
