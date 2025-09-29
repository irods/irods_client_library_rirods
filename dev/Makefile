# prepare for CRAN by removing unneeded irods_demo bagage
.ONESHELL:
SHELL = /bin/bash
PATH_MODULES := ../inst/irods_demo/.
IRODS_MODULES := nginx http icommands catalog minio
SPACE = $(eval) $(eval)
DOCKER_MODULES = $(subst $(SPACE),\|,$(IRODS_MODULES))
DOCKER_MODULES_REGEX = ".*\($(DOCKER_MODULES)\).*"

.PHONY: update clean

all: update clean

update:
	git submodule sync --recursive
	git submodule update --init --force --recursive --remote
clean:
	$(shell find $(PATH_MODULES) -type d ! -regex $(DOCKER_MODULES_REGEX) -exec rm -rf {} +)
	Rscript extract_irods_services_yaml.R $(DOCKER_MODULES)
