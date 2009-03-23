;; This file is part of yashmup

;; event.lisp
;;
;; Contains the event-queue and event classes, and code to interact with them.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :yashmup)

;;;
;;; Event & Queue
;;;

(defclass event-queue ()
  ((priority-queue
    :initarg :priority-queue
    :initform (make-priority-queue :key #'exec-time)
    :accessor priority-queue)
   (paused-p
    :initarg :paused-p
    :initform nil
    :accessor paused-p)
   (locked-p
    :initarg :locked-p
    :initform nil
    :accessor locked-p)))

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



;;;
;;; Event-queue
;;;

;;; Generics
(defgeneric push-event (event event-queue))
(defgeneric peek-next-event (event-queue))
(defgeneric pop-next-event (event-queue))
(defgeneric pause (event-queue))
(defgeneric unpause (event-queue))
(defgeneric toggle-pause (event-queue))
(defgeneric clear (event-queue)
  (:documentation "Clears all events off the event queue"))
(defgeneric lock (event-queue))
(defgeneric unlock (event-queue))
(defgeneric toggle-lock (event-queue))

;;; Methods
(defmethod push-event ((event event) (queue event-queue))
  (priority-queue-insert (priority-queue queue) event)
  t)

(defmethod peek-next-event ((queue event-queue))
  (priority-queue-minimum (priority-queue queue)))

(defmethod pop-next-event ((queue event-queue))
  (priority-queue-extract-minimum (priority-queue queue)))

(defmethod pause ((event-queue event-queue))
  (setf (paused-p event-queue) t))

(defmethod unpause ((event-queue event-queue))
  (setf (paused-p event-queue) nil))

(defmethod toggle-pause ((event-queue event-queue))
  (if (paused-p event-queue)
      (unpause event-queue)
      (pause event-queue)))

(defmethod clear ((queue event-queue))
  (let ((pause-state (paused-p queue)))
   (setf (priority-queue queue) (make-instance 'event-queue))
   (setf (paused-p queue) pause-state)))

(defmethod lock ((queue event-queue))
  (setf (locked-p queue) t))

(defmethod unlock ((queue event-queue))
  (setf (locked-p queue) t))

(defmethod toggle-lock ((queue event-queue))
  (if (locked-p queue)
      (unlock queue)
      (lock queue)))




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

(defmethod process-next-event ((event-queue event-queue))
  "Processes the next event in EVENT-QUEUE, executing it if it's 'baked'."
  (unless (paused-p event-queue)
    (let ((next-event (peek-next-event event-queue)))
      (when (and next-event
		 (cooked-p next-event))
	(let ((event (pop-next-event event-queue)))
	  (execute-event event))))))

(defmethod cooked-p ((event event))
  "Simply checks that it doesn't shoot its load prematurely.."
  (when (<= (exec-time event)
	    (get-internal-real-time))
    t))

(defmethod execute-event ((event event))
  "Executes a standard event. Nothing fancy, just a funcall."
  (funcall (payload event)))

;;;
;;; Util
;;;

