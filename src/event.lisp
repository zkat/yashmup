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
    :initform (current-frame *game*)
    :accessor exec-frame
    :documentation "The time of execution when this event will be considered 'cooked'. 
By default, all events are immediately cooked.")))

(defun make-event (payload &key (delay 0))
  "Creates a new event, with PAYLOAD being a function that contains everything to be executed.
It also accepts a DELAY, in milliseconds, until the event is ready to go. Otherwise, it's
ready immediately."
  (push-event (make-instance 'event
			     :payload payload 
			     :exec-frame (+ delay (current-frame *game*)))
	      *game*))

;;;
;;; Event-queue
;;;

;;; Generics
(defgeneric push-event (event game)
  (:documentation "Adds EVENT to GAME's event-queue"))
(defgeneric peek-next-event (game)
  (:documentation "Peeks at the next event in GAME's event-queue without removing it.
Returns NIL if there are no queued events."))
(defgeneric pop-next-event (game)
  (:documentation "Returns the next available event, and removes it from GAME's event-queue.
Returns NIL if there is nothing in the queue."))
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
   (setf (event-queue game) (make-priority-queue :key #'exec-frame))
   (setf (paused-p game) pause-state)))

;;;
;;; Event processing
;;;

;;; Generics
(defgeneric process-next-event (game)
  (:documentation "Grabs the next event from GAME's event queue and executes it."))

(defgeneric process-cooked-events (game)
  (:documentation "Processes all cooked events in GAME"))

(defgeneric event-available-p (game)
  (:documentation "Is there a cooked event available?"))

(defgeneric execute-event (event)
  (:documentation "Takes care of executing a particular event."))

(defgeneric cooked-p (event)
  (:documentation "Is the event ready to fire?"))


;;; Methods

;; Why am I not using this in main.lisp? ffs.
(defmethod process-next-event ((game game))
  "Processes the next event in EVENT-QUEUE, executing it if it's 'baked'."
  (when (event-available-p game)
    (let ((event (pop-next-event game)))
      (execute-event event))))

(defmethod event-available-p ((game game))
  "Simply peeks to see if there's an event in the queue, and if it's cooked."
  (when (and (peek-next-event game)
	     (cooked-p (peek-next-event game)))
    t))

(defmethod cooked-p ((event event))
  "Simply checks that it doesn't shoot its load prematurely.."
  (let  ((frame-difference (- (exec-frame event) (current-frame *game*))))
    (when (<= frame-difference 0)
      t)))

(defmethod execute-event ((event event))
  "Executes a standard event. Nothing fancy, just a funcall."
  (funcall (payload event)))

(defmethod process-cooked-events ((game game))
  (loop
     while (event-available-p *game*)
     do (process-next-event *game*)))