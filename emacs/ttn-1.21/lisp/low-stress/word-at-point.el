;;; ID: word-at-point.el,v 1.7 1998/09/27 07:04:06 ttn Exp

;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Return word at point as a string.

;;;###autoload
(defun word-at-point ()
  "Returns current word as a string."
  (interactive)
  (save-excursion
    (save-match-data
      (cond ((looking-at "\\Sw")
	     (re-search-backward "\\<\\w+")
	     (buffer-substring (match-beginning 0) (match-end 0)))
	    (t
	     (re-search-forward "\\>")
	     (word-at-point)))
      )))

(provide 'word-at-point)

;;; word-at-point.el,v1.7 ends here
