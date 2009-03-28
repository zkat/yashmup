(in-package :sprite-checker)

;; Configure these
(setf *filename* "explosion.gif")
(setf *background-image-filename* nil) ;set this to a string filename to have a bg
(setf *cell-width* 15)
(setf *cell-height* 14)

;; You shouldn't need to change this at all, but if the cell mask is positioned weird,
;; it might be worth a shot.
(setf *y-offset* 0)

;; SDL config variables
(setf *frame-rate* 15)
(setf *screen-width* 200)
(setf *screen-height* 200)

;; number of frames to pause before looping the sprite
;; setting this to negative actually reduces the number of 
;; frames of the sprite that are actually displayed
(setf *pause-between-loops* 5) 

;; You can set a custom background color by replacing sdl:*color* with (sdl:color :r x :g y :b z :a w)
;; x y z and w being any int from 0-255.

;; They default to 0, so you only need to set the ones you want to be higher than 0.
;; ex: (sdl:color :b 255) is blue

;; Other colors: sdl:*red*, sdl:*blue*, sdl:*cyan*, sdl:*green*, sdl:*magenta*, sdl:*yellow*

;; This is ignored if *background-image-filename* is set.
(setf *bg-color* sdl:*black*)