(defpackage :nclack
  (:use :cl :cl-ppcre)
  (:import-from :alexandria :make-keyword)
  (:export :make-request))

(defpackage :nclack.utils
  (:use :cl))

(defpackage :fsm
  (:use :cl)
  (:export :standard-state-machine
           :standard-state-machine-event
           :last-event
           :state
           :defstate
           :deffsm))

(defpackage :nclack.request
  (:use :cl :fsm)
  (:import-from :alexandria #:make-keyword))

(defpackage :nclack.server
  (:use :cl :iolib))
