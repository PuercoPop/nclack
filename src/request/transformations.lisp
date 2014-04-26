(in-package :nclack/request)

;; Functions that transforn the env plist (plist => plist). They are used to
;; make sure the env is clack compliant without the messing with the http
;; parser.


(defun script-name-transform (env)
  "Add :script-name (Required, String).

The initial portion of the request URI path that corresponds to the Clack
application. The value of this key may be an empty string when the client is
accessing the application represented by the server's root URI. Otherwise, it
is a non-empty string starting with a forward slash ( / )."
  (let*
      ((uri (getf env :request-uri))
       (question-mark-start (position #\? uri)))
    (setf (getf env :script-name)
          (if question-mark-start
              (subseq uri 0 question-mark-start)
              uri))
    env))

(defun query-string-transform (env)
  "Add :query-string (Optional, String).

The portion of the request URI that follows the ? , if any. This key may have
no value at all while the key itself always exists."
  (let*
      ((uri (getf env :request-uri))
       (question-mark-start (position #\? uri)))
    (if question-mark-start
        (setf (getf env :query-string)
              (subseq uri (1+ question-mark-start)))
              env)
    env))
