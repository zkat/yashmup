(asdf:oos 'asdf:load-op 'lispbuilder-sdl)
(asdf:oos 'asdf:load-op 'lispbuilder-sdl-image)

(defpackage #:sprite-checker
  (:use :cl))

(in-package :sprite-checker)

;; Configure these
(defparameter *path-to-sprite* "/absolute/path/to/sprite.gif")
(defparameter *cell-width* 0)
(defparameter *cell-height* 0)
(defparameter *num-frames* 0)

;; In case you need these
(defparameter *frame-rate* 20)
(defparameter *screen-width* 500)
(defparameter *screen-height* 500)
(defparameter *obj-color* sdl:*white*)
(defparameter *bg-color* sdl:*black*)

(defun load-config ()
  (let ((config-file (merge-pathnames "config.lisp")))
    (load config-file)))

(defvar *current-cell* 0)
(defvar *running* t)
(defun main ()
  (setf *running* t)
  (sdl:with-init (sdl:sdl-init-video)
    (sdl:initialise-default-font)
    (sdl:window *screen-width* *screen-height*
		:title-caption "sprite test"
		:icon-caption "sprite test")
    (setf (sdl:frame-rate) *frame-rate*)
    (sdl:clear-display *bg-color*)
    (let* ((image (sdl-image:load-image
		   *path-to-sprite*
		  :color-key (sdl:color :r 255 :b 255)))
	   (num-frames (1- (/ (sdl:width image) *cell-width*))))
     (sdl:with-events ()
       (:quit-event () (prog1 t
			 (sdl:free image)))
       (:idle ()
	      (sdl:clear-display *bg-color*)
	      (sdl:set-cell (sdl:rectangle 
			     :x (* *current-cell* *cell-width*) 
			     :y 0 
			     :w *cell-width*
			     :h *cell-height*)
			    :surface image)
	      (sdl:draw-surface-at-* image 250 250)
	      (if (< num-frames *current-cell*)
		  (setf *current-cell* 0)
		  (incf *current-cell*))
	      (sdl:update-display)
	      (when (not *running*)
		(sdl:push-quit-event)))))))
