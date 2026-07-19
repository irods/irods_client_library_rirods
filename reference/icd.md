# Get or Set Current Working Directory in iRODS

`ipwd()` and `icd()` are the iRODS equivalents of
[`getwd()`](https://rdrr.io/r/base/getwd.html) and
[`setwd()`](https://rdrr.io/r/base/getwd.html) respectively. For
example, whereas [`getwd()`](https://rdrr.io/r/base/getwd.html) returns
the current working directory in the local system, `ipwd()` returns the
current working directory in iRODS.

## Usage

``` r
icd(dir)

ipwd()
```

## Arguments

- dir:

  Collection to set as working directory.

## Value

Invisibly the current directory before the change (same convention as
[`setwd()`](https://rdrr.io/r/base/getwd.html)).

## See also

[`setwd()`](https://rdrr.io/r/base/getwd.html) and
[`getwd()`](https://rdrr.io/r/base/getwd.html) for R equivalents,
[`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
for listing collections and objects in iRODS.

## Examples

``` r
if (FALSE) { # is_irods_demo_running()
is_irods_demo_running()
DONTSHOW({
.old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
})
# connect project to server
create_irods("http://localhost:9001/irods-http-api/0.2.0", overwrite = TRUE)

# authenticate
iauth("rods", "rods", "rodsadmin")

# default dir
icd(".")
ipwd()

# relative paths work as well
icd("/tempZone/home")
ipwd()

# go back on level lower
icd("..")
ipwd()

# absolute paths work as well
icd("/tempZone/home/rods")
ipwd()

# back home
icd("/tempZone/home")
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
