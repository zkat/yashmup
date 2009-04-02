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
   (shots-per-second :initarg :sps :initform 10 :accessor shots-per-second)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)))

(defgeneric fire! (obj)
  (:documentation "Makes OBJ fire sum bulletz"))

(defmethod update ((gen generator))
  (incf (frames-since-last-shot gen)))

(defmethod fire! ((gen generator))
  (when (<= (/ *default-framerate* 
	       (shots-per-second gen))
	    (frames-since-last-shot gen))
    (with-slots (x y firing-angle owner) gen
      (let ((pew-pew (make-instance (ammo-class gen)
				    :x x :y y
				    :angle firing-angle
				    :shooter owner)))
	(attach pew-pew *game*)
	(sdl-mixer:play-sample (sfx pew-pew))
	(setf (frames-since-last-shot gen) 0)))))
