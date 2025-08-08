#!/bin/sh

DIR=$(realpath $1)

docker compose up -d irods-client-icommands
docker exec irods-demo-irods-client-icommands-1 iadmin mkuser "$2" rodsuser
docker exec irods-demo-irods-client-icommands-1 iadmin moduser "$2" password "$3"
