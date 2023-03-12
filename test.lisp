;;;; test.lisp

(in-package :mnas-defclass)

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod print-object ((x zm-struct) s)
  (format s "~A " (zm-struct-ceh x))
  (format s "~A " (zm-struct-ceh_pr x))
  (format s "~A " (zm-struct-naim_ps x))
  (format s "~% " ))

(defmethod print-object ((x zm-struct) s)
  '((format s "|~A"(db-sostoyanie              x))
    (format s "|~A"(db-dokument-!kod!          x))
    (format s "|~A"(db-dokument-!oboznachenie! x))
    (format s "|~A"(db-dokument-!naimenovanie! x))
    (format s "|~A"(db-naim+materiala-ogk      x))
    (format s "|~A"(db-kategoriya-dokumenta    x))
    (format s "|~A"(db-yazyk                   x))
    (format s "|~A"(db-arhiv                   x))
    (format s "|~A"(db-tip-dokumenta           x))
    (format s "|~A"(db-avtor                   x))
    (format s "|~A"(db-data-utverzhd+          x))
    (format s "|~A"(db-data-annulir+           x))
    (format s "|~A"(db-data-vvoda-v-deiystvie  x))
    (format s "|~A"(db-data-priost+            x))
    (format s "|~A"(db-grif                    x))
    (format s "|~A"(db-otn-nie-mezhdu-dok-mi   x))
    (format s "|~A"(db-unikal-nyiy-nomer       x))))


(defun foo (obj) (if (string= (zm-struct-deiystvuet-otmenena obj) "") (list obj) nil))

(defun foo-1 (obj) (list obj))
