(in-package :nclack-tests)

(defparameter *specs-dir* (system-relative-pathname :nclack-tests
                                                    "specs/"))

(def-suite request-suite
    :description "Testing for the conversion between HTTP request to the Clack
    'environ' representation.")
(in-suite request-suite)

;; 1. Read 001.http file
;; 2. Compare the request to the form in 001.lisp

(test first-test ()
      (let* ((http-stream (open (merge-pathnames "requests/valid/001.http"
                                                 *specs-dir*)))
             (expected-request (read (open
                                      (merge-pathnames "requests/valid/001.lisp"
                                                       *specs-dir*))))
             (request-tests (read (open
                                   (merge-pathnames "requests/valid/001.spec"
                                                    *specs-dir*))))
             (created-request (nclack:make-request http-stream)))
        (declare (special expected-request)
                 (special created-request))
        (close http-stream)
        (eval request-tests)
        ))

(defun test-runner ()
  (run! 'request-suite))

(defun setup-test-tuples (path)
  "Get all the *.http files in the directory, match them with their *.lisp and *spec counterparts And return a list of tuples in the form (001.http 001.lisp 001.spec). Signal a condition if no *.lisp or *.spec counterpart found."
  (let ((result (list)))
    (dolist (file (directory path))
      ;; (format t "~A~%" file)
      (setf result (append result (list (get-the-counterparts file)))))
    result))

(defun get-the-counterparts (absolute-filename)
  "For each file *.http get the *.lisp and *.spec counterparts"
  (flet ((add-directory (filename)
           (make-pathname :directory (pathname-directory #P"/Users/PuercoPop/quicklisp/local-projects/nclack/specs/requests/valid/pp_01.http")
                          :defaults filename)))
    (let* ((dir (make-pathname :directory
                               (pathname-directory absolute-filename)))
           (filename (file-namestring file))
           (request-file (cl-ppcre:regex-replace "http$" filename "lisp"))
           (spec-file (cl-ppcre:regex-replace "http$" filename "spec")))
      `(,absolute-filename
        ,(add-directory request-file)
        ,(add-directory spec-file)))))
