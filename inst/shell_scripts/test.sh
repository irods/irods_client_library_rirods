#!/bin/sh

# get token
SECRETS=$(echo -n "rods:rods" | base64)
TOKEN=$(curl -X POST -u "rods:rods" http://localhost:9001/irods-http-api/0.1.0/authenticate)

curl -H "Authorization: Bearer $TOKEN" "http://localhost:9001/irods-http-api/0.1.0/data-objects" \
  --data-urlencode 'op=parallel_write_init'                                     \
  --data-urlencode "lpath=/tempZone/home/rods/file.bin"                         \
  --data-urlencode 'stream-count=3' \
  -v

# Open 3 streams to the data object, file.bin.
transfer_handle=$(curl -H "Authorization: Bearer $TOKEN" "http://localhost:9001/irods-http-api/0.1.0/data-objects" \
  --data-urlencode 'op=parallel_write_init'                                     \
  --data-urlencode "lpath=/tempZone/home/rods/file3.bin"                         \
  --data-urlencode 'stream-count=3'                                             \
  | jq -r .parallel_write_handle)

curl -H "Authorization: Bearer $TOKEN" "http://localhost:9001/irods-http-api/0.1.0/data-objects" \
    -F 'op=write' \
    -F 'lpath=/tempZone/home/rods/foo5090' \
    -F 'bytes=580a00;type=application/octet-stream' \
    -v
