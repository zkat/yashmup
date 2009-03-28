#+sbcl(require 'sb-posix)

(asdf:oos 'asdf:load-op 'sprite-checker)

#+sbcl(sb-ext:save-lisp-and-die "sprite-checker"
			  :toplevel (lambda ()
				      (sb-posix:putenv
				       (format nil "SBCL_HOME=~A" 
					       #.(sb-ext:posix-getenv "SBCL_HOME")))
				      (sprite-checker::main)
				      0)
			  :executable t)

#+clisp(ext:saveinitmem "sprite-checker"
			:init-function (lambda ()
					 (cffi:define-foreign-library sdl
					   (t (:default "libSDL")))
					 (cffi:define-foreign-library sdl-image
					   (t (:default "libSDL_image")))
					 (cffi:use-foreign-library sdl)
					 (cffi:use-foreign-library sdl-image)
					 (sprite-checker::main)
					 (ext:quit))
			:norc t
			:script t
			:executable t
			:quiet t)