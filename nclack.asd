(in-package :cl-user)

(asdf:defsystem nclack
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
               :optima
               :closer-mop)

  :pathname "src/"
  :components ((:file "packages")
               (:file "nclack")
               (:module "request"
                        :components
                        ((:file "conditions")
                         (:file "utils")
                         (:file "fsm")
                         (:file "interface")
                         (:file "implementation")
                         (:file "parser")))))

(asdf:defsystem nclack-tests
  :depends-on (:nclack
               :fiveam
               :flexi-streams
               :anaphora)
  :pathname "tests/"
  :serial t
  :components ((:file "packages")
               (:file "conf")
               (:file "utils")
               (:file "runner")
               (:file "parser")
               (:file "request")))

(defmethod asdf:perform ((op asdf:test-op)
                         (system (eql (asdf:find-system :nclack))))
  (asdf:load-system :nclack-tests)
  (asdf/package:symbol-call :nclack-tests 'test-runner))
