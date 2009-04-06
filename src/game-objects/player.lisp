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
   (hitbox-x-offset :initform 25)
   (hitbox-y-offset :initform 36)
   (hitbox-height :initform 1)
   (hitbox-width :initform 1)))

(defmethod initialize-instance :after ((player player) &key)
  (let* ((weapon (make-instance 'weapon
				:owner player
				:sps 10
				:sfx (load-sample "sfx/pew")
				:x-offset 25
				:y-offset 36))
	 (generators (list (make-instance 'generator
					  :x-offset -15
					  :y-offset -30
					  :firing-angle 180
					  :owner weapon
					  :ammo-class (find-class 'laser))
			   (make-instance 'generator
					  :x-offset -6
					  :y-offset -35
					  :firing-angle 180
					  :owner weapon
					  :ammo-class (find-class 'laser))
			   (make-instance 'generator
					  :x-offset 4
					  :y-offset -35
					  :firing-angle 180
					  :owner weapon
					  :ammo-class (find-class 'laser))
			   (make-instance 'generator
					  :x-offset 14
					  :y-offset -30
					  :firing-angle 180
					  :owner weapon
					  :ammo-class (find-class 'laser)))))
    (setf (generators weapon) generators)
    (attach weapon player)))

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

(defmethod collided-p ((sprite-1 sprite) (sprite-2 player))
  "Checks whether two sprites have collided."
  (let* ((sprite-1-hitbox-x (+ (x sprite-1) (hitbox-x-offset sprite-1)))
	 (sprite-1-hitbox-y (+ (y sprite-1) (hitbox-y-offset sprite-1)))
	 (sprite-2-hitbox-x (+ (x sprite-2) (hitbox-x-offset sprite-2)))
	 (sprite-2-hitbox-y (+ (y sprite-2) (hitbox-x-offset sprite-2))))
    ;; This version naively loops through all coordinates of both hitboxes, and finds overlaps.
    (when (and (< sprite-1-hitbox-x sprite-2-hitbox-x)
	       (> (+ (hitbox-width sprite-1) sprite-1-hitbox-x)
		  sprite-2-hitbox-x)
	       (< sprite-1-hitbox-y sprite-2-hitbox-y)
	       (> (+ (hitbox-height sprite-1) sprite-1-hitbox-y)
		  sprite-2-hitbox-y))
      t)))

(defmethod collided-p ((sprite-1 player) (sprite-2 sprite))
  (collided-p sprite-2 sprite-1))