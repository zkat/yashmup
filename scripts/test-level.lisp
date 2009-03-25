;; level-script file for testing 
(in-package :yashmup)
(dotimes (ix 20)
  (let ((an-enemy (make-instance 'enemy)))
    (fork (:delay 60)
      (setf (angle an-enemy) 180)
      (setf (velocity an-enemy) 1)
      (fire! an-enemy)
      (fork (:delay 120)
	(setf (angle an-enemy) 0)
	(setf (velocity an-enemy) 3)
	(fork (:delay 10 :repeat 3)
	  (fire! an-enemy))))
    (push an-enemy (enemies *game*))))

(dotimes (ix 20)
  (let ((an-enemy (make-instance 'enemy)))
    (fork (:delay 60)
      (setf (angle an-enemy) 180)
      (setf (velocity an-enemy) 1)
      (fire! an-enemy)
      (fork (:delay 120)
	(setf (angle an-enemy) 0)
	(setf (velocity an-enemy) 3)
	(fork (:delay 10 :repeat 3)
	  (fire! an-enemy))))
    (attach an-enemy *game*)))

(let ((the-enemy (make-instance 'enemy)))
  (move-in-a-circle the-enemy))

(defun move-in-a-circle (obj)
  (let ((circle-velocity (* 50 2 pi 1/240))
	(delta-angle 360/250)
	(the-angle (angle obj)))
    (fork (:delay 1 :repeat 240)
      (let* ((vertical (+ (velocity obj) (* circle-velocity (cos the-angle))))
	     (horizontal (* circle-velocity (sin the-angle)))
	     (theta (atan (/ horizontal vertical))))
	(setf (angle obj) (floor theta))
	(setf (velocity obj) (floor (sqrt (+ (expt vertical 2) (expt horizontal 2)))))
	(incf the-angle delta-angle)))))
