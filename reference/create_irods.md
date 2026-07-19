# Generate IRODS Configuration File

This will create an iRODS configuration file containing information
about the iRODS server. Once the file has been created, future sessions
connect again with the same iRODS server without further intervention.

## Usage

``` r
create_irods(host, zone_path = character(1), overwrite = FALSE)
```

## Arguments

- host:

  URL of host.

- zone_path:

  Deprecated

- overwrite:

  Overwrite existing iRODS configuration file. Defaults to `FALSE`.

## Value

Invisibly, the path to the iRODS configuration file.

## Details

The configuration file is located in the user-specific configuration
directory. This destination is set with R_USER_CONFIG_DIR if set.
Otherwise, it follows platform conventions (see also
[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)).
