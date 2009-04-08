;; This file is part of yashmup

;; sprite.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defparameter *draw-hitbox-p* nil)
;;;
;;; Sprite classes
;;;
(defclass sprite (game-object)
  ((image :initarg :image :initform (error "Must provide an image for this sprite") :accessor image)
   (hitbox-x-offset :accessor hitbox-x-offset)
   (hitbox-y-offset :accessor hitbox-y-offset)
   (hitbox-radius :accessor hitbox-radius)
   (draw-hitbox-p :initform *draw-hitbox-p* :accessor draw-hitbox-p)))

(defclass animated-sprite (sprite)
  ((frame-x-size :accessor frame-x-size)
   (frame-y-size :accessor frame-y-size)
   (current-frame :initform 0 :accessor current-frame)))

;; TODO
;; (defmethod next-frame ((sprite animated-sprite))
;;   (with-accessors ((img image)) sprite
;;     ))

(defmethod initialize-instance :after ((sprite sprite) 
				       &key hitbox-radius 
				       hitbox-x-offset
				       hitbox-y-offset)
  (if hitbox-x-offset
      (setf (hitbox-x-offset sprite) hitbox-x-offset)
      (unless (slot-boundp sprite 'hitbox-x-offset)
	(setf (hitbox-x-offset sprite) (- (floor (+ (x sprite)
						    (/ (width sprite) 2)))
					  (x sprite)))))
  (if hitbox-y-offset
      (setf (hitbox-y-offset sprite) hitbox-y-offset)
      (unless (slot-boundp sprite 'hitbox-y-offset)
	(setf (hitbox-y-offset sprite) (- (floor (+ (y sprite)
						    (/ (height sprite) 2)))
					  (y sprite)))))
  (if hitbox-radius
      (setf (hitbox-radius sprite) hitbox-radius)
      (unless (slot-boundp sprite 'hitbox-radius)
	(setf (hitbox-radius sprite) (floor (/ (width sprite) 2))))))

;;;
;;; Generic functions
;;;
(defgeneric draw (sprite)
  (:documentation "Draws OBJ and whatever it has attached to it that should be drawn."))
(defgeneric collided-p (obj1 obj2)
  (:documentation "Performs a collision check between two objects. Returns T or NIL"))
(defgeneric distance (sprite1 sprite2))
(defgeneric angle-from (sprite1 sprite2))

;;; Sprite methods
(defmethod width ((sprite sprite))
  (sdl:width (image sprite)))

(defmethod height ((sprite sprite))
  (sdl:height (image sprite)))

(defmethod center ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:point :x (floor (+ x (hitbox-x-offset sprite)))
	       :y (floor (+ y (hitbox-y-offset sprite))))))

(defmethod distance ((sprite1 sprite) (sprite2 sprite))
  (let* ((s1-center (center sprite1))
	 (s2-center (center sprite2))
	 (x1 (sdl:x s1-center))
	 (y1 (sdl:y s1-center))
	 (x2 (sdl:x s2-center))
	 (y2 (sdl:y s2-center)))
    (sqrt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2)))))

(defmethod angle-from ((sprite1 sprite) (sprite2 sprite))
  (let* ((s1-center (center sprite1))
	 (s2-center (center sprite2))
	 (x1 (sdl:x s1-center))
	 (y1 (sdl:y s1-center))
	 (x2 (sdl:x s2-center))
	 (y2 (sdl:y s2-center)))
    (let ((x (- x1 x2))
	  (y (- y1 y2)))
      ;; I don't know why I had to do this, or why it worked.
      (- (radians-to-degrees (* -1 (atan y x)))
	 90))))

(defmethod draw ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:draw-surface-at-* image (floor x) (floor y)))
  (when (draw-hitbox-p sprite)
    (let ((hitbox-x (floor (+ (x sprite) (hitbox-x-offset sprite))))
	  (hitbox-y (floor (+ (y sprite) (hitbox-y-offset sprite)))))
      (sdl:draw-circle-* hitbox-x
			 hitbox-y
			 (hitbox-radius sprite)
			 :color sdl:*red*))))

(defmethod collided-p ((sprite-1 sprite) (sprite-2 sprite))
  "This is a very simple collision-testing algorithm that uses a circular 'hitbox'."
  (with-slots ((sp1-r hitbox-radius)) sprite-1
    (with-slots ((sp2-r hitbox-radius)) sprite-2
      (let ((distance (distance sprite-1 sprite-2)))
	(unless (> distance
		   (+ sp1-r sp2-r))
	  t)))))
