(in-package :nclack.request)

(defun cl-rf ()
  (format nil "~C~C" #\Return #\Linefeed))

(defun read-http-line (stream)
  "read until crlf, return the string without the crlf."
  (let ((line (make-array 140 :element-type 'character
                          :adjustable t
                          :fill-pointer 0)))
    (read-http-line-iter stream line)))


(defun read-http-line-iter (stream accum &optional prev-char)
  (let ((current-char (read-char stream nil 'eof)))
    (cond ((or (eq current-char 'eof)
               (and (eq #\Linefeed current-char)
                    (eq #\Return prev-char))) accum)
          ((eq #\Return current-char)
           (read-http-line-iter stream
                                accum
                                current-char))
          (t
           (read-http-line-iter stream
                                (append-to-string accum current-char)
                                current-char)))))

(defun append-to-string (string &rest chars)
  (loop
     :for char :in chars
     :do
       (vector-push-extend char string))
  string)
