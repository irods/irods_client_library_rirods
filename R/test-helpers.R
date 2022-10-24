# create local irods instance in temp dir
local_create_irods <- function(
    host = "http://localhost/irods-rest/0.9.2",
    dir = tempdir(),
    env = parent.frame()
  ) {

  # to return to
  old_dir <- getwd()

  # change working directory
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)

  # switch to new irods project
  create_irods(host, overwrite = TRUE)

  # authenticate
  iauth("rods", "rods")

  # add user bobby
  iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")

  # modify pass word bobby
  iadmin(action = "modify", target = "user", arg2 = "bobby", arg3 = "password",
         arg4  = "passWORD")

  # login
  iauth("bobby", "passWORD")

  invisible(dir)
}
