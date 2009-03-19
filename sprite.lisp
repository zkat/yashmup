(in-package :yashmup)


(defclass sprite ()
  ((x
    :initarg :x
    :initform 0
    :accessor x)
   (y
    :initarg :y
    :initform 0
    :accessor y)
   (image
    :initarg :image
    :initform (error "Must provide an image for this sprite")
    :accessor image)))

(defmethod width ((sprite sprite))
  (sdl:width (image sprite)))
(defmethod height ((sprite sprite))
  (sdl:height (image sprite)))

(defgeneric center (obj))
(defmethod center ((sprite sprite))
  (with-slots (image x y)
      ship
    (sdl:point :x (floor (+ x (/ (sdl:width image) 2)))
	       :y (floor (+ y (/ (sdl:height image) 2))))))

(defgeneric draw (obj))
(defmethod draw ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:draw-surface-at-* image x y)))

(defgeneric update (obj))
(defmethod update ((sprite sprite))
  (values))

(defgeneric collided-p (obj1 obj2))
(defmethod collided-p ((sprite-1 sprite) (sprite-2 sprite))
  
  )

