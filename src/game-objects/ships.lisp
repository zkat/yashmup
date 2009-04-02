;; This file is part of yashmup

;; ships.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;; Ships
(defclass ship (sprite) 
  ((velocity :initform 5)
   (firing-p :initform nil :accessor firing-p)
   (weapon :initarg :weapon :accessor weapon)
   (damage-taken :initform 0 :accessor damage-taken)))

;;; Generic functions
(defgeneric explode! (ship)
  (:documentation "Destroys the ship"))
