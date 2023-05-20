# chunk size can be calculated

    Code
      calc_chunk_size(11, 10L)
    Output
      $object
       [1] 0 0 0 0 0 1 1 1 1 1 1
      
      $offset
      [1] 0 5
      
      $count
      [1] 5 6
      

---

    Code
      calc_chunk_size(20, 10L)
    Output
      $object
       [1] 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1
      
      $offset
      [1]  0 10
      
      $count
      [1] 10 10
      

---

    Code
      calc_chunk_size(30, 10L)
    Output
      $object
       [1] 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2
      
      $offset
      [1]  0 10 20
      
      $count
      [1] 10 10 10
      

