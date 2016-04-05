;;; machine-mearning-buffer.el --- TODO -*- lexical-binding: t; -*

;; Copyright (C) 2016 by dvnmk
;;
;; Author: dvnmk <divinomok@gmail.com>
;; URL: https://github.com/dvnmk/machine-mearning
;; DEMO: https://vimeo.com/bacq/machine-mearning
;; Keywords: TODO
;; Version: minus-moebius

;; This file is NOT a part of GNU Emacs.

;;; License:
;; TODO

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

(defun qt-mouse-drag-digitizer (event)
"capture mouse event drag => list"
  (interactive "e")
  (let* ((pos-0 (event-start event))
	 (pos-1 (event-end event))
	 (pt1 (posn-x-y pos-0))
	 (pt2 (posn-x-y pos-1))
	 (dt (/ (- (posn-timestamp pos-1)
		   (posn-timestamp pos-0))
		1000.0)))
    (message "%s ->  %s wahrend %s" pt1 pt2 dt)
    (list (car pt1) (cdr pt1) (car pt2) (cdr pt2) dt)
    ))

(defun qt-mouse-drag (event)
  ""
  (interactive "e")
  (let* ((lst (qt-mouse-drag-digitizer event))
	(cmd (format "(drag-passiert '%s)" lst)))
    (2slime cmd)))


(defun qt-mouse-click-digitizer (event)
  (interactive "e")
  (let* ((pos-0 (event-start event))
	 (pt0 (posn-x-y pos-0))
	 (ts (posn-timestamp pos-0)))
    (message "%s at %s" pt0 ts)
    (list (car pt0) (cdr pt0) ts)))

(defun qt-mouse-click (event)
  (interactive "e")
  (let* ((lst (qt-mouse-click-digitizer event))
	 (cmd (format "(click-passiert '%s)" lst)))
    (2slime cmd)))

(defun record-start ()
  (interactive)
  (let ((cmd (format "(record-start)")))
    (2slime cmd)))

(defun record-stop ()
  (interactive)
  (let ((cmd (format "(record-stop)")))
    (2slime cmd)))

(defun record-reset ()
  (interactive)
  (let ((cmd (format "(record-reset)")))
    (2slime cmd)))


;;;###autoload
(define-minor-mode machine-mearning-mode
  "TODO"
  :lighter " (M)"
  :keymap (let ((map (make-sparse-keymap)))

            (define-key map (kbd "<mouse-1>") #'qt-mouse-click)
            (define-key map (kbd "<drag-mouse-1>") #'qt-mouse-drag)
            (define-key map (kbd "<down-mouse-1>") (lambda () (interactive) (message "Machine-Mearning>")))
            (define-key map (kbd "C-c C-c") #'foo)
            ;; (define-key map [down-mouse-1] 'nil)
	    ;; (define-key map [drag-mouse-1 'nil])
	    
	    (define-key map (kbd "1") #'record-start)
	    (define-key map (kbd "0") #'record-stop)
	    (define-key map (kbd "9") #'record-reset)
	    
	    map))

(provide 'machine-mearning-mode)

;;; machine-mearning-mode.el ends here
