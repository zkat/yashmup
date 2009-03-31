;; test-level.lisp
;;
;; This should help me figure out what a single level should look like...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defun circle-from-right (level)
  (fork (:level level :repetitions 3 :repeat-delay 20)
    (let ((enemy (make-instance 'enemy :x 515 :y 30 :velocity 5)))
      (attach enemy level)
      (setf (angle enemy) 270)
      (fork (:level level :delay 45)
	(move-in-curve enemy
		       :level level :direction :counter-clockwise 
		       :num-frames 170 :angle-delta 2)
	(fork (:level level)
	  (fork (:level level :repeat-delay 8 :repetitions 80)
	    (fire! enemy)))
	(fork (:level level :delay 500)
	  (detach enemy level))))))

(defun circle-from-left (level)
  (fork (:level level :repeat-delay 20 :repetitions 3)
    (let ((enemy (make-instance 'enemy :x -15 :y 30 :velocity 5)))
      (attach enemy level)
      ;; First start by moving to the right
      (setf (angle enemy) 90)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:level level :delay 45)
	(move-in-curve enemy :level level :num-frames 170 :angle-delta 2)
	;; 50 frames after the curve-move is *started*...
	(fork (:level level)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:level level :repeat-delay 8 :repetitions 80)
	    (fire! enemy)))
	;; Once we're done, we detach the enemy from the level
	(fork (:level level :delay 500)
	  (detach enemy level))))))

(let ((level (make-instance 'level)))
  ;;;
  ;;; First wave
  ;;;

  (fork (:level level :repeat-delay 500 :repetitions 20)
    (circle-from-left level))

  (setf (current-level *game*) level))

