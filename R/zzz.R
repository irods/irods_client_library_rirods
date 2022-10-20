# .onLoad <- function(libname, pkgname) {
#   message("Start iRODS session.")
# }
#
#
# irods session environment
.rirods2 <- new.env(parent = parent.env(environment()))
