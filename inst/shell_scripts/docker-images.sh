#!/bin/sh

docker images --filter=reference="irods_demo*" --filter=reference="irods/*" --format "{{.Repository}}"
