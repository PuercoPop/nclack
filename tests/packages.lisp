(eval-when (:compile-toplevel :load-toplevel)
  (defpackage :nclack-tests
    (:use :cl :fiveam :nclack :flexi-streams)
    (:import-from :asdf :system-relative-pathname)
    (:import-from :optima :match
                  :property)
    (:export :test-runner)))
