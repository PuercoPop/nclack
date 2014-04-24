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
  (:export
   #:make-request))

(defpackage :nclack/server
  (:use :cl :iolib))

(uiop/package:define-package :nclack
  (:use :cl :nclack/request)
  (:reexport :nclack/request))
