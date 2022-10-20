
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rirods2

<!-- badges: start -->
<!-- badges: end -->

The goal of rirods2 is a pure R client for iRODS

## Installation

You can install the development version of rirods2 like so:

``` r
# install.packages("devtools")
devtools::install_github("MartinSchobben/rirods2")
```

## Example

This is a basic example which shows you how to quickly launch a local
iRODS server, connect with R, and perform some actions. For more
information on the iRODS demo server check
<https://github.com/irods/irods_demo>.

``` bash
# clone the repo
# git clone https://github.com/irods/irods_demo
# initiate git submodules
# git submodule update --init
# to start
cd ../irods_demo
docker-compose up
```

Then to connect a project from R with the iRODS server you have to
provide the host name of the server, like so:

``` r
library(rirods2)

# connect project to server
create_irods("http://localhost/irods-rest/0.9.2")
```

In this example Bobby is a user of iRODS and he can authenticate
himself, like so:

``` r
# login as bobby
iauth("bobby", "passWORD")
```

Suppose Bobby would like to upload an R object from his current R
session to an iRODS collection. For this, use the iput command:

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# check where we are
ipwd()
#> [1] "/tempZone/home/bobby"

# store
iput(foo)

# add some metadata
imeta(
  "foo", 
  "data_object", 
  operations = 
    list(operation = "add", attribute = "foo", value = "bar", units = "baz")
)

# check if file is stored with associated metadata
ils(metadata = TRUE)
#>               logical_path      metadata        type
#> 1 /tempZone/home/bobby/foo foo, bar, baz data_object
```

If Bobby wanted to copy the foo R object from an iRODS collection to his
local directory, he would use iget:

``` r
# retrieve in native R format
iget("foo")
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z
```

Possibly Bobby does not want a native R object to be stored on iRODS but
a file type that can be accessed by other programs.

``` r
library(readr)

# creates a csv file of foo
write_csv(foo, "foo.csv")

# send file
iput("foo.csv")

# check whether it is stored
ils()
#>                   logical_path        type
#> 1     /tempZone/home/bobby/foo data_object
#> 2 /tempZone/home/bobby/foo.csv data_object
```

Later on somebody else might want to download this file again and store
it locally.

``` r
# retrieve it again later
iget("foo.csv")
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

Objects can also be discovered by using General Queries and `iquery()`:

``` r
# look for objects in the home directory with a wildcard `%`
iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
#>             collection data_object
#> 1 /tempZone/home/bobby         foo
#> 2 /tempZone/home/bobby     foo.csv
```

``` r
# or where data objects named "foo" can be found
iquery("SELECT COLL_NAME, DATA_NAME WHERE DATA_NAME LIKE 'foo%'")
#>                    collection        data_object
#> 1        /tempZone/home/bobby                foo
#> 2        /tempZone/home/bobby            foo.csv
#> 3  /tempZone/trash/home/bobby                foo
#> 4  /tempZone/trash/home/bobby     foo.1243538807
#> 5  /tempZone/trash/home/bobby     foo.1397457722
#> 6  /tempZone/trash/home/bobby     foo.1897832140
#> 7  /tempZone/trash/home/bobby     foo.2139999920
#> 8  /tempZone/trash/home/bobby     foo.3407179898
#> 9  /tempZone/trash/home/bobby     foo.3674208461
#> 10 /tempZone/trash/home/bobby     foo.3875447246
#> 11 /tempZone/trash/home/bobby      foo.432847936
#> 12 /tempZone/trash/home/bobby      foo.799865305
#> 13 /tempZone/trash/home/bobby            foo.csv
#> 14 /tempZone/trash/home/bobby foo.csv.1034183041
#> 15 /tempZone/trash/home/bobby foo.csv.1638565932
#> 16 /tempZone/trash/home/bobby foo.csv.1846147999
#> 17 /tempZone/trash/home/bobby foo.csv.2183868033
#> 18 /tempZone/trash/home/bobby foo.csv.2279356880
#> 19 /tempZone/trash/home/bobby foo.csv.3275042440
#> 20 /tempZone/trash/home/bobby  foo.csv.342948025
#> 21 /tempZone/trash/home/bobby foo.csv.3503481366
#> 22 /tempZone/trash/home/bobby  foo.csv.809666106
```

Finally, we can clean up Bobby’s home directory:

``` r
# delete object
irm("foo", trash = FALSE)
irm("foo.csv", trash = FALSE)

# check if object is removed
ils()
#> This collection does not contain any objects or collections.
```

<!-- The user Bobby can also be removed again. -->

## Stop your local iRODS server

``` bash
docker-compose down
```
