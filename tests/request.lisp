(in-package :nclack-tests)

;; Testing for the conversion between HTTP request to the Clack 'environ'
;; representation.
(defsuite (request-suite :in root-suite)
    (run-child-tests))
(in-suite request-suite)


;; 1. Read 001.http file
;; 2. Compare the request to the form in 001.lisp

(deftest first-test ()
      (let ((created-request
             (with-open-file (input-stream
                              (merge-pathnames "requests/valid/001.http"
                                               *gunicorn-tests-dir*)
                              :direction :input)
                (nclack:make-request input-stream)))
            (pattern-request (list :request-method :PUT
                                    :request-uri "/stuff/here?foo=bar"
                                    :script-name "/stuff"
                                    :query-string "foo=bar"
                                    :server-name "127.0.0.1"
                                    :server-port 5984
                                    :http-host "127.0.0.1:5984"
                                    :url-scheme :http
                                    :server-protocol :HTTP/1.0
                                    :content-length 14
                                    :content-length "application/json"
                                    :raw-body (make-string-input-stream "{\"nom\": \"nom\"}"))))

        (conforms-to pattern-request created-request)))
