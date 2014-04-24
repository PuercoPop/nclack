#!/bin/sh
sbcl --eval "(ql:quickload :nclack)" \
     --eval "(asdf:perform 'asdf:test-op :nclack)" \
     --eval "(progn (terpri) (sb-ext:quit))"
