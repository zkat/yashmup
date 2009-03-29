;; This file is part of yashmup

;; resources.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *resource-table* (make-hash-table))

(defun load-image (name &key (ext ".bmp") (color-key sdl:*magenta*))
  (let ((image-path (merge-pathnames (concatenate 'string name ext) *resource-path*)))
    (sdl-image:load-and-convert-image (namestring image-path) :alpha 255 :color-key color-key
				      :image-type ".bmp")))

(defun load-sample (name &key (ext ".wav"))
  (let ((sound-path (merge-pathnames (concatenate 'string name ext) *resource-path*)))
    (sdl-mixer:load-sample (namestring sound-path))))

(defun load-music (name &key (ext ".ogg") errorp)
  (let ((music-path (merge-pathnames (concatenate 'string name ext) *resource-path*)))
    (handler-case
	(sdl-mixer:load-music (namestring music-path))
      (simple-error ()
	(if errorp
	    (error "Couldn't load music resource")
	    nil)))))

(defun find-resource (name)
  (if (symbolp name)
      (let ((resource (gethash name *resource-table*)))
	resource)
      (error "resource name must be a symbol")))

(defun init-resources ()
  (setf (gethash 'background *resource-table*)
	(load-image "bg" :ext ".png"))
  (setf (gethash 'player-ship *resource-table*)
	(load-image "gif/s1-magent" :ext ".gif" :color-key sdl:*magenta*))
  (setf (gethash 'laser1 *resource-table*)
	(load-image "bullets/laser1" :ext ".gif"))
  (setf (gethash 'laser2 *resource-table*)
	(load-image "bullets/laser2" :ext ".gif" :color-key (sdl:color)))
  (setf (gethash 'bullet1 *resource-table*)
	(load-image "bullets/bullet1" :ext ".gif"))
  (setf (gethash 'bullet2 *resource-table*)
	(load-image "bullets/bullet2" :ext ".gif"))
  (setf (gethash 'bullet3 *resource-table*)
	(load-image "bullets/bullet3" :ext ".gif"))
  (setf (gethash 'enemy-small *resource-table*)
	(load-image "enemy-small" :ext ".gif" :color-key (sdl:color :r 255 :g 255 :b 255)))
  (setf (gethash 'enemy-large *resource-table*)
	(load-image "enemy-large" :ext ".gif" :color-key (sdl:color :r 255 :g 255 :b 255)))
  (setf (gethash 'golden-boss *resource-table*)
	(load-image "golden-boss" :ext ".gif" :color-key (sdl:color)))
  (setf (gethash 'laser-sample *resource-table*)
	(let ((sample (load-sample "pew")))
	  (setf (sdl-mixer:sample-volume sample) 5)
	  sample))
  (setf (gethash 'explosion *resource-table*)
	(load-image "explosion" :ext ".gif" :color-key (sdl:color :r 255 :b 255)))
  (setf (gethash 'music *resource-table*)
	(load-music "game-music" :ext ".mp3")))
