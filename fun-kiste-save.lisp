(DEFPARAMETER *ok* '((PROGN (SLEEP 0) (STOUCH (LIST 160.0 331.5)))))

(DEFPARAMETER *BACK* '((PROGN (SLEEP 0) (STOUCH (LIST 22.5 40.5)))))

(DEFPARAMETER *DOWN*
  '((PROGN (SLEEP 0) (STOUCH (LIST 151.0 568.0 152.0 0.0 0.1)))))

(DEFPARAMETER *UP*
  '((PROGN (SLEEP 0) (STOUCH (LIST 151.0 150.0 152.0 500.0 0.1)))))


(defun back ()
  (mach *back*))

(defun ok ()
  (mach *ok*))

(defun up ()
  (mach *up*))

(defun down ()
  (mach *down*))


(DEFPARAMETER *SELECT-ORDER*
  '((PROGN (SLEEP 1) (STOUCH (LIST 63.5 498.5)))
    (PROGN (SLEEP 1) (STOUCH (LIST 31.5 176.0)))
    (PROGN (SLEEP 2.4) (STOUCH (LIST 22.5 122.5)))
    (PROGN (SLEEP 0) (STOUCH (LIST 297.0 41.0)))))

(DEFPARAMETER *paymethode*
  '((PROGN (SLEEP 2) (STOUCH (LIST 161.0 416.0)))
    (PROGN (SLEEP 1) (STOUCH (LIST 162.0 469.5)))
    (PROGN (SLEEP 1) (STOUCH (LIST 26.5 411.5)))
    (PROGN (SLEEP 1.4) (STOUCH (LIST 157.5 396.0)))
    (PROGN (SLEEP 2.4) (STOUCH (LIST 241.0 131.0)))

    (PROGN (SLEEP 0.8) (STOUCH (LIST 234.5 95.0)))
    (progn (sleep 2.4) (bottom))
    (PROGN (SLEEP 0.7) (STOUCH (LIST 237.0 279.5)))
    (PROGN (SLEEP 0.5) (STOUCH (LIST 35.0 212.0)))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 33.5 173.5)))

    (PROGN (SLEEP 0.8) (STOUCH (LIST 248.5 119.0)))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 52.5 68.5)))
    (PROGN (SLEEP 0.7) (up-1))
    (PROGN (SLEEP 0) (bottom))))

;; TODO roller-selector fun?
(defparameter *bank-select-sh*
  '((progn (sleep 0.4) (stouch (list 281.0 402.0)))
    (progn (sleep 0.4) (stouch (list 161.0 532.5)))
    (progn (sleep 1.4) (stouch (list 161.0 554.5)))
    (progn (sleep 0.6) (stouch (list  164.5 445.5 159.0 548.5  0.2)))
    (progn (sleep 0.6) (stouch (list  164.5 445.5 159.0 548.5  0.2)))
    (progn (sleep 0) (stouch (list 200.5 193.5)))))

(defparameter *bank-select-ha*
  '((progn (sleep 0.4) (stouch (list 282.0 400.5)))
    (progn (sleep 0.4) (stouch (list 158.5 484.5)))
    (progn (sleep 1.4) (stouch (list 158.5 484.5)))
    (progn (sleep 0.6) (stouch (list  164.5 548.5 159.0 445.5 0.2)))
    (progn (sleep 0.6) (stouch (list  164.5 548.5 159.0 445.5 0.2)))
    (progn (sleep 0) (stouch (list 200.5 193.5)))))

(DEFPARAMETER *konto-nu-SH*
  '((progn (sleep 1) (type-string-secupad (concatenate 'string *my-sh* "/")) )
    (progn (sleep 3) (crack-secupad))
    (PROGN (SLEEP 1.4) (STOUCH (LIST 165.0 133.0)))
    (progn (sleep 0) (bottom))))

(DEFPARAMETER *konto-nu-ha*
  '((progn (sleep 1) (type-string-secupad (concatenate 'string *my-ha* "/")) )
    (progn (sleep 1.6) (crack-secupad))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 165.0 133.0)))
    (progn (sleep 0) (bottom))
    ))

(DEFPARAMETER *KONTO-PIN*
  '((progn (sleep 0.8) (type-string-secupad (concatenate 'string *my-konto-pin* "/")))
    (progn (sleep 1.2) (crack-secupad))
    (PROGN (SLEEP 0) (STOUCH (LIST 152.0 166.5)))    ))

