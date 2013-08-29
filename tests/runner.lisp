(in-package :nclack-tests)

(defun test-runner ()
  (run! 'http-parser-suite)
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
