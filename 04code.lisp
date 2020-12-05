(ql:quickload :str)
(ql:quickload :cl-ppcre)
(ql:quickload :iterate)
(use-package :str)
(use-package :cl-ppcre)
(use-package :iterate)

(declaim (optimize (debug 0) (safety 0) (speed 3)))

(defun file-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))

(defun get-prefixes (elements)
  (let ((prefixes (iter (for el in elements)
                        (collect (car (str:split #\: el))))))
    (remove-if (lambda (x) (string= x ""))
               (sort prefixes #'string<))))

(defun parse-data (content)
  (let* ((blocks   (cl-ppcre:split (coerce '(#\Newline #\Newline) 'string) content))
         (nonempty (remove-if (lambda (x) (string= x "")) blocks))
         (parsed   (mapcar (lambda (x) (cl-ppcre:regex-replace-all "\\n" x " ")) nonempty))
         (parts    (mapcar (lambda (x) (str:split #\Space x)) parsed))
         (prefixes (mapcar #'get-prefixes parts)))
     prefixes))

(defun valid-passport? (passport)
  (or (equal passport
             (list "byr" "cid" "ecl" "eyr" "hcl" "hgt" "iyr" "pid"))
      (equal passport
             (list "byr" "ecl" "eyr" "hcl" "hgt" "iyr" "pid"))))

(defvar *input* '())
(setf *input* (file-string "04input.txt"))

(defun main()
  (let* ((parsed (parse-data *input*))
         (validated (mapcar #'valid-passport? parsed))
         (result (count T (remove-if #'null validated))))
    (print result)))

(main)

