;; This file is part of yashmup

;; event.lisp
;;
;; Contains the event-queue and event classes, and code to interact with them.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Events
;;;

(defclass event ()
  ((payload
    :initarg :payload
    :accessor payload
    :documentation "A function, that contains the code to be executed.")
   (exec-frame
    :initarg :exec-frame
    :accessor exec-frame
    :documentation "The time of execution when this event will be considered 'cooked'. 
By default, all events are immediately cooked.")))

(defun make-event (payload 
		   &key (delay 0) start-frame
		   (level (current-level *game*))
		   repetitions (repeat-delay 0))
  "Generates one or more events that execute PAYLOAD."
  (let ((target-frame (or start-frame (current-frame level))))
    (push-event (make-instance 'event
			       :payload payload 
			       :exec-frame (+ delay target-frame))
		level)
    (when repetitions
      (labels ((recurse (times)
			 (if (<= times 0)
			     nil
			     (progn
			       (push-event (make-instance 'event
							  :payload payload 
							  :exec-frame (+ repeat-delay (current-frame level)))
					   level)
			       (push-event (make-instance 'event
							  :payload (lambda ()
								     (recurse (1- times)))
							  :exec-frame (+ repeat-delay (current-frame level)))
					   level)))))
	(recurse repetitions)))))

(defmacro fork ((&key level delay repetitions repeat-delay) 
		&body body)
  "Turns BODY into one or more event-loop events."
  `(make-event (lambda () ,@body)
	       ,@(when level `(:level ,level))
	       ,@(when delay `(:delay ,delay))
	       ,@(when repetitions `(:repetitions ,repetitions))
	       ,@(when repeat-delay `(:repeat-delay ,repeat-delay))))

;;;
;;; Event-queue
;;;
(defun make-event-queue ()
  (make-priority-queue :key #'exec-frame))

;;; Generics
(defgeneric push-event (event level)
  (:documentation "Adds EVENT to LEVEL's event-queue"))
(defgeneric peek-next-event (level)
  (:documentation "Peeks at the next event in LEVEL's event-queue without removing it.
Returns NIL if there are no queued events."))
(defgeneric pop-next-event (level)
  (:documentation "Returns the next available event, and removes it from LEVEL's event-queue.
Returns NIL if there is nothing in the queue."))
(defgeneric clear-events (level)
  (:documentation "Clears all events off the event queue"))

;;; Methods
(defmethod push-event ((event event) (level level))
  (priority-queue-insert (event-queue level) event)
  t)

(defmethod peek-next-event ((level level))
  (priority-queue-minimum (event-queue level)))

(defmethod pop-next-event ((level level))
  (priority-queue-extract-minimum (event-queue level)))

(defmethod clear-events ((level level))
  (let ((pause-state (paused-p level)))
   (setf (event-queue level) (make-event-queue))
   (setf (paused-p level) pause-state)))

;;;
;;; Event processing
;;;

;;; Generics
(defgeneric process-next-event (level)
  (:documentation "Grabs the next event from LEVEL's event queue and executes it."))

(defgeneric process-cooked-events (level)
  (:documentation "Processes all cooked events in LEVEL"))

(defgeneric event-available-p (level)
  (:documentation "Is there a cooked event available?"))

(defgeneric execute-event (event)
  (:documentation "Takes care of executing a particular event."))

(defgeneric cooked-p (event)
  (:documentation "Is the event ready to fire?"))


;;; Methods

(defmethod process-next-event ((level level))
  "Processes the next event in EVENT-QUEUE, executing it if it's 'baked'."
  (when (event-available-p level)
    (let ((event (pop-next-event level)))
      (execute-event event))))

(defmethod event-available-p ((level level))
  "Simply peeks to see if there's an event in the queue, and if it's cooked."
  (when (and (peek-next-event level)
	     (cooked-p (peek-next-event level)))
    t))

(defmethod cooked-p ((event event))
  "Simply checks that it doesn't shoot its load prematurely.."
  (let  ((frame-difference (- (exec-frame event) (current-frame (current-level *game*)))))
    (when (<= frame-difference 0)
      t)))

(defmethod execute-event ((event event))
  "Executes a standard event. Nothing fancy, just a funcall."
  (funcall (payload event)))

(defmethod process-cooked-events ((level level))
  (loop
     while (event-available-p level)
     do (process-next-event level)))

;;; Helper Macro
