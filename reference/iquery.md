# Query Data Objects and Collections in iRODS

Use SQL-like expressions to query data objects and collections based on
different properties. Read more about queries by looking at the
iCommands equivalent `iquest` in the [iRODS
Docs](https://docs.irods.org/master/icommands/user/#iquest).

## Usage

``` r
iquery(
  query,
  limit = 100,
  offset = 0,
  type = c("general", "specific"),
  case_sensitive = TRUE,
  distinct = TRUE,
  parser = c("genquery1", "genquery2"),
  sql_only = FALSE,
  verbose = FALSE
)
```

## Arguments

- query:

  GeneralQuery for searching the iCAT database.

- limit:

  Maximum number of rows to return.

- offset:

  Number of rows to skip for paging. Deprecated.

- type:

  Type of query: 'general' (the default) or 'specific'.

- case_sensitive:

  Whether the string matching in the query is case sensitive. Defaults
  to `TRUE`.

- distinct:

  Whether only distinct rows should be listed. Defaults to `TRUE`.

- parser:

  Which parser to use: genquery1 or genquery2. Defaults to genquery1.

- sql_only:

  Whether to dry-run query and return SQL syntax query as return.
  Defaults to `FALSE`. Needs
  [Genquery2](https://github.com/irods/irods_api_plugin_genquery2/?#api-plugin).

- verbose:

  Whether information should be printed about the HTTP request and
  response.

## Value

A dataframe with one row per result and one column per requested
attribute, with "size" and "time" columns parsed to the right type.

Invisibly, the HTTP response.

## References

https://docs.irods.org/master/icommands/user/#iquest

Use SQL-like expressions to query data objects and collections based on
different properties.

## See also

[`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md)

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

# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# store
isaveRDS(foo, "foo.rds")

# add metadata
imeta(
  "foo.rds",
  operations =
    list(
      list(operation = "add", attribute = "bar", value = "baz")
  )
)

# search for objects by metadata
iquery("SELECT COLL_NAME, DATA_NAME WHERE META_DATA_ATTR_NAME LIKE 'bar%'")

# delete object
irm("foo.rds", force = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
