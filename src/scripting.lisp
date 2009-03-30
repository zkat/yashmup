;; This file is part of yashmup

;; scripting.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Useful scripts
;;;
(defun move-in-curve (obj &key (angle-delta 1) (num-frames 1) starting-angle)
  (when starting-angle
    (setf (angle obj) starting-angle))
  (fork (:delay 1 :repeat num-frames)
    (incf (angle obj) angle-delta)))

(defun chase (target obj &key (num-frames 100))
  (fork (:delay 1 :repeat num-frames)
    (setf (angle obj) (angle-from obj target))))

(defun orbit (target obj &key (keep-distance 100) (num-frames 100))
  (fork (:delay 1 :repeat num-frames)
    (let ((dist-difference (- (distance obj target)
			      keep-distance)))
      (cond ((> dist-difference (+  (velocity obj)))
	     (setf (angle obj) (+ 30 (angle-from obj target))))
	    ((< dist-difference 0)
	     (setf (angle obj) (- (angle-from target obj) 30)))
	    (t
	     (setf (angle obj) (+ (angle-from obj target) 90)))))))

