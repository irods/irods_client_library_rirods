---
output: 
  github_document:
     md_extensions: [ 
      "-autolink_bare_uris" 
    ]
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# rirods benchmarks

## Prerequisites

For the benchmarks one needs to connect to the iRODS C++ REST API - https://github.com/irods/irods_client_rest_cpp.

Launch a local demonstration iRODS service (including the REST API):


```bash
# clone the repository
git clone --recursive https://github.com/irods/irods_demo
# start the REST API
cd irods_demo
docker-compose up -d nginx-reverse-proxy
```

This will result in the demonstration REST API running at http://localhost/irods-rest/0.9.3 (or later version).

## Usage benchmarks

The benchmarks are based on the R package *bench*. The two parameters of interest are `median`, which is the sample median time and `mem_alloc`, which is the total amount of memory allocated by R while running the expression.

To perform a benchmark use GNU make:


```bash
make
```

## Results

The results are based on the HEAD of the main branch on the iRODS organization repository and the local package. The test case uses `iput()` and `iget()` with a `count` smaller than the file size.

## Performance iget and iput

<table>
<caption><i>Table 1: Comparing allocation of memory and runtime for `iget()` and `iput()` for different file sizes.</i></caption>
 <thead>
  <tr>
   <th style="text-align:right;"> src </th>
   <th style="text-align:right;"> ref </th>
   <th style="text-align:right;"> file size </th>
   <th style="text-align:right;"> expression </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> memory allocated </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 205.94ms </td>
   <td style="text-align:right;"> 1.44MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 269.91ms </td>
   <td style="text-align:right;"> 315.59KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 403.7ms </td>
   <td style="text-align:right;"> 438.13KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 482.71ms </td>
   <td style="text-align:right;"> 567.65KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.97s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.96s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.02m </td>
   <td style="text-align:right;"> 63.16MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.17m </td>
   <td style="text-align:right;"> 63.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 12.22m </td>
   <td style="text-align:right;"> 738.66MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 14.68m </td>
   <td style="text-align:right;"> 739.9MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 221.86ms </td>
   <td style="text-align:right;"> 1.44MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 258.7ms </td>
   <td style="text-align:right;"> 315.59KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 428.21ms </td>
   <td style="text-align:right;"> 437.51KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 511.99ms </td>
   <td style="text-align:right;"> 567.64KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.17s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.97s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.05m </td>
   <td style="text-align:right;"> 63.17MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.19m </td>
   <td style="text-align:right;"> 63.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 12.29m </td>
   <td style="text-align:right;"> 738.67MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 14.72m </td>
   <td style="text-align:right;"> 739.93MB </td>
  </tr>
</tbody>
</table>



<div class="figure">
<img src="man/figures/README-plot1-1.png" alt="&lt;i&gt;Fig 1: Comparing allocation of memory and runtime for `iget()` and `iput()` for different file sizes.&lt;/i&gt;" width="100%" />
<p class="caption"><i>Fig 1: Comparing allocation of memory and runtime for `iget()` and `iput()` for different file sizes.</i></p>
</div>


## Performance isaveRDS and ireadRDS

<table>
<caption><i>Table 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.</i></caption>
 <thead>
  <tr>
   <th style="text-align:right;"> src </th>
   <th style="text-align:right;"> ref </th>
   <th style="text-align:right;"> file size </th>
   <th style="text-align:right;"> expression </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> memory allocated </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 257ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 203ms </td>
   <td style="text-align:right;"> 70.7KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 262ms </td>
   <td style="text-align:right;"> 71KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 221ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 251ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 201ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 259ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 211ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 246ms </td>
   <td style="text-align:right;"> 71KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 217ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 293ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 216ms </td>
   <td style="text-align:right;"> 73.6KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 244ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 204ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 255ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 215ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 249ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 201ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 254ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 032008f3d62876de95c19bb6b251966e63db284b </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 212ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
</tbody>
</table>



<div class="figure">
<img src="man/figures/README-plot2-1.png" alt="&lt;i&gt;Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.&lt;/i&gt;" width="100%" />
<p class="caption"><i>Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.</i></p>
</div>
