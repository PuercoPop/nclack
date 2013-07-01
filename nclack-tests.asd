(asdf:defsystem #:nclack-tests
  :depends-on (nclack fiveam flexi-streams)
  :pathname "tests/"
  :serial t
  :components ((:file "packages")
               (:file "conf")
               (:file "utils")
               (:file "runner")
               (:file "request")))
