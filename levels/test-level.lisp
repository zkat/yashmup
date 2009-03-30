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
      ;; First start by moving to the right
      (setf (angle enemy) 90)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:level level :delay 45)
	(move-in-curve enemy :level level :num-frames 170 :angle-delta 3)
	;; 50 frames after the curve-move is *started*...
	(fork (:level level :delay 50)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:level level :delay 5 :repeat 20)
	   (fire! enemy)))
	;; Once we're done, we detach the enemy from the level
	(fork (:level level :delay 500)
	  (detach enemy level)))))

  ;; right-hand side of first wave
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
