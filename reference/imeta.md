# Add or Remove Metadata

In iRODS, metadata is stored as attribute-value-units triples (AVUs),
consisting of an attribute name, an attribute value and an optional
unit. This function allows to chain several operations ('add' or
'remove') linked to specific AVUs. Read more about metadata by looking
at the iCommands equivalent `imeta` in the [iRODS
Docs](https://docs.irods.org/master/icommands/metadata/).

## Usage

``` r
imeta(
  logical_path,
  entity_type = c("data_object", "collection", "user"),
  operations = list(),
  admin = FALSE,
  verbose = FALSE
)
```

## Arguments

- logical_path:

  Path to the data object or collection (or name of the user).

- entity_type:

  Type of item to add metadata to or remove it from. Options are
  'data_object', 'collection' and 'user'. Deprecated.

- operations:

  List of named lists or
  [data.frame](https://rdrr.io/r/base/data.frame.html) representing
  operations. The valid components of each of these lists or vectors
  are:

  - `operation`, with values 'add' or 'remove', depending on whether the
    AVU should be added to or removed from the metadata of the item
    (required).

  - `attribute`, with the name of the AVU (required).

  - `value`, with the value of the AVU (required).

  - `units`, with the unit of the AVU (optional).

- admin:

  Whether to grant admin rights. Defaults to `FALSE`.

- verbose:

  Whether information should be printed about the HTTP request and
  response. Defaults to `FALSE`.

## Value

Invisibly, the HTTP response.

## References

https://docs.irods.org/master/icommands/metadata/

## See also

[`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md)

## Examples

``` r
if (FALSE) { # is_irods_demo_running()
is_irods_demo_running()

# demonstration server (requires Bash, Docker and Docker-compose)
# use_irods_demo()
DONTSHOW({
.old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
})
# connect project to server
create_irods("http://localhost:9001/irods-http-api/0.2.0", overwrite = TRUE)

# authentication
iauth("rods", "rods")

# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# store
isaveRDS(foo, "foo.rds")

# check if file is stored
ils()

# add some metadata
imeta(
  "foo.rds",
   operations =
    list(
     list(operation = "add", attribute = "foo", value = "bar", units = "baz")
   )
)

# `operations` can contain multiple tags supplied as a `data.frame`
imeta(
  "foo.rds",
  operations = data.frame(
    operation = c("add", "add"),
    attribute = c("foo2", "foo3"),
    value = c("bar2", "bar3"),
    units = c("baz2", "baz3")
   )
 )

# or again as a list of lists
imeta(
  "foo.rds",
  operations = list(
    list(operation = "add", attribute = "foo4", value = "bar4", units = "baz4"),
    list(operation = "add", attribute = "foo5", value = "bar5", units = "baz5")
  )
)

# list of lists are useful as AVUs don't have to contain units
imeta(
  "foo.rds",
  operations = list(
    list(operation = "add", attribute = "foo6", value = "bar6"),
    list(operation = "add", attribute = "foo7", value = "bar7", units = "baz7")
  )
)

# check if file is stored with associated metadata
ils(metadata = TRUE)

# delete object
irm("foo.rds", force = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
