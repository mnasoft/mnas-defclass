;;;; test.lisp

(in-package #:mnas-defclass)

(defun make-class (name parents slots)
  (let ((s (make-string-output-stream)))
    (format s "(defclass ~A (" name)
    (mapcar #'(lambda(el) (format s " ~A" el)) parents)
    (format s " )~%(")
    (mapcar
     #'(lambda(el)
	 (format s "~&(~A-~A :accessor ~A-~A :initarg :~A " name (first el) name (first el) (first el))
	 (when (second el) (format s ":initform ~S " (second el)))
	 (when (third el) (format s ":documentation ~S" (third el)))
	 (format s ")"))
     slots)
    (format s "))")
    (read-from-string  (get-output-stream-string s) nil)))

(defmacro make-class (name parents slots)
  (let ((s (make-string-output-stream)))
    (format s "(defclass ~A (" name)
    (mapcar #'(lambda(el) (format s " ~A" el)) parents)
    (format s " )~%(")
    (mapcar
     #'(lambda(el)
	 (format s "~&(~A-~A :accessor ~A-~A :initarg :~A " name (first el) name (first el) (first el))
	 (when (second el) (format s ":initform ~S " (second el)))
	 (when (third el) (format s ":documentation ~S" (third el)))
	 (format s ")"))
     slots)
    (format s "))")
    (read-from-string  (get-output-stream-string s) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(make-class 'cl-foo '()
	    '((input  nil "Имя входного файла")
	      (output nil "Имя выходного файла")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
