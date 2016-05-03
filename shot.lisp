(in-package #:machine-mearning)

;; TODO
;; (eval-when (:compile-toplevel)
;;   (setf *default-pathname-defaults* *compile-file-truename*))

;; TODO 
;; (setf *default-pathname-defaults* *load-truename*)

;; (defparameter *working-dir* (make-pathname :defaults *load-truename*
;; 				   :type nil
;; 				   :name nil
;; 				   :version nil))

(defparameter *working-dir* 
  #P"/Users/dvnmk/quicklisp/local-projects/machine-mearning/")

(defparameter *shot-path*
  (merge-pathnames "shot.png" *working-dir*))

(defparameter *shot-resize-path*
  (merge-pathnames "shot-resize.png" *working-dir*))

(defparameter *remote-file*
  "mobile@localhost:/var/mobile/Media/DCIM/100APPLE/shot.png")

;; TODO (declaim)
;; (declaim (type opticl:8-bit-rgb-image *shot-img*)) ; TODO
(defparameter *shot-img* nil)


;; pathname TODO
(defun shot-symlink ()
  "Make symbolic link of newest made file."
  (cmd "ln -fs $(ls -rt1 /var/mobile/Media/DCIM/100APPLE |tail -1) /var/mobile/Media/DCIM/100APPLE/shot.png"))

;; pathname TODO
(defun shot-down ()
  (external-program:run "rsync"
		   `("-v" "-e ssh \'-p 2000\'" "-L"
		     ;; "--progress"
		     ,*remote-file*
		     ,(directory-namestring *working-dir*))
		   :wait t :output t))

(defun shot-sym-down ()
  (progn
    (shot-shot)
    (sleep 0.5)
    (shot-symlink)
    (sleep 0.8)
    (shot-down)
;;    (sleep 0.6)
    ;; (setf *shot-img* (opticl:read-png-file *shot-path*)) ; zusammen in (progn) ist slow, als getrennt.
    '(shot-read)    ))

(defun shot-read ()
  (declare (optimize (speed 3) (safety 0)))
  (setf *shot-img* (opticl:read-png-file *shot-path*))
  '*shot-img*)


(defun que-shot-size ()
  "que ist die width y height of shot-img"
  (opticl:with-image-bounds (height width)  *shot-img*
    (list height width)))

(defun que-shot-ratio ()
  (let ((tmp (que-shot-size)))
    (/ (car tmp) (cadr tmp) 1.0)))

(defun shot-resize-imagick ()
  (external-program:run "convert"
		   `(,(namestring *shot-path*)  "-resize" "320x568" 
		      ,(namestring *shot-resize-path*))
		   :wait t :output t))

(defun shot-resize-opticl ()
  (declare (optimize (speed 3) (safety 0)))
  (let ((img (opticl:resize-image *shot-img* 568 320)))
    (declare (type opticl:8-bit-rgb-image img))
    (opticl:write-png-file *shot-resize-path*  img)))


;; boxy scanner

(defun count-rgb-pixel (list-rgb boxy)
  "Wie viel rgb-pixel in boxy, x0 y0 w h?"
  (let* ((x0 (car boxy))
	 (y0 (cadr boxy))
	 (w (caddr boxy))
	 (h (cadddr boxy))
	 (x1 (+ x0 w))
	 (y1 (+ y0 h)))
    (iter (for x from x0 to x1)
	  (sum (iter (for y from y0 to y1)
		     (counting (equalp  (opticl:pixel* *shot-img* y x) list-rgb)))))))


(defun count-rgb-pixel< (list-rgb boxy)
  "Wie viel rgb-pixel in boxy, x0 y0 w h? < version. only car of list-rgb is vergliechable. this fun is needed weil, + version kann nicht so unterschiedlichen farbe barfen."
  (let* ((x0 (car boxy))
	 (y0 (cadr boxy))
	 (w (caddr boxy))
	 (h (cadddr boxy))
	 (x1 (+ x0 w))
	 (y1 (+ y0 h)))
    (iter (for x from x0 to x1)
	  (sum (iter (for y from y0 to y1)
		     (counting (<  (car (opticl:pixel* *shot-img* y x)) (car list-rgb))))))))

