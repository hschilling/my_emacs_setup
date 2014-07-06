;;; ID: forward-page-ignore-narrow.el,v 1.8 1998/09/27 06:55:27 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Like `forward-page', except ignores page narrowing.

;;;###autoload
(defun forward-page-ignore-narrow (&optional count)
  "Like `forward-page', except ignores page narrowing."
  (interactive "p")
  (if (not (narrowed-to-page-p))
      (forward-page count)
    (widen)
    (forward-page count)
    (narrow-to-page)))

(provide 'forward-page-ignore-narrow)

;;; forward-page-ignore-narrow.el,v1.8 ends here
