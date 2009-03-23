#+sbcl(require 'sb-posix)
#+clisp
(push (merge-pathnames "lib/" 
		    #+sbcl(values *default-pathname-defaults*)
		    #+ccl(ccl::current-directory-name)
		    #+clisp(ext:default-directory)) asdf:*central-registry*)

(asdf:oos 'asdf:load-op 'yashmup)
#+sbcl(sb-ext:save-lisp-and-die "yashmup-sbcl"
				:toplevel (lambda ()
					    (sb-posix:putenv
					     (format nil "SBCL_HOME=~A" 
						     #.(sb-ext:posix-getenv "SBCL_HOME")))
					    (yashmup::main)
					    0)
				:executable t)

#+ccl(ccl::save-application "yashmup-ccl"
			    :toplevel-function
			    (lambda ()
			      (yashmup::main)
			      0))

#+clisp(ext:saveinitmem "yashmup-clisp"
			:init-function (lambda ()
					 (yashmup::main)
					 0)
			:norc t
			:script t
			:executable t
			:quiet t)
