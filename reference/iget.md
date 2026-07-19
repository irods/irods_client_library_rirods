# Retrieve File or Object from iRODS

Transfer a file from iRODS to the local storage with `iget()` or read an
R object from an RDS file in iRODS with `ireadRDS()` (see
[`readRDS()`](https://rdrr.io/r/base/readRDS.html)).

## Usage

``` r
iget(
  logical_path,
  local_path,
  offset = 0,
  count = 0,
  verbose = FALSE,
  overwrite = FALSE,
  ticket = NULL
)

ireadRDS(logical_path, offset = 0, count = 0, verbose = FALSE, ticket = NULL)
```

## Arguments

- logical_path:

  Source path in iRODS.

- local_path:

  Destination path in local storage. By default, the basename of the
  logical path; the file will be stored in the current directory (see
  [`getwd()`](https://rdrr.io/r/base/getwd.html)).

- offset:

  Offset in bytes into the data object. Deprecated.

- count:

  Maximum number of bytes to write. Deprecated.

- verbose:

  Whether information should be printed about the HTTP request and
  response.

- overwrite:

  Whether the local file should be overwritten if it exists. Defaults to
  `FALSE`.

- ticket:

  A valid iRODS ticket string. Defaults to `NULL`.

## Value

The R object in case of `ireadRDS()`, invisibly `NULL` in case of
`iget()`.

The R object in case of `ireadRDS()`, invisibly `NULL` in case of
`iget()`.

## See also

[`iput()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
for sending files,
[`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
for sending R objects to iRODS,
[`saveRDS()`](https://rdrr.io/r/base/readRDS.html) for an R equivalent.

Transfer a file from iRODS to the local storage with `iget()` or read an
R object from an RDS file in iRODS with `ireadRDS()` (see
[`readRDS()`](https://rdrr.io/r/base/readRDS.html)).

## Examples

``` r
if (FALSE) { # is_irods_demo_running()
is_irods_demo_running()
DONTSHOW({
.old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
.old_wd <- setwd(tempdir())
Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
})
# connect project to server
create_irods("http://localhost:9001/irods-http-api/0.2.0", overwrite = TRUE)

# authenticate
iauth("rods", "rods")

# save the iris dataset as csv and send the file to iRODS
write.csv(iris, "iris.csv")
iput("iris.csv", "iris.csv")

# bring the file back with a different name
iget("iris.csv", "newer_iris.csv")
file.exists("newer_iris.csv") # check that it has been transferred

# send an R object to iRODS in RDS format
isaveRDS(iris, "irids_in_rds.rds")

# read it back
iris_again <- ireadRDS("irids_in_rds.rds")
iris_again

# delete objects in iRODS
irm("irids_in_rds.rds", force = TRUE)
irm("iris.csv", force = TRUE)

DONTSHOW({
setwd(.old_wd)
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
