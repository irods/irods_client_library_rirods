#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost:80/irods-rest/0.9.2/auth)

curl -X DELETE -H "Authorization: ${TOKEN}" "http://localhost:80/irods-rest/0.9.2/logicalpath?logical-path=/tempZone/home/X&no-trash=1"
