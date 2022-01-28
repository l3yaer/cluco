;;;; cluco.asd

(asdf:defsystem #:cluco
  :description "Describe cluco here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-ppcre)
  :components ((:file "package")
               (:file "cluco")
			   (:file "compiler")
			   (:file "util")))
