;; This file is part of yashmup

;; player.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Player class
;;;
(defclass player (ship)
  ((x :initform (/ *screen-width* 2))
   (y :initform (- *screen-height* 50))
   (image :initform (gethash 'player-ship *resource-table*))
   (pew :initform (gethash 'laser-sample *resource-table*) :accessor pew)
   (score :initform 0 :accessor score)
   (hitbox-x-offset :initform 24)
   (hitbox-y-offset :initform 35)
   (hitbox-height :initform 3)
   (hitbox-width :initform 3)))

;;; Player methods
(defmethod attach ((player player) (game game))
  (setf (player game) player))
(defmethod detach ((player player) (game game))
  (setf (player game) nil))

(defmethod update ((player player))
  (incf (frames-since-last-shot player))
  (with-slots (x y) player
    (when (key-down-p :sdl-key-left)
      (unless (>= 0 x)
       (setf (slot-value player 'angle) 270)
       (incf x (horiz-velocity player))))
    (when (key-down-p :sdl-key-right)
      (unless (<= *screen-width* (+ x (width player)))
       (setf (slot-value player 'angle) 90)
       (incf x (horiz-velocity player))))
    (when (key-down-p :sdl-key-up)
      (unless (>= 0 y)
       (setf (slot-value player 'angle) 180)
       (incf y (vert-velocity player))))
    (when (key-down-p :sdl-key-down)
      (unless (<= *screen-height* (+ y (height player)))
       (setf (slot-value player 'angle) 0)
       (incf y (vert-velocity player))))
    (if (key-down-p :sdl-key-space)
  	(setf (firing-p player) t)
  	(setf (firing-p player) nil))
    (when (and (firing-p player)
  	       (> (frames-since-last-shot player) (shot-limit player)))
      (fire! player))))

(defmethod fire! ((player player))
  (with-slots (x y) player
    (let ((lazors (list (make-instance 'laser
				       :x (+ 17 x)
				       :y (- y 3)
				       :angle 180
				       :shooter player)
			(make-instance 'laser
				       :x (+ x 8)
				       :y (+ y 5)
				       :angle 180
				       :shooter player)
			(make-instance 'laser
				       :x (+ x 30)
				       :y (- y 3)
				       :angle 180
				       :shooter player)
			(make-instance 'laser
				       :x (+ 40 x)
				       :y (+ y 5)
				       :angle 180
				       :shooter player))))
      (dolist (lazor lazors) (attach lazor *game*))
      (sdl-mixer:play-sample (pew player))
      (setf (frames-since-last-shot player) 0))))
