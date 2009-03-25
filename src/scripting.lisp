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