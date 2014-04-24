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
  (when (getf pattern-request :request-method)
    (is (eq (getf request-to-test :request-method)
             (getf request-to-test :request-method))))
  (when (getf pattern-request :script-name)
    (is (string= (getf request-to-test :script-name)
                  (getf request-to-test :script-name))))
  (when (getf pattern-request :path-info)
    (is (string= (getf request-to-test :path-info)
                  (getf request-to-test :path-info))))
  (when (getf pattern-request :query-string)
    (is (string= (getf request-to-test :query-string)
                  (getf request-to-test :query-string))))
  (when (getf pattern-request :server-name)
    (is (string= (getf request-to-test :server-name)
                  (getf request-to-test :server-name))))
  (when (getf pattern-request :server-port)
    (is (eql (getf request-to-test :server-port)
              (getf request-to-test :server-port))))
  (when (getf pattern-request :server-protocol)
    (is (eq (getf request-to-test :server-protocol)
             (getf request-to-test :server-protocol))))
  (when (getf pattern-request :request-uri)
    (is (string= (getf request-to-test :request-uri)
                  (getf request-to-test :request-uri))))
  (when (getf pattern-request :raw-body)
    (is (string= (stream-to-string (getf request-to-test :raw-body))
                  (stream-to-string (getf request-to-test :raw-body))))))
