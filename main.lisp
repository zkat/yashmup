(in-package :yashmup)

(defun main ()
  (setf *running* t)
  (sdl:with-init (sdl:sdl-init-video sdl:sdl-init-audio)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "PEW PEW"
		:icon-caption "PEW PEW")
    (setf (sdl:frame-rate) 60)
    (sdl:clear-display *bg-color*)
    (init-resources)
    (play-game)))

(defun play-game ()
  (setf *game* (make-instance 'game))
  (sdl:with-events ()
    (:quit-event () (prog1 t
		      (setf (running-p *game*) nil)))
    (:key-down-event (:key key)
		     (handle-key-event key *game*))
    (:key-up-event (:key key)
		   (handle-key-event key *game* :event-type :key-up))
    (:idle ()
	   (unless (paused-p *game*)
	    (take-a-step *game*))
	   (sdl:update-display)
	   (when (not (running-p *game*))
	     (sdl:push-quit-event)))))

(defun toggle-pause ()
  (if (paused-p *game*)
      (setf (paused-p *game*) nil)
      (setf (paused-p *game*) t)))
