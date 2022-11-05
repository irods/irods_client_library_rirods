#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# add metadata
curl -G -X POST \
  -H "Authorization: ${TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{"entity_name":'"$4"',"entity_type":"collection","operations":[{"operation":"add","attribute":"foo","value":"bar","units":"baz"}]}' \
  "$3/metadata"

# list to show result
sh "${MYDIR}/ils.sh" $1 $2 $3 $4 0 0 1 0 100
