;;;; machine-mearning.asd

(asdf:defsystem #:machine-mearning
  :description "Describe machine-mearning here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-tesseract #:opticl #:external-program #:iterate)
  :serial t
  :components ((:file "package")
	       ;; (:file "gehiem.lisp.gpg")
	       (:file "shot")
               (:file "machine-mearning")
               (:file "key")))
