# List iRODS Data Objects and Collections

List the contents of a collection, optionally with stat, metadata,
and/or access control information for each element in the collection.

## Usage

``` r
ils(
  logical_path = ".",
  stat = FALSE,
  permissions = FALSE,
  metadata = FALSE,
  offset = numeric(1),
  limit = find_irods_file("max_number_of_rows_per_catalog_query"),
  recurse = FALSE,
  ticket = NULL,
  message = TRUE,
  verbose = FALSE
)
```

## Arguments

- logical_path:

  Path to the collection whose contents are to be listed. By default
  this is the current working collection (see
  [`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)).

- stat:

  Whether stat information should be included. Defaults to `FALSE`.

- permissions:

  Whether access control information should be included. Defaults to
  `FALSE`.

- metadata:

  Whether metadata information should be included. Defaults to `FALSE`.

- offset:

  Number of records to skip for pagination. Deprecated.

- limit:

  Number of records to show per page.

- recurse:

  Recursively list. Defaults to `FALSE`.

- ticket:

  A valid iRODS ticket string. Defaults to `NULL`.

- message:

  Show message when empty collection. Default to `FALSE`.

- verbose:

  Whether information should be printed about the HTTP request and
  response. Defaults to `FALSE`.

## Value

Dataframe with logical paths and, if requested, additional information.

## See also

[`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
for finding the working collection,
[`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
for setting the working collection, and
[`list.files()`](https://rdrr.io/r/base/list.files.html) for an R
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

# list home directory
ils()

# make collection
imkdir("some_collection")

# list a different directory
ils("/tempZone/home/rods/some_collection")

# show metadata
ils(metadata = TRUE)

# delete `some_collection`
irm("some_collection", force = TRUE, recursive = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
