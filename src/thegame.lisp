;; This file is part of yashmup

;; thegame.lisp
;;
;; You just lost it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *game* nil)
(defclass game ()
  ((running-p :initform t :accessor running-p)
   (keys-held-down :initform (make-hash-table :test #'eq) :accessor keys-held-down)
   (last-frame-time :initform (get-internal-real-time) :accessor last-frame-time)
   (current-level :initform nil :accessor current-level)
   (paused-p :initform nil :accessor paused-p)))

;;;
;;; Generic functions
;;;
(defgeneric take-a-step (game))
(defgeneric resolve-collisions (game))
(defgeneric pause-screen (game))
(defgeneric handle-key-event (key game &key))

;;; Game methods
(defmethod current-frame ((game game))
  (current-frame (current-level game)))

(defmethod update ((game game))
  (update (current-level game)))

(defmethod draw ((game game))
  (draw (current-level game)))

(defmethod take-a-step ((game game))
  (unless (paused-p game)
    (update game)
    (incf (current-frame game)))
  (draw game)
  (when (paused-p game)
    (pause-screen game)))

(defmethod resolve-collisions ((game game))
  (loop for enemy in (enemies game)
       do (loop for projectile in (projectiles game)
	     do (cond ((and (eql (player game)
				 (shooter projectile))
			    (collided-p projectile enemy))
		       (incf (damage-taken enemy))
		       (setf (projectiles game) (delete projectile (projectiles game))))
		      ((collided-p projectile (player game))
		       (incf (damage-taken (player game)))
		       (setf (projectiles game) (delete projectile (projectiles game))))
		      (t (values))))))

(defmethod pause-screen ((game game))
  (sdl:draw-box-* 0 0 *screen-width* *screen-height* :color (sdl:color) :alpha 150)
  (sdl:draw-string-shaded-* "PAUSED" 
			    (/ *screen-width* 2)
			    (/ *screen-height* 2)
			    sdl:*red*
			    (sdl:color :a 0)))

(defun toggle-pause ()
  (if (paused-p *game*)
      (progn
	(sdl-mixer::resume-music)
	(setf (paused-p *game*) nil))
      (progn
	(sdl-mixer:pause-music)
	(setf (paused-p *game*) t))))

;;; Key event handling
(defmethod handle-key-event (key game &key (event-type :key-down))
  (cond ((eql event-type :key-down)
	 (register-key-press key game))
	((eql event-type :key-up)
	 (register-key-release key game))
	(t
	 (error "Unknown key-event type"))))

(defun register-key-press (key game)
  (when (sdl:key= key :sdl-key-p)
    (toggle-pause))
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) t)))

(defun register-key-release (key game)
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) nil)))

(defun key-down-p (key &optional (game *game*))
  (with-slots (keys-held-down) game
    (let ((down-p (gethash key keys-held-down)))
      down-p)))

;;;
;;; Messages
;;;
(defclass message (game-object)
  ((times-displayed :initform 0 :accessor times-displayed)
   (display-limit :initarg :limit :initform 60 :accessor display-limit)
   (message-string :initarg :msg :initform "" :accessor message-string)))

(defmethod update ((msg message))
  (with-slots (x y times-displayed display-limit message-string) msg
    (if (and display-limit 
	       (>= times-displayed display-limit))
	(setf (messages *game*)
	      (delete msg (messages *game*)))
	(incf times-displayed))))

(defmethod draw ((msg message))
  (with-slots (x y message-string) msg
   (sdl:draw-string-shaded-* message-string x y sdl:*red* (sdl:color :a 0))))

(defun display-message (message x y &optional display-limit)
  (let ((msg (make-instance 'message :x x :y y :msg message :limit display-limit)))
    (push msg (messages *game*))))