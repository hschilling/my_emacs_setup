;;; ID: toggle-vars.el,v 1.5 1998/09/27 07:03:00 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Toggle certain variables.

;;;###autoload
(defun toggle-case-fold-search ()
  "If `case-fold-search' is currently nil, make it t.  Otherwise make it nil."
  (interactive)
  (setq case-fold-search (not case-fold-search)))

(provide 'toggle-vars)

;;; toggle-vars.el,v1.5 ends here
