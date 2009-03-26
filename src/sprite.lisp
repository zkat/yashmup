;; This file is part of yashmup

;; sprite.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Sprite classes
;;;
(defclass sprite (game-object)
  ((image :initarg :image :initform (error "Must provide an image for this sprite") :accessor image)
   (hitbox-x-offset :initform 0 :accessor hitbox-x-offset)
   (hitbox-y-offset :initform 0 :accessor hitbox-y-offset)
   (hitbox-width :accessor hitbox-width)
   (hitbox-height :accessor hitbox-height)
   (draw-hitbox-p :initform nil :accessor draw-hitbox-p)))

(defmethod initialize-instance :after ((sprite sprite) 
				       &key hitbox-width hitbox-height)
  (if hitbox-width
      (setf (hitbox-width sprite) hitbox-width)
      (unless (slot-boundp sprite 'hitbox-width)
	(setf (hitbox-width sprite) (width sprite))))
  (if hitbox-height
      (setf (hitbox-height sprite) hitbox-height)
      (unless (slot-boundp sprite 'hitbox-height)
	(setf (hitbox-height sprite) (height sprite)))))

;;;
;;; Generic functions
;;;
(defgeneric draw (sprite)
  (:documentation "Draws OBJ and whatever it has attached to it that should be drawn."))
(defgeneric collided-p (obj1 obj2)
  (:documentation "Performs a collision check between two objects. Returns T or NIL"))
(defgeneric crashed! (obj1 obj2)
  (:documentation "Runs whatever happens when obj1 and obj2 crash"))
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
    (sdl:point :x (floor (+ x (/ (hitbox-x-offset sprite) 2)))
	       :y (floor (+ y (/ (hitbox-y-offset sprite) 2))))))

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
      (- (radians-to-degrees (* -1 (atan y x)))
	 90))))

(defmethod draw ((sprite sprite))
  (with-slots (image x y)
      sprite
    (sdl:draw-surface-at-* image x y))
  (when (draw-hitbox-p sprite)
    (let ((hitbox-x (+ (x sprite) (hitbox-x-offset sprite)))
	  (hitbox-y (+ (y sprite) (hitbox-y-offset sprite))))
      (sdl:draw-rectangle-* hitbox-x
			    hitbox-y
			    (hitbox-width sprite)
			    (hitbox-height sprite)
			    :color sdl:*red*))))

(defmethod collided-p ((sprite-1 sprite) (sprite-2 sprite))
  "Naive implementation of 'pixel-perfect' collision-detection, using sprite hitboxes"
  (let* ((sprite-1-hitbox-x (+ (x sprite-1) (hitbox-x-offset sprite-1)))
	 (sprite-1-hitbox-y (+ (y sprite-1) (hitbox-y-offset sprite-1)))
	 (sprite-2-hitbox-x (+ (x sprite-2) (hitbox-x-offset sprite-2)))
	 (sprite-2-hitbox-y (+ (y sprite-2) (hitbox-x-offset sprite-2))))
    (loop
       for x1 from sprite-1-hitbox-x upto (+ sprite-1-hitbox-x (hitbox-width sprite-1))
       do (loop for x2 from sprite-2-hitbox-x upto (+ sprite-2-hitbox-x (hitbox-width sprite-2))
	     when (= x1 x2)
	     do (loop
		   for y1 from sprite-1-hitbox-y upto (+ sprite-1-hitbox-y (hitbox-height sprite-1))
		   do (loop
			 for y2 from sprite-2-hitbox-y upto (+ sprite-2-hitbox-y (hitbox-height sprite-2))
			 when (= y1 y2)
			 do (return-from collided-p t))))
       finally (return-from collided-p nil))))

(defmethod crashed! ((obj1 sprite) (obj2 sprite))
  (incf (damage-taken obj1) 10)
  (incf (damage-taken obj2) 10))
