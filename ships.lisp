(in-package :yashmup)

;;; Ships
(defclass ship (moving-sprite) 
  ((velocity :initform 5)
   (firing-p :initform nil :accessor firing-p)
   (shot-limit :initform 4 :accessor shot-limit)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)))

(defclass player-ship (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 100))
   (image :initform (gethash 'player-ship *resource-table*))))

(defmethod update ((ship player-ship))
  (incf (frames-since-last-shot ship))
  (with-slots (x y) ship
    (when (key-down-p :sdl-key-left)
      (unless (>= 0 x)
       (setf (slot-value ship 'angle) 270)
       (incf x (horiz-velocity ship))))
    (when (key-down-p :sdl-key-right)
      (unless (<= *screen-width* (+ x (width ship)))
       (setf (slot-value ship 'angle) 90)
       (incf x (horiz-velocity ship))))
    (when (key-down-p :sdl-key-up)
      (unless (>= 0 y)
       (setf (slot-value ship 'angle) 180)
       (incf y (vert-velocity ship))))
    (when (key-down-p :sdl-key-down)
      (unless (<= *screen-height* (+ y (height ship)))
       (setf (slot-value ship 'angle) 0)
       (incf y (vert-velocity ship))))
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
	      (push lazor (projectiles *game*)))
	    lazors)
      ;;	(play-sound lazor) ;; fucking sdl doesn't seem to like sound >:(
      (setf (frames-since-last-shot ship) 0))))