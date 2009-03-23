;; This file is part of yashmup

;; main.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defun main ()
  (sdl:with-init (sdl:sdl-init-video sdl:sdl-init-audio)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "PEW PEW"
		:icon-caption "PEW PEW")
    (setf (sdl:frame-rate) 0)
    (sdl:clear-display *bg-color*)
    (init-resources)
    (setf *game* (make-instance 'game))
    (sdl:with-events ()
      (:quit-event () (prog1 t
			(setf (running-p *game*) nil)))
      (:key-down-event (:key key)
		       (handle-key-event key *game*))
      (:key-up-event (:key key)
		     (handle-key-event key *game* :event-type :key-up))
      (:idle ()
;;	     (execute-next-event (event-queue *game*)) <-- this is what I should be aiming at
	     (take-a-step *game*)
	     (sdl:update-display)
	     (sleep (/ 1 (framerate *game*)))))))





