.onLoad <- function(libname, pkgname) {
  message("Start iRODS session.")
}

.rirods2 <- new.env(parent = parent.env(environment()))

