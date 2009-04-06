(in-package :yashmup)

;;;
;;; First wave
;;;
(fork (:delay 2000)
  
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

(fork (:delay 100)
  (let* ((boss (make-instance 'small-enemy :x (- (/ *screen-width* 2) 100)
			     :y -200
			     :hp 1000
			     :image (load-image "bosses/small-boss-01")))
	 (weapon (make-instance 'weapon
				:x-offset 100
				:y-offset 100
				:owner boss
				:sps 50))
	 (generators (append (loop for i upto 34
				collect (make-instance 'generator
						       :ammo-class (find-class 'enemy-laser)
						       :firing-angle (* i 10)
						       :owner weapon
						       :x-offset 50))
			     (loop for i upto 34
				collect (make-instance 'generator
						       :ammo-class (find-class 'enemy-laser)
						       :firing-angle (* i 10)
						       :owner weapon
						       :x-offset -50))
			       (loop for i upto 34
				collect (make-instance 'generator
						       :ammo-class (find-class 'enemy-laser)
						       :firing-angle (* i 10)
						       :owner weapon
						       :y-offset 70)))))
    (setf (generators weapon) generators)
    (attach weapon boss)
    (attach boss *game*)
    (setf (velocity boss) 1)
    (move-in-angle boss 0 :duration 200)
    (fork (:delay 300)
      (setf (angle boss) 90)
      (fork (:repeat-delay 150 :repetitions 5)
	(setf (velocity boss) 1)
	(setf (angle boss) (* (angle boss) -1))))
    (fork (:delay 250)
      (fork (:repetitions 40 :repeat-delay 15)
	(fire! boss)))
    (fork (:delay 850)
      (setf (velocity boss) 1)
      (move-in-angle boss 180 :duration 200))
    (fork (:delay 1150)
      (detach boss *game*))))



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
