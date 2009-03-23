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
	     (loop while (and (peek-next-event *game*)
			      (cooked-p (peek-next-event *game*)))
		do (execute-event (pop-next-event *game*)))
	     (take-a-step *game*)
	     (sdl:update-display)
	     (multiple-value-bind (seconds-since-last-frame curr-time)
		 (time-difference (last-frame-time *game*))
	       (setf (last-frame-time *game*) curr-time)
	       (sleep (let ((sleep-time (- (/ 1 (framerate *game*)) seconds-since-last-frame)))
			(if (>= sleep-time 0)
			    sleep-time
			    0))))))))

(defun sdl-controlled ()
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
	     (loop while (and (peek-next-event *game*)
			      (cooked-p (peek-next-event *game*)))
		do (execute-event (pop-next-event *game*)))
	     (take-a-step *game*)
	     (sdl:update-display)))))





