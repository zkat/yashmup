;; This file is part of yashmup

;; enemy.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Enemy class
;;;
(defclass enemy (ship)
  ((x :initform (random 450))
   (y :initform -30)
   (velocity :initform 3)
   (angle :initform 0)
   (image :initform (load-image "gif/enemy-3"))
   (destroyed-p :initform nil :accessor destroyed-p)))

(defmethod initialize-instance :after ((enemy enemy) &key)
  (let* ((weapon (make-instance 'weapon
				:owner enemy
				:sps 50
				:x-offset 20
				:y-offset 20))
	 (generators (list (make-instance 'generator
					  :ammo-class (find-class 'enemy-laser)
					  :x-offset -5
					  :firing-angle 0
					  :owner weapon)
			   (make-instance 'generator
					  :ammo-class (find-class 'enemy-laser)
					  :x-offset 5
					  :firing-angle 0
					  :owner weapon))))
    (setf (generators weapon) generators)
    (attach weapon enemy)))

;;; Enemy methods
(defmethod attach ((enemy enemy) (game game))
  (attach enemy (current-level game)))
(defmethod attach ((enemy enemy) (level level))
  (push enemy (enemies level)))
(defmethod detach ((enemy enemy) (level level))
  (setf (enemies level)
	(delete enemy (enemies level))))
(defmethod detach ((enemy enemy) (game game))
  (detach enemy (current-level game)))

(defmethod update ((enemy enemy))
  (with-slots (x y angle damage-taken) enemy
    (incf y (vert-velocity enemy))
    (incf x (horiz-velocity enemy))
    (update (weapon enemy))
    (when (> damage-taken 1)
      (explode! enemy))
    (when (collided-p (player (current-level *game*))
		      enemy)
      (crashed! (player (current-level *game*)) enemy)
      (incf (score (player (current-level *game*)))))))

(defmethod fire! ((enemy enemy))
  (unless (destroyed-p enemy)
    (fire! (weapon enemy))))

(defmethod explode! ((enemy enemy))
  (with-slots (x y) enemy
   (detach enemy *game*)
   (display-message "KABOOM" (- x 15) y 60)
   (setf (destroyed-p enemy) t)
   (incf (score (player (current-level *game*))))))
