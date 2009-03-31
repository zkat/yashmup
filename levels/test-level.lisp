;; test-level.lisp
;;
;; This should help me figure out what a single level should look like...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Action definitions
;;;
;;; Note: I could do something like defaction that makes this simpler, or just make the whole
;;;       *level*-scripting system run inside a fancy macro that lets you specify frames.
(defun circle-from-left (level)
  (fork (:level level :repeat-delay 20 :repetitions 3)
    (let ((enemy (make-instance 'enemy :x -20 :y 30 :velocity 4.5)))
      (attach enemy level)
      ;; First start by moving to the right
      (setf (angle enemy) 90)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:delay 45 :level level)
	(move-in-curve enemy :duration 170 :angle-delta 3 :level level)
	;; 50 frames after the curve-move is *started*...
	(fork (:delay 40 :level level)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:level level :repeat-delay 8 :repetitions 80)
	    (fire! enemy)))
	;; Once we're done, we detach the enemy from the *level*
	(fork (:delay 500 :level level)
	  (detach enemy level))))))

(defun circle-from-right (level)
  (fork (:level level :repeat-delay 20 :repetitions 3)
    (let ((enemy (make-instance 'enemy :x 510 :y 30 :velocity 4.5)))
      (attach enemy level)
      ;; First start by moving to the right
      (setf (angle enemy) 270)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:delay 45 :level level)
	(move-in-curve enemy :duration 170 :angle-delta 3 :level level :direction :counter-clockwise)
	;; 50 frames after the curve-move is *started*...
	(fork (:delay 40 :level level)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:level level :repeat-delay 8 :repetitions 80)
	    (fire! enemy)))
	;; Once we're done, we detach the enemy from the *level*
	(fork (:delay 500 :level level)
	  (detach enemy level))))))

;;; Level script begins here
(let ((level (make-instance 'level)))
  (fork (:repeat-delay 500 :repetitions 20 :level level)
    (circle-from-left level)
    (circle-from-right level))
  (setf *level* level))

