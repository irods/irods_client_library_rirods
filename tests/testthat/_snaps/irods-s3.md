# coerce irods_df to data.frame

    Code
      irods_zone
    Output
                                logical_path      metadata        type
      1 /tempZone/home/rods/testthat/foo.rds foo, bar, baz data_object

---

    Code
      irods_zone[basename(irods_zone$logical_path) == "foo.rds", "metadata"]
    Output
      [[1]]
        attribute value units
      1       foo   bar   baz
      

