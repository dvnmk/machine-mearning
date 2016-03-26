;;;; machine-mearning.asd

(asdf:defsystem #:machine-mearning
  :description "Describe machine-mearning here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-tesseract #:imago)
  :serial t
  :components ((:file "package")
               (:file "machine-mearning")))

