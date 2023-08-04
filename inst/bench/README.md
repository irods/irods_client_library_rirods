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
   <td style="text-align:right;"> 213.63ms </td>
   <td style="text-align:right;"> 2.72MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 260.93ms </td>
   <td style="text-align:right;"> 324.98KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 455.36ms </td>
   <td style="text-align:right;"> 467.76KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 520.51ms </td>
   <td style="text-align:right;"> 494.37KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.38s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 6.43s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.1m </td>
   <td style="text-align:right;"> 67.09MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.27m </td>
   <td style="text-align:right;"> 67.17MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 12.74m </td>
   <td style="text-align:right;"> 784.51MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 15.39m </td>
   <td style="text-align:right;"> 785.78MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 220.31ms </td>
   <td style="text-align:right;"> 2.43MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 271.21ms </td>
   <td style="text-align:right;"> 375.49KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 444.52ms </td>
   <td style="text-align:right;"> 466.59KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 530.14ms </td>
   <td style="text-align:right;"> 491.86KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.46s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 6.33s </td>
   <td style="text-align:right;"> 5.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.1m </td>
   <td style="text-align:right;"> 67.09MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.3m </td>
   <td style="text-align:right;"> 67.17MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 13.05m </td>
   <td style="text-align:right;"> 784.51MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 15.25m </td>
   <td style="text-align:right;"> 785.78MB </td>
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
   <td style="text-align:right;"> 276ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 228ms </td>
   <td style="text-align:right;"> 85.8KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 269ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 224ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 271ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 224ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 269ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 227ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 270ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 234ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 296ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 220ms </td>
   <td style="text-align:right;"> 88.6KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 265ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 218ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 276ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 232ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 285ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 223ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 268ms </td>
   <td style="text-align:right;"> 84KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> a79c67049360868d3a63dae0ebddd0b534d00cb9 </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 229ms </td>
   <td style="text-align:right;"> 82.1KB </td>
  </tr>
</tbody>
</table>



<div class="figure">
<img src="man/figures/README-plot2-1.png" alt="&lt;i&gt;Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.&lt;/i&gt;" width="100%" />
<p class="caption"><i>Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.</i></p>
</div>
