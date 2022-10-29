#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

curl -X POST -H "Authorization: ${TOKEN}" "http://localhost/irods-rest/0.9.3/logicalpath?logical-path=/tempZone/home/rods/a/b/c&collection=1&create-parent-collections=1"
