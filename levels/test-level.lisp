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
(defun circle-from-left ()
  (fork (:repeat-delay 20 :repetitions 3)
    (let ((enemy (make-instance 'enemy :x -20 :y 30 :velocity 4.5)))
      (attach enemy *game*)
      ;; First start by moving to the right
      (setf (angle enemy) 90)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:delay 45)
	(move-in-curve enemy :duration 170 :angle-delta 3)
	;; 50 frames after the curve-move is *started*...
	(fork (:delay 40)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:repeat-delay 8 :repetitions 10)
	    (fire! enemy)))
	;; Once we're done, we detach the enemy from the *level*
	(fork (:delay 500)
	  (detach enemy *game*))))))

(defun circle-from-right ()
  (fork (:repeat-delay 20 :repetitions 3)
    (let ((enemy (make-instance 'enemy :x 510 :y 30 :velocity 4.5)))
      (attach enemy *game*)
      ;; First start by moving to the right
      (setf (angle enemy) 270)
      ;; 45 frames later, start moving in a clockwise curve
      (fork (:delay 45)
	(move-in-curve enemy :duration 170 :angle-delta 3 :direction :counter-clockwise)
	;; 50 frames after the curve-move is *started*...
	(fork (:delay 40)
	  ;; Shoot 20 times, with a 5-frame delay between each shot
	  (fork (:repeat-delay 8 :repetitions 10)
	    (fire! enemy)))
	;; Once we're done, we detach the enemy from the *level*
	(fork (:delay 500)
	  (detach enemy *game*))))))

;;; Level script begins here
(fork (:repeat-delay 300 :repetitions 20)
  (circle-from-left)
  (circle-from-right))

