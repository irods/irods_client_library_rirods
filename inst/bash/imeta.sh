#!/bin/sh

# token
SECRETS=$(echo -n bobby:passWORD | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

curl -X POST \
-H "Authorization: ${TOKEN}" \
-H "Content-Type: application/json" \
--data '{"entity_name":"/tempZone/home/bobby/foo","entity_type":"data_object","operations":[{"operation":"add","attribute":"foo","value":"bar","units":"baz"}]}' \
http://localhost/irods-rest/0.9.3/metadata
