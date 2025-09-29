# iRODS session environment
.rirods <- new.env(parent = parent.env(environment()))

.onLoad <- function(libname, pkgname) {
  ns <- topenv()
  ns$.irods_host <- "http://localhost:9001/irods-http-api/0.5.0"
}
