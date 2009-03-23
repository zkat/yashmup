(require 'asdf)
(require 'sb-posix)
(push (merge-pathnames "lib/") asdf:*central-registry*)

(require 'yashmup)
(sb-ext:save-lisp-and-die "yashmup"
			  :toplevel (lambda ()
				      (sb-posix:putenv
				       (format nil "SBCL_HOME=~A" 
					       #.(sb-ext:posix-getenv "SBCL_HOME")))
				      (yashmup::main)
				      0)
			  :executable t)

