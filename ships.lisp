(in-package :yashmup)

;;; Ships
(defclass ship (game-object) 
  ((x-vel :initform 4)
   (y-vel :initform 4)))

(defclass player-ship (ship)
  ((x-loc :initform (/ *screen-width* 2))
   (y-loc :initform (- *screen-height* 100))
   (graphic :initform (load-player-ship-image))
   (firing-p :initform nil :accessor firing-p)
   (missiles :initform nil :accessor missiles)))

;;; Missiles
(defclass missile (game-object)
  ((x-vel :initform 0)
   (y-vel :initform -20)
   (shooter :initarg :shooter :accessor shooter)))

(defmethod draw ((missile missile))
  (with-slots ((x x-loc)
	       (y y-loc))
      missile
    (sdl:draw-line-* x y x (+ y 10) :color sdl:*red*)))

(defmethod move ((missile missile))
  (with-slots ((x x-loc)
	       (y y-loc)
	       (dx x-vel)
	       (dy y-vel))
      missile
    (incf x dx)
    (incf y dy)
    (when (< y -10)
      (setf (missiles (shooter missile))
	    (delete missile (missiles (shooter missile)))))))