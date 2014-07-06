;;; ID: give-me-a-scratch-buffer-now.el,v 1.9 1998/09/27 06:55:41 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Find *scratch* buffer; put it in lisp-interaction-mode.
;;; Prefix arg guarantees new buffer.
;;;
;;; I leave the mode to the default hook, in this case text-mode-hook (qv).

;;;###autoload
(defun give-me-a-scratch-buffer-now (want-new)
  "Bring up *scratch* or younger siblings if prefixed."
  (interactive "P")

  (switch-to-buffer
   (if want-new
       (generate-new-buffer "*scratch*")
     "*scratch*"))
  (lisp-interaction-mode))

(provide 'give-me-a-scratch-buffer-now)

;;; give-me-a-scratch-buffer-now.el,v1.9 ends here
