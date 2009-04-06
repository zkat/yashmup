;; This file is part of yashmup

;; projectile.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass projectile (sprite)
  ((shooter :initarg :shooter :accessor shooter)
   (image :initform (load-image "bullets/7x7-bullet-01"))
   (frames-left :initform 300 :accessor frames-left
		:documentation "How many frames left until this bullet dies?")))

(defclass laser (projectile)
  ((velocity :initform 30)
   (image :initform (load-image "bullets/2x10-bullet-01"))
   (frames-left :initform 20)))

(defclass enemy-laser (projectile)
  ((velocity :initform 4)
   (image :initform (load-image "bullets/8x8-bullet-01"))
   (frames-left :initform 300)))

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