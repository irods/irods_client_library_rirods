# output is printed 2

    Code
      print(ils())
    Output
      
      ==========
      iRODS Zone
      ==========
                                logical_path        type
       /tempZone/home/rods/testthat/fred.rds data_object
        /tempZone/home/rods/testthat/qux.rds data_object

---

    Code
      print(ils(metadata = TRUE))
    Output
      
      ========
      metadata
      ========
      /tempZone/home/rods/testthat/fred.rds :
       attribute value units
             foo   bar   baz
      
      /tempZone/home/rods/testthat/qux.rds :
      data frame with 0 columns and 0 rows
      
      
      ==========
      iRODS Zone
      ==========
                                logical_path        type
       /tempZone/home/rods/testthat/fred.rds data_object
        /tempZone/home/rods/testthat/qux.rds data_object

# output is printed 3

    Code
      print(ils(metadata = TRUE))
    Output
      
      ========
      metadata
      ========
      /tempZone/home/rods/testthat/fred.rds :
       attribute value units
             foo   bar   baz
            foo1  bar1  baz1
      
      /tempZone/home/rods/testthat/qux.rds :
      data frame with 0 columns and 0 rows
      
      
      ==========
      iRODS Zone
      ==========
                                logical_path        type
       /tempZone/home/rods/testthat/fred.rds data_object
        /tempZone/home/rods/testthat/qux.rds data_object

# output is printed 4

    Code
      print(ils(metadata = TRUE))
    Output
      
      ========
      metadata
      ========
      /tempZone/home/rods/testthat/fred.rds :
       attribute value units
             foo   bar   baz
            foo1  bar1  baz1
      
      /tempZone/home/rods/testthat/qux.rds :
       attribute value units
             foo   bar      
      
      
      ==========
      iRODS Zone
      ==========
                                logical_path        type
       /tempZone/home/rods/testthat/fred.rds data_object
        /tempZone/home/rods/testthat/qux.rds data_object

---

    Code
      print(ils(metadata = TRUE, permissions = TRUE))
    Output
      
      ========
      metadata
      ========
      /tempZone/home/rods/testthat/fred.rds :
       attribute value units
             foo   bar   baz
            foo1  bar1  baz1
      
      /tempZone/home/rods/testthat/qux.rds :
       attribute value units
             foo   bar      
      
      
      ==========
      iRODS Zone
      ==========
                                logical_path        type rods
       /tempZone/home/rods/testthat/fred.rds data_object  own
        /tempZone/home/rods/testthat/qux.rds data_object  own

