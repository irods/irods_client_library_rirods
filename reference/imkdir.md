# Create a New Collection in iRODS

This is the equivalent to
[`dir.create()`](https://rdrr.io/r/base/files2.html), but creating a
collection in iRODS instead of a local directory.

## Usage

``` r
imkdir(
  logical_path,
  create_parent_collections = FALSE,
  overwrite = FALSE,
  verbose = FALSE
)
```

## Arguments

- logical_path:

  Path to the collection to create, relative to the current working
  directory (see
  [`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)).

- create_parent_collections:

  Whether parent collections should be created when necessary. Defaults
  to `FALSE`.

- overwrite:

  Whether the existing collection should be overwritten if it exists.
  Defaults to `FALSE`.

- verbose:

  Whether information about the HTTP request and response should be
  printed. Defaults to `FALSE`.

## Value

Invisibly the HTTP request.

## See also

[`irm()`](https://irods.github.io/irods_client_library_rirods/reference/irm.md)
for removing collections,
[`dir.create()`](https://rdrr.io/r/base/files2.html) for an R
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

# authentication
iauth("rods", "rods")

# list all object and collection in the current collection of iRODS
ils()

# create a new collection
imkdir("new_collection")

# check if it is there
ils()

# and move to the new directory
icd("new_collection")

# remove collection
icd("..")
irm("new_collection", force = TRUE, recursive = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
