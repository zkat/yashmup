;; This file is part of yashmup

;; config.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defparameter *screen-height* 650)
(defparameter *screen-width* 500)
(defparameter *bg-color* sdl:*black*)
(defvar *running* nil)
(defparameter *default-framerate* 60)
(defparameter *resource-path*
  (merge-pathnames "resources/" 
		   #+ccl(concatenate 'string (ccl::current-directory-name) "/")
		   #+sbcl(values *default-pathname-defaults*)
		   #+clisp(ext:default-directory)))