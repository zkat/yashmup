;; This file is part of yashmup

;; weapon.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass weapon (game-object)
  ((owner :initarg :owner :accessor owner)
   (x-offset :initarg :x-offset :initform 0 :accessor x-offset)
   (y-offset :initarg :y-offset :initform 0 :accessor y-offset)
   (shots-per-second :initarg :sps :initform 10 :accessor shots-per-second)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)
   (sfx :initarg :sfx :initform nil :accessor sfx)
   (generators :initform nil :initarg :generators :accessor generators :type list)))

(defmethod update ((weapon weapon))
  (with-slots (x y x-offset y-offset owner generators frames-since-last-shot) weapon
    (setf x (+ (x owner) x-offset))
    (setf y (+ (y owner) y-offset))
    (mapc #'update generators)
    (incf frames-since-last-shot)))

(defmethod fire! ((weapon weapon))
  (when (<= (/ *default-framerate*
	       (shots-per-second weapon))
	    (frames-since-last-shot weapon))
    (mapc #'fire! (generators weapon))
    (when (sfx weapon)
      (sdl-mixer:play-sample (sfx weapon)))
    (setf (frames-since-last-shot weapon) 0)))

(defmethod attach ((weapon weapon) (ship ship))
  (setf (weapon ship) weapon))
