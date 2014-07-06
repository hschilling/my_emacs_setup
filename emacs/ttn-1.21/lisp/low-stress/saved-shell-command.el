;;; ID: saved-shell-command.el,v 1.9 1998/09/27 07:01:19 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Do a shell command, asking for luser mercy on output.

;;;###autoload
(defun saved-shell-command (cmd)
  "Does a `shell-command', renames buffer, optionally kills it."
  (interactive "sShell command: ")
  (let ((n 0)
	(newname (concat "ssc: " cmd))
	(oldw (selected-window))
	(numlines 0)
	(window-min-height 1))
    (shell-command cmd)
    (switch-to-buffer-other-window "*Shell Command Output*")
    (while (get-buffer newname)
      (setq newname (format "ssc: %s <%d>" cmd (setq n (1+ n)))))
    (rename-buffer newname)
    (setq numlines (count-lines 1 (point-max)))
    (if (> numlines 0)
	(progn
	  (if (< numlines (window-height))
	      (enlarge-window (- (1+ numlines) (window-height))))
	  (if (y-or-n-p "Keep? ")
	      (setq buffer-read-only (message ""))
	    (delete-window)
	    (kill-buffer newname)
	    (message "")))
      (delete-window)
      (kill-buffer newname))
    (select-window oldw)))

(provide 'saved-shell-command)

;;; saved-shell-command.el,v1.9 ends here
