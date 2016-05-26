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
	 (pt0 (posn-x-y pos-0))
	 (pt1 (posn-x-y pos-1))
	 (ts0 (posn-timestamp pos-0))
	 (ts1 (posn-timestamp pos-1))
	 ;; (dt (/ (- (posn-timestamp pos-0)
	 ;; 	   (posn-timestamp pos-1))
	 ;; 	1000.0))
	 )
    (message "%s ->  %s" pt0 pt1)
    (list ts0 ts1 (car pt0) (cdr pt0)   (car pt1) (cdr pt1)   )
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
    (list ts ts (car pt0) (cdr pt0))))

(defun qt-mouse-click (event)
  (interactive "e")
  (let* ((lst (qt-mouse-click-digitizer event))
	 (cmd (format "(click-passiert '%s)" lst)))
    (2slime cmd)))

(defun record-start-tgl ()
  (interactive)
  (let ((status (2slime "*record-status*")))
    (if (equalp status "NIL"
		)
	(2slime "(record-start)")
      (2slime "(record-stop)"))))


(defun record-reset ()
  (interactive)
  (let ((cmd (format "(record-reset)")))
    (2slime cmd)))

(defun mach-mal ()
  "einmal execute mit current fun-kiste"
  (interactive)
  (let ((cmd (format "(mach-mal)")))
    (2slime cmd)))

(defun fun-kiste-save (kiste-name)
  "current record-kiste -> fun-kiste y save it."
  (interactive "s:kiste-name: ")
  (let ((cmd (format "(fun-kiste-save '%s)" kiste-name)))
    (2slime cmd)))

(fset 'select-order
   [f3 ?\( ?m ?  ?* ?s ?e ?l ?e ?c ?t ?- ?o ?r ?d ?e ?r ?* ?\C-e return])
(global-set-key (kbd "s-7") #'select-order )

(fset 'paymethode
   [f3 ?\( ?m ?  ?* ?p ?a ?y ?m ?e ?t ?h ?o ?d ?e ?* ?\C-e return])
(global-set-key (kbd "s-8") #'paymethode)

(fset '11st
   [f3 ?\( ?1 ?1 ?s ?t ?\C-e return])
(global-set-key (kbd "s-6") #'11st)

(global-set-key (kbd "<s-escape>") #'slime-interrupt)

(fset 'venga
   [f3 ?\( ?m ?  ?* ?v ?e ?n ?g ?a ?* ?\C-e return])
(global-set-key (kbd "s-9") #'venga)

;;;###autoload
(define-minor-mode machine-mearning-mode
  "TODO"
  :lighter " (M)"
  :keymap (let ((map (make-sparse-keymap)))

            (define-key map (kbd "<mouse-1>") #'qt-mouse-click)
            (define-key map (kbd "<drag-mouse-1>") #'qt-mouse-drag)
            (define-key map (kbd "<down-mouse-1>") 
	      (lambda () (interactive) (message "Machine-Mearning>")))
            (define-key map (kbd "C-c C-c") #'foo)
            ;; (define-key map [down-mouse-1] 'nil)
	    ;; (define-key map [drag-mouse-1 'nil])
	    
	    (define-key map (kbd "1") #'record-start-tgl)
	    (define-key map (kbd "2") #'fun-kiste-save)
	    (define-key map (kbd "3") #'mach-mal)
	    (define-key map (kbd "4") #'record-reset)
	    
	    (global-set-key  (kbd "s-1") #'record-start-tgl)
	    (global-set-key  (kbd "s-2") #'fun-kiste-save)
	    (global-set-key  (kbd "s-3") #'mach-mal)
	    (global-set-key  (kbd "s-4") #'record-reset)
	    
	    map))















(provide 'machine-mearning-mode)

;;; machine-mearning-mode.el ends here
