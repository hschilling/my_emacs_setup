;;; ID: strip.el,v 1.8 1998/09/27 07:02:30 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Strip whitespace.  Inspired by GNU `make' func w/ same name.

;;;###autoload
(defun strip (s)
  "Return a new string derived by stripping whitespace surrounding string S."
  (interactive "sString: ")
  (let ((r s))
    (when (string-match "^ +" r)
      (setq r (substring r (match-end 0))))
    (when (string-match " +$" r)
      (setq r (substring r 0 (match-beginning 0))))
    r))

(provide 'strip)

;;; strip.el,v1.8 ends here
