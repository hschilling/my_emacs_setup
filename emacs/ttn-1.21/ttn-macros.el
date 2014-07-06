;;; ttn-macros.el,v 1.60 1998/09/27 06:41:40 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Fundamental macros.  Basic idea is to minimize.

(require 'cl)

(defmacro progs (&rest body)		; simple lambda
  `(function (lambda ()
	       ,@body)))

(defmacro progsa (args &rest body)	; simple-w/-args lambda
  `(function (lambda ,args
	       ,@body)))

(defmacro progc (&rest body)		; simple command
  `(function (lambda ()
	       (interactive)
	       ,@body)))

(defmacro progca (args istr &rest body)	; simple-w/-args command
  `(function (lambda ,args
	       (interactive ,istr)
	       ,@body)))

(defalias 'd. 'defun)

(mapc
 (progsa (macro) (put macro 'lisp-indent-function 'defun))
 '(progs progsa progc progca d.))

(provide 'ttn-macros)

;;; ttn-macros.el,v1.60 ends here
