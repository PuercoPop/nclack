(defpackage :nclack/utils
  (:use :cl))

(defpackage :fsm
  (:use :cl)
  (:export :standard-state-machine
           :standard-state-machine-event
           :last-event
           :state
           :defstate
           :deffsm))

(defpackage :nclack/request
  (:use :cl :fsm :nclack/utils)
  (:import-from :alexandria #:make-keyword)
  (:import-from :anaphora
                :aif
                :it)
  (:import-from :puri
                :parse-uri
                :merge-uris
                :uri-host
                :uri-port
                :uri-path
                :uri-query)
  (:export
   #:make-request))

(defpackage :nclack/server
  (:use :cl :iolib))

(uiop/package:define-package :nclack
  (:use :cl :nclack/request)
  (:reexport :nclack/request))
