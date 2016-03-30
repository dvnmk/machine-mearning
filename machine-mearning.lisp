;;;; machine-mearning.lisp

(in-package #:machine-mearning)

;;; "machine-mearning" goes here. Hacks and glory await!

(defparameter *ssh* nil)
(defparameter *shot-image* nil)

(defparameter *working-dir* 
  #P"/Users/dvnmk/quicklisp/local-projects/machine-mearning/")

(defparameter *shot-path*
  (merge-pathnames "shot.png" *working-dir*))

(defparameter *shot-resize-path*
  (merge-pathnames "shot-resize.png" *working-dir*))

(defparameter *remote-file*
  "mobile@localhost:/var/mobile/Media/DCIM/100APPLE/shot.png")

;; (defparameter *shot* (make-pathname
;; 		      :directory *working-dir*
;; 		      :name "shot"
;; 		      :type "png"))



(defparameter *ssh-in* nil)

(defun connect ()
  (progn
    (defparameter *ssh* (ccl:run-program "ssh"
					'("-t" "-t" "mobile@localhost" "-p" "2000")
					:output t :input :stream :wait nil
					:sharing :external))
    (defparameter *ssh-in* (ccl:external-process-input-stream *ssh*))))

(defun disconnect ()
  (ccl:signal-external-process *ssh* 9))

(defun cmd (cmd)
  (progn (format *ssh-in* "~D~%" cmd)
	 (finish-output *ssh-in*)))
 
(defun swipe (x1 y1 x2 y2 dura)
  (let ((cmd (format nil "stouch swipe ~S ~S ~S ~S ~S" x1 y1 x2 y2 dura)))
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

;; (with-open-file (in "/tmp/quux")
;; 	   (loop for line = (read-line in nil)
;; 	      until (equal line "iphn:~ mobile$ ")
;; 		do (format t "wu~%")))

;; pathname TODO
(defun shot-shot ()
  (cmd "activator send libactivator.system.take-screenshot"))

;; pathname TODO
(defun shot-symlink ()
  "Make symbolic link of newest made file."
  (cmd "ln -fs $(ls -rt1 /var/mobile/Media/DCIM/100APPLE |tail -1) /var/mobile/Media/DCIM/100APPLE/shot.png"))

;; pathname TODO
(defun shot-down ()
  (ccl:run-program "rsync"
		   `("-v" "-e ssh \'-p 2000\'" "-L"
		     ;; "--progress"
		     ,*remote-file*
		     ,(directory-namestring *working-dir*))
		   :wait t :output t))

(defun shot-sym-down ()
  (progn
    (shot-shot)
    (sleep 0.7)
    (shot-symlink)
    (sleep 0.5)
    (shot-down)
    (setf *shot-image* (opticl:read-png-file *shot-path*))
    (typecase *shot-image*
      (opticl:8-bit-rgb-image
       (locally  
    	   (declare (type opticl:8-bit-rgb-image *shot-image*)))))
    ))

(defun shot-resize-imagick ()
  (ccl:run-program "convert"
		   `(,(namestring *shot-path*)  "-resize" "320x568" 
		      ,(namestring *shot-resize-path*))
		   :wait t :output t))

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
   `(defun setup-weiter ()
     ;; (setq *win* (get-buffer-window "qt-wrapper"))
     (setq window-resize-pixelwise t)
     (setq fit-window-to-buffer-horizontally t)
     (progn
       (switch-to-buffer "qt-wrapper")
       (switch-to-buffer ,shot-filename)   ; unless buffer TODO
       (fit-window-to-buffer)
       (window-pixel-left *win*)))))

(let ((path (namestring *qt-wrapper-path*)))
  (swank:eval-in-emacs
   `(defun setup-qt-wrapper ()
      (let ((que (get-buffer-window "qt-wrapper")))
	(if que (progn (setq *win* que)
		       (setup-weiter))
	    (progn (find-file ,path)
		   (setup-qt-wrapper)))))))

(defun que-qt-wrapper-left ()
  (setq *qt-wrapper-left* (swank:eval-in-emacs '(setup-qt-wrapper)))
  (format t "*QT-WRAPPER-LEFT*: ~d, DEM NACHST, KALIBRATION M/ QUICKTIME PLAYER" *qt-wrapper-left*)
  *qt-wrapper-left*)


(defun shot-resize-opticl ()
  (let ((img (opticl:resize-image *shot-image* 568 320)))
    (typecase img
      (opticl:8-bit-rgb-image
       (locally
	   (declare (type )))))
    (opticl:write-png-file *shot-resize-path*  img)))

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

(defun conv-mouse-pos ()
  "convert the nimm-mouse-pos-gt value im verzueglich mit window"
  (let* ((i (nimm-mouse-pos))
	 (x (* (- (car i) *qt-wrapper-left* *fringe-width*)
	       *ratio*))
	 (y (* (cdr i) *ratio*)))
    (list x y)))

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

(defparameter *kiste* '())

(defun qt-run ()
  "venga quicktime player fue die iphone screen sharing"
  (ccl:run-program "open" '("-a" "QuickTime Player") :wait nil :output t))

(defun qt-kill ()
  "quicktime player no mas"
  (with-output-to-string (out)
    (ccl:run-program "killall"
		     '("QuickTime Player")
		     :output out)))

(defun que-winid-qt ()
  "que ist die window id of app quicktime player"
  (let ((tmp0 (with-output-to-string (out)
		(let ((tmp (format nil "tell app \"QuickTime Player\" to id of window 1")))
		  (ccl:run-program "osascript" 
				   `("-e" ,tmp) :output out)))))
   tmp0))

(defun shot-local ()
  "screenshot from quicktime player, save to *shot-path*"
  (let ((winid (format nil "-l~a" (que-winid-qt))))
		       (ccl:run-program "screencapture"
					`(,winid "-o" ,(namestring *shot-path*)) :output t)))

(defun guck-local ()
  "shot-local y m-m/revert-buffer shot.png"
  (progn (shot-local)
	 (m-m/revert-buffer (file-namestring *shot-path*))))

;; TODO setf od. setq
(defun read-shot-img ()
  (setq *shot-image* (opticl:read-png-file *shot-path*))
  ;; 'read-shot-img
  (format t "> (read-shot-img)-gt"))

(defun que-shot-size ()
  "que ist die width y height of shot-img"
  (opticl:with-image-bounds (height width)  *shot-image*
    (list height width)))

(defun que-shot-ratio ()
  (let ((tmp (que-shot-size)))
    (/ (car tmp) (cadr tmp) 1.0)))

(defun guck-read-que-local ()
  (progn (guck-local)
	 (read-shot-img)
	 (que-shot-size)))

(defvar *el-path* (merge-pathnames "machine-mearning-mode.el" *working-dir*))
(swank:eval-in-emacs `(load ,(namestring *el-path*)))

(defun licht- ()
  (cmd "activator send libactivator.screen.brightness.decrease"))

(defun licht+ ()
  (cmd "activator send libactivator.screen.brightness.increase"))
