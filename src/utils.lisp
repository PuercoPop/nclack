(in-package :nclack.utils)

(defun merge-plists (list-a list-b)
  "If a key from list-b does not exist in list-a add it to it."
  (let ((*merged-list* (copy-list list-a)))
    (declare (special *merged-list*))
    (loop for key in list-b by #'cddr
       do
         (unless (getf list-a key)
           (setf *merged-list* (append *merged-list*  `(,key ,(getf list-b key))))))
        *merged-list*))

