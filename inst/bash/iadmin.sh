#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# create user bobby (G flag appends data with "?")
curl -G -X POST -H "Authorization: ${TOKEN}" \
  --data-urlencode "action=$5" \
  --data-urlencode "target=$6" \
  --data-urlencode "arg2=$7" \
  --data-urlencode "arg3=$8" \
  --data-urlencode "arg4=$9" \
  --data-urlencode "arg5=$10" \
  --data-urlencode "arg6=$11" \
  --data-urlencode "arg7=$12" \
  -o /dev/null \
  "$3/admin"

# list to show result

sh "${MYDIR}/ils.sh" $1 $2 $3 $4 0 0 0 0 100
