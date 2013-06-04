(in-package :nclack-tests)

;; 1. Read 001.http file
;; 2. Compare the request to the form in 001.lisp

(defun first-test ()
  (let* ((http-stream (open "tests/requests/valid/001.http"))
         (expected-request (read (open "tests/requests/valid/001.lisp")))
         (created-request (nclack:make-request http-stream)))
    (close http-stream)
    (eq created-request expected-request)))
