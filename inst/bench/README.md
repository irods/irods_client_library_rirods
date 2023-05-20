
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rirods benchmarks

## Prerequisites

For the benchmarks on needs to connect to the iRODS C++ REST API -
https://github.com/irods/irods_client_rest_cpp.

Launch a local demonstration iRODS service (including the REST API):

``` bash
# clone the repository
git clone --recursive https://github.com/irods/irods_demo
# start the REST API
cd irods_demo
docker-compose up -d nginx-reverse-proxy
```

This will result in the demonstration REST API running at
http://localhost/irods-rest/0.9.3 (or later version).

## Usage benchmarks

The benchmarks are based on the R package *bench*. The two parameters of
interest are `median`, which is the sample median time and `mem_alloc`,
which is the total amount of memory allocated by R while running the
expression.

To perform a benchmark use GNU make:

``` bash
make
```

## Results

The results are based on the HEAD of the main branch on the iRODS
organization repository and the local package. The test case uses
`iput()` and `iget()` with a `count` smaller than the file size.

## Performance iget and iput

<table>
<caption>
<i>Table 1: Comparing allocation of memory and runtime for `iget()` and
`iput()` for different file sizes.</i>
</caption>
<thead>
<tr>
<th style="text-align:right;">
src
</th>
<th style="text-align:right;">
ref
</th>
<th style="text-align:right;">
file size
</th>
<th style="text-align:right;">
expression
</th>
<th style="text-align:right;">
median
</th>
<th style="text-align:right;">
memory allocated
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
164.61ms
</td>
<td style="text-align:right;">
1.42MB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
100.74ms
</td>
<td style="text-align:right;">
326.8KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
3913
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
326.49ms
</td>
<td style="text-align:right;">
449.64KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
3913
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
389.02ms
</td>
<td style="text-align:right;">
954.76KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
48914
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
4.02s
</td>
<td style="text-align:right;">
6.4MB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
48914
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
4.66s
</td>
<td style="text-align:right;">
9.55MB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
588915
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
48.98s
</td>
<td style="text-align:right;">
228.64MB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
588915
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
57.19s
</td>
<td style="text-align:right;">
114.82MB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
6888916
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
10.71m
</td>
<td style="text-align:right;">
22.82GB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
6888916
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
11.73m
</td>
<td style="text-align:right;">
1.31GB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
161.06ms
</td>
<td style="text-align:right;">
1.43MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
197.02ms
</td>
<td style="text-align:right;">
318.41KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
3913
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
342.55ms
</td>
<td style="text-align:right;">
437.51KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
3913
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
388.29ms
</td>
<td style="text-align:right;">
568.27KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
48914
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
4.03s
</td>
<td style="text-align:right;">
5.25MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
48914
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
4.63s
</td>
<td style="text-align:right;">
5.25MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
588915
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
48.61s
</td>
<td style="text-align:right;">
63.16MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
588915
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
56.45s
</td>
<td style="text-align:right;">
63.24MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
6888916
</td>
<td style="text-align:right;">
iget(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
9.48m
</td>
<td style="text-align:right;">
738.55MB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
6888916
</td>
<td style="text-align:right;">
iput(file_name, overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
11.02m
</td>
<td style="text-align:right;">
739.79MB
</td>
</tr>
</tbody>
</table>

<div class="figure">

<img src="man/figures/README-plot1-1.png" alt="&lt;i&gt;Fig 1: Comparing allocation of memory and runtime for `iget()` and `iput()` for different file sizes.&lt;/i&gt;" width="100%" />
<p class="caption">
<i>Fig 1: Comparing allocation of memory and runtime for `iget()` and
`iput()` for different file sizes.</i>
</p>

</div>

## Performance isaveRDS and ireadRDS

<table>
<caption>
<i>Table 2: Comparing allocation of memory and runtime for `isaveRDS()`
and `ireadRDS()` for different object sizes.</i>
</caption>
<thead>
<tr>
<th style="text-align:right;">
src
</th>
<th style="text-align:right;">
ref
</th>
<th style="text-align:right;">
file size
</th>
<th style="text-align:right;">
expression
</th>
<th style="text-align:right;">
median
</th>
<th style="text-align:right;">
memory allocated
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
1152
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
104ms
</td>
<td style="text-align:right;">
103.9KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
1152
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
177ms
</td>
<td style="text-align:right;">
70.5KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
4752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
105ms
</td>
<td style="text-align:right;">
103.9KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
4752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
182ms
</td>
<td style="text-align:right;">
66.8KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
40752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
102ms
</td>
<td style="text-align:right;">
103.9KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
40752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
171ms
</td>
<td style="text-align:right;">
66.8KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
400752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
104ms
</td>
<td style="text-align:right;">
103.9KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
400752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
171ms
</td>
<td style="text-align:right;">
66.2KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
4000752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
104ms
</td>
<td style="text-align:right;">
103.9KB
</td>
</tr>
<tr>
<td style="text-align:right;">
irods/irods_client_library_rirods
</td>
<td style="text-align:right;">
HEAD
</td>
<td style="text-align:right;">
4000752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
175ms
</td>
<td style="text-align:right;">
66.8KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
1152
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
204ms
</td>
<td style="text-align:right;">
70.4KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
1152
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
163ms
</td>
<td style="text-align:right;">
73.6KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
4752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
210ms
</td>
<td style="text-align:right;">
70.4KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
4752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
163ms
</td>
<td style="text-align:right;">
67KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
40752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
205ms
</td>
<td style="text-align:right;">
70.4KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
40752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
167ms
</td>
<td style="text-align:right;">
67KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
400752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
202ms
</td>
<td style="text-align:right;">
70.4KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
400752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
166ms
</td>
<td style="text-align:right;">
67KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
4000752
</td>
<td style="text-align:right;">
isaveRDS(object, ""object.rds"", overwrite = TRUE, count = 1000)
</td>
<td style="text-align:right;">
195ms
</td>
<td style="text-align:right;">
70.4KB
</td>
</tr>
<tr>
<td style="text-align:right;">
/local/path
</td>
<td style="text-align:right;">
fcdb4aa76b9cfbf04d74dc16568c9b3a31792372
</td>
<td style="text-align:right;">
4000752
</td>
<td style="text-align:right;">
ireadRDS(""object.rds"", count = 1000)
</td>
<td style="text-align:right;">
167ms
</td>
<td style="text-align:right;">
67KB
</td>
</tr>
</tbody>
</table>

<div class="figure">

<img src="man/figures/README-plot2-1.png" alt="&lt;i&gt;Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.&lt;/i&gt;" width="100%" />
<p class="caption">
<i>Fig 2: Comparing allocation of memory and runtime for `isaveRDS()`
and `ireadRDS()` for different object sizes.</i>
</p>

</div>
