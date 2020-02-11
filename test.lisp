(cl:in-package "https://github.com/g000001/srfi-39#internals")


(def-suite* srfi-39)


(test make-parameter1
  (let ((radix (make-parameter 10))
        (write-shared
         (make-parameter
          nil
          (lambda (x)
            (if (typep x 'boolean)
                x
                (error "only booleans are accepted by write-shared"))))))
    (is (= 10 (funcall radix)))
    (is (= 2 (progn
               (funcall radix 2)
               (funcall radix))))
    (signals (cl:error)
      (funcall write-shared 0))))


(test make-parameter2
  (let ((prompt
         (make-parameter
          123
          (lambda (x)
            (if (stringp x)
                x
                (with-output-to-string (out) (princ x out)))))))
    (is (string= "123" (funcall prompt)))
    (is (progn
          (funcall prompt ">")
          (string= ">"
                   (funcall prompt))))))


(test parameterize
  (let ((radix (make-parameter 10))
        (prompt
         (make-parameter
          123
          (lambda (x)
            (if (stringp x)
                x
                (with-output-to-string (out) (princ x out)))))))
    (flet ((f (n)
             (format nil "~VR" (funcall radix) n)))
      (is (equalp (parameterize ((radix 2))
                    (list (funcall radix)
                          (parameterize ((radix 16)) (funcall radix))
                          (funcall radix)
                          (f 10)
                          (parameterize ((radix 8)) (f 10))
                          (parameterize ((radix 8) (prompt (f 10)))
                            (funcall prompt))))
                  '(2 16 2 "1010" "12" "1010"))))))


;;; *EOF*
