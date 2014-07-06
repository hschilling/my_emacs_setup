;;; ID: append-to-nth-buffer.el,v 1.8 1998/09/27 06:50:17 ttn Exp

;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;; based on distribution's version found in simple.el.  args different.
;;;###autoload
(defun append-to-nth-buffer (start end &optional which)
  "Append to specified buffer the text of the region.
It is inserted into that buffer before its point.

When calling from a program, give three arguments:
START, END and WHICH.
START and END specify the portion of the current buffer to be copied.
WHICH is a prefix argument interpreted as an index into the buffer-list.
  When no argument is given, the target buffer is the next one down."
  (interactive "r\np")
  (let ((target (if (= 1 which)
		    (other-buffer)
		  (elt (buffer-list) which))))
    (if (or (not target)
	    (cdr (assoc 'buffer-read-only (buffer-local-variables target))))
	(message "Cannot write to buffer `%s'." target)
      (append-to-buffer target start end)
      (if (interactive-p)
	  (message "Modified buffer `%s'." target)))))

(provide 'append-to-nth-buffer)

;;; append-to-nth-buffer.el,v1.8 ends here
