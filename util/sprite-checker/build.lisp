(require 'asdf)
(require 'sb-posix)
(require 'lispbuilder-sdl)
(require 'lispbuilder-sdl-image)

(load "sprite-check.lisp")
(sb-ext:save-lisp-and-die "sprite-checker"
			  :toplevel (lambda ()
				      (sb-posix:putenv
				       (format nil "SBCL_HOME=~A" 
					       #.(sb-ext:posix-getenv "SBCL_HOME")))
				      (sprite-checker::main)
				      0)
			  :executable t)