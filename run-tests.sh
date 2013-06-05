#!/bin/sh
sbcl --eval "(ql:quickload :nclack-tests)" \
     --eval "(nclack-tests:test-runner)" \
     --eval "(progn (terpri) (sb-ext:quit))"
