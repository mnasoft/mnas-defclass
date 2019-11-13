;;;; mnas-defclass-postmodern.lisp

;;;; Пример использования postmodern

(in-package #:mnas-defclass)

(require :postmodern)

(use-package :postmodern)

(connect-toplevel "test" "namatv" "" "localhost")

(defclass country ()
  ((name        :col-type string              :initarg :name        :reader   country-name)
   (inhabitants :col-type integer             :initarg :inhabitants :accessor country-inhabitants)
   (sovereign   :col-type (or db-null string) :initarg :sovereign   :accessor country-sovereign))
  (:metaclass dao-class)
  (:keys name ))

(execute (dao-table-definition 'country))

(insert-dao (make-instance 'country :name "The Netherlands" :inhabitants  16800000 :sovereign "Willem-Alexander"))
(insert-dao (make-instance 'country :name "Croatia"         :inhabitants   4400000))
(insert-dao (make-instance 'country :name "Україна"         :inhabitants  42000000))
(insert-dao (make-instance 'country :name "Россия"          :inhabitants 150000000))

(delete-dao (get-dao 'country "Україна"))

(select-dao 'country (:>= 'inhabitants 10000000) 'inhabitants)

(get-dao 'country "Croatia")


(dao-table-name (get-dao 'country "Україна")

(dao-table-name 		'country)
		
(let ((c-ry (get-dao 'country "Україна")))
  (setf (country-inhabitants c-ry) 4600000)
  (update-dao croatia))

(defprepared sovereign-of (:select 'sovereign :from 'country :where (:= 'name '$1)) :single!)

(disconnect-toplevel)

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
	   (format o-stream "~&   (:metaclass dao-class)")
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
  (execute (dao-table-definition class-symbol))
  (mapcar #'insert-dao
	  (init-objects-by-list class-symbol (cdr table))))

(make-dao-class "db-test" '("Обозначение" "Наименование" "Нечто" "Что-то") :keys '(0))

(defparameter *tbl*
  '(("Обозначение" "Наименование"            "Нечто" "Что-то")
    ("090038048"   "Форсунка воспламенителя" "СП"    "ДТ")
    ("Ф90038001"   "Форсунка"                "СП"    "ДТ")
    ("Г80038135"   "Воспламенитель"          "SP"    "ГТ")))

(make-dao-class-and-init-items "db" *tbl* :keys '(0))


(execute (dao-table-definition 'db-test))
(execute "DROP table db_test;")

(progn 
  (defclass db nil
    (
     (:col-type string naimenovanie :accessor db-naimenovanie :initarg :naimenovanie :initform nil :documentation "Наименование")
     (:col-type string oboznachenie :accessor db-oboznachenie :initarg :oboznachenie :initform nil :documentation "Обозначение")
     (:col-type string nechto :accessor db-nechto :initarg :nechto :initform nil :documentation "Нечто")
     (:col-type string chto-to :accessor db-chto-to :initarg :chto-to :initform nil :documentation "Что-то")
     )
    (:metaclass dao-class))
  (defmethod print-object ((obj db) stream) (mnas-defclass:print-slots obj stream)))
