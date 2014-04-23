(in-package :nclack.request)

(define-condition parse-error ()
  ((prefix :initform "Parse Error" :reader prefix)
   (message :initarg message :reader message))
  (:report (lambda (condition stream)
             (format stream "~S: ~S"
                     (prefix condition)
                     (message condition) )))
  (:documentation "Signals errors ocurred during parsing."))

(define-condition chunked-body-parse-error (parse-error)
  ((prefix :initform "Chunked Body")))
