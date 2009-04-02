;; This file is part of yashmup

;; projectile.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass projectile (sprite)
  ((shooter :initarg :shooter :accessor shooter)
   (image :initform (load-image "gif/bullet-3"))
   (frames-left :initform 150 :accessor frames-left
		:documentation "How many frames left until this bullet dies?")))

(defclass laser (projectile)
  ((velocity :initform 30)
   (image :initform (load-image "gif/bullet-8"))
   (frames-left :initform 20)))

(defclass enemy-laser (projectile)
  ((velocity :initform 4)
   (image :initform (load-image "gif/bullet-9"))
   (frames-left :initform 150)))

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
      (detach proj *game*))))
