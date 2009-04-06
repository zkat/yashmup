(in-package :yashmup)

;;;
;;; First wave
;;;
(fork ()
  
 (fork (:repeat-delay 30 :repetitions 3)
   (let ((enemy (make-instance 'small-enemy :x -25 :y 50 :velocity 4)))
     (attach enemy *game*)
     (move-in-angle enemy 70)
     (fork (:delay 50 :repeat-delay 40 :repetitions 5)
       (fire! enemy))
     (fork (:delay 80)
       (move-in-curve enemy :angle-delta 1.5 :duration 200)
       (fork (:repeat-delay 40 :repetitions 15)
	 (fire! enemy)))
     (fork (:delay 350)
       (detach enemy *game*))))

 (fork (:repeat-delay 30 :repetitions 3)
   (let ((enemy (make-instance 'small-enemy :x (+ 20 *screen-width*) :y 50 :velocity 4)))
     (attach enemy *game*)
     (move-in-angle enemy 290)
     (fork (:delay 50 :repeat-delay 40 :repetitions 5)
       (fire! enemy))
     (fork (:delay 80)
       (move-in-curve enemy :angle-delta 1.5 :duration 200 :direction :counter-clockwise)
       (fork (:repeat-delay 40 :repetitions 15)
	 (fire! enemy)))
     (fork (:delay 350)
       (detach enemy *game*))))

 (fork (:delay 100)
   (let ((enemy (make-instance 'enemy
			       :x (- (/ *screen-width* 2) 100)
			       :y -30 :velocity 3)))
     (attach enemy *game*)
     (move-in-angle enemy 0 :duration 30)
     (fork (:delay 32 :repeat-delay 60 :repetitions 5)
       (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
     (fork (:delay 300)
       (setf (velocity enemy) 3)
       (move-in-angle enemy 180 :duration 50))
     (fork (:delay 400)
       (detach enemy *game*))))

 (fork (:delay 100)
   (let ((enemy (make-instance 'enemy
			       :x (+ (/ *screen-width* 2) 100)
			       :y -30 :velocity 3)))
     (attach enemy *game*)
     (move-in-angle enemy 0 :duration 30)
     (fork (:delay 32 :repeat-delay 60 :repetitions 5)
       (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
     (fork (:delay 300)
       (setf (velocity enemy) 3)
       (move-in-angle enemy 180 :duration 50))
     (fork (:delay 400)
       (detach enemy *game*)))))

;;;
;;; Second wave
;;;

(fork (:delay 600)
  
  )


;;;
;;; Third wave
;;;

;;; Pattern description:

;;;
;;; Fourth wave
;;;

;;; Pattern description:

;;;
;;; Fifth wave
;;;

;;; Pattern description:

;;;
;;; Boss
;;;


;;; First pattern:

;;; Second pattern:

;;; Third pattern:

;;; Fourth pattern:

;;; Fifth pattern:
