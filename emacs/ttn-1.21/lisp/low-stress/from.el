;;; ID: from.el,v 1.8 1998/09/27 06:55:34 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Basically, "egrep '^From ' $MAIL" (note the SPC).

;;;###autoload
(defun from ()
  "Where's the mail coming from?"
  (interactive)
  (saved-shell-command "egrep '^From ' $MAIL"))

(provide 'from)

;;; from.el,v1.8 ends here
