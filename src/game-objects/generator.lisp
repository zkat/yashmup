;; This file is part of yashmup.

;; generator.lisp
;;
;; Contains code related to bullet generators. including the generator class.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass generator (game-object)
  ((ammo-sprite :initform (load-image "bullets/7x7-bullet-01")
		:initarg :ammo-sprite
		:accessor ammo-sprite)
   (owner :initarg :owner :initform (error "Bullet generator must belong to someone")
	  :accessor owner)
   (muzzle-velocity :initarg :muzzle-velocity :initform 4 :accessor muzzle-velocity)
   (firing-angle :initarg :firing-angle :initform 0 :accessor firing-angle)
   (x-offset :initform 0 :initarg :x-offset :accessor x-offset)
   (y-offset :initform 0 :initarg :y-offset :accessor y-offset)))

(defgeneric fire! (obj)
  (:documentation "Makes OBJ fire sum bulletz"))

(defmethod update ((gen generator))
  (with-slots (x y x-offset y-offset owner) gen
      (setf x (+ (x owner) x-offset))
    (setf y (+ (y owner) y-offset))))

(defmethod fire! ((gen generator))
  (with-slots (ammo-sprite x y firing-angle owner muzzle-velocity) gen
    (let ((pew-pew (make-instance 'projectile
				  :x x :y y
				  :image ammo-sprite
				  :angle firing-angle
				  :velocity muzzle-velocity
				  :shooter owner)))
      (attach pew-pew *game*))))
