
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rirods

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/irods/irods_client_library_rirods/branch/main/graph/badge.svg)](https://app.codecov.io/gh/irods/irods_client_library_rirods?branch=main)
[![R-CMD-check](https://github.com/irods/irods_client_library_rirods/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/irods/irods_client_library_rirods/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The rirods package is an R client for iRODS.

## Installation

You can install the development version of rirods like so:

``` r
install.packages("rirods")
```

Or, the development version from GitHub, like so:

``` r
# install.packages("devtools")
devtools::install_github("irods/irods_client_library_rirods")
```

## Prerequisites

This package connects to the iRODS C++ REST API -
https://github.com/irods/irods_client_rest_cpp.

Launch a local demonstration iRODS service (including the REST API):

``` r
# load
library(rirods)
# setup a mock iRODS server (https://github.com/irods/irods_demo)
use_irods_demo("alice", "passWORD")
```

This will result in the demonstration REST API running at
http://localhost/irods-rest/0.9.3 (or later version).

These Docker containers are designed to easily stand up a
**DEMONSTRATION** of the iRODS server. It is intended for education and
exploration.

**DO NOT USE IN PRODUCTION**

## Example Usage

To connect to the REST API endpoint of your choice, load `rirods`,
connect with `create_irods()`, and authenticate with your iRODS
credentials:

``` r
# connect
create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
```

### authentication

In this example Alice is a user of iRODS and she can authenticate
herself with `iauth()`. This prompts a dialog where you can enter your
username and password without hardcoding this information in your
scripts.

``` r
# login as alice with password "passWORD"
iauth() # or iauth("alice", "passWORD")
```

### save R objects

Suppose Alice would like to upload an R object from her current R
session to an iRODS collection. For this, use the `isaveRDS()` command:

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# check where we are in the iRODS namespace
ipwd()
#> [1] "/tempZone/home/alice"

# store data in iRODS
isaveRDS(foo, "foo.rds")
```

### metadata

To truly appreciate the strength of iRODS, we can add some metadata that
describes the data object “foo”:

``` r
# add some metadata
imeta(
  "foo.rds", 
  "data_object", 
  operations = 
    data.frame(operation = "add", attribute = "foo", value = "bar", units = "baz")
)

# check if file is stored with associated metadata
ils(metadata = TRUE)
#> 
#> ========
#> metadata
#> ========
#> /tempZone/home/alice/foo.rds :
#>  attribute value units
#>        foo   bar   baz
#> 
#> 
#> ==========
#> iRODS Zone
#> ==========
#>                  logical_path        type
#>  /tempZone/home/alice/foo.rds data_object
```

### read R objects

If Alice wanted to copy the foo R object from an iRODS collection to her
current R session, she would use `ireadRDS()`:

``` r
# retrieve in native R format
ireadRDS("foo.rds")
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z
```

### csv

Possibly Alice does not want a native R object to be stored on iRODS but
a file type that can be accessed by other programs. For this, use the
`iput()` command:

``` r
library(readr)

# creates a csv file of foo
write_csv(foo, "foo.csv")

# send file
iput("foo.csv", "foo.csv")

# check whether it is stored
ils()
#> 
#> ==========
#> iRODS Zone
#> ==========
#>                  logical_path        type
#>  /tempZone/home/alice/foo.csv data_object
#>  /tempZone/home/alice/foo.rds data_object
```

Later on somebody else might want to download this file again and store
it locally:

``` r
# retrieve it again later
iget("foo.csv", "foo.csv")
read_csv("foo.csv")
#> Rows: 3 Columns: 2
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): y
#> dbl (1): x
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 3 × 2
#>       x y    
#>   <dbl> <chr>
#> 1     1 x    
#> 2     8 y    
#> 3     9 z
```

### query

By adding metadata you and others can more easily discover data in
future projects. Objects can be searched with General Queries and
`iquery()`:

``` r
# look for objects in the home collection with a wildcard `%`
iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
#>      [,1]                   [,2]     
#> [1,] "/tempZone/home/alice" "foo.csv"
#> [2,] "/tempZone/home/alice" "foo.rds"
```

``` r
# or for data objects with a name that starts with "foo"
iquery("SELECT COLL_NAME, DATA_NAME WHERE DATA_NAME LIKE 'foo%'")
#>      [,1]                   [,2]     
#> [1,] "/tempZone/home/alice" "foo.csv"
#> [2,] "/tempZone/home/alice" "foo.rds"
```

### cleanup

Finally, we can clean up Alice’s home collection:

``` r
# delete object
irm("foo.rds", force = TRUE)
irm("foo.csv", force = TRUE)

# check if objects are removed
ils()
#> This collection does not contain any objects or collections.
```

``` r
# close the server
stop_irods_demo()
# optionally remove the Docker images
# irods:::remove_docker_images()
```
