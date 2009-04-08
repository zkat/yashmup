;; This file is part of yashmup

;; thegame.lisp
;;
;; You just lost it
;;
;; TODO -
;; * Clean up this file a bit.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *game* nil)
(defclass game ()
  ((running-p :initform t :accessor running-p)
   (keys-held-down :initform (make-hash-table :test #'eq) :accessor keys-held-down)
   (current-level :initarg :current-level :accessor current-level)
   (game-over-p :initform nil :accessor game-over-p)
   (paused-p :initform nil :accessor paused-p)))

;;;
;;; Generic functions
;;;
(defgeneric take-a-step (game))
(defgeneric resolve-collisions (game))
(defgeneric pause-screen (game))
(defgeneric handle-key-event (key game &key))

;;; Game methods
(defmethod update ((game game))
  (update (current-level game)))

(defmethod draw ((game game))
  (draw (current-level game))
  (when (paused-p game)
    (draw-pause-screen game))
  (when (game-over-p game)
    (draw-game-over-screen game)))

(defmethod take-a-step ((game game))
  (draw game)
  (unless (paused-p game)
    ;; (process-cooked-events game)
    (update game)))

(defun draw-game-over-screen (game)
  (declare (ignore game))
  (sdl:draw-box-* 0 0 *screen-width* *screen-height* :color (sdl:color) :alpha 150)
  (sdl:draw-string-shaded-* "GAME OVER" 
			    (/ *screen-width* 2)
			    (/ *screen-height* 2)
			    sdl:*red*
			    (sdl:color :a 0)))

(defmethod draw-pause-screen ((game game))
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
(defmethod handle-key-event (key (game game) &key (event-type :key-down))
  ;; This seems a bit ugly. I'll think about it...
  (cond ((eql event-type :key-down)
	 (register-key-press key game))
	((eql event-type :key-up)
	 (register-key-release key game))
	(t
	 (error "Unknown key-event type"))))

(defmethod register-key-press (key (game game))
  (when (sdl:key= key :sdl-key-p)
    (toggle-pause))
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) t)))

(defmethod register-key-release (key (game game))
  (with-slots (keys-held-down) game
    (setf (gethash key keys-held-down) nil)))

(defun key-down-p (key &optional (game *game*))
  (with-slots (keys-held-down) game
    (let ((down-p (gethash key keys-held-down)))
      down-p)))

;;;
;;; Messages
;;;
;;; These are mostly here temporarily. Basically, they're text-based sprites.
(defclass message (game-object)
  ((times-displayed :initform 0 :accessor times-displayed)
   (display-limit :initarg :limit :initform 60 :accessor display-limit)
   (message-string :initarg :msg :initform "" :accessor message-string)))

(defmethod update ((msg message))
  (with-slots (x y times-displayed display-limit message-string) msg
    (if (and display-limit 
	       (>= times-displayed display-limit))
	(setf (messages (current-level *game*))
	      (delete msg (messages (current-level *game*))))
	(incf times-displayed))))

(defmethod draw ((msg message))
  (with-slots (x y message-string) msg
   (sdl:draw-string-shaded-* message-string (floor x) (floor y) sdl:*red* (sdl:color :a 0))))

(defun display-message (message x y &optional display-limit)
  (let ((msg (make-instance 'message :x x :y y :msg message :limit display-limit)))
    (push msg (messages (current-level *game*)))))


