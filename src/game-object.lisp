;; This file is part of yashmup

;; game-object.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Base Game Object class
;;;
(defclass game-object ()
  ((x :initarg :x :initform 0 :accessor x)
   (y :initarg :y :initform 0 :accessor y)
   (velocity :initarg :velocity :initform 0 :accessor velocity)
   (angle :initarg :angle :initform 0 :accessor angle :documentation "Movement angle, in degrees")))

;;;
;;; Generic functions
;;;
(defgeneric center (obj)
  (:documentation "Returns an SDL:POINT object containing the coordinates that
 should be used as OBJ's center point"))
(defgeneric update (obj)
  (:documentation "Run once per frame, this function does a one-step update OBJ"))
(defgeneric attach (obj game)
  (:documentation "Registers OBJ with GAME"))
(defgeneric detach (obj game)
  (:documentation "Unregisters OBJ from GAME, effectively removing GAME's reference to it."))
(defgeneric horiz-velocity (obj)
  (:documentation "Returns a fixnum approximating the current horizontal velocity of OBJ"))
(defgeneric vert-velocity (obj)
  (:documentation "Returns a fixnum approximating the current vertical velocity of OBJ"))

;;; Methods
(defmethod center ((obj game-object))
  (sdl:point :x (x obj) :y (y obj)))

(defmethod horiz-velocity ((obj game-object))
  (floor (* (velocity obj) (sin (degrees-to-radians (angle obj))))))

(defmethod vert-velocity ((obj game-object))
  (floor (* (velocity obj) (cos (degrees-to-radians (angle obj))))))
