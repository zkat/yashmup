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
	(sdl-mixer:play-music music :loop t)))
    (add-lots-of-enemies 36)
    (sdl:with-events ()
       (:quit-event () (prog1 t
			 (setf (running-p *game*) nil)
			 (sdl-mixer:halt-music)
			 (free-audio)
			 (sdl-mixer:close-audio)))
       (:key-down-event (:key key)
			(handle-key-event key *game*))
       (:key-up-event (:key key)
		      (handle-key-event key *game* :event-type :key-up))
       (:idle ()
	      (loop
		 until (not (and (peek-next-event *game*)
				 (cooked-p (peek-next-event *game*))))
		 do (execute-event (pop-next-event *game*)))
	      (take-a-step *game*)
	      (sdl:update-display)))))

(defun add-lots-of-enemies (&optional (num-enemies 10))
  (dotimes (i num-enemies)
    (fork (:delay (* i 10))
      (spawn-an-enemy))))

(defun spawn-an-enemy ()
  (let ((an-enemy (make-instance 'enemy :x 70 :y 300)))
    (move-in-curve an-enemy :num-frames 10000)
    (fork (:delay 10001)
      (detach an-enemy *game*))
    (attach an-enemy *game*)))

(defun free-audio ()
  (let ((music (find-resource 'music))
	(laser-sample (find-resource 'laser-sample)))
    (when music
      (sdl-mixer:free music))
    (when laser-sample
      (sdl-mixer:free laser-sample))))