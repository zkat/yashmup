;; level-script file for testing 

(let ((an-enemy (make-instance 'enemy :y 0 :x 0)))
  (fork (:delay 60)
    (setf (angle an-enemy) 180)
    (setf (velocity an-enemy) 1)
    (fire! an-enemy)
    (fork (:delay 120)
      (setf (angle an-enemy) 0)
      (setf (velocity an-enemy) 3)
      (fork (:delay 10 :repeat 3)
	(fire! an-enemy))))
  (push an-enemy (enemies *game*)))
	 