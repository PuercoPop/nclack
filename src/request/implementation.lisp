(in-package :nclack.request)

(defun make-request (in-stream)
  (process-first-line (read-line in-stream)))

(defun process-first-line (first-line)
  "Request-Line   = Method SP Request-URI SP HTTP-Version CRLF"
  (destructuring-bind (method request-uri http-version)
      (cl-ppcre:split "(\\s+)|(\\r\\n)" first-line)
    (list
     :request-method (make-keyword method)
     :request-uri request-uri
     :server-protocol (make-keyword http-version))))
