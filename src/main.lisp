;; This file is part of yashmup

;; main.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defun main ()
  (sdl:with-init (sdl:sdl-init-video sdl:sdl-init-audio)
    (sdl-mixer:open-audio :chunksize 1024)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "PEW PEW"
		:icon-caption "PEW PEW")
    (setf (sdl:frame-rate) 60)
    (sdl:clear-display *bg-color*)
    (setup-paths)
    (setf *game* (make-instance 'game))
    (setf (current-level *game*) (load-level "test-level"))
    (sdl:with-events ()
       (:quit-event () (prog1 t
			 (setf (running-p *game*) nil)
			 (kill-audio)))
       (:key-down-event (:key key)
			(handle-key-event key *game*))
       (:key-up-event (:key key)
		      (handle-key-event key *game* :event-type :key-up))
       (:idle ()
	      (take-a-step *game*)
	      (sdl:update-display)))))

(defun setup-paths ()
  "This is necessary because compiling an image myself means the pathname
objects are saved as my own :<"
  (setf *resource-path*
	  (merge-pathnames "resources/" 
		   #+ccl(concatenate 'string (ccl::current-directory-name) "/")
		   #+sbcl(values *default-pathname-defaults*)
		   #+clisp(ext:default-directory)))
  (setf *level-path*
	  (merge-pathnames "levels/"
		   #+clisp(ext:default-directory)
		   #+sbcl(values *default-pathname-defaults*)
		   #+ccl(concatenate 'string (ccl::current-directory-name) "/"))))

(defun kill-audio ()
  (sdl-mixer:halt-music)
  (free-audio)
  (sdl-mixer:close-audio))

(defun free-audio ()
  (let ((music (find-resource 'music))
	(laser-sample (find-resource 'laser-sample)))
    (when music
      (sdl-mixer:free music))
    (when laser-sample
      (sdl-mixer:free laser-sample))))

