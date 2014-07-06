;;; ID: updating-shell-command.el,v 1.8 1998/09/27 07:03:54 ttn Exp

;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;; still pretty rough, bedtime now.

;;;###autoload
(defun updating-shell-command (cmd)
  "In a shell, run CMD every five seconds."
  (interactive "sCommand: ")
  (while (progn
	   (shell-command cmd)
	   (set-buffer "*Shell Command Output*")
	   (goto-char (point-max))
	   (insert "\n" (current-time-string))
	   (sit-for 5))))

(provide 'updating-shell-command)

;;; updating-shell-command.el,v1.8 ends here
