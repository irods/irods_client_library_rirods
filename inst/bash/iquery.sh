#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# query data
curl -G -X GET -H "Authorization: ${TOKEN}" \
  --data-urlencode "limit=$5" \
  --data-urlencode "offset=$5" \
  --data-urlencode "type=$5" \
  --data-urlencode "query=$5" \
  "$3/query"
