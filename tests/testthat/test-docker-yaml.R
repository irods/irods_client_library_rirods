test_that("docker compose yaml can be found and loaded", {
  skip_on_os("windows")
  path <- get_docker_compose_path()
  expect_equal(path,
               system.file("irods_demo/docker-compose.yml", package = "rirods"))
  expect_vector(get_docker_yaml())
  expect_equal(any(is_irods_service_in_yaml("nginx", get_docker_yaml())), TRUE)
  ref <- list(c(
    "irods-catalog",
    "irods-catalog-provider",
    "irods-catalog-consumer",
    "irods-client-icommands",
    "irods-client-http-api",
    "nginx-reverse-proxy"
  )) |> setNames("irods-demo")
  expect_equal(extract_irods_services_names(c(
    "nginx", "http-api", "icommands", "catalog"
  )), ref)
})
