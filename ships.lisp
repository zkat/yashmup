(in-package :yashmup)

(defvar *projectiles* nil)

;;; Ships
(defclass ship (moving-sprite) 
  ((x-vel :initform 5)
   (y-vel :initform 5)))

(defclass player-ship (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 100))
   (firing-p :initform nil :accessor firing-p)
   (image :initform (gethash 'player-ship *resource-table*))))

(defclass enemy (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform 50)
   (x-vel :initform -3)
   (image :initform (gethash 'enemy *resource-table*))
   (damage :initform 0 :accessor damage)))

(defmethod update ((enemy enemy))
  (with-slots (x x-vel) enemy
    (when (or (> x (- *screen-width* 200))
	      (< x 50))
      (setf x-vel (* x-vel -1)))
    (incf x x-vel)))

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
