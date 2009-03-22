;; This file is part of yashmup

;; projectile.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass projectile (moving-sprite)
  ((shooter :initarg :shooter :accessor shooter)
   (image :initform (gethash 'bullet1 *resource-table*))))

(defclass laser (projectile)
  ((velocity :initform 30)
   (image :initform (gethash 'laser1 *resource-table*))))

(defclass enemy-laser (projectile)
  ((velocity :initform 3)
   (image :initform (gethash 'laser2 *resource-table*))))

(defmethod update ((proj projectile))
  (with-slots (x y)
      proj
    (incf x (horiz-velocity proj))
    (incf y (vert-velocity proj))
    (when (or (< y -10)
	      (> y 850))
      (setf (projectiles *game*)
	    (delete proj (projectiles *game*))))))
