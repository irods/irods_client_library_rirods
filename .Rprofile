# dependency management
options(renv.settings.snapshot.type = "explicit")
source("renv/activate.R")

# package development
if (interactive()) {
  suppressPackageStartupMessages(require(devtools))
}

# development key (create key with httr2::secret_make_key() and place in user
# level environment variables. One can use usethis::edit_r_environ() for this.
# Store the key under "DEV_KEY_IRODS")

# iRODS environment variables for development
Sys.setenv(DEV_HOST_IRODS = "Dd_rTPPENlWR7NrXsGQkPrd2GgLhUD9zavGum-ppk-v0iSL3iYwc2Uckc_7Tomx92vMcwBON")
Sys.setenv(DEV_ZONE_PATH_IRODS = "AEGApbh1J6Gk0v16t51Wf4YzZBc7LMEFtKthhmw")
Sys.setenv(DEV_USER = "szYLD6oOfZ73SEh9zgOlGVNU97TzWA")
Sys.setenv(DEV_PASS = "szYLD6oOfZ73SEh9zgOlGVNU97TzWA")

# only use core irods-demo functionality
system("cd dev && make")
