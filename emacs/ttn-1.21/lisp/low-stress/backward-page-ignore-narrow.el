;;; ID: backward-page-ignore-narrow.el,v 1.8 1998/09/27 06:50:49 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Like `backward-page', except ignores page narrowing.

;;;###autoload
(defun backward-page-ignore-narrow (&optional count)
  "Like `backward-page', except ignores page narrowing."
  (interactive "p")
  (if (not (narrowed-to-page-p))
      (backward-page (1+ count))
    (widen)
    (backward-page (1+ count))
    (narrow-to-page)))

(provide 'backward-page-ignore-narrow)

;;; backward-page-ignore-narrow.el,v1.8 ends here
