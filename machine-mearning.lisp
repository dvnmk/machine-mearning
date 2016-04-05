;;;; machine-mearning.lisp

(in-package #:machine-mearning)

;;; "machine-mearning" goes here. Hacks and glory await!

(defparameter *ssh* nil)
(defparameter *ssh-in* nil)

(defun connect ()
  (progn
    (defparameter *ssh* (external-program:start "ssh"
					'("-t" "-t" "mobile@localhost" "-p" "2000")
					:output t :input :stream 
								 ;; :wait nil
					;; :sharing :external
							  ))
    (defparameter *ssh-in* (external-program:process-input-stream *ssh*))))

(defun disconnect ()
  (external-program:signal-process *ssh* 9))

(defun cmd (cmd)
  (progn (format *ssh-in* "~D~%" cmd)
	 (finish-output *ssh-in*)))
 
(defun swipe (lst)
  (let* ((x1 (nth 0 lst))
	(y1 (nth 1 lst))
	(x2 (nth 2 lst))
	(y2 (nth 3 lst))
	(dura (nth 4 lst))
	(cmd (format nil "stouch swipe ~S ~S ~S ~S ~S" x1 y1 x2 y2 dura)))
    (cmd cmd)))

(defun touch (lst)
  (let* ((x (car lst))
	(y (cadr lst))
	(cmd (format nil "stouch touch ~S ~S" x y)))
    (cmd cmd)
    lst))

(defun zzz ()
  "Push the sleep button on iphone"
  (cmd "activator send libactivator.system.sleepbutton"))

(defun wach ()
  "Dismiss the lockscreen on iphone"
  (cmd "activator send libactivator.lockscreen.dismiss"))

(defun noti ()
  "Open the notification-center"
  (cmd "activator send libactivator.system.activate-notification-center"))

(defun fotos ()
  "Open the Foto app"
  (cmd "activator send com.apple.mobileslideshow"))

(defun home ()
  "Open home springboard"
  (cmd "activator send libactivator.system.first-springboard-page"))

(defun auction ()
  "Open the auction app"
  (cmd "activator send kr.co.auction.AuctionBrowser"))

;; (cmd "activator current-mode")

;; (cmd "activator current-app")

(defun shot-shot ()
  (cmd "activator send libactivator.system.take-screenshot"))


(defun m-m/revert-buffer (buf)
  (let ((tar-buf-path (namestring (merge-pathnames "shot.png" *working-dir*))))
    (swank:eval-in-emacs
     `(let ((tar-buf (get-buffer ,buf)))
	(if tar-buf (with-current-buffer tar-buf
		      (revert-buffer t t))
	    (find-file ,tar-buf-path)))   )))


(defparameter *qt-wrapper-path* (merge-pathnames "qt-wrapper" *working-dir*))

;;
(let ((shot-filename (file-namestring *shot-path*)))
  (swank:eval-in-emacs
   `(defun setup-fit ()
      (setq window-resize-pixelwise t)
      (setq fit-window-to-buffer-horizontally t)
      (progn
	(other-window 1)
	(switch-to-buffer ,shot-filename) 
	(setq *win* (get-buffer-window ,shot-filename))
	(fit-window-to-buffer)
	(window-pixel-left *win*))
      )))

(let ((qt-filename (namestring *qt-wrapper-path*))
      (shot-filename (namestring *shot-path* )))
  (swank:eval-in-emacs
   `(defun setup-wins ()
      (setq window-resize-pixelwise t)
      (setq fit-window-to-buffer-horizontally t)
      (progn (split-window-right)
	     (other-window 1)
	     (find-file ,qt-filename)
	     (find-file ,shot-filename)
	     (setq *win* (get-buffer-window ,shot-filename))
	     (fit-window-to-buffer)
	     (window-pixel-left *win*)))))

(defparameter *qt-wrapper-left* 0)

(defun init ()
  (setq *qt-wrapper-left* (swank:eval-in-emacs '(setup-wins)))
  (format t "*QT-WRAPPER-LEFT*: ~d, DEM NACHST, KALIBRATION M/ QUICKTIME PLAYER" *qt-wrapper-left*)
  *qt-wrapper-left*)

(defun fit-again ()
  (setq *qt-wrapper-left* (swank:eval-in-emacs '(setup-fit)))
  (format t "*QT-WRAPPER-LEFT*: ~d, DEM NACHST, KALIBRATION M/ QUICKTIME PLAYER" *qt-wrapper-left*)
  *qt-wrapper-left*)


(defun guck ()
  "wifi ssh ver. <-> (guck-local)"
  (progn (shot-sym-down) 
	 (m-m/revert-buffer "shot.png")
	 ;; (shot-resize-opticl)
	 ;; (sleep 0.2)
	 ;; (revert-buffer "shot-resize.png")
	 ))

;; kann genommen aus emacs variable werden. DONE
(defparameter *fringe-width* (swank:eval-in-emacs
			      '(car (window-fringes))))

;; entscheiden (x y), (y x), (x . y), od. (y . x) TODO
(defparameter *last-druck-point* '(0 0))

(defparameter *ratio* 0.5)
(defparameter *scr-size-ori* (/ 1136 2))
(defparameter *scr-size-jetzt* 1136.0)
 
(defun calc-ratio ()
     (setf *ratio* (/ *scr-size-ori* *scr-size-jetzt*)))

(defparameter *qt-wrapper-left* nil)

(defun nimm-mouse-pos ()
  (swank:eval-in-emacs
   '(cdr (mouse-pixel-position))))

(defun druck ()
  "druck the current mouse point y setf *last-drcuk-point*"
  (let* ((i (conv-mouse-pos))
	 (x (car i))
	 (y (cadr i)))
       (touch i)
       (setf (car *last-druck-point*) x)
       (setf (cadr *last-druck-point*) y)
       (format t "GEDRUCKT ~d ~d~%" x y)
       *last-druck-point*))

(defun druck-guck ()
  (progn (druck)
	 (sleep 2)
	 (guck)
	 *last-druck-point*
	 ))

(defun qt-run ()
  "venga quicktime player fue die iphone screen sharing"
  (external-program:start "open" '("-a" "QuickTime Player") :output t))

(defun qt-kill ()
  "quicktime player no mas"
  (with-output-to-string (out)
    (external-program:run "killall"
		     '("QuickTime Player")
		     :output out)))
 
 (defvar *el-path* (merge-pathnames "machine-mearning-mode.el" *working-dir*))
(swank:eval-in-emacs `(load ,(namestring *el-path*)))

(defun licht- ()
  (cmd "activator send libactivator.screen.brightness.decrease"))

(defun licht+ ()
  (cmd "activator send libactivator.screen.brightness.increase"))

(defun red-msg (msg color)
  "Insert red color msg at the end of buffer in the buffer qt-wrapper"
  (let ((wo (file-namestring *qt-wrapper-path*)))
    (swank::eval-in-emacs
     `(with-current-buffer ,wo
	(end-of-buffer)
	(insert (propertize ,msg 'font-lock-face '(:foreground ,color)))))))

(defun halbe (etwas-lst)
  "alle ele in list mit ratio, eigentlich nicht half machen, deswegen halbe"
  (mapcar (lambda (x) (* x *ratio*)) etwas-lst))

(defun drag-passiert (lst)
  (let* ((convrted-poen-lst (list (* (nth 0 lst) *ratio*)
			      (* (nth 1 lst) *ratio*)
			      (* (nth 2 lst) *ratio*)
			      (* (nth 3 lst) *ratio*)
			      (nth 4 lst)))
	 (msg (format nil "~A" convrted-poen-lst)))
    (progn  (if *record-status* (push convrted-poen-lst *record-kiste*))
	    ;; (swipe convrted-poen-lst)
	    (red-msg msg "darkcyan") ; debug
	    (swank:eval-in-emacs 
	     `(message "DRAG-passiert: %s" ,msg)))))


(defun  click-passiert (lst)
  (let* ((convrted-poen-lst (list (* (car lst) *ratio*) ; x
			 (* (cadr lst) *ratio*) ; y
			 (caddr lst)))
	 (msg (format nil "~A" convrted-poen-lst)))			; ts
    (progn (if *record-status* (push  convrted-poen-lst *record-kiste*))
	   ;; (touch convrted-poen-lst) ; soll ohne ts
	   (red-msg msg "black")	; debug
	   (swank:eval-in-emacs
	    `(message "CLICK-passiert: %s" ,msg )))))

(defun poen-conv (lst)
  "retina poen position -> normal resolution fuer touch cmd"
  (let ((x (* (- (car lst) *qt-wrapper-left* *fringe-width*)
	      *ratio*))
	(y (* (cadr lst) *ratio*)))
    (list x y)))

(defun conv-mouse-pos ()
  "convert the nimm-mouse-pos-gt value im verzueglich mit window"
  (let* ((poen-cons (nimm-mouse-pos))
	 (poen-lst (list (car poen-cons) (cdr poen-cons))))
    (poen-conv poen-lst)))

;; record
(defparameter *record-kiste* nil)
(defparameter *record-status* nil)

(defun record-start ()
       (progn (setf *record-status* t)
	      (swank:eval-in-emacs
	       '(message "RECORD-START-gt"))))

(defun record-stop ()
       (progn (setf *record-status* nil)
	      (swank:eval-in-emacs
	       '(message "RECORD-STOP-gt"))))

(defun record-reset ()
  (progn (setf *record-kiste* nil)
	 (swank:eval-in-emacs
	  '(message "*record-kiste* LEER-gt"))))

;; *record-kiste* to fun converter
;; cond el in list ist 4 length, ist es ein swipe so, einfach (swipe)
;; wenn es 3, dann ist es ein touch. denk mal dran dit timestampe

