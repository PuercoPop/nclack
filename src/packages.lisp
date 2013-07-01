(defpackage :nclack
  (:use :cl :cl-ppcre)
  (:import-from :alexandria :make-keyword)
  (:export :make-request))

(defpackage :nclack.request
  (:use :cl))

(defpackage :nclack.server
  (:use :cl :iolib))
