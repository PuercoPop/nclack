(in-package :nclack-tests)

;; Design example
;; (conforms-to '(:method :PUT
;;                :request-uri "blah"
;;                :server-protocol :HTTP/1.0))
;; expands into
;; (is (match result ((property :request-method x) (eq x :PUT))))
;; (is (match result ((property :request-uri x)
;;            (string= "/stuff/here?foo=bar"))))
;; (is (match result ((property :server-protocol x) (eq x :HTTP/1.0))))
(defmacro conforms-to (property-list)
  `(progn ,@(loop for (key value) on property-list by #'cddr
              collect
                `(is (match result ((property ,key x) (eq x ,value)))))))

;; Use case
;; (let ((result (list :method :PUT :request-uri "blah" :server-protocol :HTTP/1.0)))
;;   (conforms-to (:method :PUT
;;                  :request-uri "blah"
;;                  :server-protocol :HTTP/1.0)))
