;;; ID: ae.el,v 1.10 1998/09/27 06:49:41 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Auto-editing amusement: watch Emacs spaz out!

(require 'ttn-macros)

(defun ae-make-smooth-array-backwards (n delta)
  (if (> n 0)
      (cons (- n delta)
	    (ae-make-smooth-array-backwards (- n delta) delta))
    '()))

(defun ae-make-smooth-array (n delta)
  (nreverse (ae-make-smooth-array-backwards n delta)))

(defun ae-fill-paragraph ()
  "Fills paragraphs w/ justification.  See `fill-paragraph'."
  (fill-paragraph 1))

(defun ae-spaz-out-paragraph ()
  "Makes the current paragraph spaz out until user intervenes."
  (interactive)
  (let ((delays (mapcar (progsa (x)
			  (let ((s (sin x)))
			    (apply '* (make-list 24 s))))
			(ae-make-smooth-array pi 0.2)))
	(fill-column fill-column)
	(fc-min fill-column)
	(fc-max fill-column))
    (setcdr (last delays) delays)	; DAG is now DG
    (while (and delays (sit-for (car delays)))
      (ae-fill-paragraph)
      (message "%f [%d %d %d]" (car delays) fc-min fill-column fc-max)
      (setq delays (cdr delays))
      (when (> 25 (random 100))
	(setq fill-column (+ fill-column (1- (random 3))))
	(when (< fill-column fc-min)
	  (setq fc-min fill-column))
	(when (> fill-column fc-max)
	  (setq fc-max fill-column))))))

;;;###autoload
(defun ae ()
  "Kicks off an auto-editing session.  Wow."
  (interactive)
  (ae-spaz-out-paragraph))

(provide 'ae)

;;; ae.el,v1.10 ends here
