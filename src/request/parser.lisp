(in-package :nclack/request)

;; stream -> env
(defun parse-request (stream)
  (let ((env (list)))
    (setf env (parse-first-line env stream))
    (setf env (parse-headers env stream))
    (setf env (parse-body env stream))

    (setf env (puri-transform env))
    (setf env (script-name-transform env))
    (setf env (query-string-transform env))
    (setf env (server-name-transform env))
    (setf env (server-port-transform env))))

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
                :for line = (read-http-line stream)
                 :until (string= "" line)
                 :append (parse-header-line line))))

(defun parse-header-line (line)
  (destructuring-bind (key value)
      (cl-ppcre:split ": " line)
    (list (make-keyword (string-upcase key)) value)))

;; plist, stream => plist
(defun parse-body (env stream)
  (if (eq 'eof (peek-char nil stream nil 'eof))
      env
      (append env (list :raw-body stream))))

;; Chunked-body requires http1.1, header Transfer-Encoding field set to chunked
;; and content-length not set.

;; plist, stream => plist
(defun parse-chunked-body (env stream)
  (append env
          (list :raw-body
               (%parse-chunked-body stream))))

;; stream => stream
(defun %parse-chunked-body (stream)
  (let
      ((fsm (make-instance 'chunked-body)))
    (loop
       :do (funcall fsm (read-char stream nil 'eof))
       :until (eq (state fsm) :finish)
       :finally (return (body fsm)))))

(defun is-digit-p (char)
  "Include hexadecimal digits."
  (member char '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9
                 #\A #\B #\C #\D #\E #\F
                 #\a #\b #\c #\d #\e #\f) :test #'char=))

(deffsm chunked-body ()
  ((buffer :initarg :buffer :initform nil :accessor buffer)
   (body :accessor body)
   (counter :initarg :counter :initform 0 :accessor counter)
   (next-line :initform :start-counter-line :accessor next-line
              :documentation "Control to which state the end of line, goes to
              next. Two states, :start-counter-line and :read-line-content."))
  (:default-initargs . (:state :start-counter-line)))

(defmethod toggle-line ((fsm chunked-body))
  (if (eq :start-counter-line (next-line fsm))
      :read-line-content
      :start-counter-line))

(defstate chunked-body :start-counter-line (fsm c)
  (cond
    ((char= #\0 c) :penultimate-line-penultimate-char)
    ((is-digit-p c)
     (progn
       (setf (counter fsm) (+ (* 16 (counter fsm)) (digit-char-p c 16)))
       :read-line-length))
    (t (error 'chunked-body-parse-error
              :message (format nil
                               "Lines should begin with a digit unless at the end of body, got ~C instead."
                               c)))))

(defstate chunked-body :read-line-length (fsm c)
  (cond
    ((is-digit-p c)
     (progn
       (setf (counter fsm) (+ (* 16 (counter fsm)) (digit-char-p c 16)))
       :read-line-length))
    ((char= c #\Return) :end-line)
    (t (error 'chunked-body-parse-error
              :message (format nil
                               "Only hexadecimals digit, ~C and ~C permitted in the cuurent line. Got ~C instead"
                               #\Return
                               #\Linefeed
                               c)))))

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
      (setf (next-line fsm) (toggle-line fsm))
      (error 'chunked-body-parse-error
              :message (format nil
                               "Lines should end with ~C, got ~C instead."
                               #\Linefeed c))))

(defstate chunked-body :penultimate-line-penultimate-char (fsm c)
  (if (char= #\Return c)
      :penultimate-line-end-of-line
      (error 'chunked-body-parse-error
             :message (format nil
                              "Penultimate character of penultimate line. Expected ~C, got ~C instead."
                              #\Return
                              c))))

(defstate chunked-body :penultimate-line-end-of-line (fsm c)
  (if (char= #\Linefeed c)
      :last-line
      (error 'chunked-body-parse-error
             :message (format nil
                              "End of penultimate line. Expected ~C, got ~C instead."
                              #\Linefeed
                              c))))

(defstate chunked-body :last-line (fsm c)
  (if (char= #\Return c)
      :end-body
      (error
       'chunked-body-parse-error
       :message (format nil
                        "Beginning of Last Line. Expected ~C, got ~C instead."
                        #\Return
                        c))))

(defstate chunked-body :end-body (fsm c)
  (cond
    ((char= #\Linefeed c)
     (progn
       (setf (body fsm) (with-output-to-string (stream)
                          (dolist (char (nreverse (buffer fsm)))
                            (princ char stream))
                          stream))
       :finish))
    (t (error 'chunked-body-parse-error
              :message (format nil
                               "Expecting the body to terminate with ~C, got ~C instead."
                               #\Linefeed c)))))

(defstate chunked-body :finish (fsm c))
