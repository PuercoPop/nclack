(in-package :nclack-tests)


(def-suite request-suite
    :description "Testing for the conversion between HTTP request to the Clack
'environ' representation.")
(in-suite request-suite)

;; 1. Read 001.http file
;; 2. Compare the request to the form in 001.lisp

(test first-test ()
  (let* ((http-stream (open "tests/requests/valid/001.http"))
         (expected-request (read (open "tests/requests/valid/001.lisp")))
         (created-request (nclack:make-request http-stream)))
    (close http-stream)
    (is (eq created-request expected-request))))

(defun test-runner ()
  (run! 'request-suite))
