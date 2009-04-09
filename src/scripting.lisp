;; This file is part of yashmup

;; scripting.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Useful scripts
;;;
(defun move-in-curve (obj &key (angle-delta 1) 
		      (duration 1) (level (current-level *game*)) 
		      starting-angle
		      (direction :clockwise))
  (when starting-angle
    (setf (angle obj) starting-angle))
  (fork (:level level :repeat-delay 1 :repetitions duration)
    (case direction
      (:clockwise
       (decf (angle obj) angle-delta))
      (:counter-clockwise
       (incf (angle obj) angle-delta)))))

(defun move-in-angle (obj angle &key duration (level (current-level *game*)))
  (setf (angle obj) angle)
  (when duration
   (fork (:delay duration :level level)
     (setf (max-velocity obj) 0))))

(defun chase (target obj &key (duration 100) (level (current-level *game*)))
  (fork (:level level :repeat-delay 1 :repetitions duration)
    (setf (angle obj) (angle-from obj target))))

(defun orbit (target obj &key (keep-distance 100) (duration 100) (level (current-level *game*)))
  (fork (:level level :repeat-delay 1 :repetitions duration)
    (let ((dist-difference (- (distance obj target)
			      keep-distance)))
      (cond ((> dist-difference (+  (max-velocity obj)))
	     (setf (angle obj) (+ 30 (angle-from obj target))))
	    ((< dist-difference 0)
	     (setf (angle obj) (- (angle-from target obj) 30)))
	    (t
	     (setf (angle obj) (+ (angle-from obj target) 90)))))))

(defun shoot-in-angle (obj angle)
  (let ((generators (generators (weapon obj))))
    (mapc (lambda (gen)
	    (setf (firing-angle gen) angle))
	  generators)
    (fire! obj)))