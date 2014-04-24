(in-package :nclack-tests)

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

(def-suite gunicorn-request-suite)
(in-suite gunicorn-request-suite)

(test 001.http ()
      (let ((result (parse-request (read http-file))))
        (conforms-to (format nil "~S" (read spec-file)))
        ))

(defun collect-tests (&key
                        (specs-dir *specs-dir*)
                        (output-file *gunicorn-tests-dir*))
  "Grab every *.http and *.lisp and write"
  (with-open-file (output output-file
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (format output "~S~%" '(def-suite gunicorn-request-suite))
    (format output "~S~%" '(in-suite gunicorn-request-suite))
    (loop for (filename http-file spec-file) in (setup-test-tuples specs-dir)
       do
         (with-open-file (spec spec-dir
                               :direction :input
                               :if-does-not-exist :error)
           (format "~S~%"
                   `(test ,filename ()
                          (let result (parse-request (read http-file))
                               (conforms-to (format nil "~S" ,(read spec)))))))
         ))
  )

(with-open-file (output #P"~/t.lisp"
                        :direction :output
                        :if-exists :supersede
                        :if-does-not-exist :create)
  (with-open-file (input #P"~/test.lisp"
                         :direction :input
                         :if-does-not-exist :error)
    (format output "~S" '(1 2 3))))

(conforms-to (read-file spec-file))

(defun setup-test-tuples (path)
  "Get all the *.http files in the directory, match them with their
  *.lisp counterpart. Return a list of tuples in the form (001.http
  001.lisp). Signal a condition if no *.lisp counterpart found[TODO]."
  (loop for file in (remove-if-not (lambda (x) (string= "http" (pathname-type x))) (cl-fad:list-directory path))
     collect (list file (get-spec-file file))))

(defun get-spec-file (absolute-filename)
  "For each file *.http get the *.lisp and *.spec counterparts"
  (let ((spec-file (make-pathname :directory (pathname-directory absolute-filename)
                                  :defaults (concatenate 'string (pathname-name absolute-filename) ".lisp"))))
    spec-file))
