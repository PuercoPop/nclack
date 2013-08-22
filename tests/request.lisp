(in-package :nclack-tests)

(def-suite request-suite
    :description "Testing for the conversion between HTTP request to the Clack
    'environ' representation.")
(in-suite request-suite)


;; 1. Read 001.http file
;; 2. Compare the request to the form in 001.lisp

(test first-test ()
      (let* ((http-stream (open (merge-pathnames "requests/valid/001.http"
                                                 *specs-dir*)))
             (expected-request (read (open
                                      (merge-pathnames "requests/valid/001.lisp"
                                                       *specs-dir*))))
             (request-tests (read (open
                                   (merge-pathnames "requests/valid/001.spec"
                                                    *specs-dir*))))
             (created-request (nclack:make-request http-stream)))
        (declare (special expected-request)
                 (special created-request))
        (close http-stream)
        (eval request-tests)))
