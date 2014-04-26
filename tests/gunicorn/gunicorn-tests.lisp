
(in-package :nclack-tests)

;; Testing for the conversion between HTTP request to the Clack 'environ'
;; representation.
(defsuite (gunicorn-request-suite :in root-suite)
    (run-child-tests))
(in-suite gunicorn-request-suite)


(deftest test-001 ()
      (let ((created-request
             (with-open-file (input-stream #P"/home/puercopop/quicklisp/local-projects/nclack/tests/gunicorn/specs/requests/valid/001.http"
                              :direction :input)
                (nclack:make-request input-stream)))
            (pattern-request (list :request-method :PUT
      :request-uri "/stuff/here?foo=bar"
      :script-name "/stuff/here"
      :query-string "foo=bar"
      :server-name "127.0.0.1"
      :server-port 5984
      :http-host "127.0.0.1:5984"
      :url-scheme :http
      :server-protocol :HTTP/1.0
      :content-length 14
      :content-length "application/json"
      :raw-body (make-string-input-stream "{\"nom\": \"nom\"}"))
))

        (conforms-to pattern-request created-request)))
