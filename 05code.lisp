(ql:quickload :str)
(use-package :str)
(ql:quickload :fiveam)

(declaim (optimize (debug 0) (safety 0) (speed 3)))

;; Read input

(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

;; I stole this function from the internet
(defun integer->bit-vector (integer)
  "Create a bit-vector from a positive integer."
  (labels ((integer->bit-list (int &optional accum)
             (cond ((> int 0)
                    (multiple-value-bind (i r) (truncate int 2)
                      (integer->bit-list i (push r accum))))
                   ((null accum) (push 0 accum))
                   (t accum))))
    (coerce (integer->bit-list integer) 'bit-vector)))

(defvar *input* '())
(setf *input* (remove-if (lambda (x) (string= x "")) (get-file "05input.txt")))

;; Part 1

(defun walk (current ops)
  (cond ((eq ops '()) current)
        ((or (string= (car ops) #\F)
             (string= (car ops) #\L)) (walk (/ current 2) (cdr ops)))
        ((or (string= (car ops) #\B)
             (string= (car ops) #\R)) (+ (/ current 2) (walk (/ current 2) (cdr ops))))))

(defun run1 (spot &optional (range 128))
  (- (walk range (coerce spot 'list)) 1))

(defun calc1 (seat-id)
  (let ((row-id (run1 (substring 0 7 seat-id)))
        (col-id (run1 (substring 7 10 seat-id) 8)))
    (+ (* 8 row-id) col-id)))

;; Part 2

(defun my-seat (allseats)
  (labels ((find-seat (seats found)
             (cond ((<= (length seats) 1) found)
                   ((= (abs (- (car seats) (cadr seats))) 2)
                    (find-seat (cdr seats) (cons (+ 1 (car seats)) found)))
                   (t (find-seat (cdr seats) found)))))
    (find-seat allseats '())))

(defun main ()
  (let* ((part1 (mapcar #'calc1 *input*))
         (result (my-seat (sort part1 #'<))))
    result))

(main)

;; Tests

(use-package :fiveam)
(def-suite my-suite :description "AOC Day 5 Tests")
(in-suite my-suite)

(test my-tests
   "Examples"
  (is (= (calc1 "FBFBBFFRLR") 357))
  (is (= (calc1 "BFFFBBFRRR") 567))
  (is (= (calc1 "FFFBBBFRRR") 119))
  (is (= (calc1 "BBFFBBFRLL") 820)))

