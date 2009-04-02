;; This file is part of yashmup.

;; generator.lisp
;;
;; Contains code related to bullet generators. including the generator class.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass generator (game-object)
  ((ammo-class :initform (find-class 'projectile)
	       :initarg :ammo-class
	       :accessor ammo-class)
   (owner :initarg :owner :initform (error "Bullet generator must belong to someone")
	  :accessor owner)
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
  (with-slots (x y firing-angle owner) gen
    (let ((pew-pew (make-instance (ammo-class gen)
				  :x x :y y
				  :angle firing-angle
				  :shooter owner)))
      (attach pew-pew *game*))))
