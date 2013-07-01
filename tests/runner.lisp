(in-package :nclack-tests)

(defun test-runner ()
  (run! 'request-suite))

(defun test-collector ()
  "Looks for all the triplets and defines a test for them. In current suite or
   taking a suite as an argument? "
  (loop
     for triplet in (setup-test-tuples
                     (merge-pathnames "requests/valid/*.http" *specs-dir*))
     do
       (let ((http-file (first triplet))
             (request-file (second triplet))
             (spec-file (third triplet)))
         #.`(test ,(gensym) ()
                  (let* ((http-stream (open http-file))
                         (expected-request (read (open request-file)))
                         (request-tests (read (open spec-file))))
                    (close http-stream)
                    (eval request-tests))))))



(defun setup-test-tuples (path)
  "Get all the *.http files in the directory, match them with their *.lisp and
   *spec counterparts And return a list of tuples in the form
   (001.http 001.lisp 001.spec). Signal a condition if no *.lisp or *.spec
   counterpart found."
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
    (let* ((file (make-pathname :directory
                               (pathname-directory absolute-filename)))
           (filename (file-namestring file))
           (request-file (cl-ppcre:regex-replace "http$" filename "lisp"))
           (spec-file (cl-ppcre:regex-replace "http$" filename "spec")))
      `(,absolute-filename
        ,(add-directory request-file)
        ,(add-directory spec-file)))))

;; (setup-test-tuples (merge-pathnames "requests/valid/*.http"
;;                                     *specs-dir*))
