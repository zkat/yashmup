;; This file is part of yashmup

;; scripting.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

(defmacro fork ((&key (delay 0) (repeat 1)) &body body)
  "Turns BODY into one or more event-loop events."
  (let ((loop-var (gensym "loop-var")))
    `(dotimes (,loop-var ,repeat)
       (push-event (make-instance 'event 
				  :payload (lambda () ,@body)
				  :exec-frame (+ (* ,delay (1+ ,loop-var)) (current-frame *game*)))
		   *game*))))