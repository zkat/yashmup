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
   (exec-time
    :initarg :exec-time
    :initform (get-internal-real-time)
    :accessor exec-time
    :documentation "The time of execution when this event will be considered 'cooked'. 
By default, all events are immediately cooked.")))

(defun make-event (payload &key (delay 0))
  "Creates a new event, with PAYLOAD being a function that contains everything to be executed.
It also accepts a DELAY, in milliseconds, until the event is ready to go. Otherwise, it's
ready immediately."
  (let ((internal-delay-time (* delay (/ internal-time-units-per-second 1000))))
    (push-event (make-instance 'event
			       :payload payload 
			       :exec-time (+ (get-internal-real-time) internal-delay-time))
		*game*)))

;;;
;;; Event-queue
;;;

;;; Generics
(defgeneric push-event (event game))
(defgeneric peek-next-event (game))
(defgeneric pop-next-event (game))
(defgeneric clear-events (game)
  (:documentation "Clears all events off the event queue"))

;;; Methods
(defmethod push-event ((event event) (game game))
  (priority-queue-insert (event-queue game) event)
  t)

(defmethod peek-next-event ((game game))
  (priority-queue-minimum (event-queue game)))

(defmethod pop-next-event ((game game))
  (priority-queue-extract-minimum (event-queue game)))

(defmethod clear-events ((game game))
  (let ((pause-state (paused-p game)))
   (setf (event-queue game) (make-priority-queue :key #'exec-time))
   (setf (paused-p game) pause-state)))

;;;
;;; Event processing
;;;

;;; Generics
(defgeneric process-next-event (event-queue)
  (:documentation "Grabs the next event from the event queue and executes it."))

(defgeneric execute-event (event)
  (:documentation "Takes care of executing a particular event."))

(defgeneric cooked-p (event)
  (:documentation "Is the event ready to fire?"))

;;; Methods

(defmethod process-next-event ((game game))
  "Processes the next event in EVENT-QUEUE, executing it if it's 'baked'."
  (unless (paused-p game)
    (let ((next-event (peek-next-event game)))
      (when (and next-event
		 (cooked-p next-event))
	(let ((event (pop-next-event game)))
	  (execute-event event))))))

(defmethod cooked-p ((event event))
  "Simply checks that it doesn't shoot its load prematurely.."
  (let  ((time-difference (time-difference (exec-time event))))
    (when (>= time-difference 0)
      t)))

(defmethod execute-event ((event event))
  "Executes a standard event. Nothing fancy, just a funcall."
  (funcall (payload event)))