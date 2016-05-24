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

(defun stouch (lst)
  "touch y swipe warp"
  (if (> (length lst) 4)
      (swipe lst)
      (touch lst)))

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

(defun 11st ()
  "Open the 11st app"
  (cmd "activator send kr.co.11st.mobile"))

(defun sketchbook ()
  (cmd "activator send com.autodesk.ios.SketchBookPro3"))



;; (cmd "activator current-mode")

;; (cmd "activator current-app")

(defun shot-shot ()
  (cmd "activator send libactivator.system.take-screenshot"))


(defun shot-revert-buffer (buf)
  (let ((tar-buf-path (namestring (merge-pathnames "shot.png" *working-dir*))))
    (swank:eval-in-emacs
     `(let ((tar-buf (get-buffer ,buf)))
	(if tar-buf (with-current-buffer tar-buf
		      (revert-buffer t t))
	    (find-file ,tar-buf-path)))   )))

;; DONE defvar? 
(defvar *qt-wrapper-path* (merge-pathnames "qt-wrapper" *working-dir*))

;;; TODO wenn es keine *shot-path* real file exists? dann wie?
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
      (progn (delete-other-windows)
	     (split-window-right)
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
  (qt-run)
  *qt-wrapper-left*)

(defun fit-again ()
  (setq *qt-wrapper-left* (swank:eval-in-emacs '(setup-fit)))
  (format t "*QT-WRAPPER-LEFT*: ~d, DEM NACHST, KALIBRATION M/ QUICKTIME PLAYER" *qt-wrapper-left*)
  *qt-wrapper-left*)


(defun guck ()
  "wifi ssh ver. <-> (guck-local)"
  (progn (shot-sym-down) 
	 (shot-revert-buffer "shot.png")
	 ;; (shot-resize-opticl)
	 ;; (sleep 0.2)
	 ;; (revert-buffer "shot-resize.png")
	 ))

;; kann genommen aus emacs variable werden. DONE
(defparameter *fringe-width* (swank:eval-in-emacs
			      '(car (window-fringes))))

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
	 *last-druck-point*))

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

(defun insert-log-emacs (msg color)
  "Insert x color msg at the end of buffer in the buffer qt-wrapper"
  (let ((wo (file-namestring *qt-wrapper-path*)))
    (swank:eval-in-emacs
     `(with-current-buffer ,wo
	(end-of-buffer)
	(insert (propertize ,msg 'font-lock-face '(:foreground ,color)))
	(newline)
	(end-of-buffer)))))


;;; TODO
(defun delete-log-emacs ()
  (let ((wo (file-namestring *qt-wrapper-path*)))
    (swank:eval-in-emacs
     `(with-current-buffer ,wo
	(end-of-buffer)
	(mark-paragraph)
;	(delete-region)
	(end-of-buffer)))))

(defun halbe (etwas-lst)
  "alle ele in list mit ratio, eigentlich nicht half machen, deswegen halbe"
  (mapcar (lambda (x) (* x *ratio*)) etwas-lst))


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
;; from emacs buffer kommt die datei hinzu *record-kiste*

(defparameter *record-kiste* nil)
(defparameter *record-status* nil)

(defun record-start ()
  (let ((msg "RECORD-START"))
    (progn (setf *record-status* t)
	   (insert-log-emacs msg "red")
	   (swank:eval-in-emacs
	    `(message "%s" ,msg))
)))

(defun record-stop ()
  (let ((msg "RECORD-STOP"))
    (progn (setf *record-status* nil)
	   (insert-log-emacs msg "blue")
	   (swank:eval-in-emacs
	    `(message "%s" ,msg))
	   (mach-fun-kiste-seq))))

(defun record-reset ()
  (let ((msg "*record-kiste* RESET"))
    (progn (setf *record-kiste* nil)
	   (insert-log-emacs msg "violet")
;	   (delete-log-emacs)
	   (swank:eval-in-emacs
	    '(message "*record-kiste* RESET")))))

(defun drag-passiert (lst)
  (let* ((start (nth 0 lst))
	 (end (nth 1 lst))
	 (delta (/ (- end start) 1000.0))
	 (convrted-poen (list  start
			       end
			       (* (nth 2 lst) *ratio*)
			       (* (nth 3 lst) *ratio*)
			       (* (nth 4 lst) *ratio*)
			       (* (nth 5 lst) *ratio*)
			       delta
			       ))
	 (msg (format nil "~A" convrted-poen)))
    (progn  (if *record-status* (progn
				  (push convrted-poen *record-kiste*)
				  (setf msg (concatenate 'string
							 msg
							 " <REC>"))))
	    (swipe (cddr convrted-poen))
	    (insert-log-emacs msg "darkcyan") ; debug
	    (swank:eval-in-emacs 
	     `(message "DRAG-passiert: %s " ,msg)))))


