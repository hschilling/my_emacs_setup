;;; ID: vt220-term.el,v 1.9 1998/09/27 07:04:00 ttn Exp

;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;;###autoload
(defun vt220-term ()
  "Sets up vt220 terminals."
  (interactive)
  (when (string= (getenv "TERM") "vt220")
    (global-set-key [select] 'set-mark-command)
    (global-set-key [insertchar] 'yank)
    (global-set-key [deletechar] 'kill-region)
    (global-set-key [help] 'eval-expression)
    (global-set-key [menu] 'advertised-undo)
    (global-set-key [f13] 'previous-buffer)
    (global-set-key [f14] 'next-buffer)
    (global-set-key [f17] 'shrink-window)
    (global-set-key [f18] 'enlarge-window)
    (global-set-key [f19] 'goto-previous-window)
    (global-set-key [f20] 'other-window)
    (global-set-key [select] 'set-mark-command)
    (global-set-key [insertchar] 'yank)
    (global-set-key [deletechar] 'kill-region)
    (global-set-key [help] 'eval-expression)
    (global-set-key [menu] 'advertised-undo)
    (global-set-key [f13] 'previous-buffer)
    (global-set-key [f14] 'next-buffer)
    (global-set-key [f17] 'shrink-window)
    (global-set-key [f18] 'enlarge-window)
    (global-set-key [f19] 'goto-previous-window)
    (global-set-key [f20] 'other-window)
    (global-set-key [f10] 'give-me-a-scratch-lisp-buffer-now!)
    (global-set-key [f11] 'kill-buffer-close-window)
    (global-set-key [f12] 'delete-window)
    ;; Add keybindings here.
    ))

(provide 'vt220-term)

;;; vt220-term.el,v1.9 ends here
