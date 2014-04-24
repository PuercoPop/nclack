(in-package :nclack-tests)

(defun test-runner ()
  (funcall-test-with-feedback-message #'http-parser-suite t)
  (funcall-test-with-feedback-message #'request-suite t))
