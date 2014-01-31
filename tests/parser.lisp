(in-package :nclack-tests)

(def-suite http-parser-suite
    :description "Http Parser to plist.")
(in-suite http-parser-suite)

(test parse-first-line
  (let ((result (with-input-from-string
                    (in-stream (format nil
                                       "PUT /stuff/here?foo=bar HTTP/1.0~C~C"
                                       #\Return
                                       #\Linefeed))
                  (nclack::parse-first-line (list) in-stream))))
    (is (match result ((property :request-method x) (eq x :PUT))))
    (is (match result ((property :request-uri x) (eq x "/stuff/here?foo=bar"))))
    (is (match result ((property :server-protocol x) (eq x :HTTP/1.0))))))


(test parse-headers
  (let ((result
         (with-input-from-string (in-stream
                                  (format nil
                                          "Server: http://127.0.0.1:5984~C~CContent-Type: application/json~C~CContent-Length: 14~C~C~C~C" #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed))
           (nclack::parse-headers (list) in-stream))))
    (is (match result ((property :content-type x) (string= x "Application/json"))))
    ))

(test parse-body ())