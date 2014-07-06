;;; ID: split-into-3-windows.el,v 1.10 1998/09/27 07:02:19 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Split frame into three windows.  Prefix arg changes axis.

;;;###autoload
(defun split-into-3-windows (&optional arg)
  "Splits one window into three, highest first.  Optional ARG inverts axis.
Currently, doesn't work while minibuffer is busy."
  (interactive "P")
  (let* ((old (if arg (window-width) (window-height)))
	 (v (/ (- old 2) 3)))
    (if arg
	(progn
	  (split-window-horizontally)
	  (while (> (window-width) v)
	    (shrink-window-horizontally 1))
	  (other-window 1)
	  (split-window-horizontally)
	  (other-window -1))
      (split-window-vertically)
      (while (> (window-height) v) (shrink-window 1))
      (other-window 1)
      (split-window-vertically)
      (other-window -1))))

(provide 'split-into-3-windows)

;;; split-into-3-windows.el,v1.10 ends here
