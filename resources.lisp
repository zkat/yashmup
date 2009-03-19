(in-package :yashmup)

(defvar *resource-table* (make-hash-table))

(defun load-image (name)
  (let ((image-path (merge-pathnames (concatenate 'string name ".png") *resource-path*)))
    (sdl-image:load-image (namestring image-path) :alpha 255)))

(defun load-sound (name)
  ;; todo
  name)