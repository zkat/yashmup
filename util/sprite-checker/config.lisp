(in-package :sprite-checker)

(setf 
 ;; Filenames of images to load
 *filename* "explosion.gif"
 *color-key* (sdl:color :r 255 :b 255) ; this color is keyed to transparent
 *background-image-filename* nil ; set this to a string filename to have a bg

 ;; Height and width of the focused cell, in pixels
 *cell-width* 15
 *cell-height* 14

 ;; If there is more than one animation in a sprite sheet,
 ;; this selects which row to play (0 is the topmost row)
 *cell-row* 0
 ;;number of frames in this row
 *number-of-frames* 15

 ;; Number of frames to pause for between loops
 *pause-between-loops* 5

 ;; SDL config variables
 *screen-width* 200
 *screen-height* 200

 ;; remember, yashmup runs at 60fps.
 ;; I'll have a way to limit how fast sprites are -actually- played, though.
 *frame-rate* 60

 ;; You can set a custom background color by replacing sdl:*color* with (sdl:color :r x :g y :b z :a w)
 ;; x y z and w being any int from 0-255.
 ;;
 ;; They default to 0, so you only need to set the ones you want to be higher than 0.
 ;; ex: (sdl:color :b 255) is blue.
 ;;
 ;; Other colors: sdl:*red*, sdl:*blue*, sdl:*cyan*, sdl:*green*, sdl:*magenta*, sdl:*yellow*
 ;; This is ignored if *background-image-filename* is set.
 *bg-color* sdl:*black*
 )
