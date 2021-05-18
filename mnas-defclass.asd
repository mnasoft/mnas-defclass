;;;; mnas-defclass.asd

(defsystem #:mnas-defclass
  :description "Describe mnas-defclass here"
  :author "Nick Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"  
  :serial t
  :depends-on (#:mnas-string #:postmodern)
  :components ((:file "package")
               (:file "mnas-defclass")
	       (:file "mnas-defclass-mop")
	       (:file "mnas-defclass-postmodern")
	       ))

