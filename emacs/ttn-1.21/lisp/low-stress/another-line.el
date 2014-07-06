;;; ID: another-line.el,v 1.10 1998/09/27 06:50:01 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Copy current line, incrementing numbers.  Bus-friendly.  :->

;;;###autoload
(defun another-line ()
  "Copies line, preserving cursor column, and increments any numbers found.
This should probably be generalized in the future."
  (interactive)
  (let* ((col (current-column))
	 (bol (progn (beginning-of-line) (point)))
	 (eol (progn (end-of-line) (point)))
	 (line (buffer-substring bol eol)))
    (beginning-of-line)
    (while (re-search-forward "[0-9]+" eol 1)
      (let ((num (string-to-int (buffer-substring
				  (match-beginning 0) (match-end 0)))))
	(replace-match (int-to-string (1+ num)))))
    (beginning-of-line)
    (insert line "\n")
    (move-to-column col)))

(provide 'another-line)

;;; another-line.el,v1.10 ends here
