;; This file is part of yashmup

;; scripting.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; The Macro
;;;
(defmacro fork ((&key (delay 0) (repeat 0)) &body body)
  "Turns BODY into one or more event-loop events."
  `(labels ((recurse (times)
	      (if (< times 0)
		  nil
		  (progn
		    (push-event (make-instance 'event
					       :payload (lambda ()
							  ,@body)
					       :exec-frame (+ ,delay (current-frame *game*)))
				*game*)
		    (push-event (make-instance 'event
					       :payload (lambda ()
							  (recurse (1- times)))
					       :exec-frame (+ ,delay (current-frame *game*)))
				*game*)))))
     (recurse ,repeat)))

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

