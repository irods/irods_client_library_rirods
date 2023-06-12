#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

curl -G -X DELETE -H "Authorization: ${TOKEN}" \
  --data-urlencode "logical-path=$4" \
  --data-urlencode "no-trash=$5" \
  "$3/logicalpath"
