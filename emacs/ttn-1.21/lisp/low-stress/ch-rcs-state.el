;;; ID: ch-rcs-state.el,v 1.7 1998/09/27 06:52:20 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Change the RCS "state" of a file.

;;;###autoload
(defun ch-rcs-state (file new-state)
  "Set FILE's RCS state to NEW-STATE."
  (interactive "fFile: \nsNew state: ")
  (switch-to-buffer (find-file file))
  (shell-command (format "co -l %s; ci -u -s%s -m\"state now %s\" %s"
			 file new-state new-state file))
  (kill-buffer (current-buffer))
  (find-file file))

(provide 'ch-rcs-state)

;;; ch-rcs-state.el,v1.7 ends here
