(DEFPARAMETER *BACK* '((PROGN (SLEEP 0) (STOUCH (LIST 22.5 40.5)))))

(DEFPARAMETER *DOWN*
  '((PROGN (SLEEP 0) (STOUCH (LIST 151.0 568.0 152.0 0.0 0.1)))))

(DEFPARAMETER *UP*
  '((PROGN (SLEEP 0) (STOUCH (LIST 151.0 150.0 152.0 500.0 0.1)))))

(DEFPARAMETER *SELECT-ORDER*
  '((PROGN (SLEEP 1) (STOUCH (LIST 239.5 533.0)))
    (PROGN (SLEEP 1) (STOUCH (LIST 29.0 230.5)))
    (PROGN (SLEEP 1.8) (STOUCH (LIST 26.0 85.0)))
    (PROGN (SLEEP 0) (STOUCH (LIST 251.5 41.0)))))

(DEFPARAMETER *paymethode*
  '((PROGN (SLEEP 0.7) (STOUCH (LIST 161.5 187.5)))
    (PROGN (SLEEP 1) (bottom))
    (PROGN (SLEEP 0.7) (STOUCH (LIST 170.0 279.0)))
    (PROGN (SLEEP 0.7) (up))
    (PROGN (SLEEP 0) (bottom))))

(DEFPARAMETER *bankpay-agree*
  '((PROGN (SLEEP 0.3) (STOUCH (LIST 107.0 515.0)))
    (PROGN (SLEEP 1) (STOUCH (LIST 36.0 201.5)))
    (PROGN (SLEEP 0) (STOUCH (LIST 260.5 83.0))))) 


(DEFPARAMETER *MIN-NUM*
  '((type-string-secupad (concatenate 'string *my-min* "/"))
    (progn (sleep 0.5))
    (progn (crack-secupad))
    (progn (sleep 1))
    (PROGN (SLEEP 0) (STOUCH (LIST 199.0 184.5))))) 

(DEFPARAMETER *BANK-SH*
  '((progn (sleep 0.8) (type-string-numpad (concatenate 'string *my-sh* "/")) )
    (PROGN (SLEEP 0) (STOUCH (LIST 221.0 263.0)))
    (PROGN (SLEEP 0) (STOUCH (LIST 103.5 373.5)))
    (PROGN (SLEEP 0.766) (STOUCH (LIST 153.5 248.5)))
    (PROGN (SLEEP 0.954) (STOUCH (LIST 150.5 329.5 152.5 150.5 0.766)))
    (PROGN (SLEEP 0) (STOUCH (LIST 158.0 330.0 154.5 140.0 0.954)))
    (PROGN (SLEEP 0) (STOUCH (LIST 156.0 224.5)))))

(DEFPARAMETER *KONTO-PIN*
  '((progn (sleep 0.8) (type-string-secupad (concatenate 'string *my-konto-pin* "/")))
    (progn (sleep 0) (crack-secupad))
    (progn (sleep 1))
    (PROGN (SLEEP 0.8) (STOUCH (LIST 198.5 301.5)))
    (progn (sleep 0) (top))))

(DEFPARAMETER *SH-PIN*
  '((progn (sleep 3) (stouch (list 161.5 310.5)))
    (PROGN (SLEEP 0) (STOUCH (LIST 265.5 380.5)))
    (progn (sleep 1))
    (progn (sleep 0) (type-string-numpad (concatenate 'string *my-sh-pin* "/")))
    (progn (sleep 0) (sleep 0.5))
    (PROGN (SLEEP 0) (STOUCH (LIST 157.5 381.5)))))

;; secucard cracking kiste
(DEFPARAMETER *foo*
  '((progn (sleep 0.5) (type-string-secupad (concatenate 'string *my-konto-pin* "/")))
    (progn (sleep 0) (crack-secupad))
    (progn (sleep 0.2) (top)) ; WICHTIG, WEGEN ABSOLUTE POSTION KALIBRATION
    (PROGN (SLEEP 0) (STOUCH (LIST 247.5 421.5)))))

;;; SYNOPSIS
(auction)
(m *select-order*)
(m *paymethode*)
(m *bankpay-agree*)
(m *min-num*)
(m *bank-sh*)
(m *konto-pin*)
(m *SH-PIN*)

(progn
  (m *select-order*)
  (sleep 4.8)
  (m *paymethode*)
  (sleep 3.5)
  (m *bankpay-agree*)
  (sleep 1)
  (m *min-num*)
  (sleep 2.4)
  (m *bank-sh*)
  (sleep 1) ;
  (m *konto-pin*)
  (sleep 1) ;
  (m *sh-pin*)
  )

