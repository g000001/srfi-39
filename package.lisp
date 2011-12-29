;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-39
  (:use)
  (:export :make-parameter
           :parameterize))

(defpackage :srfi-39.internal
  (:use :srfi-39 :cl :fiveam :mbe))
