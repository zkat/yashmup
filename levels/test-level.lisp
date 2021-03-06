(in-package :yashmup)

;;;
;;; First wave
;;;

(fork (:delay 100)
;; Total wave duration: 700
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
     (fork (:delay 500)
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
     (fork (:delay 500)
       (detach enemy *game*))))

 (fork (:delay 200)
   (fork (:repeat-delay 30 :repetitions 3)
     (let ((enemy (make-instance 'small-enemy :x -25 :y 200 :velocity 4)))
       (attach enemy *game*)
       (move-in-angle enemy 100)
       (fork (:delay 50 :repeat-delay 40 :repetitions 5)
	 (fire! enemy))
       (fork (:delay 80)
	 (move-in-curve enemy :angle-delta 1.5 :duration 200)
	 (fork (:repeat-delay 40 :repetitions 15)
	   (fire! enemy)))
       (fork (:delay 500)
	 (detach enemy *game*)))))
 
 (fork (:delay 200)
   (fork (:repeat-delay 30 :repetitions 3)
     (let ((enemy (make-instance 'small-enemy :x (+ 20 *screen-width*) :y 200 :velocity 4)))
       (attach enemy *game*)
       (move-in-angle enemy 270)
       (fork (:delay 50 :repeat-delay 40 :repetitions 5)
	 (fire! enemy))
       (fork (:delay 80)
	 (move-in-curve enemy :angle-delta 1.5 :duration 200 :direction :counter-clockwise)
	 (fork (:repeat-delay 40 :repetitions 15)
	   (fire! enemy)))
       (fork (:delay 500)
	 (detach enemy *game*)))))

 (fork (:delay 150)
   (let ((enemy (make-instance 'enemy
			       :x (- (/ *screen-width* 2) 100)
			       :y -30 :velocity 3)))
     (attach enemy *game*)
     (move-in-angle enemy 0 :duration 30)
     (fork (:delay 32 :repeat-delay 20 :repetitions 15)
       (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
     (fork (:delay 300)
       (setf (velocity enemy) 3)
       (move-in-angle enemy 180 :duration 50))
     (fork (:delay 400)
       (detach enemy *game*))))

 (fork (:delay 150)
   (let ((enemy (make-instance 'enemy
			       :x (+ (/ *screen-width* 2) 100)
			       :y -30 :velocity 3)))
     (attach enemy *game*)
     (move-in-angle enemy 0 :duration 30)
     (fork (:delay 32 :repeat-delay 20 :repetitions 15)
       (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
     (fork (:delay 300)
       (setf (velocity enemy) 3)
       (move-in-angle enemy 180 :duration 50))
     (fork (:delay 400)
       (detach enemy *game*)))))


;;;
;;; Second wave
;;;


;; total wave duration: 1000
(fork (:delay 600)

  ;; Orbiting bastards
  (fork (:repeat-delay 60 :repetitions 10)
    (let ((enemy (make-instance 'small-enemy
				:x 0
				:y -10)))
      (attach enemy *game*)
      (orbit (player (current-level *game*)) enemy :duration 300 :keep-distance 130)
      (fork (:repeat-delay 45 :repetitions 7)
	(shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
      (fork (:delay 600)
	(detach enemy *game*))))

  (fork (:repeat-delay 60 :repetitions 10)
    (let ((enemy (make-instance 'small-enemy
				:x *screen-width*
				:y -10)))
      (attach enemy *game*)
      (orbit (player (current-level *game*)) enemy :duration 300 :keep-distance 130)
      (fork (:repeat-delay 45 :repetitions 7)
	(shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
      (fork (:delay 600)
	(detach enemy *game*))))

  ;; They're ba~ck
   (fork (:delay 400)
     (let ((enemy (make-instance 'enemy
				 :x (- (/ *screen-width* 2) 100)
				 :y -30 :velocity 3)))
       (attach enemy *game*)
       (move-in-angle enemy 0 :duration 30)
       (fork (:delay 32 :repeat-delay 20 :repetitions 15)
	 (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
       (fork (:delay 300)
	 (setf (velocity enemy) 3)
	 (move-in-angle enemy 180 :duration 50))
       (fork (:delay 400)
	 (detach enemy *game*))))

    (fork (:delay 400)
      (let ((enemy (make-instance 'enemy
				  :x (+ (/ *screen-width* 2) 100)
				  :y -30 :velocity 3)))
	(attach enemy *game*)
	(move-in-angle enemy 0 :duration 30)
	(fork (:delay 32 :repeat-delay 20 :repetitions 15)
	  (shoot-in-angle enemy (angle-from enemy (player (current-level *game*)))))
	(fork (:delay 300)
	  (setf (velocity enemy) 3)
	  (move-in-angle enemy 180 :duration 50))
	(fork (:delay 400)
	  (detach enemy *game*)))))



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

(fork (:delay 1700)
  (let* ((boss (make-instance 'small-enemy :x (- (/ *screen-width* 2) 100)
			     :y -200
			     :hp 1000
			     :image (load-image "bosses/small-boss-01")))
	 (weapon (make-instance 'weapon
				:x-offset 100
				:y-offset 100
				:owner boss
				:sps 50))
	 (generators (append (loop for i upto 35
				collect (make-instance 'generator
						       :ammo-sprite (load-image "bullets/8x8-bullet-01")
						       :firing-angle (* i 10)
						       :muzzle-velocity 3
						       :owner weapon
						       :x-offset -50
						       :y-offset -40))
			     (loop for i upto 20
				collect (make-instance 'generator
						       :ammo-sprite (load-image "bullets/8x8-bullet-01")
						       :firing-angle (* i 18)
						       :muzzle-velocity 4
						       :owner weapon
						       :x-offset -50
						       :y-offset -40))
			     (loop for i upto 71
				collect (make-instance 'generator
						       :ammo-sprite (load-image "bullets/8x8-bullet-01")
						       :firing-angle (+ 7 (* i 5))
						       :muzzle-velocity 1.8
						       :owner weapon
						       :x-offset -50
						       :y-offset -40)))))
    (setf (generators weapon) generators)
    (attach weapon boss)
    (attach boss *game*)
    (setf (velocity boss) 2)
    (move-in-angle boss 0 :duration 150)
    (fork (:delay 175)
      (setf (angle boss) -90)
      (setf (velocity boss) 0.5))

;;; First pattern:
    (fork (:delay 250)
      (fork (:repeat-delay 150 :repetitions 5)
	(setf (velocity boss) 0.5)
	(setf (angle boss) (* (angle boss) -1)))
      (fork (:delay 800)
	(setf (velocity boss) 0)))
    (fork (:delay 250)
      (fork (:repetitions 40 :repeat-delay 40)
	(mapc (lambda (generator)
		(incf (firing-angle generator)))
	      (generators (weapon boss)))
	(fire! boss)))
    (fork (:delay 2000)
      (setf (velocity boss) 0.5)
      (move-in-angle boss 180 :duration 600))
    (fork (:delay 2700)
      (detach boss *game*)
      (setf (game-over-p *game*) t))))


