#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# imdkir
curl -G -X POST -H "Authorization: ${TOKEN}" \
  --data-urlencode "logical-path=$4" \
  --data-urlencode "collection=$5" \
  --data-urlencode "create-parent-collections=$6" \
  "$3/logicalpath"
