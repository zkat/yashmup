(in-package :yashmup)

(defvar *resource-table* (make-hash-table))

(defun load-image (name)
  (let ((image-path (merge-pathnames (concatenate 'string name ".png") *resource-path*)))
    (sdl-image:load-image (namestring image-path) :alpha 255)))

(defun load-sound (name)
  (let ((sound-path (merge-pathnames (concatenate 'string name ".wav") *resource-path*)))
    (sdl-mixer:load-sample (namestring sound-path))))

(defun init-resources ()
  (setf (gethash 'background *resource-table*)
	(load-image "background"))
  (setf (gethash 'player-ship *resource-table*)
	(load-image "player-ship"))
  (setf (gethash 'laser *resource-table*)
	(load-image "laser"))
  (setf (gethash 'enemy *resource-table*)
	(load-image "enemy"))
  (setf (gethash 'pew *resource-table*)
	(load-sound "pew")))

