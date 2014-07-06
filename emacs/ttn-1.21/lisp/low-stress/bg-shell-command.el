;;; ID: bg-shell-command.el,v 1.11 1998/09/27 06:51:02 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Run a shell command in the background, renaming buffer.

;;;###autoload
(defun bg-shell-command (cmd &optional watch)
  "Do shell CMD in background, renaming controlling buffer.
If optional arg WATCH non-nil, switch to that buffer, otherwise show nothing."
  (interactive "sShell command (to be backgrounded): \np")
  (let (buf)
    (save-excursion
      (save-window-excursion
	(shell-command (concat cmd "&"))
	(set-buffer "*Async Shell Command*")
	(setq buf (rename-buffer (concat "*bg job* " cmd) t))))
    (when watch
      (switch-to-buffer buf))))

(provide 'bg-shell-command)

;;; bg-shell-command.el,v1.11 ends here
