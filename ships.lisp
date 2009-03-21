(in-package :yashmup)

(defvar *projectiles* nil)

;;; Ships
(defclass ship (moving-sprite) 
  ((x-vel :initform 5)
   (y-vel :initform 5)
   (firing-p :initform nil :accessor firing-p)
   (shot-limit :initform 3 :accessor shot-limit)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)))

(defclass player-ship (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 100))
   (image :initform (gethash 'player-ship *resource-table*))))

(defclass enemy (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform 50)
   (x-vel :initform -2)
   (image :initform (gethash 'enemy *resource-table*))
   (damage :initform 0 :accessor damage)))

(defmethod update ((enemy enemy))
  (with-slots (x y x-vel damage) enemy
    (when (or (> x (- *screen-width* 150))
	      (< x 50))
      (setf x-vel (* x-vel -1)))
    (incf x x-vel)
    (when (> damage 300)
      (sdl:draw-string-shaded-* "HAHAHA PUNY HUMAN YOU CANNOT BEAT ME!"
				x (- y 10)
				sdl:*red*
				sdl:*black*))))

(defmethod update ((ship player-ship))
  (incf (frames-since-last-shot ship))
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
    (when (and (firing-p ship)
	       (> (frames-since-last-shot ship) (shot-limit ship)))
      (fire! ship))))

(defgeneric fire! (ship))
(defmethod fire! ((ship player-ship))
  (with-slots (x y) ship
    (let ((lazors (list (make-instance 'laser
				       :x (+ 24 x)
				       :y y
				       :shooter ship)
			(make-instance 'laser
				       :x x
				       :y (+ y 5)
				       :shooter ship)
			(make-instance 'laser
				       :x (+ 46 x)
				       :y (+ y 5)
				       :shooter ship))))
      (mapc (lambda (lazor)
	      (push lazor *projectiles*))
	    lazors)
      ;;	(play-sound lazor) ;; fucking sdl doesn't seem to like sound >:(
      (setf (frames-since-last-shot ship) 0))))