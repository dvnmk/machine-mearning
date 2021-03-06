(in-package #:machine-mearning)

(defun iter-box-rvrs (x0 y0 dx dy x-times y-times)
  (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	(collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
		       (collect (list x y)))
	  at beginning))) 


(defun iter-box (x0 y0 dx dy x-times y-times)
  "make box array at x-y cordination"
  (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	(collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
		       (collect (list x y)))))) 

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

(defparameter *numpad-xy-map* (mach-numpad))

(defun wozu-nth-btn-numpad (x)
  (let ((row-0 (nth 0 *numpad-xy-map*))
	(row-1 (nth 1 *numpad-xy-map*))
	(row-2 (nth 2 *numpad-xy-map*))
	(row-3 (nth 3 *numpad-xy-map*))
	(row-4 (nth 4 *numpad-xy-map*)))
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

(defparameter *numpad-seq* "/1234567890!")

(defun touch-diese-char-numpad (char-x)
  (let* ((ori-xy (wozu-nth-btn-numpad (position char-x *numpad-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)))

(defun type-string-numpad (string-x)
  (mapcar #'touch-diese-char-numpad (coerce string-x 'list)))

;;
(defun loch-finden-citi ()
  "Specific PIXEL gucken y barf die (x y) im reihe, ohne blau (0 0 101) => (x y) btn list /o loch"
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
	(y-times 2)
	(dx-boxy 10)
	(dy-boxy 1)
	(qux (list 0 0 0)))
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (if (> (count-rgb-pixel qux `(,x ,y ,dx-boxy ,dy-boxy))
				0)
			     (collect (list x y))))
	    into r at beginning)
	  (finally (progn (push '((239 1088) (557 1088)) r)
			  (return (nreverse R)))))))


(defun loch-finden-bankpay ()
  (let ((x0 22)
	(y0 677)
	(dx 58)
	(dy 96)
	(x-times 10)
	(y-times 3)
	(dx-boxy 17)
	(dy-boxy 15)
	(quux (list 0 0 0)))
    (iter (for y from y0 to (+ y0 (* dy y-times)) by dy)
	  (collect (iter (for x from x0 to (+ x0 (* dx x-times)) by dx)
			 (if (> (count-rgb-pixel quux `(,x ,y ,dx-boxy ,dy-boxy))
				0)
			     (collect (list x y))))
	    into r at beginning)
	  (finally (progn (push '((555 1079)) r) ; "/"
			  (return (nreverse r)))))))

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
	 (row-3 (nth 3 *loch-gefunden-xy-map*))
	 (len-0 (length row-0))
	 (len-1 (length row-1))
	 (len-2 (length row-2))
)
    (cond ((< x len-0)			(nth x row-0))
	  ((< x #1=(+ len-0 len-1))	(nth (- x len-0) row-1))
	  ((< x #2=(+ #1# len-2))	(nth (- x #1#) row-2))
	  (t				(nth (- x #2#) row-3)))))


(defun wozu-nth-btn-bankpay (x)
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

;; ^ shift ! backspace $ change-keyboard? @ en-@ # spacebar / return
(defparameter *citi-key-seq* "1234567890qwertyuiopasdfghjkl^zxcvbnm!!$$@@####////")

(defparameter *secupad-key-seq* "1234567890!/")

(defparameter *bankpay-key-seq* "1234567890qwertyuiopasdfghjklzxcvbnm/")

(defun touch-diese-char-citi (char-x)
  (let* ((ori-xy (wozu-nth-btn-citi (position char-x *citi-key-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)))

(defun touch-diese-char-secupad (char-x)
  (let* ((ori-xy (wozu-nth-btn-secupad (position char-x *secupad-key-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (touch tar-xy)
    ;; TODO zwischen zeitraum ist es ok?
 ;   (sleep 0.2)
    ))

;;; TODO debug probe
(defun touch-diese-char-bankpay (char-x)
  (let* ((ori-xy (wozu-nth-btn-bankpay (position char-x *bankpay-key-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
   (touch tar-xy)
    ))

(defun type-string-citi (string-x)
  (mapcar #'touch-diese-char-citi (coerce string-x 'list)))

(defun type-string-secupad (string-x)
  (mapcar #'touch-diese-char-secupad (coerce string-x 'list)))

(defun type-string-bankpay (string-x)
  (mapcar #'touch-diese-char-bankpay (coerce string-x 'list)))

(defun crack-secupad ()
  (progn (shot-sym-down)
	 (shot-read)
	 (setf *loch-gefunden-xy-map* (loch-finden-secupad))))

(defun crack-citi ()
  (progn (shot-sym-down)
	 (shot-read)
	 (setf *loch-gefunden-xy-map* (loch-finden-citi))))

(defun crack-bankpay ()
  (progn (shot-sym-down)
	 (shot-read)
	 (setf *loch-gefunden-xy-map* (loch-finden-bankpay))))


;; enkey
;;; TODO append returns new list ist es ok? append ist expensive, sag der.
(defun mach-enkey ()
  "x0 y0 dx dy row col"  
  (let* ((row-0 (list 32 766 64 1 9 0))
	 (row-1 (list 64 874 64 1 8 0))
	 (row-2 (list 128 989 64 1 7 0))
	 (row-3 (list 38 1100 81 1 8 0))
	 (xy-0 (apply #'iter-box row-0))
	 (xy-1 (apply #'iter-box row-1))
	 (xy-2 (apply #'iter-box row-2))
	 (xy-3 (apply #'iter-box row-3)))
    (nconc xy-0 xy-1 xy-2 xy-3)))

(defparameter *enkey-xy-map* (mach-enkey))

;; TODO kali  m/ lezte row
;; ^ shift, ! bs $ num @ kbd #\spaceko spc / ok
;; TODO shift not included
(defparameter *enkey-seq* "qwertyuiopasdfghjklzxcvbnm!$@    ./")

(defun wozu-nth-btn-enkey (x)
  "nth btn => position (x y)"
  (let* ((row-0 (nth 0 *enkey-xy-map*))
	 (row-1 (nth 1 *enkey-xy-map*))
	 (row-2 (nth 2 *enkey-xy-map*))
	 (row-3 (nth 3 *enkey-xy-map*))
	 (len-0 (length row-0))
	 (len-1 (length row-1))
	 (len-2 (length row-2)))
    (cond ((< x len-0)			(nth x row-0))
	  ((< x #1=(+ len-0 len-1))	(nth (- x len-0) row-1))
	  ((< x #2=(+ #1# len-2))	(nth (- x #1#) row-2))
	  (t				(nth (- x #2#) row-3)))))


(defun touch-diese-char-enkey (char-x)
  (let* ((ori-xy (wozu-nth-btn-enkey (position char-x *enkey-seq*)))
	 (tar-xy (halbe ori-xy)))
    ;; (princ ori-xy)
    (stouch tar-xy)))

(defun type-string-enkey (string-x)
  (mapcar #'touch-diese-char-enkey (coerce string-x 'list)))

(defun crack-secupad-y-type (x)
  (progn (crack-secupad)
	 (type-string-secupad x)))

;;; TODO unbenutzte fun, gebraucht?
(defun crack-bankpay-y-type (x)
  (progn (crack-bankpay)
	 (type-string-bankpay x)))


(defun wie-viel-255 ()
  "wie viel pixel = 255 in boxy"
  (let ((x0 151) (y0 604)
	(w 25) (h 36)
	(dx 26) (dy 97)
	(color '(255 255 255)))
    (list
     (count-rgb-pixel color (list x0 y0 w h))
     (count-rgb-pixel color (list (+ x0 dx) y0 w h))
     (count-rgb-pixel color (list x0 (+ y0 dy) w h))
     (count-rgb-pixel color (list (+ x0 dx) (+ y0 dy) w h)))))


;; (defun wie-viel-<55 ()
;;   "accumulate pixel < 55 in boxy"
;;   (let ((x0 220)
;; 	(y0 828)
;; 	(w 17)
;; 	(h 28)
;; 	(dx 17)
;; 	(dy 78)
;; 	(color '(55 55 55)))
;;     (list
;;      (count-rgb-pixel< color (list x0 y0 w h))
;;      (count-rgb-pixel< color (list (+ x0 dx) y0 w h))
;;      (count-rgb-pixel< color (list x0 (+ y0 dy) w h))
;;      (count-rgb-pixel< color (list (+ x0 dx) (+ y0 dy) w h)))))
 
;; TODO DYNAMIC SCOPING BENUTZUNG
(defun wie-viel-<55-in-x (x) 
  (let ((*shot-path* (merge-pathnames (format nil "shot~a.png" x)
				      *working-dir*)))
    (shot-read)
    (wie-viel-55)))

(defun wie-viel-255-in-x (x) 
  (let ((*shot-path* (merge-pathnames (format nil "shot~a.png" x)
				      *working-dir*)))
    (shot-read)
    (wie-viel-255)))

;;2528 2209 0301 2409 1406

;;; TODO alist plist substitute etc? array?!
;; (defparameter *pin-seq* (list 68 87 90 94 80 102 58 107 100 101))

;; (defparameter *pin-seq* '((68 . 1) (87 . 2) (90 . 3) (94 . 4) (80 . 5)
;; 			  (102 . 6) (58 . 7) (107 . 8) (100 . 9) (101 . 0)))

;; scanned-boxy-pixel gefunden
;; < 55
;; +---+---+---+---+---+---+---+---+----+----+
;; |1  |2  |3  |4  |5  |6  |7  |8  |9   |0   |
;; +---+---+---+---+---+---+---+---+----+----+
;; |68 |87 |90 | 94|80 |102|58 |107| 100|101 |
;; +---+---+---+---+---+---+---+---+----+----+


;; (defparameter *pin-seq* (list 232 2 349 338 5 6 7 8 9 403))

(defparameter *pin-seq* '((232 . 1) (360 . 2) (349 . 3) (338 . 4) (369 . 5)
			  (400 . 6) (267 . 7) (417 . 8) (399 . 9) (403 . 0)))

;; scanned-boxy-pixel gefunden
;; = 255
;; +---+---+---+---+---+---+---+---+---+---+
;; |1  |2  |3  |4  |5  |6  |7  |8  |9  |0  |
;; +---+---+---+---+---+---+---+---+---+---+
;; |232|360|349|338|369|400|267|417|399|403|
;; +---+---+---+---+---+---+---+---+---+---+

(defun que-pin (bank-slot lst)
  "query pin of bank-slot durch geheim, lst ist wie (24 09) "
  (let*  ((x (car lst))
	  (y (cadr lst))
	  (pin0 (nth x bank-slot))
	  (pin1 (nth y bank-slot)))
    (list (format nil "~2,'0d" (first pin0))
	  (format nil "~d" (second pin1)))))

(defun finde-auf-pin-seq (lst)
  "find die nummer auf pin-seq from wie-viel-255"
  (mapcar (lambda (x) (cdr (assoc x *pin-seq*)))
	  lst))

(defun parse-list4-list2 (lst)
  "(2 4 0 9) => (24 09)"
  (let* ((a0 (format nil "~d" (nth 0 lst)))
	 (a1 (format nil "~d" (nth 1 lst)))
	 (b0 (format nil "~d" (nth 2 lst)))
	 (b1 (format nil "~d" (nth 3 lst)))
	 (res (list (concatenate 'string a0 a1) (concatenate 'string b0 b1))))
    (format t "~a ; OCR-gt" res)
    (mapcar #'parse-integer res)))

(defparameter *gefunden-pin* nil)

;; (que-pin *sh* (parse-list4-list2 (finde-auf-pin-seq (wie-viel-55))))

(defun crack-pin (bank-slot)
  "=> pin code, um zu getyped werden"
  (progn
    (shot-sym-down)
    (shot-read)
    (setf *gefunden-pin* (que-pin bank-slot (parse-list4-list2
					     (finde-auf-pin-seq (wie-viel-255)))))))

;; (crack-secupad-y-type *gefunden-pin*)

