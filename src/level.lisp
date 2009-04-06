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

(defun load-level (name)
  "Loads a level script and returns the configured LEVEL object."
  (let ((*game* (make-instance 'game
			       :current-level (make-instance 'level))))
    (load (merge-pathnames (concatenate 'string name ".lisp") *level-path*))
    (current-level *game*)))

;;;
;;; Generic functions
;;;

;;; Methods
(defmethod update ((level level))
  "Takes care of calling UPDATE on all of LEVEL's member objects. Also, resolves collisions"
  (with-slots (background player projectiles enemies messages current-frame) level
    (unless (dead-p player)
      (resolve-collisions level))
    (process-cooked-events level)
    (incf current-frame)
    (update background)
    (mapc #'update projectiles)
    (unless (dead-p player)
      (update player))
    (mapc #'update enemies)
    (mapc #'update messages)))

(defmethod draw ((level level))
  (with-slots (background player projectiles enemies messages) level
    (draw background)
    (mapc #'draw messages)
    (unless (dead-p player)
      (draw player))
    (mapc #'draw enemies)
    (mapc #'draw projectiles)
    (sdl:draw-string-shaded-* (format nil "Lives left: ~a" (lives (player level)))
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
		       (decf (hp enemy))
		       (setf projectiles (delete projectile projectiles)))
		      ((collided-p projectile player)
		       (explode! player)
		       (explode! projectile)
		       (return-from resolve-collisions))
		      ((collided-p player enemy)
		       (explode! player)
		       (explode! enemy)
		       (return-from resolve-collisions))
		      (t 
		       (values)))))))