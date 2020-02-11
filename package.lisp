;;;; package.lisp

(cl:in-package cl-user)


(defpackage "https://github.com/g000001/srfi-39"
  (:use)
  (:export make-parameter
           parameterize))


(defpackage "https://github.com/g000001/srfi-39#internals"
  (:use "https://github.com/g000001/srfi-39"
        cl
        fiveam
        mbe))


;;; *EOF*
