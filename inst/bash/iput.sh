#!/bin/sh

# dir
MYDIR="$(dirname "$(realpath "$0")")"

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# R object
Rscript -e "foo <- data.frame(x = c(1, 8, 9), y = c('x', 'y', 'z')); saveRDS(foo, 'foo.rds')"

# create file
curl -G -X PUT -H "Authorization: ${TOKEN}" \
  -H "Accept-Encoding: gzip, deflate, br" \
  --data-binary @foo.rds \
  --data-urlencode "logical-path=$4" \
  --data-urlencode "offset=$5" \
   "$3/stream"

# delete file
rm foo.rds
