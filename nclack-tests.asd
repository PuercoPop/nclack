(asdf:defsystem #:nclack-tests
  :depends-on (nclack fiveam)
  :pathname "tests/"
  :serial t
  :components ((:file "packages")
               (:file "request")))
