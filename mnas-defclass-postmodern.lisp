;;;; mnas-defclass-postmodern.lisp

(in-package #:mnas-defclass)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(export 'make-dao-class)
(defun make-dao-class (class-name names-docs &key (keys nil) (parents) &aux (o-stream (make-string-output-stream)))
  (let* ((slot-names   (strings-to-slots names-docs))
	(class-string
	 (progn
	   (format o-stream "(progn ~%")
	   (format o-stream "(defclass ~a ~s~%" class-name parents)
	   (format o-stream "  (~%")
	   (mapc
	    #'(lambda (el)
		(format
		 o-stream "   (~a ~20,1t :col-type string :accessor ~a-~a ~75,1t :initarg :~a ~100,1t :initform \"\" :documentation ~s)~%"
		 (first el) class-name (first el) (first el) (second el)))
	    slot-names)
	   (format o-stream ")")
	   (format o-stream "~&   (:metaclass postmodern:dao-class)")
	   (when (and keys (listp keys)) (format o-stream "~&   (:keys ~{~a ~})" (mapcar #'(lambda (el) (first (nth el slot-names))) keys)))
  	   (format o-stream ")~%")
   	   (format o-stream "(defmethod print-object ((obj ~a) stream) (mnas-defclass:print-slots obj stream))" class-name)
	   (format o-stream ")")
	   (get-output-stream-string o-stream))))
    (format t "~a" class-string)
    (eval (read-from-string class-string))
    ))

(export 'make-dao-class-and-init-items)
(defun make-dao-class-and-init-items (class-name table &key (parents) (keys nil) &aux (class-symbol (read-from-string class-name)))
  (make-dao-class class-name (car table) :parents parents :keys keys)
  (postmodern:execute (postmodern:dao-table-definition class-symbol))
  (mapcar #'postmodern:insert-dao
	  (init-objects-by-list class-symbol (cdr table))))
