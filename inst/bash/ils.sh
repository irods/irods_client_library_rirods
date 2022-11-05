#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# list files
curl -G -X GET -H "Authorization: ${TOKEN}" \
  --data-urlencode "logical-path=$4" \
  --data-urlencode "stat=$5" \
  --data-urlencode "permissions=$6" \
  --data-urlencode "metadata=$7" \
  --data-urlencode "offset=$8" \
  --data-urlencode "limit=$9" \
  "$3/list?"


