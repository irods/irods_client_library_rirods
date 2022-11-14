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

# irods environment variables for development
Sys.setenv(DEV_HOST_IRODS = "itxgo_ZF5Ncd79rj1OKLC2i_0z0D7gYgWZj1JbZN7sQe28QyICI6piF5sZyiW0ITmRYCqvh9")
Sys.setenv(DEV_ZONE_PATH_IRODS = "pDRzU24ysv8w1_bSIy6WXFZVJk2Sl2weSv9k2PI")
Sys.setenv(DEV_USER = "ZGlORquE2G6BIPS5JAcuPcngmBB6Wg")
Sys.setenv(DEV_PASS = "ZGlORquE2G6BIPS5JAcuPcngmBB6Wg")
