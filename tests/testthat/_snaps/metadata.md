# metadata works 1

    Code
      ils(metadata = TRUE)
    Output
                 logical_path      metadata       type
      1  /tempZone/home/bobby          NULL collection
      2 /tempZone/home/public          NULL collection
      3   /tempZone/home/rods foo, baz, bar collection

# metadata works 2

    Code
      ils(metadata = TRUE)
    Output
                 logical_path                        metadata       type
      1  /tempZone/home/bobby                            NULL collection
      2 /tempZone/home/public                            NULL collection
      3   /tempZone/home/rods foo, foo2, baz, baz2, bar, bar2 collection

# metadata query works

    Code
      iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
    Output
                  collection data_object
      1 /tempZone/home/bobby        test

# metadata removing works

    Code
      ils(metadata = TRUE)
    Output
                 logical_path metadata       type
      1  /tempZone/home/bobby     NULL collection
      2 /tempZone/home/public     NULL collection
      3   /tempZone/home/rods     NULL collection

