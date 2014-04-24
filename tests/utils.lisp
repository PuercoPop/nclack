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
  (is (awhen (getf pattern-request :request-method)
         (eq it
             (getf request-to-test :request-method))))
  (is (awhen (getf pattern-request :script-name)
         (string= it
                  (getf request-to-test :script-name))))
  (is (awhen (getf pattern-request :path-info)
         (string= it
                  (getf request-to-test :path-info))))
  (is (awhen (getf pattern-request :query-string)
         (string= it
                  (getf request-to-test :query-string))))
  (is (awhen (getf pattern-request :server-name)
         (string= it
                  (getf request-to-test :server-name))))
  (is (awhen (getf pattern-request :server-port)
         (eql it
              (getf request-to-test :server-port))))
  (is (awhen (getf pattern-request :server-protocol)
         (eq it
             (getf request-to-test :server-protocol))))
  (is (awhen (getf pattern-request :request-uri)
         (string= it
                  (getf request-to-test :request-uri))))
  (is (awhen (getf pattern-request :raw-body)
         (string= (stream-to-string it)
                  (stream-to-string  (getf request-to-test :raw-body))))))