(defun  click-passiert (lst)
  "(ts ts x y)"
  (let* ((convrted-poen-lst (list (nth 0 lst)
				  (nth 1 lst)
				  (* (nth 2 lst) *ratio*) 
				  (* (nth 3 lst) *ratio*)))
	 (msg (format nil "~A" convrted-poen-lst)))			; ts
    (progn (if *record-status* (progn (push  convrted-poen-lst *record-kiste*)
				      (setf msg (concatenate 'string
							 msg
							 " <REC>"))))
	   (stouch (cddr convrted-poen-lst))	
	   (insert-log-emacs msg "darkblue")	; debug
	   (swank:eval-in-emacs
	    `(message "CLICK-passiert: %s" ,msg )))))


;; *record-kiste* zu *fun-kiste* conversion

(defparameter *fun-kiste* nil)
(defparameter *old-end* 0)

(defun fun-kiste-reset ()
  (setf *fun-kiste* nil
	*old-end* nil))

(defun mach-fun-kiste (lst-ele)
  (let* ((start (car lst-ele))
	 (end (cadr lst-ele ))
	 (zwsn (if *old-end* (/ (- start *old-end*) 1000.0)
		   0)))
    (setf *old-end* end)
    (progn  (push `(progn (sleep ,zwsn)
			  (stouch (list ,@(cddr lst-ele))))
		  *fun-kiste*))))

(defun mach-fun-kiste-seq ()
  (progn (fun-kiste-reset)
	 (mapcar #'mach-fun-kiste (reverse *record-kiste*))
	 *fun-kiste*))

(defun mach-mal ()
  (progn (swank:eval-in-emacs
	  '(message "mach-mal"))
	 (mapcar #'eval (reverse *fun-kiste*)))  )

;; *fun-kiste* manipulation
;; (PROGN (SLEEP 999) (STOUCH (LIST 64.5 323.5 151.5 312.5 999)))
(defun sleep-kontrol-ele (ele fun-x by-x)
  "(SLEEP 999) manipulate the 999 via fun-x by by-x"
  (setf #1=(nth 1 (nth 1 ele)) (funcall fun-x #1# by-x)))

(defun sleep-kontrol-seq (kiste fun-x by-x) 
  (mapcar (lambda(ele)(sleep-kontrol-ele ele fun-x by-x)) kiste))


(defun drag-kontrol-ele (ele fun-x by-x)
  "(LIST 0 0 0 0 999) manipulate the 999 via fun-x by by-x"
  (if #1=(nth 5 (nth 1(nth 2 ele)))
      (setf #1# (funcall fun-x #1# by-x))))

;;; TODO name? not seq -> list od. etwas, eigentlich seq ist string, vector
(defun drag-kontrol-seq (kiste fun-x by-x)
  "list verstion from drag-kontrol-ele"
  (mapcar (lambda (ele) (drag-kontrol-ele ele fun-x by-x)) kiste))

;;; save fun

(defun fun-kiste-symbol (qname)
  "current fun-kiste zu neue name symbolisieren. record-stop no need. during recording kann save."
  (progn (mach-fun-kiste-seq)
	 `(defparameter ,qname ',(copy-list *fun-kiste*))))


(defun fun-kiste-mod-symbol (qname)
  `(defparameter ,qname ',(copy-list (eval qname))))

(defun fun-kiste-set (name)
  "from current record-kiste defparameter, fuer saved kiste zu set, einfach (load *fun-kiste-path*) "
  (eval (fun-kiste-symbol name)))

(defparameter *fun-kiste-save-path*
  (merge-pathnames "fun-kiste-save.lisp" *working-dir*)
    "fuer neue save file setting, not defvar sondern defparameter")

;;; TODO als macro?
(defun fun-kiste-save (qkiste)
  (let* ((res (fun-kiste-symbol qkiste))
	 (msg (format nil "FUN-KISTE-SAVE ~s" (symbol-name qkiste))))
    (progn (with-open-file (out *fun-kiste-save-path* 
				:direction :output :if-exists :append)
	     (print res out)
	     (eval res)			; automatich defparameter
	     )
	   (insert-log-emacs msg "red")
	   (swank:eval-in-emacs
	    `(message "%s" ,msg)))))

(defun fun-kiste-mod-save (qkiste)
  (let* ((res (fun-kiste-mod-symbol qkiste))
	 (msg (format nil "FUN-KISTE-MOD-SAVE ~s" (symbol-name qkiste))))
    (progn (with-open-file (out *fun-kiste-save-path* 
				:direction :output :if-exists :append)
	     (print res out)
	     (eval res)			; automaticsh defparameter
	     )
	   (insert-log-emacs msg "red")
	   (swank:eval-in-emacs
	    `(message "%s" ,msg)))))

;; (format nil "(defparameter ~a ~a)" (symbol-name 'foo-2) foo-2)

(defun mach (kiste)
  "ok kiste! reverse y mapcar"
  (mapcar #'eval (reverse kiste)))

(defun m (kiste)
  "abkuerzung of #'mach"
  (mach kiste))

(defun sleep-null (kiste)
  (sleep-kontrol-seq kiste #'* 0))

(defun fun-kiste-save-load ()
  (load *fun-kiste-save-path*))

(defun back ()
  (mach *back*))

(defun ok ()
  (mach *ok*))

(defun up ()
  (mach *up*))

(defun down ()
  (mach *down*))

(defun up-1 ()
  (cmd "activator send com.rpetrich.superscroller.up"))

(defun down-1 ()
  (cmd "activator send com.rpetrich.superscroller.down"))

(defun bottom ()
  (cmd "activator send com.rthakrar.taptoscrollforactivator.bottom"))

(defun top ()
  (cmd "activator send com.rthakrar.taptoscrollforactivator.top"))

(defun middle ()
  (cmd "activator send com.rthakrar.taptoscrollforactivator.middle"))


;;

