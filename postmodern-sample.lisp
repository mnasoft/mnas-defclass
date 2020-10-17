;;;; postmodern-sample.lisp

;;;; Пример использования postmodern

(in-package #:mnas-defclass)

(use-package :postmodern)

(postmodern:connect-toplevel "test" "namatv" "" "localhost")

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

(dao-table-name 'country)

(let ((c-ry (get-dao 'country "Україна")))
  (loop for i from 1 :to 1000000 :do 
       (setf (country-inhabitants c-ry)  (1+ (country-inhabitants c-ry))))
  (update-dao c-ry))

(defprepared sovereign-of (:select 'sovereign :from 'country :where (:= 'name '$1)) :single!)

(sovereign-of "The Netherlands")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(make-dao-class "db-test" '("Обозначение" "Наименование" "Нечто" "Что-то") :keys '(0))
(execute (dao-table-definition 'db-test))


(defparameter *tbl*
  '(("Обозначение" "Наименование"            "Нечто" "Что-то")
    ("090038048"   "Форсунка воспламенителя" "СП"    "ДТ")
    ("Ф90038001"   "Форсунка"                "СП"    "ДТ")
    ("Г80038135"   "Воспламенитель"          "SP"    "ГТ")))

(make-dao-class-and-init-items "db" *tbl* :keys '(0))

(execute (dao-table-definition 'db-test))
(execute "DROP table db_test;")


(disconnect-toplevel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(export 'read-from-exel-tab-text)
(defun read-from-exel-tab-text (f-name &key (external-format :cp1251))
  "   Выполняет чтение из файла, экспортируемого из ΙΤ-предприятие 
в exel и затем в текстовый файл (с разделителями табуляции).
   Пример использования:
@begin[lang=lisp](code)
 (read-from-exel-tab-text \"d:/PRG/msys2/home/namatv/org/tz/TZ_3.txt\")
@end(code)
"
  (labels ((remove-some-chars (str)
	     (let ((rez str))
	       (setf rez (string-trim " " rez))
	       (when (and (< 2 (length rez))
			  (char= #\" (char rez 0))
			  (char= #\" (char rez (1- (length rez)))))
		 (setf rez (subseq rez 1 (1- (length rez)))))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez "\"\"" "\"")))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez "  "   " " )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez "( "   "(" )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez " )"   ")" )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez "[ "   "[" )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez " ]"   "]" )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez "{ "   "{" )))
	       (when (< 2 (length rez)) (setf rez (mnas-string:string-replace-all rez " }"   "}" )))
	       rez)))
    (with-open-file  (str f-name :external-format external-format)
      (do ((lines    nil)
	   (curr-lst nil)
	   (last-ln  "")
	   (l-str    nil)
	   (line (read-line str nil 'eof) (read-line str nil 'eof)))
	  ((eql line 'eof) (mapcar #'(lambda (lst) (mapcar #'remove-some-chars lst)) (nreverse lines)))
	(setf l-str (mnas-string:split "	" (concatenate 'string last-ln line)))
	(if (evenp (count #\" (first (last l-str))))
	    (progn
	      (setf curr-lst (append curr-lst l-str))
	      (push curr-lst lines)
	      (setf last-ln ""
		    curr-lst nil))
	    (progn
	      (setf last-ln  (first (last l-str)))
	      (setf curr-lst (append curr-lst (nreverse (cdr (nreverse l-str)))))))))))


  
