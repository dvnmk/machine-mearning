;; key.lisp keyboard reader
(defun mach-numpad ()
  "normal no security pad , (nil nil ok 1 2 3 4 5 6 7 8 nil 0 backspace)"
  (let ((x0 99)
	(y0 668)
	(dx 221)
	(dy 106)
	(x-times 2)
	(y-times 4))
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (collect (list x y)))))))

(defparameter *numpad-xy-map* (mach-num-pad))

(defun wozu-nth-btn-numpad (x)
  (let ((row-0 (nth 0 *num-pad-xy-map*))
	(row-1 (nth 1 *num-pad-xy-map*))
	(row-2 (nth 2 *num-pad-xy-map*))
	(row-3 (nth 3 *num-pad-xy-map*))
	(row-4 (nth 4 *num-pad-xy-map*)))
    (case x
      (0 (nth 2 row-0)) ; confirm
      (1 (nth 0 row-1))
      (2 (nth 1 row-1))
      (3 (nth 2 row-1))
      (4 (nth 0 row-2))
      (5 (nth 1 row-2))
      (6 (nth 2 row-2))
      (7 (nth 0 row-3))
      (8 (nth 1 row-3))
      (9 (nth 2 row-3))
      (10 (nth 1 row-4)) ; nummer null
      (11 (nth 2 row-4)) ; backspace
      )))

(defparameter *numpad-seq* "#1234567890!")

(defun touch-diese-char-numpad (char-x)
  (let* ((ori-xy (wozu-nth-btn-numpad (position char-x *numpad-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)))

(defun type-string-numpad (string-x)
  (mapcar #'touch-diese-char-numpad (coerce string-x 'list)))

;;
(defun loch-finden-citi ()
  "Specific pixel gucken y barf die (x y) im reihe, ohne blau (0 0 101) => (x y) btn list /o loch"
  (let ((x0 38)
	(y0 700)
	(dx 58)
	(dy 96)
	(x-times 10)
	(y-times 4)
	(quux (list 0 0 101)))
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (unless (equal (opticl:pixel* *shot-img* y x) quux)
			   (collect (list x y))))))))


(defun loch-finden-secupad ()
  (let ((x0 80)
	(y0 806)
	(dx 159)
	(dy 94)
	(x-times 3)
	(y-times 3)
	(rgb (list 0 0 0))
	(dx-boxy 10)
	(dy-boxy 10)
	)
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (if (> (count-rgb-pixel rgb `(,x ,y ,dx-boxy ,dy-boxy))
				0)
			   (collect (list x y))))))))


(defparameter *loch-gefunden-xy-map* nil)

(defun wozu-nth-btn-citi (x)
  "nth btn => position (x y)"
  (let* ((row-0 (nth 0 *loch-gefunden-xy-map*))
	 (row-1 (nth 1 *loch-gefunden-xy-map*))
	 (row-2 (nth 2 *loch-gefunden-xy-map*))
	 (row-3 (nth 3 *loch-gefunden-xy-map*))
	 (row-4 (nth 4 *loch-gefunden-xy-map*))
	 (len-0 (length row-0))
	 (len-1 (length row-1))
	 (len-2 (length row-2))
	 (len-3 (length row-3)))
    (cond ((< x len-0)			(nth x row-0))
	  ((< x #1=(+ len-0 len-1))	(nth (- x len-0) row-1))
	  ((< x #2=(+ #1# len-2))	(nth (- x #1#) row-2))
	  ((< x #3=(+ #2# len-3))	(nth (- x #2#) row-3))
	  (t				(nth (- x #3#) row-4)))))

(defun wozu-nth-btn-secupad (x)
  "nth btn => position (x y)"
  (let* ((row-0 (nth 0 *loch-gefunden-xy-map*))
	 (row-1 (nth 1 *loch-gefunden-xy-map*))
	 (row-2 (nth 2 *loch-gefunden-xy-map*))
	 (len-0 (length row-0))
	 (len-1 (length row-1)))
    (cond ((< x len-0)			(nth x row-0))
	  ((< x #1=(+ len-0 len-1))	(nth (- x len-0) row-1))
	  (t				(nth (- x #1#) row-2)))))

;; ^ shift 
;; !! backspace 
;; $ change-keyboard? 
;; @ en-@
;; #### spacebar
;; //// return
(defparameter *citi-key-seq* "1234567890qwertyuiopasdfghjkl^zxcvbnm!!$$@@####////")
(defparameter *secupad-key-seq* "1234567890!!//")

(defun touch-diese-char-citi (char-x)
  (let* ((ori-xy (wozu-nth-btn-citi (position char-x *citi-key-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)))

(defun touch-diese-char-secupad (char-x)
  (let* ((ori-xy (wozu-nth-btn-secupad (position char-x *secupad-key-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)))


(defun type-string-citi (string-x)
  (mapcar #'touch-diese-char-citi (coerce string-x 'list)))

(defun type-string-secupad (string-x)
  (mapcar #'touch-diese-char-secupad (coerce string-x 'list)))


