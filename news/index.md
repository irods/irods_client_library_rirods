# Changelog

## rirods 0.3.0

### Minor changes

- Move maintainership to the iRODS Consortium
- Updating GitHub Actions to current versions

## rirods 0.2.0

CRAN release: 2024-03-15

### Major changes

- Moving to the new [iRODS C++ HTTP
  API](https://github.com/irods/irods_client_http_api)

### Minor changes

- Printed output
  [`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
  has changed a little
- Parameters of
  [`create_irods()`](https://irods.github.io/irods_client_library_rirods/reference/create_irods.md),
  [`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md),
  [`iput()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md),
  [`iget()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md),
  [`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md),
  [`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md),
  and
  [`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md)
  are soft deprecated and will be removed over time

## rirods 0.1.2

CRAN release: 2023-11-02

- Adding more documentation as vignettes:
  - Use iRODS demo
  - rirods vs iCommands
  - Accessing data locally and in iRODS
  - Use iRODS metadata

## rirods 0.1.1

CRAN release: 2023-06-30

- Supply configuration file to correct user-specific configuration
  directory with
  [`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html).

## rirods 0.1.0

- Initial CRAN submission.
