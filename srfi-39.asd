;;;; srfi-39.asd

(cl:in-package :asdf)

(defsystem :srfi-39
  :serial t
  :depends-on (:mbe :fiveam)
  :components ((:file "package")
               (:file "srfi-39")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-39))))
  (load-system :srfi-39)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-39.internal :srfi-39))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
