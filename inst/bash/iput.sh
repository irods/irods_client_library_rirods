#!/bin/sh

# dir
MYDIR=$(dirname "$(realpath $0)")

# token
TOKEN=$(sh "${MYDIR}/iauth.sh" $1 $2 $3)

# R object
Rscript -e "foo <- data.frame(x = c(1, 8, 9), y = c('x', 'y', 'z')); saveRDS(foo, 'foo.rds')"

# url encode with php
LPATH=$(sh "${MYDIR}/urlencode.sh" "$4/foo.rds")

# create file
curl -X PUT -H "Authorization: ${TOKEN}" \
  -H "Accept-Encoding: gzip, deflate, br" \
  --data-binary @foo.rds \
   "$3/stream?logical-path=${LPATH}&offset=$5&count=$6"

# delete file
rm foo.rds
