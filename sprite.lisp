(in-package :yashmup)

;;;
;;; Static sprites
;;;
(defclass sprite ()
  ((x :initarg :x :initform 0 :accessor x)
   (y :initarg :y :initform 0 :accessor y)
   (image :initarg :image :initform (error "Must provide an image for this sprite") :accessor image)))

(defmethod width ((sprite sprite))
  (sdl:width (image sprite)))
(defmethod height ((sprite sprite))
  (sdl:height (image sprite)))

(defgeneric center (obj))
(defmethod center ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:point :x (floor (+ x (/ (sdl:width image) 2)))
	       :y (floor (+ y (/ (sdl:height image) 2))))))

(defgeneric draw (obj))
(defmethod draw ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:draw-surface-at-* image x y)))

(defgeneric update (obj))

;;; Collision detection
(defgeneric collided-p (obj1 obj2))
(defmethod collided-p ((sprite-1 sprite) (sprite-2 sprite))
  (loop
     for x1 from (x sprite-1) upto (+ (x sprite-1) (width sprite-1))
     do (loop for x2 from (x sprite-2) upto (+ (x sprite-2) (width sprite-2))
	   when (= x1 x2)
	   do (loop
		 for y1 from (y sprite-1) upto (+ (y sprite-1) (height sprite-1))
		 do (loop
		       for y2 from (y sprite-2) upto (+ (y sprite-2) (height sprite-2))
		       when (= y1 y2)
		       do (return-from collided-p t))))
     finally (return-from collided-p nil)))

;;;
;;; Moving Sprites
;;;
(defclass moving-sprite (sprite)
  ((velocity :initarg :velocity :initform 0 :accessor velocity)
   (angle :initarg :angle :initform 0 :accessor angle :documentation "Movement angle, in degrees")))

(defun degrees-to-radians (degrees)
  (* (/ degrees 180) pi))

;; These are FLOORed because SDL shits itself on floats
(defgeneric horiz-velocity (sprite))
(defmethod horiz-velocity ((obj moving-sprite))
  (floor (* (velocity obj) (sin (degrees-to-radians (angle obj))))))
(defgeneric vert-velocity (sprite))
(defmethod vert-velocity ((obj moving-sprite))
  (floor (* (velocity obj) (cos (degrees-to-radians (angle obj))))))

