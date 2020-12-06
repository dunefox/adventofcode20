(ql:quickload :cl-ppcre)
(use-package :cl-ppcre)
(ql:quickload :str)
(use-package :str)
(ql:quickload :fiveam)
(use-package :fiveam)

(declaim (optimize (debug 0) (safety 0) (speed 3)))

;; Read input

(defun file-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))

(defun parse-data (content)
  (let* ((blocks   (cl-ppcre:split (coerce '(#\Newline #\Newline) 'string) content))
         (nonempty (remove-if (lambda (x) (string= x "")) blocks))
         (parsed   (mapcar (lambda (x) (cl-ppcre:regex-replace-all "\\n" x " ")) nonempty)))
    parsed))

(defvar *input* '())
(setf *input* (parse-data (file-string "06input.txt")))

;; Part 1
;; For part 1 I extracted the answers in a block:
;; "a\n\b\n\c" => "abc"
;; which made the deduplication much easier but for part 2 I had to change parse-data
(defun run1 (answers)
  (let* ((dedup (remove-duplicates (coerce answers 'list) :test #'string=)))
    (length dedup)))

(defun part1 (all-answers)
  (apply #'+ (mapcar #'run1 all-answers)))

;; Part 2
(defun run2 (answers)
  (let* ((chars (mapcar (lambda (x) (coerce x 'list)) answers))
         (initial (car chars))
         (rest (cdr chars)))
    (length (reduce #'intersection rest :initial-value initial))))

(defun part2 (answers)
  (apply #'+ (mapcar #'run2 answers)))

(defun main ()
  (let* ((answer-blocks (mapcar (lambda (x) (str:split #\Space x :omit-nulls t))
                                *input*))
         (sums (part2 answer-blocks)))
    sums))

(main)
(time (main))

;;Tests

(def-suite my-suite :description "AOC Day 6 Tests")
(in-suite my-suite)

(test my-tests
  "Examples"
  (is (= (run2 '("abc")) 3))
  (is (= (run2 '("a" "b" "c")) 0))
  (is (= (run2 '("ab" "ac")) 1))
  (is (= (run2 '("b")) 1))
  (is (= (run2 '("a" "a" "a" "a")) 1))
  (is (= (part2 (list '("abc") '("a" "b" "c") '("ab" "ac") '("a" "a" "a" "a") '("b"))) 6)))

(run!)
