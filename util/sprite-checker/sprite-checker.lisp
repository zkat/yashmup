(defpackage #:sprite-checker
  (:use :cl))

(in-package :sprite-checker)

(defparameter *filename* "explosion.gif")
(defparameter *color-key* (sdl:color :r 255 :b 255))
(defparameter *background-image-filename* nil)
(defparameter *cell-width* 15)
(defparameter *cell-height* 14)
(defparameter *cell-row* 0)
(defparameter *number-of-frames* 15)
(defparameter *frame-rate* 60)
(defparameter *screen-width* 500)
(defparameter *screen-height* 500)
(defparameter *bg-color* sdl:*black*)

(defparameter *pause-between-loops* 5
  "Number of frames to pause between loops")

(defun load-config ()
  (let ((config-file (merge-pathnames "config.lisp")))
    (load config-file)))

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
		  :color-key *color-key*))
	   (background (when *background-image-filename*
			 (sdl-image:load-image (namestring 
						(merge-pathnames *background-image-filename*)))))
	   (current-cell 0))
     (sdl:with-events ()
       (:quit-event () (prog1 t
			 (sdl:free image)))
       (:idle ()
	      (if background
		  (sdl:draw-surface background)
	      (sdl:clear-display *bg-color*))
	      (sdl:set-cell (sdl:rectangle 
			     :x (* current-cell *cell-width*) 
			     :y (* *cell-row* *cell-height*)
			     :w *cell-width*
			     :h *cell-height*)
			    :surface image)
	      (sdl:draw-surface-at-* image (/ *screen-width* 2) (/ *screen-height* 2))
	      (if (< (+ *pause-between-loops* *number-of-frames*) current-cell)
		  (setf current-cell 0)
		  (incf current-cell))
	      (sdl:update-display)
	      (when (not *running*)
		(sdl:push-quit-event)))))))
