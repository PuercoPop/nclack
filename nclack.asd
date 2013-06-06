(asdf:defsystem #:nclack
  :name "nclack"
  :description "not clack"
  :long-description "An http server that complies with the clack interface, hopefully."
  :author "Javier Olaechea <pirata@gmail.com>"
  :version "20130604"
  :serial t
  :license "<3"
  :depends-on (#:usocket
               #:cl-ppcre
               #:alexandria)

  :pathname "src/"
  :components ((:file "packages")
               (:file "nclack")
               (:file "request")))
