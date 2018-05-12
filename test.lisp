;;;; test.lisp

(in-package #:mnas-defclass)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(mnas-defclass
 (Cl-name "Cl-name doc"
	  (parent-1 parent-2)
	  ((slot-1         "Init-form for slot-1"  "Doc for slot-1")
	   (slot-2         Init-form-for-slot2     "Doc for slot-1")
	   (slot-3         3                       "Doc for slot-3"))))

(mnas-print-defclass
 (Cl-name "Cl-name doc"
	  (parent-1 parent-2)
	  ((slot-1         "Init-form for slot-1"  "Doc for slot-1")
	   (slot-2         'Init-form-for-slot2    "Doc for slot-2")
   	   (slot-3         3                       "Doc for slot-3"))))
