;; This file is part of yashmup

;; background.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass background (sprite)
  ((y :initform -1600)
   (image :initform (load-image "backgrounds/background-01" :ext ".png"))
   (scroll-speed :initform 1 :accessor scroll-speed)))

(defmethod update ((bg background))
  (with-slots (y scroll-speed) bg
    (if (<= 0 y)
  	(setf y -1600)
  	(incf y scroll-speed))))

(defmethod draw ((bg background))
  (with-slots (image x y)
      bg
    (sdl:draw-surface-at-* image (floor x) (floor (+ y 1600)))
    (sdl:draw-surface-at-* image (floor x) (floor y))))