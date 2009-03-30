;; test-level.lisp
;;
;; This should help me figure out what a single level should look like...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(let ((level (make-instance 'level)))
  (fork (:level level :delay 50 :repeat 20)
    (attach (make-instance 'enemy) level))
  (fork (:level level :delay (* 50 20))
    (fork (:level level :delay 1 :repeat 50)
      (attach (make-instance 'enemy) level))
    (fork (:level level :delay 300)
      (print "Level over")))
  (setf (current-level *game*) level))
