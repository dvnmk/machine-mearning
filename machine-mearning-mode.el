;;; machine-mearning-buffer.el --- a physikal buffer, connecting with the machschine >>STARTX<< in Emacs -*- lexical-binding: t; -*

;; Copyright (C) 2016 by dvnmk
;;
;; Author: dvnmk <divinomok@gmail.com>
;; URL: https://github.com/dvnmk/machine-mearning
;; DEMO: https://vimeo.com/bacq/machine-mearning
;; Keywords: buffer, physical
;; Version: minus-moebius

;; This file is NOT a part of GNU Emacs.

;;; License:
;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 2.

;;; Commentary:

;;; Code:


;;; helper
(defun 2slime (str)
  (cadr (slime-eval `(swank:eval-and-grab-output ,str))))


(defmacro use (fun-name)
  "Use the same name fun from CL"
  `(defun ,fun-name (&optional arg1 arg2)
     (if arg1
	 (if arg2
	     (2slime (format "(%s %s %s)" ',fun-name arg1 arg2))
	   (2slime (format "(%s \"%s\")" ',fun-name arg1)))
       (2slime (format "(%s)" ',fun-name)))))

(defmacro use-i (fun-name)
  "Use the same name fun with interactive from CL"
  `(defun ,fun-name (&optional arg1 arg2)
     (interactive)
     (if arg1
	   (if arg2
	       (2slime (format "(%s %s %s)" ',fun-name arg1 arg2))
	     (2slime (format "(%s \"%s\")" ',fun-name arg1)))
	 (2slime (format "(%s)" ',fun-name)))))

(use-i druck-guck)
(global-set-key (kbd "<H-return>") #'druck-guck)
(use-i druck)

;;;###autoload
(define-minor-mode machine-mearning-mode
  "TODO"
  :lighter " (M)"
  :keymap (let ((map (make-sparse-keymap)))

            (define-key map (kbd "<mouse-1>") #'foo)
            (define-key map (kbd "<drag-mouse-1>") #'conv-mouse-drag)
            (define-key map (kbd "C-c C-c") #'foo)
            
            ;; (define-key map (kbd "C-a")
            ;;   (lambda()(interactive)
            ;;     (beginning-of-visual-line)
            ;;     (setq wo 0)
            ;;     (message "DEBUG// C-a, anfang")))

            map)
  )


(provide 'machine-mearning-mode)

;;; machine-mearning-mode.el ends here
