#!/bin/sh

docker images --filter=reference="irods_demo_*" --format "{{.Repository}}"
