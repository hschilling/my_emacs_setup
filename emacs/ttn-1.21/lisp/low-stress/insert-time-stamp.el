;;; ID: insert-time-stamp.el,v 1.9 1998/09/27 06:57:00 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Insert time stamp string.  See source for format.

;;;###autoload
(defun insert-time-stamp (verbose)
  "Insert time string in current buffer.  Be verbose w/ prefix arg."
  (interactive "P")
  (and (not buffer-read-only)
       ;; hey, before you think you should waste more time...
       ;; ISO 8601 is ugly: "%Y-%m-%dT%T%z" => 1997-11-07T21:30:39-0800
       ;; current: "%Y.%m%d.%T%z"           => 1997.1107.21:34:10-0800
       (let ((format "%Y.%m%d.%T%z"))
	 (when verbose
	   (setq format (concat format ", d%j, %A")))
	 (insert (format-time-string format (current-time))))))

(provide 'insert-time-stamp)

;;; insert-time-stamp.el,v1.9 ends here
