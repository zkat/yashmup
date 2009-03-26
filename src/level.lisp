;; This file is part of yashmup

;; level.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Level Class
;;;
(defclass level ()
  ((event-queue :initform (make-priority-queue :key #'exec-frame) :accessor event-queue)
   (current-frame :initform 0 :accessor current-frame)
   (player :initform (make-instance 'player) :accessor player)
   (background :initform (make-instance 'background) :accessor background)
   (projectiles :initform nil :accessor projectiles)
   (enemies :initform nil :accessor enemies)
   (messages :initform nil :accessor messages)))

(defun load-level (name)
  ;; todo
  name
  )

;;;
;;; Generic functions
;;;

;;; Methods
(defmethod update ((level level))
  (with-slots (player background projectiles enemies messages) level
    (update background)
    (mapc #'update projectiles)
    (mapc #'update enemies)
    (update player)
    (mapc #'update messages)
    (resolve-collisions game)))

(defmethod draw ((level level))
  (draw (background game))
  (mapc #'draw (messages game))
  (sdl:draw-string-shaded-* (format nil "Player damage: ~a" (damage-taken (player game)))
			    5 5 sdl:*red* (sdl:color :a 0))
  (sdl:draw-string-shaded-* (format nil "Enemies downed: ~a" (score (player game)))
			    5 15 sdl:*red* (sdl:color :a 0))
  (draw (player game))
  (mapc #'draw (enemies game))
  (mapc #'draw (projectiles game)))