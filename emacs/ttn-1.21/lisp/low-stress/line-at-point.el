;;; ID: line-at-point.el,v 1.8 1998/09/27 06:57:07 ttn Exp

;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Return current line as a string (w/o terminating newline).

;;;###autoload
(defun line-at-point ()
  "Returns current line as a string."
  (interactive)
  (save-excursion
    (buffer-substring (progn (end-of-line) (point))
		      (progn (beginning-of-line) (point)))))

(provide 'line-at-point)

;;; line-at-point.el,v1.8 ends here
