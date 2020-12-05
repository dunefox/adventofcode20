(ql:quickload :iterate)
(use-package :iterate)

(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect (parse-integer line))))

(defvar *input* (get-file "01input.txt"))

; 2 summands
(defun walk-rest (diff start)
  (iter (for i from start below (length *input*))
    (when (member (- diff (nth i *input*)) *input*)
      (leave (* (nth i *input*) (- diff (nth i *input*)))))))

; 3 summands
(defun walk-all ()
  (iter (for i below (length *input*))
    (let* ((el (nth i *input*))
           (partial (walk-rest (- 2020 el) i)))
      (if partial
          (leave (* el partial))))))

(assert (= (walk-rest 2020 0) 299299))
(assert (= (walk-all) 287730716))

