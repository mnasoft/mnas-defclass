;;;; mnas-defclass.lisp

(in-package #:mnas-defclass)

;;; "mnas-defclass" goes here. Hacks and glory await!

(defun make-slot (class slot i-form doc)
  "Генерирует отдельный слот
Пример использования:
(make-slot 'class-name 'slot-name nil \"Документация для слота\")
=> (CLASS-NAME-SLOT-NAME :ACCESSOR CLASS-NAME-SLOT-NAME :INITARG :SLOT-NAME :DOCUMENTATION \"Документация для слота\")
"
  (let ((class-str (symbol-name class))
	(slot-str  (symbol-name  slot))
	(rez-slot nil))
    (push (read-from-string (concatenate 'string class-str "-" slot-str)) rez-slot)
    (push :accessor  rez-slot)
    (push (read-from-string (concatenate 'string class-str "-" slot-str)) rez-slot)
    (push :initarg rez-slot)
    (push (read-from-string (concatenate 'string ":" slot-str)) rez-slot)
    (when i-form
      (push :initform rez-slot)
      (push i-form rez-slot))
    (when (stringp doc)
      (push :documentation rez-slot)
      (push doc rez-slot))
    (reverse rez-slot)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mnas-class-slot (name slots)
  "Предназначена для генерации слотов класса
Пример использования:
(mnas-class-slot 'cl-name 
		 '((slot-1 nil \"Doc 1\") 
		   (slot_2 nil \"Doc 2\")))
=> ( (CL-NAME-SLOT-1 :ACCESSOR CL-NAME-SLOT-1 :INITARG :SLOT-1 :DOCUMENTATION \"Doc 1\")
     (CL-NAME-SLOT_2 :ACCESSOR CL-NAME-SLOT_2 :INITARG :SLOT_2 :DOCUMENTATION \"Doc 2\") )
"
  (mapcar #'(lambda (el) (make-slot name (first el) (second el) (third el) )) slots))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro mnas-defclass ((class-name doc-string parents slots))
  "Предназначен для генерации класса
Пример использования:

 (mnas-defclass
  (Cl-name \"Cl-name doc\"
 	  (parent-1 parent-2)
 	  ((slot-1         \"Init-form for slot-1\"  \"Doc for slot-1\")
 	   (slot-2         'Init-form-for-slot2     \"Doc for slot-1\")
 	   (slot-3         3                        \"Doc for slot-3\"))))
"
  `(eval (list 'defclass ',class-name ',parents
	       (mnas-class-slot ',class-name ',slots)
	       (list :documentation ,doc-string))))

(export 'mnas-defclass)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro mnas-print-defclass ((class-name doc-string parents slots))
  "Предназначен для генерации класса
Пример использования:
;;;; (mnas-defclass ('class-name \"Doc for class\" '() '((slot-1 nil \"Doc for slot-1\") (slot-2 nil \"Doc for slot-2\"))))
"
  `(list 'defclass ',class-name ',parents
	       (mnas-class-slot ',class-name ',slots)
	       (list :documentation ,doc-string)))

(export 'mnas-print-defclass)
