#!/usr/bin/env Rscript --vanilla

args <- commandArgs(trailingOnly = TRUE)

devtools::load_all()

extract_irods_services <- function(services = args[1]) {
  new_docker_compose_file <- docker_compose_file <- get_docker_yaml()
  grep_services <- is_irods_service_in_yaml(services, docker_compose_file)
  new_docker_compose_file[["services"]] <- docker_compose_file[["services"]][grep_services]
  yaml::write_yaml(new_docker_compose_file,  get_docker_compose_path())
  invisible(NULL)
}

extract_irods_services()
