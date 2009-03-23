;; This file is part of yashmup

;; resources.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *resource-table* (make-hash-table :test #'eq))

(defun load-image (name &key (extension ".bmp") color-key)
  (let ((image-path (merge-pathnames (concatenate 'string name extension) *resource-path*)))
    (sdl-image:load-image (namestring image-path) :alpha 255 :color-key color-key)))

(defun load-sound (name)
  (let ((sound-path (merge-pathnames (concatenate 'string name ".wav") *resource-path*)))
    (sdl-mixer:load-sample (namestring sound-path))))

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
	(load-image "golden-boss" :extension ".gif" :color-key (sdl:color))))
