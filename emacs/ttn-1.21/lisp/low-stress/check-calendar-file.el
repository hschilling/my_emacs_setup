;;; ID: check-calendar-file.el,v 1.8 1998/09/27 06:52:33 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Old (probably rotten) code for calendar munging.

;;;###autoload
(defun check-calendar-file () "should be called only as part of calendar-hook"
  (save-excursion
    (let ((buffer-read-only nil)
	  (cf (generate-new-buffer "*calendar-file*")))
      (goto-char (point-max)) (insert "\n\nfor today:\n----------\n")
      (if (not (file-exists-p "~/etc/calendar"))
	  (set-window-start (selected-window) 1)
	(save-excursion
	  (set-buffer cf)
	  (insert-file-contents "~/etc/calendar")
	  (replace-regexp "/\\*\\(.*\n\\)*.*\\*/" "")
	  (goto-char 1)
	  (let*
	      ((month (substring (current-time-string) 4 7))
	       (mnum (int-to-string
		      (nth 1 (assoc
			      month
			      '(("Jan" 1) ("Feb" 2) ("Mar" 3) ("Apr" 4)
				("May" 5) ("Jun" 6) ("Jul" 7) ("Aug" 8)
				("Sep" 9) ("Oct" 10) ("Nov" 11) ("Dec" 12))))))
	       (date-re
		(concat "^[ \t]*\\(" month "[ \t]+\\|" mnum
			"/\\|\\*[ \t]+\\)"
			(substring (current-time-string) 8 10)))
	       (match-count 0))
	    (while (re-search-forward date-re (point-max) t)
	      (re-search-forward "[^ \t].*\n" (point-max) t)
	      (append-to-buffer "*Calendar*" (match-beginning 0)
				(match-end 0))
	      (setq match-count (1+ match-count)))
	    (set-buffer "*Calendar*")
	    (if (> match-count 0) (enlarge-window (+ 3 match-count))))))
      (kill-buffer cf)
      (set-window-start (selected-window) 1))))

(provide 'check-calendar-file)

;;; check-calendar-file.el,v1.8 ends here
