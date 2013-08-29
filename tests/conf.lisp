(in-package :nclack-tests)

;; (defparameter  *debug-on-failure* t)
(defparameter *specs-dir* (system-relative-pathname :nclack-tests
                                                    "specs/"))

(defparameter *gunicorn-tests-dir*
  (system-relative-pathname :nclack-tests
                            "tests/request/gunicorn/"))
