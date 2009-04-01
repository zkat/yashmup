;; This file is part of yashmup

;; ships.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;; Ships
(defclass ship (sprite) 
  ((velocity :initform 5)
   (firing-p :initform nil :accessor firing-p)
   (shot-limit :initform 4 :accessor shot-limit)
   (frames-since-last-shot :initform 0 :accessor frames-since-last-shot)
   (damage-taken :initform 0 :accessor damage-taken)))

;;; Generic functions
(defgeneric explode! (ship)
  (:documentation "Destroys the ship"))
