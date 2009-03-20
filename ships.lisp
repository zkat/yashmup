(in-package :yashmup)

(defvar *projectiles* nil)

;;; Ships
(defclass ship (moving-sprite) 
  ((x-vel :initform 4)
   (y-vel :initform 4)))

(defclass player-ship (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 100))
   (firing-p :initform nil :accessor firing-p)
   (image :initform (gethash 'player-ship *resource-table*))))

(defmethod update ((ship player-ship))
  (with-slots ((x x)
	       (y y)
	       (dx x-vel)
	       (dy y-vel))
      ship
    (when (key-down-p :sdl-key-left)
      (decf x dx))
    (when (key-down-p :sdl-key-right)
      (incf x dx))
    (when (key-down-p :sdl-key-up)
      (decf y dy))
    (when (key-down-p :sdl-key-down)
      (incf y dy))
    (if (key-down-p :sdl-key-space)
	(setf (firing-p ship) t)
	(setf (firing-p ship) nil))
    (when (firing-p ship)
      (push (make-instance 'laser
			   :x (+ 24 x)
			   :y y
			   :shooter ship)
	    *projectiles*))))

;;; pew pew
(defclass projectile (moving-sprite)
  ((shooter :initarg :shooter :accessor shooter)))

(defclass laser (projectile)
  ((x-vel :initform 0)
   (y-vel :initform -20)
   (image :initform (gethash 'laser *resource-table*))))

(defmethod update ((laser laser))
  (with-slots ((x x)
	       (y y)
	       (dx x-vel)
	       (dy y-vel))
      laser
    (incf x dx)
    (incf y dy)
    (when (< y -10)
      (setf *projectiles*
	    (delete laser *projectiles*)))))