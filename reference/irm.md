# Remove Data Objects or Collections in iRODS

This is the equivalent of
[`file.remove()`](https://rdrr.io/r/base/files.html), but applied to an
item inside iRODS.

## Usage

``` r
irm(
  logical_path,
  force = TRUE,
  recursive = FALSE,
  catalog_only = FALSE,
  verbose = FALSE
)
```

## Arguments

- logical_path:

  Path to the data object or collection to remove.

- force:

  Whether the data object or collection should be deleted permanently.
  If `FALSE`, it is sent to the trash collection. Defaults to `TRUE`.

- recursive:

  If a collection is provided, whether its contents should also be
  removed. If a collection is not empty and `recursive` is `FALSE` , it
  cannot be deleted. Defaults to `FALSE`.

- catalog_only:

  Whether to remove only the catalog entry. Defaults to `FALSE`.

- verbose:

  Whether information should be printed about the HTTP request and
  response. Defaults to `FALSE`.

## Value

Invisibly the HTTP call.

## See also

[`imkdir()`](https://irods.github.io/irods_client_library_rirods/reference/imkdir.md)
for creating collections,
[`file.remove()`](https://rdrr.io/r/base/files.html) for an R
equivalent.

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
iauth("rods", "rods")

# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# store
isaveRDS(foo, "foo.rds")

# check if file is stored
ils()

# delete object
irm("foo.rds", force = TRUE)

# check if file is deleted
ils()
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
