(in-package :nclack-tests)

(defun stream-to-string (stream)
  (concatenate 'string
               (loop
                  :for char = (read-char stream nil 'eof)
                  :until (eq char 'eof)
                  :collect char)))


(defun conforms-to (pattern-request request-to-test)
  "Go one by one, inspecting the pattern-request for keys that should be
present in a clack request and, if presemt in the pattern-request, compare the
two values with the appropiate form. EQ for keywords, EQL for numbers, STRING=
for strings and STRING= on the STREAM-TO-STRING for streams."
  (awhen (getf pattern-request :request-method)
    (is (eq it
             (getf request-to-test :request-method))))
  (awhen (getf pattern-request :script-name)
    (is (string= it
                  (getf request-to-test :script-name))))
  (awhen (getf pattern-request :path-info)
    (is (string= it
                  (getf request-to-test :path-info))))
  (awhen (getf pattern-request :query-string)
    (is (string= it
                  (getf request-to-test :query-string))))
  (awhen (getf pattern-request :server-name)
    (is (string= it
                  (getf request-to-test :server-name))))
  (awhen (getf pattern-request :server-port)
    (is (eql it
              (getf request-to-test :server-port))))
  (awhen (getf pattern-request :server-protocol)
    (is (eq it
             (getf request-to-test :server-protocol))))
  (awhen (getf pattern-request :request-uri)
    (is (string= it
                  (getf request-to-test :request-uri))))
  (awhen (getf pattern-request :raw-body)
    (is (string= (stream-to-string it)
                  (stream-to-string (getf request-to-test :raw-body))))))
