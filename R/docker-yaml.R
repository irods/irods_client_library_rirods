get_docker_compose_path <- function() {
  system.file("irods_demo/docker-compose.yml", package = "rirods")
}

get_docker_yaml <- function() {
  docker_compose_file <- yaml::read_yaml(get_docker_compose_path(), handlers = list(
    # make sure that sequences of size one are read as list
    # (defaults to vector of length one)
    seq = function(x) {
      x <- as.list(x)
      x
    }
  ))
}

is_irods_service_in_yaml <- function(services, docker_compose_file) {
  docker_compose_service_names <- names(docker_compose_file[["services"]])
  irods_services_pattern <- paste0(services, collapse = "|")
  grepl(irods_services_pattern, docker_compose_service_names)
}

extract_irods_services_names <- function(services) {
  docker_compose_file <- get_docker_yaml()
  list(names(docker_compose_file[["services"]])[is_irods_service_in_yaml(services, docker_compose_file)]) |>
    setNames(docker_compose_file[["name"]])
}
