;; This file is part of yashmup

;; config.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defparameter *screen-height* 800)
(defparameter *screen-width* 500)
(defparameter *bg-color* sdl:*black*)
(defvar *running* nil)
(defparameter *resource-path*
  (merge-pathnames "resources/" 
		   #+sbcl(values *default-pathname-defaults*)
		   #+ccl(ccl::current-directory-name)
		   #+clisp(ext:default-directory)))