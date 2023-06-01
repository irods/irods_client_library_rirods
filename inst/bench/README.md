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
   <td style="text-align:right;"> 177.1ms </td>
   <td style="text-align:right;"> 1.44MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 252.66ms </td>
   <td style="text-align:right;"> 315.59KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 368.62ms </td>
   <td style="text-align:right;"> 437.51KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 421.44ms </td>
   <td style="text-align:right;"> 567.64KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.47s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.2s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 52.8s </td>
   <td style="text-align:right;"> 63.16MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.03m </td>
   <td style="text-align:right;"> 63.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 10.34m </td>
   <td style="text-align:right;"> 738.58MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 12.08m </td>
   <td style="text-align:right;"> 739.84MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 179.12ms </td>
   <td style="text-align:right;"> 1.44MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 261.75ms </td>
   <td style="text-align:right;"> 318.42KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 356.22ms </td>
   <td style="text-align:right;"> 437.51KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 447.14ms </td>
   <td style="text-align:right;"> 567.64KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 4.4s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 48914 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 5.12s </td>
   <td style="text-align:right;"> 5.25MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 53.3s </td>
   <td style="text-align:right;"> 63.16MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 588915 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 1.03m </td>
   <td style="text-align:right;"> 63.24MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iget(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 10.37m </td>
   <td style="text-align:right;"> 738.59MB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 6888916 </td>
   <td style="text-align:right;"> iput(file_name, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 12.11m </td>
   <td style="text-align:right;"> 739.83MB </td>
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
   <td style="text-align:right;"> 220ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 175ms </td>
   <td style="text-align:right;"> 70.7KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 216ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 174ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 219ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 174ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 218ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 175ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 214ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> irods/irods_client_library_rirods </td>
   <td style="text-align:right;"> HEAD </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 185ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 223ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 1152 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 184ms </td>
   <td style="text-align:right;"> 73.6KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 222ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 4752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 186ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 216ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 40752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 177ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 216ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 400752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 179ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> isaveRDS(object, &quot;&quot;object.rds&quot;&quot;, overwrite = TRUE, count = 1000) </td>
   <td style="text-align:right;"> 217ms </td>
   <td style="text-align:right;"> 70.4KB </td>
  </tr>
  <tr>
   <td style="text-align:right;"> /local/path </td>
   <td style="text-align:right;"> 8d7093ace7591a2f29558ec140e87b14a06a4e9c </td>
   <td style="text-align:right;"> 4000752 </td>
   <td style="text-align:right;"> ireadRDS(&quot;&quot;object.rds&quot;&quot;, count = 1000) </td>
   <td style="text-align:right;"> 177ms </td>
   <td style="text-align:right;"> 67KB </td>
  </tr>
</tbody>
</table>



<div class="figure">
<img src="man/figures/README-plot2-1.png" alt="&lt;i&gt;Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.&lt;/i&gt;" width="100%" />
<p class="caption"><i>Fig 2: Comparing allocation of memory and runtime for `isaveRDS()` and `ireadRDS()` for different object sizes.</i></p>
</div>
