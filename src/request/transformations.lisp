(in-package :nclack/request)

;; Functions that transforn the env plist (plist => plist). They are used to
;; make sure the env is clack compliant without the messing with the http
;; parser.

(defun puri-transform (env)
  (let ((base-uri (parse-uri (getf env :server)))
        (relative-uri (parse-uri (getf env :request-uri))))
    (append (list :puri
                  (merge-uris relative-uri base-uri)) env)))

(defun script-name-transform (env)
  "Add :script-name (Required, String).

The initial portion of the request URI path that corresponds to the Clack
application. The value of this key may be an empty string when the client is
accessing the application represented by the server's root URI. Otherwise, it
is a non-empty string starting with a forward slash ( / )."
  (append (list :script-name
                (aif (uri-path (getf env :puri))
                    it
                  "/")) env))

(defun query-string-transform (env)
  "Add :query-string (Optional, String).

The portion of the request URI that follows the ? , if any. This key may have
no value at all while the key itself always exists."
  (append (list :query-string
                (uri-query (getf env :puri))) env))

(defun server-name-transform (env)
  "Add :server-name (Required, String).

The resolved server name or the server IP address."
  (append (list :server-name
                (uri-host (getf env :puri)))
          env))

(defun server-port-transform (env)
  "Add :server-port (Required, Integer)

The port on which the request is being handled."
  (append (list :server-port
                (uri-port (getf env :puri)))
          env))
