;; This file is part of yashmup

;; scripting.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defmacro fork ((&key (delay 0)) &body body)
  "Turns BODY into one or more event-loop events."
  `(push-event (make-instance 'event 
			      :payload (lambda () ,@body)
			      :exec-frame (+ ,delay (current-frame *game*)))
	       *game*))


(defun move-in-curve (obj &optional (delta-theta 1))
  (dotimes (i 600)
    (fork (:delay (1+ i))
      (incf (angle obj) delta-theta)))
  (fork (:delay 600)
    (detach obj *game*)))

(defun move-in-rose (obj center-x center-y &optional (k 5))
  (with-slots (x y angle velocity) obj
   (let* ((initial-radius radius)
	  (r (sqrt (+ (expt (- x center-x) 2)) (expt (- y center-y) 2)))
	  (theta (atan y x)))
     (dotimes (i 600)
       (fork (:delay (* i))
	 (incf theta)
	 (setf radius (* initial-radius (cos (* k (degrees-to-radians theta)))))))))
  (fork (:delay 600)
    (detach obj *game*)))
