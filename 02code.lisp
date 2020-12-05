(ql:quickload :str)
(in-package :str)

(declaim (optimize (debug 0) (safety 0) (speed 3)))

(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defvar *input* (remove-if (lambda (x) (string= x "")) (get-file "02input.txt")))

(defun parse-line (line)                                     ; "4-8 n: dnjjrtclnzdnghnbnn"
  (let* ((clean (remove-if (lambda (x) (char= x #\:)) line)) ; "4-8 n dnjjrtclnzdnghnbnn"
         (parts (words clean))                               ; ("4" "8" "n" dnjjrtclnzdnghnbnn)
         (pos   (split #\- (car parts)))                     ; ("4" "8")
         (from  (parse-integer (car pos)))                   ; 4
         (to    (parse-integer (cadr pos)))                  ; 8
         (c     (nth 1 parts))                               ; n
         (seq   (nth 2 parts)))                              ; dnjjrtclnzdnghnbnn
    (list from to c seq)))                                   ; (4 8 "n" "dnjjrtclnzdnghnbnn")

(defun validate1 (line)
  (destructuring-bind (from to n seq) line
    (let ((cnt (count-if (lambda (x) (string= x n)) seq)))
      (and (<= from cnt)
           (<= cnt to)))))

(defun validate2 (line)
  (destructuring-bind (from to n seq) line
    (let* ((fst_ (aref seq (- from 1)))
           (snd_ (aref seq (- to 1)))
           (eq1 (char= fst_ (coerce n 'character)))
           (eq2 (char= snd_ (coerce n 'character))))
      (or (and eq1 (not eq2)) (and (not eq1) eq2)))))

(defun main ()
  (let* ((clean (remove-if (lambda (x) (string= x "")) *input*))
         (parsed (mapcar #'parse-line clean))
         (results1 (mapcar #'validate1 parsed))
         (results2 (mapcar #'validate2 parsed)))
    (list (length (remove-if #'null results1))
          (length (remove-if #'null results2)))))

(assert (equal (main) (list 622 263)))

(time (main))

