;; This file is part of yashmup

;; level.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Level Class
;;;
(defclass level ()
  ((event-queue :initform (make-event-queue) :accessor event-queue)
   (current-frame :initform 0 :accessor current-frame)
   (player :initform (make-instance 'player) :accessor player)
   (background :initform (make-instance 'background) :accessor background) 
   (projectiles :initform nil :accessor projectiles)
   (enemies :initform nil :accessor enemies)
   (messages :initform nil :accessor messages)))

(defvar *level*)
(defun load-level (name)
  "Loads a level script and returns the configured LEVEL object."
  ;; WHY DOES THIS SUCK SO MUCH? PLEASE EXPLAIN
  (let ((*level* (make-instance 'level)))
    (load (merge-pathnames (concatenate 'string name ".lisp") *level-path*))
    *level*))

;;;
;;; Generic functions
;;;

;;; Methods
(defmethod update ((level level))
  "Takes care of calling UPDATE on all of LEVEL's member objects. Also, resolves collisions"
  (with-slots (background player projectiles enemies messages current-frame) level
    (process-cooked-events level)
    (incf current-frame)
    (update background)
    (mapc #'update projectiles)
    (update player)
    (mapc #'update enemies)
    (mapc #'update messages)
    (resolve-collisions level)))

(defmethod draw ((level level))
  (with-slots (background player projectiles enemies messages) level
    (draw background)
    (mapc #'draw messages)
    (draw player)
    (mapc #'draw enemies)
    (mapc #'draw projectiles)
    (sdl:draw-string-shaded-* (format nil "Player damage: ~a" (damage-taken (player level)))
			      5 5 sdl:*red* (sdl:color :a 0))
    (sdl:draw-string-shaded-* (format nil "Enemies downed: ~a" (score (player level)))
			      5 15 sdl:*red* (sdl:color :a 0))
    (sdl:draw-string-shaded-* (format nil "Current frame: ~a" (current-frame level))
			      5 25 sdl:*red* (sdl:color :a 0))))

(defmethod resolve-collisions ((level level))
  (with-slots (enemies projectiles player) level
    (loop for enemy in enemies
       do (loop for projectile in projectiles
	     do (cond ((and (eql (weapon player)
				 (shooter projectile))
			    (collided-p projectile enemy))
		       (incf (damage-taken enemy))
		       (setf projectiles (delete projectile projectiles)))
		      ((collided-p projectile player)
		       (incf (damage-taken player))
		       (setf projectiles (delete projectile projectiles)))
		      (t 
		       (values)))))))