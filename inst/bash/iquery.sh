#!/bin/sh

# token
SECRETS=$(echo -n bobby:passWORD | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

curl -X GET -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.3/query?limit=100&offset=0&type=general&query=SELECT%20COLL_NAME%2C%20DATA_NAME%20WHERE%20COLL_NAME%20LIKE%20%27%2FtempZone%2Fhome%2Fbobby%25%27' | jq
