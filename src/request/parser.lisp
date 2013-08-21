(in-package :nclack.request)

;; stream -> env
(defun parse-request (stream)
  (let ((env (list)))
    (setq env (parse-first-line env stream))
    (setq env (parse-headers env stream))
    (setq env (parse-body env stream))))

;; plist, stream => plist
(defun parse-first-line (env stream)
  "Request-Line   = Method SP Request-URI SP HTTP-Version CRLF"
  (destructuring-bind (method request-uri http-version)
      (cl-ppcre:split "(\\s+)" (read-http-line stream))
    (append env (list
                 :request-method (make-keyword method)
                 :request-uri request-uri
                 :server-protocol (make-keyword http-version)))))

;; plist, stream => plist
(defun parse-headers (env stream)
  (append env (loop
                 for line = (read-http-line stream)
                 until (string= "" line)
                 append (parse-header-line line))))

(defun parse-header-line (line)
  (destructuring-bind (key value)
      (cl-ppcre:split ": " line)
    (list (make-keyword key) value)))

;; plist, stream => plist
(defun parse-body (env stream)
  (if (eq 'eof (peek-char nil stream nil 'eof))
      env
      (append env (list :raw-body stream))))

