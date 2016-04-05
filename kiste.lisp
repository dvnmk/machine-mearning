;; kiste.lisp
;; unbenutzte pun funz

(defun que-winid-qt ()
  "que ist die window id of app quicktime player"
  (let ((tmp0 (with-output-to-string (out)
		(let ((tmp (format nil "tell app \"QuickTime Player\" to id of window 1")))
		  (external-program:run "osascript" 
				   `("-e" ,tmp) :output out)))))
   tmp0))

(defun shot-local ()
  "screenshot from quicktime player, save to *shot-path*"
  (let ((winid (format nil "-l~a" (que-winid-qt))))
		       (external-program:run "screencapture"
					`(,winid "-o" ,(namestring *shot-path*)) :output t)))

(defun guck-local ()
  "shot-local y m-m/revert-buffer shot.png"
  (progn (shot-local)
	 (m-m/revert-buffer (file-namestring *shot-path*))))

(defun guck-read-que-local ()
  (progn (guck-local)
	 (shot-read)
	 (que-shot-size)))

(defun loch-finden-secupad ()
  (let ((x0 22)
	(y0 806)
	(dx 159)
	(dy 94)
	(x-times 3)
	(y-times 3)
	(dx-boxy 70)
	(dy-boxy 2)
	(qux (list 0 0 0))
	(quux (list 255 255 255))
			   )
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (if (or 
			      (> (count-rgb-pixel qux `(,x ,y ,dx-boxy ,dy-boxy))
				0)
			      (> (count-rgb-pixel quux `(,x ,y ,dx-boxy ,dy-boxy))
				0))
			     (collect (list x y))))))))

;; gist

(iter 	       
  (for x from 0 to 5)
  (collecting x into r)
  (finally (progn (push 'wu r)
		  (return (nreverse r)))))

(defun iter-box ()
    (let ((x0 80)
       (y0 806)
       (dx 159)
       (dy 94)
       (x-times 3)
       (y-times 3))
   (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	 (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			(collect (list x y)))))))
