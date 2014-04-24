(defpackage :nclack-tests
  (:use :cl :hu.dwim.stefil :nclack :flexi-streams)
  (:import-from :asdf :system-relative-pathname)
  (:import-from :anaphora
                :awhen
                :it)
  (:export :test-runner))
