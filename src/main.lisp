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
    (init-resources)
    (setf *game* (make-instance 'game))
    (let ((music (find-resource 'music)))
      (when music
	(sdl-mixer:play-music music)))
    (sdl:with-events ()
       (:quit-event () (prog1 t
			 (setf (running-p *game*) nil)
			 (sdl-mixer:halt-music)
			 (sdl-mixer:free (find-resource 'music))
			 (let ((laser-sample (find-resource 'laser-sample)))
			   (when laser-sample
			     (sdl-mixer:free (gethash 'laser-sample *resource-table*))))
			 (sdl-mixer:close-audio)))
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






