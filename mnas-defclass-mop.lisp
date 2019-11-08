;;;; mnas-defclass-mop.lisp

(in-package #:mnas-defclass)

(export '*last-class-string-definition*)
(defparameter *last-class-string-definition* nil
  "Строка содержащая последнеен определение класса.")

(export 'string-to-slot)
(defun string-to-slot (str)
  (mnas-string:translit
   (string-downcase (string-trim " \"" (concatenate 'string  str)))
   :ht
   mnas-string:*space-cir-gr->en*))

(export 'strings-to-slots)
(defun strings-to-slots (str-list)
  (mapcar #'(lambda (el) (list (string-to-slot el) el)) str-list))

(export 'make-class)
(defun make-class (class-name names-docs &key (parents) &aux (o-stream (make-string-output-stream)))
  (let ((class-string
	 (progn
	   (format o-stream "(progn ~%")
	   (format o-stream "(defclass ~a ~s~%" class-name parents)
	   (format o-stream "  (~%")
	   (mapc
	    #'(lambda (el)
		(format
		 o-stream "   (~a :accessor ~a-~a :initarg :~a :initform nil :documentation ~s)~%"
		 (first el) class-name (first el) (first el) (second el)))
	    (strings-to-slots names-docs))
	   (format o-stream ")")
	   (format o-stream ")~%")
   	   (format o-stream "(defmethod print-object ((obj ~a) stream) (mnas-defclass:print-slots obj stream))" class-name)
	   (format o-stream ")")
	   (get-output-stream-string o-stream))))
    (format t "~a" class-string)
    (eval (read-from-string class-string))))

(export 'init-obj-by-list)
(defun init-obj-by-list (obj lst)
  "Инициализация объекта по списку значений"
  (mapcar #'(lambda (val s-name) (setf (slot-value obj s-name) val))
	  lst
	  (for-each-slot obj #'slot-name))
  obj)

(export 'init-objects-by-list)
(defun init-objects-by-list (class-type lst)
  "Инициализация объекта по списку значений"
  (mapcar #'(lambda (el) (init-obj-by-list (make-instance class-type) el)) lst))

(export 'make-class-and-init-items)
(defun make-class-and-init-items (class-name table &key (parents))
  (make-class class-name (car table) :parents parents)
  (init-objects-by-list (read-from-string class-name) (cdr table)))

(export 'for-each-slot)
(defun for-each-slot (obj func-for-slot)
  (mapcar
   #'(lambda (el) (funcall func-for-slot el))
   (sb-mop:class-direct-slots (class-of obj))))

(export 'slot-name)
(defun slot-name (slot-def) (sb-mop:slot-definition-name slot-def))

(export 'slot-doc)
(defun slot-doc   (slot-def) (documentation slot-def t))

(export 'filter)
(defun filter (func-filter obj-lst) (mapcan func-filter obj-lst))

(export 'class-desccription)
(defun class-desccription (class-item)
  (mapcar #'(lambda (sl doc)
	      (list (symbol-name sl) doc))
	  (for-each-slot class-item #'slot-name)
	  (for-each-slot class-item #'slot-doc)))

(export 'print-slots)
(defun print-slots (obj stream)
  (format stream "~&")
  (map nil 
       #'(lambda (sl-name) (format stream "|~a" (slot-value obj sl-name)))
       (for-each-slot obj #'slot-name))
  (format stream "|"))

(export 'for-each-object-slot-name)
(defun for-each-object-slot-name (func obj)
  (mapcar
   #'(lambda (sl-name) (funcall func obj sl-name ))
   (for-each-slot obj #'slot-name)))
