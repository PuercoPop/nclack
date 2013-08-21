(in-package :nclack-tests)

(def-suite request-suite
    :description "Testing for the conversion between HTTP request to the Clack
    'environ' representation.")
(in-suite request-suite)

(test parse-first-line ()
      (let ((result (with-input-from-string
                        (in-stream "PUT /stuff/here?foo=bar HTTP/1.0")
                      (parse-first-line (list) in-stream))))
        (:request-method result is :PUT)
        (:request-uri result "/stuff/here?foo=bar")
        (:server-protocol :HTTP/1.0)))

;; Parse line
(let ((result (with-input-from-string
                  (in-stream (format nil
                                     "PUT /stuff/here?foo=bar HTTP/1.0~C~C"
                                     #\Return
                                     #\Linefeed))
                (parse-first-line (list) in-stream)))))

;; Parse headers
(with-input-from-string (in-stream
                         (format nil
                                 "Server: http://127.0.0.1:5984~C~CContent-Type: application/json~C~CContent-Length: 14~C~C~C~C" #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed))
  (parse-headers (list) in-stream))

(with-input-from-string (in-stream (format nil "A~C~CB~C~C"
                                           #\Return #\Linefeed
                                           #\Return #\Linefeed))
  (is "A" (read-http-line in-stream))
  (is "B" (read-http-line in-stream)))


(test parse-headers ())
(test parse-body ())


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
