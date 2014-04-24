(in-package :nclack/request)

(defgeneric request-method (request)
  (:documentation "The HTTP request method, must be one of :GET , :HEAD , :OPTIONS , :PUT , :POST , or :DELETE ."))

(defgeneric script-name (request)
  (:documentation "The initial portion of the request URL's path, corresponding to the application. This may be an empty string if the application corresponds to the server's root URI. If this key is not empty, it must start with a forward slash ( / )."))

(defgeneric path-info (request)
  (:documentation "The remainder of the request URL's path. This may be an empty string if the request URL targets the application root and does no have a trailing slash."))

(defgeneric query-string (request)
  (:documentation "The portion of the request URL that follows the ? , if any. This key may be empty, but must always be present, even if empty."))

(defgeneric server-name (request)
  (:documentation "The resolved server name, or the server IP address."))

(defgeneric server-port (request)
  (:documentation "The port on which the request is being handled."))

(defgeneric server-protocol (request)
  (:documentation "The version of the protocol the client used to send the request. Typically this will be something like :HTTP/1.0 or :HTTP/1.1 ."))

(defgeneric request-uri  (request)
  (:documentation "The request URI. Must start with a /."))


(defgeneric raw-body (request)
  (:documentation "If request has body then return a stream with the body contents."))


(defgeneric http-user-agent (request)
  (:documentation "The string with value the user agent header, if present."))


(defgeneric http-referer (request)
  (:documentation "The string with the http referrer, if present."))

(defgeneric remote-addr (request)
  (:documentation "The IP address of the client or the last proxy that sent the request."))


(defgeneric remote-port (request)
  (:documentation "The port of the client or the last proxy that sent the request."))

(defgeneric http-server (request)
  (:documentation "The name of Clack Handler or http server. Valid examples are :hunchentoot or :nclack."))
