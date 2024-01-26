#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)
TOKEN=$(sh iauth.sh rods rods http://localhost:9001/irods-http-api/0.1.0)


curl -G "http://localhost:9001/irods-http-api/0.1.0/collections"\
    -H "Authorization: ${TOKEN}" \
    --data-urlencode 'op=list' \
    --data-urlencode "lpath=/tempZone/home/rods" \
    --data-urlencode "recurse=0" \
    --data-urlencode "ticket="

# list files
curl -G "$3/collections?"\
    -H "Authorization: ${TOKEN}" \
    --data-urlencode 'op=list' \
    --data-urlencode "lpath=$4" \
    --data-urlencode "recurse=0" \
    --data-urlencode "ticket="

# curl -G -X GET -H "Authorization: ${TOKEN}" \
#   --data-urlencode "logical-path=$4" \
#   --data-urlencode "stat=$5" \
#   --data-urlencode "permissions=$6" \
#   --data-urlencode "metadata=$7" \
#   --data-urlencode "offset=$8" \
#   --data-urlencode "limit=$9" \
#   "$3/list?"