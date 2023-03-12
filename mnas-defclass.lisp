;;;; mnas-defclass.lisp

(in-package :mnas-defclass)

;;;; Шаблон для генерации класса Common Lisp

(setf *print-case* :downcase)

(defun make-slot (class slot i-form doc)
  "Генерирует отдельный слот

 @b(Пример использования:)
@begin[lang=lisp](code)
 (make-slot 'class-name 'slot-name nil \"Документация для слота\")
 => (CLASS-NAME-SLOT-NAME :ACCESSOR CLASS-NAME-SLOT-NAME :INITARG :SLOT-NAME :DOCUMENTATION \"Документация для слота\")
@end(code)
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

 @b(Пример использования:)
@begin[lang=lisp](code)
 (mnas-class-slot 'cl-name 
                  '((slot-1 nil \"Doc 1\") 
		   (slot_2 nil \"Doc 2\")))
=> ((CL-NAME-SLOT-1 :ACCESSOR CL-NAME-SLOT-1 :INITARG :SLOT-1 :DOCUMENTATION \"Doc 1\")
    (CL-NAME-SLOT_2 :ACCESSOR CL-NAME-SLOT_2 :INITARG :SLOT_2 :DOCUMENTATION \"Doc 2\"))
@end(code)
"
  (mapcar #'(lambda (el) (make-slot name (first el) (second el) (third el) )) slots))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(export 'mnas-defclass )
(defmacro mnas-defclass ((class-name doc-string parents slots))
"Предназначен для генерации класса
Пример использования:

 (mnas-defclass:mnas-defclass
  (Cl-name \"Cl-name doc\"
	   (parent-1 parent-2)
	   ((slot-1         \"Init-form for slot-1\"  \"Doc for slot-1\")
	    (slot-2         'Init-form-for-slot2     \"Doc for slot-1\")
	    (slot-3         3                        \"Doc for slot-3\")
	    (slot-4         (null t)                 \"Doc for slot-4\"))))
"
  `(eval (list 'defclass ',class-name ',parents
	       (mnas-class-slot ',class-name ',slots)
	       (list :documentation ,doc-string))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(export 'mnas-defclass-print )
(defmacro mnas-defclass-print ((class-name doc-string parents slots))
"@b(Описание:) метод @b(mnas-defclass-print) выполняет генерирование класса.

 @b(Пример использования:)
@begin[lang=lisp](code)
 (mnas-defclass:mnas-defclass-print
  (Cl-name \"Cl-name doc\"
	   (parent-1 parent-2)
	   ((slot-1         \"Init-form for slot-1\"  \"Doc for slot-1\")
	    (slot-2         'Init-form-for-slot2     \"Doc for slot-1\")
	    (slot-3         3                        \"Doc for slot-3\")
	    (slot-4         (null t)                 \"Doc for slot-4\"))))

 (defclass cl-name (parent-1 parent-2)
          ((cl-name-slot-1 :accessor cl-name-slot-1 :initarg :slot-1 :initform
            \"Init-form for slot-1\" :documentation \"Doc for slot-1\")
           (cl-name-slot-2 :accessor cl-name-slot-2 :initarg :slot-2 :initform
            'init-form-for-slot2 :documentation \"Doc for slot-1\")
           (cl-name-slot-3 :accessor cl-name-slot-3 :initarg :slot-3 :initform
            3 :documentation \"Doc for slot-3\")
           (cl-name-slot-4 :accessor cl-name-slot-4 :initarg :slot-4 :initform
            (null t) :documentation \"Doc for slot-4\"))
          (:documentation \"Cl-name doc\"))
@end(code)
"
  `(list 'defclass ',class-name ',parents
	       (mnas-class-slot ',class-name ',slots)
	       (list :documentation ,doc-string)))
