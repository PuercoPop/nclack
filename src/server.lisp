(in-package :nclack.server)

(defparameter *port* 6969)

(defun start-echo-server ()
  (handler-case
      (echo-server *port*)
    (socket-address-in-use-error ()
      ;; Here we catch a condition which represents trying to bind to
      ;; the same port before the first one has been released by the
      ;; kernel.  Generally this means you forgot to put ':reuse-addr
      ;; t' as an argument to bind address.
      (format t "Bind: Address already in use, forget :reuse-addr t?")))
  (finish-output))

(defun echo-server (port)
  (with-open-socket
      (server :connect :passive
              :address-family :internet
              :type :stream
              :external-format '(:ascii :eol-style :crlf)
              :ipv6 nil)
    (format t "Created a Socket: ~A[fd=~A]~%" server
                                              (iolib:socket-os-fd server))
    (bind-address server iolib:+ipv4-unspecified+ :port port :reuse-address t)
    (listen-on server :backlog 2)
    (loop 
       (with-accept-connection (client server :wait t)
         (handle-request client)))))

(defun handle-request (stream)
  (format t "Inside handle request~%")
  (let ((request (read-line stream)))
    (format stream "You said: ~A" request)))
