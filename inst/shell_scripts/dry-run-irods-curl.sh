#!/bin/sh

# get token
TOKEN=$(curl -X POST -u "$1:$2" "$3/authenticate")

curl -G "$3/collections"\
    -H "Authorization: Bearer ${TOKEN}" \
    --data-urlencode 'op=list' \
    --data-urlencode "lpath=$4" \
    --data-urlencode "recurse=0" | grep -o "\"status_code\":[0-9]*"
