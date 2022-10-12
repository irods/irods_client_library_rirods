.onLoad <- function(libname, pkgname) {
  message("Start iRODS session.")
}

.rirods2 <- new.env(parent = parent.env(environment()))

# starting dir
local(current_dir <- "/", envir = .rirods2)
