;; This file is part of yashmup

;; resources.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *resource-table* (make-hash-table))

(defun load-image (name &key (extension ".bmp") color-key)
  (let ((image-path (merge-pathnames (concatenate 'string name extension) *resource-path*)))
    (sdl-image:load-image (namestring image-path) :alpha 255 :color-key color-key)))

(defun load-sample (name)
  (let ((sound-path (merge-pathnames (concatenate 'string name ".wav") *resource-path*)))
    (sdl-mixer:load-sample (namestring sound-path))))

(defun load-music (name &key (extension ".ogg") errorp)
  (let ((music-path (merge-pathnames (concatenate 'string name extension) *resource-path*)))
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
	(load-image "background"))
  (setf (gethash 'player-ship *resource-table*)
	(load-image "sweet-ship" :extension ".gif" :color-key (sdl:color :r 255 :g 255 :b 255)))
  (setf (gethash 'laser1 *resource-table*)
	(load-image "bullets/laser1" :extension ".gif"))
  (setf (gethash 'laser2 *resource-table*)
	(load-image "bullets/laser2" :extension ".gif" :color-key (sdl:color)))
  (setf (gethash 'bullet1 *resource-table*)
	(load-image "bullets/bullet1" :extension ".gif"))
  (setf (gethash 'bullet2 *resource-table*)
	(load-image "bullets/bullet2" :extension ".gif"))
  (setf (gethash 'bullet3 *resource-table*)
	(load-image "bullets/bullet3" :extension ".gif"))
  (setf (gethash 'enemy-small *resource-table*)
	(load-image "enemy-small" :extension ".gif" :color-key (sdl:color :r 255 :g 255 :b 255)))
  (setf (gethash 'enemy-large *resource-table*)
	(load-image "enemy-large" :extension ".gif" :color-key (sdl:color :r 255 :g 255 :b 255)))
  (setf (gethash 'golden-boss *resource-table*)
	(load-image "golden-boss" :extension ".gif" :color-key (sdl:color)))
  (setf (gethash 'laser-sample *resource-table*)
	(load-sample "pew"))
  (setf (gethash 'music *resource-table*)
	(load-music "game-music")))


