(in-package :nclack/request)

(defclass request ()
  ())

(defun make-request (in-stream)
  (process-first-line (read-line in-stream)))

(defun process-request (stream)
  "Use a 'state machine' to process the request, the states are 'first-line,
'headers and 'body. Use request-env as a plist to progressively build the request. "
  (let ((*request-state* 'first-line)
        (*request-env* (list)))
    (declare (special *request-state*)
             (special *request-env*))

    (loop
       :until (eq *request-state* 'end-of-request)
       :do
         (setq *request-env*
               (append *request-env*
                       (case *request-state*
                         ('first-line (process-first-line stream))
                         ('headers (process-headers stream))
                         ('body (process-body stream))))))))

(defun process-first-line (first-line)
  "Request-Line   = Method SP Request-URI SP HTTP-Version CRLF"
  (destructuring-bind (method request-uri http-version)
      (cl-ppcre:split "(\\s+)|(\\r\\n)" first-line)
    (list
     :request-method (make-keyword method)
     :request-uri request-uri
     :server-protocol (make-keyword http-version))))
