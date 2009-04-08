;; This file is part of yashmup

;; projectile.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass projectile (sprite)
  ((shooter :initform (error "projectiles must have a shooter associated with them")
	    :initarg :shooter :accessor shooter)
   ;; This should be configurable by generators, and weapons.
   (frames-left :initform 300 :accessor frames-left
		:documentation "How many frames left until this bullet dies?")))

(defmethod attach ((proj projectile) (level level))
  (push proj (projectiles level)))
(defmethod detach ((proj projectile) (level level))
  (setf (projectiles level)
	(delete proj (projectiles level))))

(defmethod attach ((proj projectile) (game game))
  (attach proj (current-level game)))
(defmethod detach ((proj projectile) (game game))
  (detach proj (current-level game)))

(defmethod update ((proj projectile))
  (with-slots (x y frames-left)
      proj
    (incf x (horiz-velocity proj))
    (incf y (vert-velocity proj))
    (decf frames-left)
    (when (<= frames-left 0)
      (detach proj *game*))
    (when (dead-p (player (current-level *game*)))
      (explode! proj))))

(defmethod explode! ((proj projectile))
  (detach proj *game*))