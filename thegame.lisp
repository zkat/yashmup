(in-package :yashmup)

(defvar *game* nil)
(defclass game ()
  ((running-p :initform t :accessor running-p)
   (player :initform (make-instance 'player-ship) :accessor player)
   (background :initform (make-instance 'background) :accessor background)
   (projectiles :initform nil :accessor projectiles)
   (enemies :initform nil :accessor enemies)
   (enemy-counter :initform 0 :accessor enemy-counter)
   (keys-held-down :initform (make-hash-table :test #'eq) :accessor keys-held-down)
   (paused-p :initform nil :accessor paused-p)))

(defmethod update ((game game))
  (with-slots (running-p player background projectiles enemies enemy-counter) game
    (update background)
    (mapc #'update projectiles)
    (mapc #'update enemies)
    (update player)
    (incf enemy-counter)
    (when (> enemy-counter 80)
      (push (make-instance 'enemy) enemies)
      (setf enemy-counter 0))
    (resolve-collisions game)))

(defun resolve-collisions (game)
  (loop for enemy in (enemies game)
       do (loop for projectile in (projectiles game)
	     do (cond ((and (eql (player game)
				 (shooter projectile))
			    (collided-p projectile enemy))
		       (incf (damage enemy))
		       (setf (projectiles game) (delete projectile (projectiles game))))
		      ((collided-p projectile (player game))
		       (incf (damage (player game)))
		       (setf (projectiles game) (delete projectile (projectiles game))))
		      (t (values))))))

(defgeneric take-a-step (game))
(defmethod take-a-step ((game game))
  (unless (paused-p game)
    (update game))
  (draw game)
  (when (paused-p game)
    (draw-pause-screen)))

(defun draw-pause-screen ()
  (sdl:draw-box-* 0 0 *screen-width* *screen-height* :color (sdl:color) :alpha 150)
  (sdl:draw-string-shaded-* "PAUSED" 
			    (/ *screen-width* 2)
			    (/ *screen-height* 2)
			    sdl:*red*
			    (sdl:color :a 0)))

(defmethod draw ((game game))
  (draw (background game))
  (sdl:draw-string-shaded-* (format nil "Player damage: ~a" (damage (player game)))
			    5 5 sdl:*red* (sdl:color :a 0))
  (sdl:draw-string-shaded-* (format nil "Enemies downed: ~a" (score (player game)))
			    5 15 sdl:*red* (sdl:color :a 0))
  (draw (player game))
  (mapc #'draw (enemies game))
  (mapc #'draw (projectiles game)))

;;;
;;; Key event handling
;;;
(defun handle-key-event (key game &key (event-type :key-down))
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
