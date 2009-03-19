(in-package :yashmup)

;;; Ships
(defclass ship (sprite) 
  ((x-vel :initform 4)
   (y-vel :initform 4)
   (shots :initform nil :accessor shots)))

(defclass player-ship (ship)
  ((x-loc :initform (/ *screen-width* 2))
   (y-loc :initform (- *screen-height* 100))
   (firing-p :initform nil :accessor firing-p)))


(defmethod update ((ship player-ship))
  (with-slots ((x x-loc)
	       (y y-loc)
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
			   :x-loc (+ 25 (x-loc ship))
			   :y-loc (+ (y-loc ship) 35)
			   :shooter ship)
	    (shots ship)))))

;;; pew pew
(defclass laser (game-object)
  ((x-vel :initform 0)
   (y-vel :initform -20)
   (graphic :initform *laser-image*)
   (shooter :initarg :shooter :accessor shooter)))

(defmethod update ((laser laser))
  (with-slots ((x x-loc)
	       (y y-loc)
	       (dx x-vel)
	       (dy y-vel))
      laser
    (incf x dx)
    (incf y dy)
    (when (< y -10)
      (setf (shots (shooter laser))
	    (delete laser (shots (shooter laser)))))))