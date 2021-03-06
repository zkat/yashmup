;; This file is part of yashmup

;; player.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Player class
;;;
(defclass player (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 80))
   (image :initform (load-image "sweet-ship"))
   (score :initform 0 :accessor score)
   (lives :initform 3 :accessor lives)
   (dead-p :initform nil :accessor dead-p)
   (respawn-time :initform 2 :accessor respawn-time)
   (velocity :initform 4)
   (hitbox-x-offset :initform 25)
   (hitbox-y-offset :initform 36)
   (hitbox-radius :initform 1)))

(defmethod initialize-instance :after ((player player) &key)
  (unless (slot-boundp player 'weapon)
    (let* ((weapon (make-instance 'weapon
				  :owner player
				  :sps 10
				  :sfx (let ((sample (load-sample "sfx/pew")))
					 (setf (sdl-mixer:sample-volume sample) 20)
					 sample)
				  :x-offset 25
				  :y-offset 36))
	   (generators (list (make-instance 'generator
					    :x-offset -15
					    :y-offset -30
					    :firing-angle 180
					    :muzzle-velocity 30
					    :owner weapon
					    :ammo-sprite (load-image "bullets/2x10-bullet-01"))
			     (make-instance 'generator
					    :x-offset -6
					    :y-offset -35
					    :firing-angle 180
					    :muzzle-velocity 30
					    :owner weapon
					    :ammo-sprite (load-image "bullets/2x10-bullet-01"))
			     (make-instance 'generator
					    :x-offset 4
					    :y-offset -35
					    :muzzle-velocity 30
					    :firing-angle 180
					    :owner weapon
					    :ammo-sprite (load-image "bullets/2x10-bullet-01"))
			     (make-instance 'generator
					    :x-offset 14
					    :y-offset -30
					    :muzzle-velocity 30
					    :firing-angle 180
					    :owner weapon
					    :ammo-sprite (load-image "bullets/2x10-bullet-01")))))
      (setf (generators weapon) generators)
      (attach weapon player))))

;;; Player methods
(defmethod attach ((player player) (level level))
  (setf (player level) player))
(defmethod detach ((player player) (level level))
  (setf (player level) nil))
(defmethod attach ((player player) (game game))
  (attach player (current-level game)))
(defmethod detach ((player player) (game game))
  (detach player (current-level game)))

(defmethod update ((player player))
  (update (weapon player))
  (with-slots (x y) player
    (when (key-down-p :sdl-key-left)
      (unless (>= 0 x)
       (setf (slot-value player 'angle) -90)
       (incf x (horiz-velocity player))))
    (when (key-down-p :sdl-key-right)
      (unless (<= *screen-width* (+ x (width player)))
       (setf (slot-value player 'angle) 90)
       (incf x (horiz-velocity player))))
    (when (key-down-p :sdl-key-up)
      (unless (>= 0 y)
       (setf (slot-value player 'angle) 180)
       (incf y (vert-velocity player))))
    (when (key-down-p :sdl-key-down)
      (unless (<= *screen-height* (+ y (height player)))
       (setf (slot-value player 'angle) 0)
       (incf y (vert-velocity player))))
    (if (key-down-p :sdl-key-space)
  	(setf (firing-p player) t)
  	(setf (firing-p player) nil))
    (when (firing-p player)
      (fire! player))))

(defmethod fire! ((player player))
  (fire! (weapon player)))

(defmethod explode! ((player player))
  (decf (lives player))
  (setf (dead-p player) t)
  (if (>= (lives player) 0)
      (fork (:delay (* 60 (respawn-time player)))
	(respawn player))
      (setf (game-over-p *game*) t)))

(defgeneric respawn (obj))
(defmethod respawn ((player player))
  (setf (dead-p player) nil)
  (setf (x player) (/ *screen-width* 2))
  (setf (y player) (- *screen-height* 80)))
