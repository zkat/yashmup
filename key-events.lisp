(in-package :yashmup)

(defvar *keys-held-down* (make-hash-table :test 'eq))

(defun handle-key-down (key)
  (key-was-pressed key))

(defun handle-key-up (key)
  (key-was-released key))

(defun key-was-pressed (key)
  (setf (gethash key *keys-held-down*) t))

(defun key-was-released (key)
  (setf (gethash key *keys-held-down*) nil))

(defun key-down-p (key)
  (let ((down-p (gethash key *keys-held-down*)))
    down-p))
