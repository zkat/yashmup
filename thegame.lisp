(in-package :yashmup)

(defvar *game* nil)
(defclass game ()
  ((running-p :initform t :accessor running-p)
   (player :initform (make-instance 'player-ship) :accessor player)
   (background :initform (make-instance 'background) :accessor background)
   (projectiles :initform nil :accessor projectiles)
   (enemies :initform nil :accessor enemies)
   (enemy-counter :initform 0 :accessor enemy-counter)
   (keys-held-down :initform (make-hash-table :test #'eq) :accessor keys-held-down)))

(defmethod update ((game game))
  (with-slots (running-p player background projectiles enemies enemy-counter) game
    (update background)
    (mapc #'update projectiles)
    (update player)
    (mapc #'update enemies)
    (incf enemy-counter)
    (when (> enemy-counter 100)
      (push (make-instance 'enemy) enemies)
      (setf enemy-counter 0))
    (resolve-collisions game)))

(defun resolve-collisions (game)
  (loop for enemy in (enemies game)
       do (loop for projectile in (projectiles game)
	       when (and (eql (player game)
			      (shooter projectile))
			 (collided-p projectile enemy))
	       do (progn (incf (damage enemy))
			 (setf (projectiles game) (delete projectile (projectiles game)))))))

(defgeneric take-a-step (game))
(defmethod take-a-step ((game game))
  (update game)
  (draw game))

(defmethod draw ((game game))
  (draw (background game))
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
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) t)))

(defun register-key-release (key game)
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) nil)))

(defun key-down-p (key &optional (game *game*))
  (with-slots (keys-held-down) game
    (let ((down-p (gethash key keys-held-down)))
      down-p)))
