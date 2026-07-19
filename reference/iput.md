# Save Files and Objects in iRODS

Store an object or file into iRODS. `iput()` should be used to transfer
a file from the local storage to iRODS; `isaveRDS()` saves an R object
from the current environment in iRODS in RDS format (see
[`saveRDS()`](https://rdrr.io/r/base/readRDS.html)).

## Usage

``` r
iput(
  local_path,
  logical_path,
  offset = 0,
  count = 0,
  truncate = TRUE,
  verbose = FALSE,
  overwrite = FALSE,
  ticket = NULL
)

isaveRDS(
  x,
  logical_path,
  offset = 0,
  count = 0,
  truncate = TRUE,
  verbose = FALSE,
  overwrite = FALSE,
  ticket = NULL
)
```

## Arguments

- local_path:

  Local path of file to be sent to iRODS.

- logical_path:

  Destination path in iRODS.

- offset:

  Offset in bytes into the data object. Deprecated.

- count:

  Maximum number of bytes to write. Deprecated.

- truncate:

  Whether to truncate the object when opening it. Deprecated.

- verbose:

  Whether to print information about the HTTP request and response.
  Defaults to `FALSE`.

- overwrite:

  Whether the file in iRODS should be overwritten if it exists. Defaults
  to `FALSE`.

- ticket:

  A valid iRODS ticket string. Defaults to `NULL`.

- x:

  R object to save in iRODS.

## Value

(Invisibly) the HTTP response.

## See also

[`iget()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
for obtaining files,
[`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
for obtaining R objects from iRODS,
[`readRDS()`](https://rdrr.io/r/base/readRDS.html) for an R equivalent.

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

# save with a different name
iput("iris.csv", "iris_in_irods.csv")
ils()

# send an R object to iRODS in RDS format
isaveRDS(iris, "iris_in_rds.rds")

# delete objects in iRODS
irm("iris_in_irods.csv", force = TRUE)
irm("iris_in_rds.rds", force = TRUE)
irm("iris.csv", force = TRUE)

DONTSHOW({
setwd(.old_wd)
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
