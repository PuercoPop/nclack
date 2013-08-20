(defpackage :nclack
  (:use :cl :cl-ppcre)
  (:import-from :alexandria :make-keyword)
  (:export :make-request))

(defpackage :nclack.utils
  (:use :cl))

(defpackage :nclack.request
  (:use :cl)
  (:import-from :alexandria #:make-keyword))

(defpackage :nclack.server
  (:use :cl :iolib))