(defparameter *enkey-lang-ko*
  '((progn (sleep 0) (stouch (list 60.0 543.0 63.5 447.0 0.3)))))


(defparameter *enkey-lang-en*
  '((progn (sleep 0) (stouch (list 66.5 546.5 62.5 509.5 0.2)))))

(defparameter *konto-haber*
  '((progn (sleep 1.2) (type-string-enkey "qkrahrdud/"))
    (progn (sleep 1.2) (m *enkey-lang-ko*))
    (progn (sleep 0) (stouch (list 191.0 203.5)))))

(DEFPARAMETER *MIN-NUM*
  '((progn (sleep 0.6) (type-string-secupad (concatenate 'string (cadr *my-min*) "/")))
    (progn (sleep 2.2) (crack-secupad))
    (progn (sleep 0.6) (type-string-secupad (concatenate 'string (car *my-min*) "/")))
    (progn (sleep 1.2) (crack-secupad))
    (PROGN (SLEEP 0.2) (STOUCH (LIST 152.5 303.5))))) 

(defparameter *fill-sh*
  '((progn (sleep 2) (stouch (list 157.5 429.5)))
    (progn (sleep 1.8) (m *min-num*))
    (progn (sleep 2) (m *konto-haber*))
    (progn (sleep 4) (m *konto-pin*))
    (progn (sleep 3.4) (m *konto-nu-sh*))
    (progn (sleep 0) (m *bank-select-sh*))))

(defparameter *select-secucard*
  '((progn (sleep 0.8) (stouch (list 220.5 163.0)))
    (progn (sleep 0.8) (stouch (list 281.5 406.5)))
    (progn (sleep 0.8) (stouch (list 164.0 529.0)))
    (progn (sleep 0.8)(stouch (list 187.0 121.0)))))

(DEFPARAMETER *PIN-sh*
  '((progn (sleep 1) (stouch (list 219.5 212.5)))
    (progn (sleep 0.4) (stouch (list 221.0 211.0)))
    (progn (sleep 0.2) (type-string-secupad (concatenate 'string *my-sh-pin* "/")))
    (PROGN (SLEEP 0.8) (crack-secupad))
    (progn (sleep 0) (m *select-secucard*))))

(DEFPARAMETER *pin-ha*
  '((progn (sleep 1) (stouch (list 219.5 212.5)))
    (progn (sleep 0.4) (stouch (list 221.0 211.0)))
    (progn (sleep 0.2) (type-string-secupad (concatenate 'string *my-ha-pin* "/")))
    (PROGN (SLEEP 0.8) (crack-secupad))
    (progn (sleep 0) (m *select-secucard*)))  )


;; secucard cracking kiste
(DEFPARAMETER *crack-pin-sh*
  '(
    (progn (sleep 1) (stouch (list 165.5 127.5)))
    (progn (sleep 1) (stouch (list 163.0 135.5)))
    (progn (sleep 1) (stouch (list 94.5 318.5)))
    (progn (sleep 0.5) (type-string-numpad (cadr *gefunden-pin*)))
    (progn (sleep 0.5) (stouch (list 216.0 283.5)))
    (progn (sleep 0.5) (type-string-numpad (car *gefunden-pin*)))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 150.5 310.5)))
    (progn (sleep 0) (crack-pin *sh*))))



(DEFPARAMETER *pay-confirm*
  '((progn (sleep 3) (m *ok*))
    (progn (sleep 3) (stouch (list 163.5 222.0)))
    (progn (sleep 0) (type-string-bankpay (concatenate 'string
						       *confirm-code*
						       "/")))
    (progn (sleep 1.2) (crack-bankpay))
    (progn (sleep 0) (stouch (list  161.5 128.5)))
    ))
 

;;; SYNOPSIS - SZENE BASED
;; (11st)
;; #1
;; (m *select-order*)
;; #2
;; (m *paymethode*)
;; #3
;; (m *fill-sh*)
;;;; (m *fill-ha*)

;; (m *pin-sh*)
;;;; (m *pin-ha*)
;; (m *crack-pin-sh*)
;; (m *crack-pin-ha*)
;; (m *pay-confirm*)

(defparameter *venga*
  '((progn (sleep 2) (shot-sym-down))
    (progn (sleep 22) (m *abbrechen*))
    (progn (sleep 2) (m *pay-confirm*))
    (progn (sleep 2.4) (m *crack-pin-sh*))
    (progn (sleep 2) (m *pin-sh*))
    (progn (sleep 4) (m *fill-sh*))
    (progn (sleep 3) (m *paymethode*))
    (progn (sleep 0) (m *select-order*))))

