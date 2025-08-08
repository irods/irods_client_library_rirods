#!/bin/sh

DIR=$(realpath $1)

cd $DIR

docker exec irods-demo-irods-client-icommands-1 ils
