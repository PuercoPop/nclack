(in-package :cl-user)
(defpackage :nclack-test-system
  (:use :cl :asdf))
(in-package :nclack-test-system)

(defsystem nclack-tests
  :depends-on (:nclack
               :fiveam
               :flexi-streams
               :cl-fad
               :optima)
  :pathname "tests/"
  :serial t
  :components ((:file "packages")
               (:file "conf")
               (:file "utils")
               (:file "runner")
               (:file "parser")
               (:file "request")))

(defmethod perform ((op test-op) (system (eql (find-system :nclack))))
  (compile-file (asdf:system-relative-pathname :nclack-tests "tests/packages.lisp"))
  (funcall (find-symbol "test-runner" :nclack-tests))
  ;; (nclack-tests:test-runner)
  )
