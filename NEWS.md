# rirods 0.2.0

## Major changes

* Moving to the new [iRODS C++ HTTP API](https://github.com/irods/irods_client_http_api)

## Minor changes

* Printed output `ils()` has changed a little
* Parameters of `create_irods()`, `isaveRDS()`, `iput()`, `iget()`, `ireadRDS()`, `imeta()`, and `iquery()` are soft deprecated and will be removed over time

# rirods 0.1.2

* Adding more documentation as vignettes:
  + Use iRODS demo
  + rirods vs iCommands
  + Accessing data locally and in iRODS
  + Use iRODS metadata

# rirods 0.1.1

* Supply configuration file to correct user-specific configuration directory 
with `rappdirs::user_config_dir()`.

# rirods 0.1.0

* Initial CRAN submission.
