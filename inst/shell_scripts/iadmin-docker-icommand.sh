#!/bin/sh

DIR="$(dirname "$(realpath "$0")")"

cd $DIR
cd ../irods_demo

docker compose up -d irods-client-icommands
docker exec irods_demo-irods-client-icommands-1 iadmin mkuser "$1" rodsuser
docker exec irods_demo-irods-client-icommands-1 iadmin moduser "$1" password "$2"
