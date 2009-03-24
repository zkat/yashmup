;; This file is part of yashmup

;; enemy.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defclass enemy (ship)
  ((x :initform (random 450))
   (y :initform -30)
   (velocity :initform 3)
   (angle :initform 0)
   (image :initform (gethash 'enemy-small *resource-table*))))

(defmethod attach ((enemy enemy) (game game))
  (push enemy (enemies game)))

(defmethod detach ((enemy enemy) (game game))
  (setf (enemies game)
	(delete enemy (enemies game))))

(defmethod update ((enemy enemy))
  (with-slots (x y angle damage frames-since-last-shot) enemy
    (incf y (vert-velocity enemy))
    (incf frames-since-last-shot)
    (when (> damage 5)
      (detach enemy *game*)
      (display-message "KABOOM" (- x 15) y 60)
      (incf (score (player *game*))))
    (when (> y 800) ;; this will only stay until the cascade stops
      (detach enemy *game*))
    (when (collided-p (player *game*)
		      enemy)
      (crashed! (player *game*) enemy)
      (incf (score (player *game*))))))

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
      (dolist (lazor lazors) (attach lazor *game*))
      (setf (frames-since-last-shot enemy) 0))))
