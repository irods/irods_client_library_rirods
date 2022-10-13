# navigation works

    Code
      icd(".")

---

    Code
      ipwd()
    Output
      [1] "/"

---

    Code
      icd("/tempZone/home")

---

    Code
      ipwd()
    Output
      [1] "/tempZone/home"

---

    Code
      icd("..")

---

    Code
      ipwd()
    Output
      [1] "/tempZone"

---

    Code
      icd("../home/public")

---

    Code
      ipwd()
    Output
      [1] "/tempZone/home/public"

