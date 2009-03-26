(in-package :yashmup)

(defun time-difference (time-before)
  "Checks the difference between the internal-time provided and the current time.
Returns both the difference in time and the current-time used in the computation"
  (let ((time-now (get-internal-real-time)))
    (values (/ (- time-now time-before) internal-time-units-per-second)
	    time-now)))

(defun degrees-to-radians (degrees)
  (* (/ degrees 180) pi))

(defun radians-to-degrees (radians)
  (/ (* radians 180) pi))