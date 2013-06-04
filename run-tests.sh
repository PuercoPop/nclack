#!/bin/sh
sbcl --eval "(ql:quickload :nclack-tests)" \
     --eval "(nclack-tests:first-test)" \
     --eval "(progn (terpri) (sb-ext:quit))"
