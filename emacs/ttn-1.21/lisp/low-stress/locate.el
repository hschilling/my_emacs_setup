;;; ID: locate.el,v 1.5 1998/09/27 06:57:23 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Interface to locate(1).

;;;###autoload
(defun locate (args)
  "Do shell command locate(1) w/ ARGS, a string."
  (interactive "sShell command: locate ")
  (shell-command (concat "locate " args)))

(provide 'locate)

;;; locate.el,v1.5 ends here
