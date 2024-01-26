#!/bin/sh

# get token
SECRETS=$(echo -n "rods:rods" | base64)
TOKEN=$(curl -X POST -H "Authorization: Bearer ${SECRETS}" "$3/authenticate")

curl http://localhost:9001/irods-http-api/0.1.0/data-objects \
    -H "Authorization: Bearer ${SECRETS}" \
    --data-urlencode 'op=parallel-write-init' \
    --data-urlencode 'lpath=<string>' \
    --data-urlencode 'stream-count=<integer>' \
    --data-urlencode 'truncate=<integer>' \
    --data-urlencode 'append=<integer>' \
    --data-urlencode 'ticket=<string>'
