;;; ID: xscreensaver-command.el,v 1.9 1998/09/27 07:04:17 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Funcs to interact w/ xscreensaver(1).

;;;###autoload
(defun xscreensaver-command (cmd)
  "Run xscreensaver-command(1) with CMD, a string."
  (interactive "sRun: xscreensaver-command ")
  (bg-shell-command (format "xscreensaver-command %s" cmd)))

;;;###autoload
(defun xscreensaver-command-activate ()
  "Activate xscreensaver(1)."
  (interactive)
  (xscreensaver-command "-activate"))

;;;###autoload
(defun xscreensaver-command-restart ()
  "Restart xscreensaver(1)."
  (interactive)
  (xscreensaver-command "-restart"))

(provide 'xscreensaver-command)

;;; xscreensaver-command.el,v1.9 ends here
