(in-package :sprite-checker)

;; Filenames of images to load
(setf *filename* "explosion.gif")
(setf *background-image-filename* nil) ;set this to a string filename to have a bg

;; Height and width of the focused cell, in pixels
(setf *cell-width* 15)
(setf *cell-height* 14)

;;number of frames in this row
(setf *number-of-frames* 15)

;; if there is more than one animation in a sprite sheet, 
;; this selects which row to play
(setf *cell-row* 0)

;; Number of frames to pause for between loops
(setf *pause-between-loops* 5) 

;; SDL config variables
(setf *frame-rate* 15)
(setf *screen-width* 200)
(setf *screen-height* 200)

;; You can set a custom background color by replacing sdl:*color* with (sdl:color :r x :g y :b z :a w)
;; x y z and w being any int from 0-255.
;;
;; They default to 0, so you only need to set the ones you want to be higher than 0.
;; ex: (sdl:color :b 255) is blue.
;;
;; Other colors: sdl:*red*, sdl:*blue*, sdl:*cyan*, sdl:*green*, sdl:*magenta*, sdl:*yellow*
;; This is ignored if *background-image-filename* is set.
(setf *bg-color* sdl:*black*)