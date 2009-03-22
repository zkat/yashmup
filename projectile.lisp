(in-package :yashmup)

(defclass projectile (moving-sprite)
  ((shooter :initarg :shooter :accessor shooter)))

(defclass laser (projectile)
  ((velocity :initform 30)
   (image :initform (gethash 'laser *resource-table*))))

(defmethod update ((laser laser))
  (with-slots (x y)
      laser
    (incf x (horiz-velocity laser))
    (incf y (vert-velocity laser))
    (when (or (< y -10)
	      (> y 850))
      (setf (projectiles *game*)
	    (delete laser (projectiles *game*))))))
