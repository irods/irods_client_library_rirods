## Resubmission
This is a resubmission. In this version I have:

* I used quotes for names in the DESCRIPTION title.

* Care is taken that functions in examples/vignettes/tests do not write to the 
user's home filespace. 

* I corrected the function `create_irods()` that initially wrote iRODS server 
information as a text file to the user's working directory. I now save the file, 
that needs to persist beyond the R session, in the user-specific configuration 
directory. For this I used `rappdirs::user_config_dir()` which identifies either 
the directory set by the environmental variable R_USER_CONFIG_DIR or the 
os-specific default location in a next step.

* Along similar lines, The function `iget()` which downloads files from the 
iRODS server has no longer a default path to a location on the local device. 
To write to the user's home filespace the user has to explicitly supply an 
argument.

* Considering the above amendments I increased the patch version number from
0.1.0 to 0.1.1
  
## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
