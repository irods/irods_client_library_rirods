#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost:80/irods-rest/0.9.2/auth)

# R object
CONTENT=$(Rscript -e "foo <- data.frame(x = c(1, 8, 9), y = c('x', 'y', 'z')); tmp <- tempfile('foo', fileext = '.RDS'); saveRDS(foo, tmp); con <- file(tmp, 'rb'); readBin(con, 'raw', file.info(tmp)[,'size']); close(con)")

# create file
curl -X PUT --data-binary @foo.rds -H "Authorization: ${TOKEN}" -H "Accept-Encoding: gzip, deflate, br" 'http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0'

# get file
curl -X GET -H "Authorization: ${TOKEN}" -H "Accept-Encoding: gzip, deflate, br" 'http://localhost//irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0&count=1000' -v

# delete file
rm foo.rds
