;; This file is part of yashmup

;; ships.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;; Ships
(defclass ship (sprite) 
  ((firing-p :initform nil :accessor firing-p)
   (weapon :initarg :weapon :accessor weapon)
   (hp :initform 5 :initarg :hp :accessor hp)))

;;; Generic functions
(defgeneric explode! (ship)
  (:documentation "Destroys the ship"))
