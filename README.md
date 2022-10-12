
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
iRODS server. For more information check
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

To connect with the iRODS server on can do the following:

``` r
library(rirods2)
#> Start iRODS session.

# authenticate
auth()

# add user bobby
iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
#> <httr2_response>
#> POST
#> http://localhost/irods-rest/0.9.2/admin?action=add&target=user&arg2=bobby&arg3=rodsuser&arg4=&arg5=&arg6=&arg7=
#> Status: 200 OK
#> Body: In memory (33 bytes)

# modify pass word bobby
iadmin(action = "modify", target = "user", arg2 = "bobby", arg3 = "password", arg4  = "passWORD")
#> <httr2_response>
#> POST
#> http://localhost/irods-rest/0.9.2/admin?action=modify&target=user&arg2=bobby&arg3=password&arg4=passWORD&arg5=&arg6=&arg7=
#> Status: 200 OK
#> Body: In memory (33 bytes)

# check if bobby is added
ils()
#>   logical_path       type
#> 1    /tempZone collection
```

``` r
# remove user bobby
iadmin(action = "remove", target = "user", arg2 = "bobby")
#> <httr2_response>
#> POST
#> http://localhost/irods-rest/0.9.2/admin?action=remove&target=user&arg2=bobby&arg3=&arg4=&arg5=&arg6=&arg7=
#> Status: 200 OK
#> Body: In memory (33 bytes)

# check if bobby is removed
ils()
#>   logical_path       type
#> 1    /tempZone collection
```

## Navigate

## File management

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# set working directory to rods
icd("/tempZone/home/rods")

# store
iput(data = foo)
#> -> PUT /irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0 HTTP/1.1
#> -> Host: localhost
#> -> User-Agent: httr2/0.2.2 r-curl/4.3.3 libcurl/7.68.0
#> -> Accept: */*
#> -> Accept-Encoding: deflate, gzip, br
#> -> Authorization: <REDACTED>
#> -> Content-Length: 237
#> -> 
#> <- HTTP/1.1 200 OK
#> <- Server: nginx/1.23.1
#> <- Date: Wed, 12 Oct 2022 15:11:26 GMT
#> <- Content-Length: 33
#> <- Connection: keep-alive
#> <- Access-Control-Allow-Origin: *
#> <- Access-Control-Allow-Headers: *
#> <- Access-Control-Allow-Methods: AUTHORIZATION,ACCEPT,GET,POST,OPTIONS,PUT,DELETE
#> <-
#> <httr2_response>
#> PUT
#> http://localhost/irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0
#> Status: 200 OK
#> Body: In memory (33 bytes)

# check if file is stored
ils()
#>              logical_path        type
#> 1 /tempZone/home/rods/foo data_object
```

``` r
# retrieve in native R format
iget(data = "foo")
#> -> GET /irods-rest/0.9.2/stream?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&offset=0&count=1000 HTTP/1.1
#> -> Host: localhost
#> -> User-Agent: httr2/0.2.2 r-curl/4.3.3 libcurl/7.68.0
#> -> Accept: */*
#> -> Accept-Encoding: deflate, gzip, br
#> -> Authorization: <REDACTED>
#> -> 
#> <- HTTP/1.1 200 OK
#> <- Server: nginx/1.23.1
#> <- Date: Wed, 12 Oct 2022 15:11:26 GMT
#> <- Content-Length: 237
#> <- Connection: keep-alive
#> <- Access-Control-Allow-Origin: *
#> <- Access-Control-Allow-Headers: *
#> <- Access-Control-Allow-Methods: AUTHORIZATION,ACCEPT,GET,POST,OPTIONS,PUT,DELETE
#> <-
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z

# delete object
irm(data = "foo", trash = FALSE)
#> <httr2_response>
#> DELETE
#> http://localhost/irods-rest/0.9.2/logicalpath?logical-path=%2FtempZone%2Fhome%2Frods%2Ffoo&no-trash=0&recursive=0
#> Status: 200 OK
#> Body: Empty

# check if file is delete
ils()
#> data frame with 0 columns and 0 rows
```

## Stop your local iRODS server

``` bash
docker-compose down
```
