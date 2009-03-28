;; This file is part of yashmup

;; level.lisp
;;
;; TODO - 
;; * Get a better definition of what a level is, and refactor things accordingly.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Level Class
;;;
(defclass level ()
  ((event-queue :initform (make-event-queue) :accessor event-queue) ;allows per-level event loading
   (current-frame :initform 0 :accessor current-frame) ;useful on a per-level basis
   (background :initform (make-instance 'background) :accessor background) ;level-specific
   (projectiles :initform nil :accessor projectiles) ;level-specific
   (enemies :initform nil :accessor enemies) ;also level-specific
   (messages :initform nil :accessor messages))) ;why do these things even still exist, wtf

(defun load-level (name)
  ;; todo. This should handle loading of necessary resources.
  ;; Note: This will almost definitely require a rewrite of the resource-loading system. Ugh.
  name
  )

;;;
;;; Generic functions
;;;

;;; Methods
(defmethod update ((level level))
  (with-slots (background projectiles enemies messages) level
    (update background)
    (mapc #'update projectiles)
    (mapc #'update enemies)
    (update (player *game*))
    (mapc #'update messages)
    (resolve-collisions level)))

(defmethod draw ((level level))
  (draw (background level))
  (mapc #'draw (messages level))
  (sdl:draw-string-shaded-* (format nil "Player damage: ~a" (damage-taken (player *game*)))
			    5 5 sdl:*red* (sdl:color :a 0))
  (sdl:draw-string-shaded-* (format nil "Enemies downed: ~a" (score (player *game*)))
			    5 15 sdl:*red* (sdl:color :a 0))
  (draw (player *game*))
  (mapc #'draw (enemies level))
  (mapc #'draw (projectiles level)))

(defmethod resolve-collisions ((level level))
  (loop for enemy in (enemies level)
       do (loop for projectile in (projectiles level)
	     do (cond ((and (eql (player level)
				 (shooter projectile))
			    (collided-p projectile enemy))
		       (incf (damage-taken enemy))
		       (setf (projectiles level) (delete projectile (projectiles level))))
		      ((collided-p projectile (player level))
		       (incf (damage-taken (player level)))
		       (setf (projectiles level) (delete projectile (projectiles level))))
		      (t 
		       (values))))))