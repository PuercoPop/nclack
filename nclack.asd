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
               :puri
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
                         (:file "transformations")
                         (:file "interface")
                         (:file "parser")
                         (:file "compat")))))

(asdf:defsystem nclack-tests
  :depends-on (:nclack
               :hu.dwim.stefil
               :flexi-streams
               :anaphora)
  :pathname "tests/"
  :serial t
  :components ((:file "packages")
               (:file "conf")
               (:file "utils")
               (:file "parser")
               (:module "gunicorn"
                        :components
                        ((:file "gunicorn-tests")))
               (:file "runner")))

(defmethod asdf:perform ((op asdf:test-op)
                         (system (eql (asdf:find-system :nclack))))
  (asdf:load-system :nclack-tests)
  (asdf/package:symbol-call :nclack-tests 'test-runner))
