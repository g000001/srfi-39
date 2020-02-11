;;;; srfi-39.asd

(cl:in-package :asdf)


(defsystem :srfi-39
  :version "20200211"
  :description "SRFI 39 for CL: Parameter objects"
  :long-description "SRFI 39 for CL: Parameter objects
https://srfi.schemers.org/srfi-39"
  :author "Marc Feeley"
  :maintainer "CHIBA Masaomi"
  :serial t
  :depends-on (:mbe :fiveam)
  :components ((:file "package")
               (:file "srfi-39")
               (:file "test")))


(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-39))))
  (let ((name "https://github.com/g000001/srfi-39")
        (nickname :srfi-39))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-39))))
  (let ((*package*
         (find-package
          "https://github.com/g000001/srfi-39#internals")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-39)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))


;;; *EOF*
