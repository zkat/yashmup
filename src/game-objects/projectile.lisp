;; This file is part of yashmup

;; projectile.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass projectile (sprite)
  ((shooter :initarg :shooter :accessor shooter)
   (image :initform (load-image "gif/bullet-3"))))

(defclass laser (projectile)
  ((velocity :initform 30)
   (image :initform (load-image "gif/bullet-8"))))

(defclass enemy-laser (projectile)
  ((velocity :initform 2)
   (image :initform (load-image "gif/bullet-9"))))

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
  (with-slots (x y)
      proj
    (incf x (horiz-velocity proj))
    (incf y (vert-velocity proj))
    (when (or (< y -10)
	      (> y 700))
      (detach proj *game*))))
