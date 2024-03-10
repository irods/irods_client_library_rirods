#!/bin/sh

DIR="$(dirname "$(realpath "$0")")"

cd $DIR
cd ../irods_demo

docker exec irods-demo-irods-client-icommands-1 ils
