#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# get file
curl -G -X GET -H "Authorization: ${TOKEN}" \
  -H "Accept-Encoding: gzip, deflate, br" \
  --data-urlencode "logical-path=$4" \
  --data-urlencode "offset=$5" \
  --data-urlencode "count=$6" \
   "$3/stream" > foo.rds
