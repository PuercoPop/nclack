(in-package :nclack-tests)

(defun test-runner ()
  (http-parser-suite t)
  (gunicorn-request-suite t))
