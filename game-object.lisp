(in-package :yashmup)

(defclass game-object ()
  ((x-loc
    :initarg :x-loc
    :initform 0
    :accessor x-loc)
   (y-loc
    :initarg :y-loc
    :initform 0
    :accessor y-loc)
   (x-vel
    :initform 0
    :accessor x-vel)
   (y-vel
    :initform 0
    :accessor y-vel)
   (graphic
    :initarg :graphic
    :initform nil
    :accessor graphic)
   (hitbox-size
    :initform 3
    :accessor hitbox-size)))

(defgeneric draw (obj))
(defmethod draw ((obj game-object))
  (with-slots ((graphic graphic)
	       (x x-loc)
	       (y y-loc))
      obj
    (sdl:draw-surface-at-* graphic x y)))

(defgeneric move (obj))