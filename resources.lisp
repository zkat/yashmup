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
  (setf (gethash 'laser *resource-table*)
	(load-image "laser" :extension ".gif"))
  (setf (gethash 'enemy *resource-table*)
	(load-image "enemy" :extension ".gif" :color-key (sdl:color :r 255 :g 255 :b 255))))

