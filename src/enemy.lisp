;; This file is part of yashmup

;; enemy.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *enemies* nil)
(defclass enemy (ship)
  ((x :initform (random 450))
   (y :initform -30)
   (velocity :initform 3)
   (angle :initform 0)
   (image :initform (gethash 'enemy-small *resource-table*))))

(defmethod update ((enemy enemy))
  (with-slots (x y angle damage frames-since-last-shot) enemy
    (incf y (vert-velocity enemy))
    (incf frames-since-last-shot)
    (when (> frames-since-last-shot 30)
      (fire! enemy))
    (when (or (> y 800)
	      (> damage 5))
      (setf (enemies *game*) (delete enemy (enemies *game*)))
      (display-message "KABOOM" (- x 15) y 60)
      (incf (score (player *game*))))
    (when (collided-p (player *game*)
		      enemy)
      (crashed! (player *game*) enemy)
      (incf (score (player *game*))))))

(defun crashed! (obj1 obj2)
  (incf (damage obj1) 10)
  (incf (damage obj2) 10))

(defmethod fire! ((enemy enemy))
    (with-slots (x y) enemy
    (let ((lazors (list (make-instance 'enemy-laser
				       :x (+ 15 x)
				       :y (+ y 23)
				       :velocity 5
				       :shooter enemy)
			(make-instance 'enemy-laser
				       :x (+ x 8)
				       :y (+ y 23)
				       :velocity 5
				       :shooter enemy))))
      (setf (projectiles *game*)
	    (append lazors (projectiles *game*)))
      ;; (play-sound lazor) ;; fucking sdl doesn't seem to like sound >:(
      (setf (frames-since-last-shot enemy) 0))))

