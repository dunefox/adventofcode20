(ql:quickload :str)
(in-package :str)

(declaim (optimize (debug 3) (safety 3) (speed 0)))

(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defvar *input* '())
(setf *input* (remove-if (lambda (x) (string= x "")) (get-file "03example.txt")))

(print *input*)

;; Part 1

