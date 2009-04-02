;; This file is part of yashmup.

;; generator.lisp
;;
;; Contains code related to bullet generators. including the generator class.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass generator (game-object)
  ((ammo-class :initform (find-class 'projectile)
	       :accessor ammo-class)
   (owner :initarg :owner :initform (error "Bullet generator must belong to someone")
	  :accessor owner)
   (firing-angle :initarg :firing-angle :initform 0 :accessor firing-angle)
   (shots-per-second :initform 5 :accessor shots-per-second)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)))

(defgeneric fire! (obj)
  (:documentation "Makes OBJ fire sum bulletz"))

(defmethod update ((gen generator))
  (incf (frames-since-last-shot gen))
  (when (> (/ *default-framerate* (shots-per-second gen))
	   (frames-since-last-shot gen))
    (fire! gen)))

(defmethod fire! ((gen generator))
  (with-slots (x y angle) gen
    (let ((pew-pew (make-instance (ammo-class gen)
				  :x x :y y
				  :angle angle
				  :shooter gen)))
      (attach pew-pew *game*)
      (sdl-mixer:play-sample (sfx pew-pew))
      (setf (frames-since-last-shot gen) 0))))
