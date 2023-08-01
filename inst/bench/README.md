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
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 171.25ms </td>
   <td style="text-align:right;"> 1.53MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 208.95ms </td>
   <td style="text-align:right;"> 324.98KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 339.25ms </td>
   <td style="text-align:right;"> 467.76KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 458.89ms </td>
   <td style="text-align:right;"> 491.24KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.19s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.88s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 50.39s </td>
   <td style="text-align:right;"> 67.08MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 59.31s </td>
   <td style="text-align:right;"> 67.16MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 9.97m </td>
   <td style="text-align:right;"> 784.41MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 11.76m </td>
   <td style="text-align:right;"> 785.64MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 170.83ms </td>
   <td style="text-align:right;"> 1.23MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 209.19ms </td>
   <td style="text-align:right;"> 325.16KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 344.93ms </td>
   <td style="text-align:right;"> 466.21KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 403.4ms </td>
   <td style="text-align:right;"> 491.24KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.23s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.95s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 51.01s </td>
   <td style="text-align:right;"> 67.08MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 59.26s </td>
   <td style="text-align:right;"> 67.17MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 9.94m </td>
   <td style="text-align:right;"> 784.41MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 11.75m </td>
   <td style="text-align:right;"> 785.65MB </td>
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
   <td style="text-align:right;"> 212ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 586ms </td>
   <td style="text-align:right;"> 85.8KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 209ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 172ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 209ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 172ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 210ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 172ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 207ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 171ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 205ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 183ms </td>
   <td style="text-align:right;"> 88.6KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 205ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 168ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 210ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 168ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 207ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 169ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 207ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> ec8381c3356e47d9c90619a745c570c125173202 </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 177ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
</tbody>
</table>



<div class="figure">
<img src="man/figures/README-plot2-1.png" alt="&lt;i&gt;Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.&lt;/i&gt;" width="100%" />
<p class="caption"><i>Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.</i></p>
</div>