(DEFPARAMETER *ZURUCK*
  '((PROGN (SLEEP 2.489) (STOUCH (LIST 239.5 330.0)))
    (PROGN (SLEEP 2.571) (STOUCH (LIST 33.0 341.5)))
    (PROGN (SLEEP 4.77) (STOUCH (LIST 237.0 540.0)))
    (PROGN (SLEEP 2) (STOUCH (LIST 54.0 393.0)))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 153.5 96.0)))
    (progn (sleep 0) (bottom))    )) 

(DEFPARAMETER *FOO*
  '((PROGN (SLEEP 5.152) (STOUCH (LIST 163.5 315.5)))
    (PROGN (SLEEP 2.755) (STOUCH (LIST 153.0 427.0)))
    (PROGN (SLEEP 6.605) (STOUCH (LIST 79.0 527.5 91.5 306.0 0.715)))
    (PROGN (SLEEP 3.234) (STOUCH (LIST 79.5 527.0)))
    (PROGN (SLEEP 1.447) (STOUCH (LIST 91.0 476.0)))
    (PROGN (SLEEP 1.838) (STOUCH (LIST 90.0 423.0)))
    (PROGN (SLEEP 8.421) (STOUCH (LIST 93.0 391.5)))
    (PROGN (SLEEP 1.246) (STOUCH (LIST 186.5 169.5)))
    (PROGN (SLEEP 1.59) (STOUCH (LIST 161.5 316.5)))
    (PROGN (SLEEP 2.452) (STOUCH (LIST 266.0 175.0)))
    (PROGN (SLEEP 0.486) (STOUCH (LIST 257.5 498.5)))
    (PROGN (SLEEP 3.534) (STOUCH (LIST 257.5 498.0)))
    (PROGN (SLEEP 2.168) (STOUCH (LIST 174.5 356.5)))
    (PROGN (SLEEP 3.066) (STOUCH (LIST 278.5 401.5)))
    (PROGN (SLEEP 2.112) (STOUCH (LIST 165.5 556.5 166.0 508.5 0.624)))
    (PROGN (SLEEP 5.348) (STOUCH (LIST 168.0 550.5 171.5 512.0 0.7)))
    (PROGN (SLEEP 0) (STOUCH (LIST 207.0 195.5))))) 

(DEFPARAMETER *ABBRECHEN*
  '((PROGN (SLEEP 3.4) (STOUCH (LIST 160.5 323.5)))
    (PROGN (SLEEP 1.8) (STOUCH (LIST 227.5 322.5)))
    (PROGN (SLEEP 1.8) (STOUCH (LIST 242.0 432.0)))
    (PROGN (SLEEP 1.8) (STOUCH (LIST 288.5 328.5)))
    (PROGN (SLEEP 1.8) (STOUCH (LIST 166.5 494.0)))
    (PROGN (SLEEP 4) (STOUCH (LIST 196.5 320)))
    (PROGN (SLEEP 1.2) (STOUCH (LIST 261.0 385)))
    (PROGN (SLEEP 1) (STOUCH (LIST 276.0 354.5 258.5 179.0 1)))
    (progn (sleep 1.2)(stouch (list 289.0 328.0)))
    (progn (sleep 1.2) (stouch (list 160.5 515.0)))
    (progn (sleep 2.2) (stouch (list 221.0 236.5)))
    (PROGN (SLEEP 3) (STOUCH (LIST 162.5 139.5)))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 25.5 43.0)))
    (PROGN (SLEEP 0) (STOUCH (LIST 297.0 40.0)))
)) 


(DEFPARAMETER *ARM*
  '((PROGN (SLEEP 1.2) (STOUCH (LIST 230.0 326.5)))
    (PROGN (SLEEP 1) (STOUCH (LIST 305.5 107.5)))
    (PROGN (SLEEP 1) (STOUCH (LIST 304.5 142.5)))
    (PROGN (SLEEP 5) (STOUCH (LIST 163.0 472.5)))
    (PROGN (SLEEP 1) (STOUCH (LIST 166.0 148.5)))
    (progn (sleep 1) (bottom))
    (PROGN (SLEEP 1) (STOUCH (LIST 288.5 112.0)))
    (progn (sleep 0) (bottom)))) 
