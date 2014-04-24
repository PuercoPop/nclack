(in-package :nclack-tests)

(defsuite (http-parser-suite :in root-suite)
    (run-child-tests))
(in-suite http-parser-suite)

(deftest parse-first-line ()
  (let ((result
         (nclack/request::parse-first-line
          nil
          (make-string-input-stream (format nil
                                            "PUT /stuff/here?foo=bar HTTP/1.0~C~C"
                                            #\Return
                                            #\Linefeed)))))
    (is (eq (getf result :request-method) :PUT))
    (is (string= (getf result :request-uri) "/stuff/here?foo=bar"))
    (is (eq (getf result :server-protocol) :HTTP/1.0))))


(deftest parse-headers ()
    (let ((result
           (nclack/request::parse-headers
            nil
            (make-string-input-stream
             (format nil
                     "Server: http://127.0.0.1:5984~C~CContent-Type: application/json~C~CContent-Length: 14~C~C~C~C"
                     #\Return #\Linefeed
                     #\Return #\Linefeed
                     #\Return #\Linefeed
                     #\Return #\Linefeed)))))
      (is (string-equal (getf result :content-type) "Application/json"))))

(deftest parse-body ())


(deftest parse-chunked-body ()
  (let ((result (nclack/request::%parse-chunked-body
                 (make-string-input-stream
                  (format nil
                          "4~C~CWiki~C~C5~C~Cpedia~C~Ce~C~C in~C~C~C~Cchunks.~C~C0~C~C~C~C"
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed
                          #\Return #\Linefeed))))
        (expected (make-string-input-stream
                   (format nil
                           "Wikipedia in~C~C~C~Cchunks."
                           #\Return #\Linefeed #\Return #\Linefeed))))
    (is (string= result
                 (stream-to-string expected)))))
