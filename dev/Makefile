# prepare for CRAN by removing unneeded irods_demo bagage
.ONESHELL:
SHELL = /bin/bash
PATH_MODULES := ../inst/irods_demo
DOCKER_MODULES := $(addprefix $(PATH_MODULES)/,irods_client_nfsrods irods_client_zone_management_tool metalnx-db metalnx minio-data)

all: update remove clean

# update modules
update:
	git submodule sync --recursive
	git submodule update --init --force --recursive --remote
# delete unnecessary docker modules
remove:
	rm -rf $(DOCKER_MODULES)
# remove lines docker-compose
clean:
	head -n 65 '$(PATH_MODULES)/docker-compose.yml' > temp.yml
	mv temp.yml '$(PATH_MODULES)/docker-compose.yml'
