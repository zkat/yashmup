(in-package :yashmup)

(defun main ()
  (sdl:with-init (sdl:sdl-init-video sdl:sdl-init-audio)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "PEW PEW"
		:icon-caption "PEW PEW")
    (setf (sdl:frame-rate) 60)
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
	     (take-a-step *game*)
	     (sdl:update-display)
	     (when (not (running-p *game*))
	       (sdl:push-quit-event))))))

