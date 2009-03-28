(defpackage #:sprite-checker
  (:use :cl))

(in-package :sprite-checker)

(defparameter *filename* "explosion.gif")
(defparameter *cell-width* 15)
(defparameter *cell-height* 14)

(defparameter *y-offset* 0
  "You shouldn't need to change this at all unless there's something weird with the y-position
of the sprite. If there is, play with this and see if it helps.")

(defparameter *frame-rate* 20)
(defparameter *screen-width* 500)
(defparameter *screen-height* 500)
(defparameter *bg-color* sdl:*black*)

(defun load-config ()
  (let ((config-file (merge-pathnames "config.lisp")))
    (load config-file)))

(defvar *current-cell* 0)
(defvar *running* t)
(defun main ()
  (load-config)
  (setf *running* t)
  (sdl:with-init (sdl:sdl-init-video)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "sprite test"
		:icon-caption "sprite test")
    (setf (sdl:frame-rate) *frame-rate*)
    (sdl:clear-display *bg-color*)
    (let* ((image (sdl-image:load-image
		   (namestring (merge-pathnames *filename*))
		  :color-key (sdl:color :r 255 :b 255)))
	   (num-frames (1- (/ (sdl:width image) *cell-width*))))
     (sdl:with-events ()
       (:quit-event () (prog1 t
			 (sdl:free image)))
       (:idle ()
	      (sdl:clear-display *bg-color*)
	      (sdl:set-cell (sdl:rectangle 
			     :x (* *current-cell* *cell-width*) 
			     :y *y-offset*
			     :w *cell-width*
			     :h *cell-height*)
			    :surface image)
	      (sdl:draw-surface-at-* image (/ *screen-width* 2) (/ *screen-height* 2))
	      (if (< num-frames *current-cell*)
		  (setf *current-cell* 0)
		  (incf *current-cell*))
	      (sdl:update-display)
	      (when (not *running*)
		(sdl:push-quit-event)))))))
