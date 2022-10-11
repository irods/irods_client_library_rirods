#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost:80/irods-rest/0.9.2/auth)

# create file

curl -X PUT -H "Authorization: ${TOKEN}" -F "fileX=@/home/nicola/Documents/work/code/rirods2/inst/external/foo.RDS" 'http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2FfileX'

# show file
curl -X GET -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2FfileX' #-o "./foo.RDS"



curl -X PUT -H "Authorization: ${TOKEN}" -d "This is some data" 'http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2FfileX&offset=0'
curl -X GET -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2FfileX&offset=0&count=1000' --output -
