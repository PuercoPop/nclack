"""
Programatically build  the gunicorn test suite from the specs.
"""

from os import listdir
from os.path import dirname, join, realpath

spec_dir = realpath(join(__file__, "specs/"))
valid_spec_dir = join(spec_dir, "requests", "valid")
output_file = join(spec_dir, "gunicorn.lisp")

prelude="""
(in-package :nclack-tests)

(def-suite request-suite
    :description "Testing for the conversion between HTTP request to the Clack
    'environ' representation.")
(in-suite request-suite)
"""

test_template = """
(deftest test-{name} ()
      (let ((created-request
             (with-open-file (input-stream #P"{http_request_path}"
                              :direction :input)
                (nclack:make-request input-stream)))
            (pattern-request {clack_file_contents}))

        (conforms-to pattern-request created-request)))"""

spec_files = listdir(valid_spec_dir)
http_requests = filter( lambda x: x.endswith('http'), spec_files)
clack_requests = filter( lambda x: x.endswith('lisp'), spec_files)
http_requests.sort()
clack_requests.sort()
http_requests = http_requests[:len(clack_requests)]
names = map(lambda x: x.split('.')[0], a)

with open(test_file, 'w') as output_file:
    output_file.write(prelude)
    for name, request_path, clack_request_path in zip(names, http_requests, clack_requests):
        with open(clack_request_path, 'r') as clack_file:
            clack_file_contents = clack_file.read()
            output_file.write(test_template.format(
                name=name,
                http_request_path=request_path,
                clack_file_contents=clack_file_contents))
