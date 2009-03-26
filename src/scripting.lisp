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

(defun move-in-curve (obj &key (angle-delta 1) (num-frames 1))
  (if (<= num-frames 0)
      nil
      (progn
       (fork (:delay 1)
	 (incf (angle obj) angle-delta))
       (fork (:delay 1)
	 (move-in-curve obj :angle-delta angle-delta :num-frames (1- num-frames))))))

(defun chase (obj target &key (num-frames 100))
  (if (<= num-frames 0)
      nil
      (progn
	(fork (:delay 1)
	  (setf (angle obj) (angle-from obj target)))
	(fork (:delay 1)
	  (chase obj target :num-frames (1- num-frames))))))

(defun move-in-orbit (obj target &key (keep-distance 100) (num-frames 100))
  (if (<= num-frames 0)
      nil
      (progn
	(fork (:delay 1)
	  (let ((dist-difference (- (distance obj target)
				    keep-distance)))
	    (cond ((> dist-difference (+ 5 (velocity obj)))
		   (setf (angle obj) (+ 1 (angle-from obj target))))
		  ((< dist-difference 0)
		   (setf (angle obj) (- (angle-from target obj) 1)))
		  (t
		   (setf (angle obj) (+ (angle-from obj target) 90))))))
	
	(fork (:delay 1)
	  (move-in-orbit obj target :keep-distance keep-distance :num-frames (1- num-frames))))))

;; HA HA. NO
;; (defun move-in-rose (obj center-x center-y &optional (k 5))
;;   (with-slots (x y angle velocity) obj
;;    (let* ((initial-radius (sqrt (+ (expt (- x center-x) 2)) (expt (- y center-y) 2)))
;; 	  (theta (atan y x)))
;;      (dotimes (i 600)
;;        (fork (:delay (* i))
;; 	 (incf theta)
;; 	 (setf r (* initial-radius (cos (* k (degrees-to-radians theta)))))))))
;;   (fork (:delay 600)
;;     (detach obj *game*)))
