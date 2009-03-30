;; This file is part of yashmup

;; resources.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defvar *resource-table* (make-hash-table :test #'equal))

(defun load-image (name &key (ext ".gif") (color-key sdl:*magenta*) refreshp)
  (multiple-value-bind (value has-p)
      (gethash name *resource-table*)
    (if (and has-p (not refreshp))
	value
	(let* ((image-path (merge-pathnames (concatenate 'string name ext) *resource-path*))
	       (image (sdl-image:load-and-convert-image (namestring image-path) 
							:alpha 255 :color-key color-key
							:image-type ".bmp")))
	  (unless image
	    (error "Error loading image resource ~a" name))
	  (setf (gethash name *resource-table*) image)
	  image))))

(defun load-sample (name &key (ext ".wav") refreshp)
  (multiple-value-bind (value has-p)
      (gethash name *resource-table*)
    (if (and has-p (not refreshp))
	value
	(let* ((sound-path (merge-pathnames (concatenate 'string name ext) *resource-path*))
	       (sample (sdl-mixer:load-sample (namestring sound-path))))
	  (unless sample
	    (error "Error loading sample ~a" name))
	  (setf (gethash name *resource-table*) sample)
	  sample))))

(defun load-music (name &key (ext ".ogg") errorp refreshp)
  (multiple-value-bind (value has-p)
      (gethash name *resource-table*)
    (if (and has-p (not refreshp))
	value
	(let* ((music-path (merge-pathnames (concatenate 'string name ext) *resource-path*))
	       (music (handler-case
			  (sdl-mixer:load-music (namestring music-path))
			(simple-error ()
			  (if errorp
			      (error "Couldn't load music resource")
			      nil)))))
	  (setf (gethash name *resource-table*) music)
	  music))))

(defun find-resource (name)
  (let ((resource (gethash name *resource-table*)))
    resource))
