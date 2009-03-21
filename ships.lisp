(in-package :yashmup)

(defvar *projectiles* nil)

;;; Ships
(defclass ship (moving-sprite) 
  ((velocity :initform 5)
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
   (velocity :initform 2)
   (angle :initform 90)
   (image :initform (gethash 'enemy *resource-table*))
   (damage :initform 0 :accessor damage)))

(defmethod update ((enemy enemy))
  (with-slots (x y angle damage) enemy
    (when (or (> x (- *screen-width* 150))
	      (< x 50))
      (setf angle (* angle -1)))
    (incf x (horiz-velocity enemy))
    (when (> damage 300)
      (sdl:draw-string-shaded-* "HAHAHA PUNY HUMAN YOU CANNOT HOPE TO DEFEAT ME!"
				x (- y 10)
				sdl:*red*
				sdl:*black*))))

(defmethod update ((ship player-ship))
  (incf (frames-since-last-shot ship))
  (with-slots (x y) ship
    (when (key-down-p :sdl-key-left)
      (setf (angle ship) 270)
      (incf x (horiz-velocity ship)))
    (when (key-down-p :sdl-key-right)
      (setf (angle ship) 90)
      (incf x (horiz-velocity ship)))
    (when (key-down-p :sdl-key-up)
      (setf (angle ship) 180)
      (incf y (vert-velocity ship)))
    (when (key-down-p :sdl-key-down)
      (setf (angle ship) 0)
      (incf y (vert-velocity ship)))
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
				       :x (+ 17 x)
				       :y (- y 3)
				       :angle 180
				       :shooter ship)
			(make-instance 'laser
				       :x (+ x 8)
				       :y (+ y 5)
				       :angle 180
				       :shooter ship)
			(make-instance 'laser
				       :x (+ x 30)
				       :y (- y 3)
				       :angle 180
				       :shooter ship)
			(make-instance 'laser
				       :x (+ 40 x)
				       :y (+ y 5)
				       :angle 180
				       :shooter ship))))
      (mapc (lambda (lazor)
	      (push lazor *projectiles*))
	    lazors)
      ;;	(play-sound lazor) ;; fucking sdl doesn't seem to like sound >:(
      (setf (frames-since-last-shot ship) 0))))