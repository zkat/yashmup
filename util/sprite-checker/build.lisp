(require 'asdf)
(require 'sb-posix)
(require 'lispbuilder-sdl)
(require 'lispbuilder-sdl-image)

(sb-ext:save-lisp-and-die "check-sprite"
			  :toplevel (lambda ()
				      (sb-posix:putenv
				       (format nil "SBCL_HOME=~A" 
					       #.(sb-ext:posix-getenv "SBCL_HOME")))
				      (sprite-checker::main)
				      0)
			  :executable t)