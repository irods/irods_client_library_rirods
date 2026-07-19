# rirods vs iCommands

This article is meant for iRODS users familiar with iCommands, the
command-line interface to iRODS. While
[rirods](https://github.com/irods/irods_client_library_rirods) functions
are based on iCommands, not all iCommands are covered and some
functionality may differ. The article also compares the bash calls to
the R calls in case the reader is not so familiar with R syntax.

The table below lists the main functions available in
[rirods](https://github.com/irods/irods_client_library_rirods) and their
counterparts in iCommands.

| [rirods](https://github.com/irods/irods_client_library_rirods) | `iCommands` |
|----|----|
| [`icd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md) | `icd` |
| [`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md) | `ipwd` |
| [`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md) | `ils` |
| [`iget()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md), [`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md) | `iget` |
| [`iput()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md), [`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md) | `iput` |
| [`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md) | `imeta` |
| [`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md) | `iquest` |
| [`imkdir()`](https://irods.github.io/irods_client_library_rirods/reference/imkdir.md) | `imkdir` |
| [`irm()`](https://irods.github.io/irods_client_library_rirods/reference/irm.md) | `irm` |

A general note is that in iCommands the `-h` argument provides the
documentation for a certain command (e.g. `icd -h`), whereas in R this
is achieved by preceding the name of the function with `?`
(e.g. [`?icd`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)).
Moreover, the `verbose` boolean argument in most of
[rirods](https://github.com/irods/irods_client_library_rirods) commands
is used to print information about the HTTP request and response (and is
by default `FALSE`), which is not a behaviour relevant to iCommands.

## Working directory and collections

The iCommand `ipwd` and its
[rirods](https://github.com/irods/irods_client_library_rirods)
counterpart
[`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
work exactly the same, providing the path to the current working
directory. The case of
[`icd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
is different; unlike `icd`, which returns the “/zone/home” directory if
no argument is provided,
[`icd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
needs an argument with the path for a new working directory.
`icd("/tempZone/home")` will take us to `"/tempZone/home"` like `icd`
might, but
[`icd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
with no arguments will throw an error.

When it comes to listing the contents of a collection, both `ils` and
[`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
can be given a path, and if they are not, they list the contents of the
working directory. Permissions can be shown by `ils` with the `-A`
argument and by
[`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
by providing `permissions=TRUE`, although the latter does not return
information about inheritance[^1]. The time that the item was last
modified and the size of data objects is shown by `ils -l` and by
`ils(stats=TRUE)`.

``` r

ils() # ils
ils("some_collection") # ils some_collection
ils("some_collection", stat = TRUE) # ils -l some_collection
ils("some_collection", permissions = TRUE) # ils -A some_collection
ils(permissions=TRUE, stat = TRUE) # ils -Al
```

A crucial difference between `ils` and
[`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
is that `ils(metadata=TRUE)` is used to print the metadata information
of each element listed, whereas iCommands only provides metadata
information of one element at a time by calling `imeta ls` on it. At the
moment, [rirods](https://github.com/irods/irods_client_library_rirods)
does not offer any fast way of restricting the metadata to a specific
item, although the custom function `filter_ils()` shown below could be
used to achieve this result.

``` r

filter_ils <- function(pattern, ils_output = ils()) {
  stopifnot(inherits(ils_output, "irods_df"))
  ils_df <- as.data.frame(ils_output)
  if (length(pattern) == 1) {
    filtered <- ils_df[grepl(pattern, ils_df$logical_path), ]
  } else {
    filtered <- ils_df[basename(ils_df$logical_path) %in% pattern, ]
  }
  rirods:::new_irods_df(filtered)
}
```

``` r

my_files <- ils("some_collection", metadata = TRUE)
my_files
filter_ils("random", my_files) # imeta ls -d some_collection/random_numbers.rds
```

## Creating and deleting collections or data objects

With iCommands we can create new collections and data objects with
`imkdir` and `itouch` respectively. The former is matched in
[rirods](https://github.com/irods/irods_client_library_rirods) by
[`imkdir()`](https://irods.github.io/irods_client_library_rirods/reference/imkdir.md),
but the latter is not covered by the R package yet.

Both in iCommands and in
[rirods](https://github.com/irods/irods_client_library_rirods),
[`imkdir()`](https://irods.github.io/irods_client_library_rirods/reference/imkdir.md)
requires a path and has an argument to request creating the parent
collections:

``` r

imkdir("new_collection") # imkdir new_collection
ils()

# imkdir -p another_collection/subcollection
imkdir("another_collection/subcollection", create_parent_collections = TRUE)

ils()
ils("another_collection")
```

Removing data objects and collections can be achieved by `irm` in
iCommands and
[`irm()`](https://irods.github.io/irods_client_library_rirods/reference/irm.md)
in [rirods](https://github.com/irods/irods_client_library_rirods), and
both functions have a `force` and `recursive` arguments:

``` r

irm("200numbers.rds", force = FALSE) # irm 200numbers.rds
ils("/tempZone/trash/home/rods")

irm("another_collection", force = TRUE, recursive = TRUE) # irm -rf another_collection
iquery("SELECT COLL_NAME WHERE COLL_NAME LIKE '%_collection'")
```

## Getting and putting data

In order to transfer data between a local system and iRODS, the main
iCommands are `iput` and `iget`, which have
[`iput()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
and
[`iget()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
as [rirods](https://github.com/irods/irods_client_library_rirods)
counterparts. The
[rirods](https://github.com/irods/irods_client_library_rirods) functions
are much more restricted in that they don’t really offer the variety of
arguments that the iCommands do, but only options related to the HTTP
requests. Moreover, they require the user to provide both the local and
logical paths explicitly, whereas the iCommands reuse the source path by
default. In other words, while `iput myfile.txt` will take a local file
“myfile.txt” and store it in the iRODS working directory as
“myfile.txt”, `iput("myfile.txt")` will throw an error;
`iput("myfile.txt", "myfile.txt")` is the correct syntax to achieve the
desired effect:

| [rirods](https://github.com/irods/irods_client_library_rirods) | `iCommands` | Result |
|----|----|----|
| `iget("myfile.txt", "myfile.txt")` | `iget myfile.txt` | “myfile.txt” is copied from iRODS to local as “myfile.txt” |
| `iget("myfile.txt", "another_path/filename.txt")` | `iget myfile.txt another_path/filename.txt` | “myfile.txt” is copied from iRODS to local as “filename.txt” in “another_path” |
| `iput("data.csv", "data.csv")` | `iput data.csv` | “data.csv” is copied from local to iRODS as “data.csv” |
| `iput("data.csv", "data2.csv")` | `iput data.csv data2.csv` | “data.csv” is copied from local to iRODS as “data2.csv” |

Next to these functions,
[rirods](https://github.com/irods/irods_client_library_rirods) provides
two functions to store R objects directly into iRODS or read RDS files
directly from iRODS:
[`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
and
[`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md).
There is no counterpart in iCommands. To achieve the same effect as
[`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md),
a user would first have to save their object with
[`saveRDS()`](https://rdrr.io/r/base/readRDS.html), then send it to
iRODS with `iput` and finally remove it with `irm -f`; in the same vein,
the effect of
[`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
would be achieved by retrieving the file with `iget`, reading it with
[`readRDS()`](https://rdrr.io/r/base/readRDS.html) and then removing it
from the local space. Read more about this in
[`vignette("local-irods")`](https://irods.github.io/irods_client_library_rirods/articles/local-irods.md).

## Metadata and querying

The [rirods](https://github.com/irods/irods_client_library_rirods)
[`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md)
function covers two of the main functionalities of the `imeta` iCommand:
adding and removing metadata from a data object or collection. This
function has three main arguments: the logical path of the data object
or collection on which to add the metadata, the entity type
(e.g. “data_object”, the default, or “collection”) and a list of
operations, in which it is specified whether a certain AVU should be
added or removed.

``` r

icd("some_collection")
ils(metadata=TRUE)

# imeta add -C subcollection foo bar baz
imeta("subcollection",
      operations = list(
        list(operation="add", attribute="foo", value="bar", units="baz")
        )
      )

# imeta rm -d random_numbers.rds distribution normal
imeta("random_numbers.rds",
      operations = list(
        list(operation="remove", attribute="distribution", value="normal")
      ))

ils(metadata=TRUE)
```

In order to “modify” an AVU with
[rirods](https://github.com/irods/irods_client_library_rirods), we would
have to remove it and add its replacement. This also illustrates how we
can add/remove several AVUs in one
[`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md)
call, which would not be possible with `imeta`[^2].

``` r

# imeta mod -d random_numbers.rds length 100 items u:elements
imeta("random_numbers.rds",
      operations = list(
        list(operation="remove", attribute="length", value="100", units="items"),
        list(operation="add", attribute="length", value="100", units="elements")
      ))
ils(metadata=TRUE)
```

As mentioned before, whereas the iCommand `imeta ls` is used to list the
metadata of an item, `ils(metadata=TRUE)` is used in
[rirods](https://github.com/irods/irods_client_library_rirods) instead.

Finally, the
[rirods](https://github.com/irods/irods_client_library_rirods)
equivalent of iCommand `iquest` is
[`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md),
with the same GenQuery expression as main argument and a few compatible
arguments. Given a `query` variable such as “SELECT DATA_NAME,
DATA_CHECKSUM WHERE COLL_NAME LIKE ‘/tempZone/home/rods%’”:

| [rirods](https://github.com/irods/irods_client_library_rirods) | `iCommands` |
|----|----|
| `iquery(query)` | `iquest "$query"` |
| `iquery(query, case_sensitive = FALSE)` | `iquest uppercase "$query"` |
| `iquery(query, distinct = FALSE)` | `iquest no-distinct "$query"` |

To learn more about
[`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md)
and
[`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md),
see
[`vignette("metadata")`](https://irods.github.io/irods_client_library_rirods/articles/metadata.md).

[^1]: At the moment there is no functionality in
    [rirods](https://github.com/irods/irods_client_library_rirods) to
    set permissions.

[^2]: This is similar to the behavior of atomic operations in the Python
    client.
