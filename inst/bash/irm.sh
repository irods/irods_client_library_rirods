#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

curl -X DELETE -H "Authorization: ${TOKEN}" "http://localhost/irods-rest/0.9.3/logicalpath?logical-path=/tempZone/home/X&no-trash=1"
