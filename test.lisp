(cl:in-package :srfi-39.internal)

(def-suite srfi-39)

(in-suite srfi-39)

(defmacro deflex (name val)
  (let ((tem (intern (format nil "=~A=" name))))
    `(progn
       (defparameter ,tem nil)
       (define-symbol-macro ,name ,tem)
       (setf ,name ,val)
       ',name)))

(deflex radix (make-parameter 10))
(deflex write-shared
    (make-parameter
     nil
     (lambda (x)
       (if (typep x 'boolean)
           x
           (error "only booleans are accepted by write-shared")))))
(test make-parameter1
  (is (= 10 (funcall radix)))
  (funcall radix 2)
  (is (= 2 (funcall radix)))
  (signals (cl:error)
    (funcall write-shared 0)))

(deflex prompt
    (make-parameter
     123
     (lambda (x)
       (if (stringp x)
           x
           (with-output-to-string (out) (princ x out))))))

(test make-parameter2
  (is (string= "123" (funcall prompt)))
  (funcall prompt ">")
  (is (string= ">"
               (funcall prompt))))

(test parameterize
  (is (= 2 (funcall radix)))
  (is (= 16 (parameterize ((radix 16))
              (funcall radix))))
  (is (= 2 (funcall radix)))
  (defun f (n)
    (format nil "~VR" (funcall radix) n))
  (is (string= (f 10) "1010"))
  (is (string= (parameterize ((radix 8))
                 (f 10))
               "12"))
  (is (string= (parameterize ((radix 8) (prompt (f 10)))
                 (funcall prompt))
                 "1010")))

;;; eof
