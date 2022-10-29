#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

# R object
Rscript -e "foo <- data.frame(x = c(1, 8, 9), y = c('x', 'y', 'z')); saveRDS(foo, 'foo.rds')"

# create file
curl -X PUT --data-binary @foo.rds -H "Authorization: ${TOKEN}" -H "Accept-Encoding: gzip, deflate, br" 'http://localhost/irods-rest/0.9.3/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0'

# delete file
rm foo.rds
