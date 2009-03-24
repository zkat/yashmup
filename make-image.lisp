#+sbcl(require 'sb-posix)
#+clisp(load (merge-pathnames "lib/asdf.lisp" (ext:default-directory)))
(push (merge-pathnames "lib/" 
		    #+sbcl(values *default-pathname-defaults*)
		    #+ccl(ccl::current-directory-name)
		    #+clisp(ext:default-directory)) asdf:*central-registry*)

(asdf:oos 'asdf:load-op 'yashmup)

#+sbcl(sb-ext:save-lisp-and-die "yashmup"
				:toplevel (lambda ()
					    (sb-posix:putenv
					     (format nil "SBCL_HOME=~A" 
						     #.(sb-ext:posix-getenv "SBCL_HOME")))
					    (yashmup::main)
					    0)
				:executable t)

#+ccl(progn 
       (ccl::save-application "yashmup"
			      :toplevel-function
			      (lambda ()
				(cffi:define-foreign-library sdl
				  (t (:default "libSDL")))
				(cffi:define-foreign-library sdl-mixer
				  (t (:default "libSDL_mixer")))
				(cffi:define-foreign-library sdl-image
				  (t (:default "libSDL_image")))
				(cffi:use-foreign-library sdl)
				(cffi:use-foreign-library sdl-mixer)
				(cffi:use-foreign-library sdl-image)
				(yashmup::main)
				(ccl::quit))
			      :prepend-kernel t))

#+clisp(ext:saveinitmem "yashmup"
			:init-function (lambda ()
					 (cffi:define-foreign-library sdl
					   (t (:default "libSDL")))
					 (cffi:define-foreign-library sdl-mixer
					   (t (:default "libSDL_mixer")))
					 (cffi:define-foreign-library sdl-image
					   (t (:default "libSDL_image")))
					 (cffi:use-foreign-library sdl)
					 (cffi:use-foreign-library sdl-mixer)
					 (cffi:use-foreign-library sdl-image)
					 (yashmup::main)
					 (ext:quit))
			:norc t
			:script t
			:executable t
			:quiet t)
