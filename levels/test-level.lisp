;; test-level.lisp
;;
;; This should help me figure out what a single level should look like...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(let ((level (make-instance 'level)))
  ;;;
  ;;; First wave
  ;;;

  ;; first left-hand side
  (fork (:level level :delay 20 :repeat 3)
    (let ((enemy (make-instance 'enemy :x -15 :y 30 :velocity 4)))
      (attach enemy level)
      (setf (angle enemy) 90)
      (fork (:level level :delay 45)
	(move-in-curve enemy :level level :num-frames 170 :angle-delta 3)
	(fork (:level level :delay 50)
	  (fork (:level level :delay 5 :repeat 20)
	   (fire! enemy)))
	(fork (:level level :delay 500)
	  (detach enemy level)))))

  (fork (:level level :delay 20 :repeat 3)
    (let ((enemy (make-instance 'enemy :x 515 :y 30 :velocity 4)))
      (attach enemy level)
      (setf (angle enemy) 270)
      (fork (:level level :delay 45)
	(move-in-curve enemy
		       :level level :direction :counter-clockwise 
		       :num-frames 170 :angle-delta 3)
	(fork (:level level :delay 50)
	  (fork (:level level :delay 5 :repeat 20)
	   (fire! enemy)))
	(fork (:level level :delay 600)
	  (detach enemy level)))))
  
  (setf (current-level *game*) level))
