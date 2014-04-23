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


(defun parse-body (env stream)
  (if (eq 'eof (peek-char nil stream nil 'eof))
      env
      (append env (list :raw-body stream))))

;; plist, stream => plist
(defun parse-chunked-body (env stream)
  (append env
          (list :raw-body
                (loop
                   :for line = (read stream)
                   :until
                   :collect)))
)

(defun %parse-chunked-boy (stream)
  "First look for the lenght line, then read that many chars from the stream
  and verify it is crlf terminated."  )

(defun is-digit-p (char)
  (member char '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0) :test #'char=))

(deffsm chunked-body ()
  ((buffer :initarg :buffer :initform nil :accessor buffer)
   (body :accessor body)
   (counter :initarg counter :initform 0 :accessor counter)))

(defstate chunked-body :start-line (fsm c)
  (cond
    ((is-digit-p c)
     (progn
       (setf (counter fsm) (+ (* 10 (counter fsm)) (digit-char-p c)))
       :read-line-length))
    ((char= c #\Return) :end-body)
    (t (error 'chunked-body-parse-error
              :message (format nil
                               "Lines should begin with a digit or ~C, got ~C instead."
                               #\Return c)))))

(defstate chunked-body :read-line-length (fsm c)
  (cond
    ((is-digit-p c)
     (progn
       (setf (counter fsm) (+ (* 10 (counter fsm)) (digit-char-p c)))
       :read-line-length))
    (t (progn
         (decf (counter fsm))
         (setf (buffer fsm) (cons c (buffer fsm)))
         :read-line-content))))

(defstate chunked-body :read-line-content (fsm c)
  (if (eql (counter fsm) 0)
      (if (char= c #\Return)
          :end-line
          (error 'chunked-body-parse-error
              :message (format nil
                               "End of line, Expecting ~C, got ~C instead."
                               #\Return c)))
      (progn
         (decf (counter fsm))
         (setf (buffer fsm) (cons c (buffer fsm)))
         :read-line-content)))

(defstate chunked-body :end-line (fsm c)
  (if (char= c #\Linefeed)
      :start-line
      (error 'chunked-body-parse-error
              :message (format nil
                               "Expecting the body to terminate with ~C, got ~C instead."
                               #\Linefeed c))))

(defstate chunked-body :end-body ()
  (cond
    ((char= #\Linefeed c)
     (progn
       (setf (body fsm) (with-output-to-string (stream)
                          (dolist (char (buffer fsm))
                            (princ char stream))
                          stream))
       :finish))
    (t (error 'chunked-body-parse-error
              :message (format nil
                               "Expecting the body to terminate with ~C, got ~C instead."
                               #\Linefeed c)))))

(defstate chunked-body :finish (fsm c))
