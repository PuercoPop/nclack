(in-package :cl-user)
(defpackage :nclack-system
  (:use :cl :asdf))
(in-package :nclack-system)

(defsystem nclack
  :name "nclack"
  :description "not clack"
  :long-description "An http server that complies with the clack interface, hopefully."
  :author "Javier Olaechea <pirata@gmail.com>"
  :version "20130604"
  :serial t
  :license "<3"
  :depends-on (:iolib
               :cl-ppcre
               :alexandria
               :optima)

  :pathname "src/"
  :components ((:file "packages")
               (:file "nclack")
               (:module "request"
                :components
                ((:file "interface")
                 (:file "implementation")
                 (:file "parser"))))
  :in-order-to ((test-op (test-op nclack-tests))))
