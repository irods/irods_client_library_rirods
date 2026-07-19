# Package index

## Connecting and authentication

Functions for saving server details and authentication

- [`create_irods()`](https://irods.github.io/irods_client_library_rirods/reference/create_irods.md)
  : Generate IRODS Configuration File
- [`iauth()`](https://irods.github.io/irods_client_library_rirods/reference/iauth.md)
  : Authentication Service for an iRODS Zone
- [`is_connected_irods()`](https://irods.github.io/irods_client_library_rirods/reference/is_connected_irods.md)
  : Predicate for iRODS Connectivity

## Navigating the iRODS Zone

Logical paths of iRODS and listing content of collections

- [`icd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
  [`ipwd()`](https://irods.github.io/irods_client_library_rirods/reference/icd.md)
  : Get or Set Current Working Directory in iRODS
- [`ils()`](https://irods.github.io/irods_client_library_rirods/reference/ils.md)
  : List iRODS Data Objects and Collections

## Managing collections

Creating and removing data objects and collections within iRODS

- [`irm()`](https://irods.github.io/irods_client_library_rirods/reference/irm.md)
  : Remove Data Objects or Collections in iRODS
- [`imkdir()`](https://irods.github.io/irods_client_library_rirods/reference/imkdir.md)
  : Create a New Collection in iRODS

## Moving objects

Functions to transfer and download R objects and files to and from iRODS

- [`iput()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
  [`isaveRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iput.md)
  : Save Files and Objects in iRODS
- [`iget()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
  [`ireadRDS()`](https://irods.github.io/irods_client_library_rirods/reference/iget.md)
  : Retrieve File or Object from iRODS

## Metadata

Functions to annotate collections and data objects as well as discovery
of objects and collections in iRODS

- [`imeta()`](https://irods.github.io/irods_client_library_rirods/reference/imeta.md)
  : Add or Remove Metadata
- [`iquery()`](https://irods.github.io/irods_client_library_rirods/reference/iquery.md)
  : Query Data Objects and Collections in iRODS

## Demonstrating iRODS

Functions to demonstrate iRODS capabilities in a Docker container

- [`use_irods_demo()`](https://irods.github.io/irods_client_library_rirods/reference/use_irods_demo.md)
  [`stop_irods_demo()`](https://irods.github.io/irods_client_library_rirods/reference/use_irods_demo.md)
  : Run Docker iRODS Demonstration Service
- [`is_irods_demo_running()`](https://irods.github.io/irods_client_library_rirods/reference/is_irods_demo_running.md)
  : Predicate for iRODS Demonstration Service State
- [`iadmin()`](https://irods.github.io/irods_client_library_rirods/reference/iadmin.md)
  : The Administration Interface to iRODS

## iRODS s3 class

Functions to coerce and print irods_df s3 class

- [`as.data.frame(`*`<irods_df>`*`)`](https://irods.github.io/irods_client_library_rirods/reference/as.data.frame.irods_df.md)
  : Coerce to a Data Frame
- [`print(`*`<irods_df>`*`)`](https://irods.github.io/irods_client_library_rirods/reference/print.irods_df.md)
  : Print Method for iRODS Data Frame Class.
