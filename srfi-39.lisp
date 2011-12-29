;;;; srfi-39.lisp

(cl:in-package :srfi-39.internal)

(declaim (inline null? set-car! set-cdr!))

(defun null? (obj)
  (null obj))

(defun set-car! (list obj)
  (rplaca list obj))

(defun set-cdr! (list obj)
  (rplacd list obj))

(defun dynamic-wind (in body out)
  (declare (function in body out))
  (funcall in)
  (unwind-protect (funcall body)
    (funcall out)))

(defun make-parameter (init &rest conv)
  (let ((converter
         (if (null? conv) (lambda (x) x) (car conv)) ))
    (declare (function converter))
    (let ((global-cell
           (cons :false (funcall converter init)) ))
      (labels ((parameter (&rest new-val)
                  (let ((cell (dynamic-lookup #'parameter global-cell)))
                    (cond ((null? new-val)
                           (cdr cell) )
                          ((null? (cdr new-val))
                           (set-cdr! cell (funcall converter (car new-val))) )
                          (:else ; this case is needed for parameterize
                           (funcall converter (car new-val)) )))))
        (set-car! global-cell #'parameter)
        #'parameter ))))

(define-syntax parameterize
  (syntax-rules ()
    ((parameterize ((expr1 expr2) ***) body ***)
     (dynamic-bind (list expr1 ***)
                   (list expr2 ***)
                   (lambda () body ***)))))

(let ((dynamic-env-local '()))
  (flet ((dynamic-env-local-get ()
           dynamic-env-local )
         (dynamic-env-local-set! (new-env)
           (setq dynamic-env-local new-env) ))
    (declare (inline dynamic-env-local-set!
                     dynamic-env-local-get))
    (defun dynamic-bind (parameters values body)
      (declare (function body))
      (let* ((old-local
              (dynamic-env-local-get) )
             (new-cells
              (mapcar (lambda (parameter value)
                        (declare (function parameter))
                        (cons parameter (funcall parameter value :false)) )
                      parameters
                      values ))
             (new-local
              (append new-cells old-local) ))
        (dynamic-wind
         (lambda () (dynamic-env-local-set! new-local))
         body
         (lambda () (dynamic-env-local-set! old-local)) )))

    (defun dynamic-lookup (parameter global-cell)
      (or (assoc parameter (dynamic-env-local-get) :test #'eq)
          global-cell ))))

#|(let ((dynamic-env-local '()))
  (defun dynamic-bind (parameters values body)
    (declare (function body))
    (let* ((old-local
            dynamic-env-local )
           (new-cells
            (mapcar (lambda (parameter value)
                      (declare (function parameter))
                      (cons parameter (funcall parameter value :false)) )
                    parameters
                    values ))
           (new-local
            (append new-cells old-local) ))
      (dynamic-wind
       (lambda () (setq dynamic-env-local new-local))
       body
       (lambda () (setq dynamic-env-local old-local)) )))

  (defun dynamic-lookup (parameter global-cell)
    (or (assoc parameter dynamic-env-local :test #'eq)
        global-cell )))|#

#|(defvar =dynamic-env-local= '())|#

#|(define-symbol-macro dynamic-env-local =dynamic-env-local=)|#

;;; eof
