;;; eval-last-page.el,v 1.9 1998/09/27 06:54:55 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Support for AHM.  :->

(defvar eval-last-page nil
  "If non-nil by setting in first line, evals func `eval-last-page'.")
(make-variable-buffer-local 'eval-last-page)

;;;###autoload (add-hook 'find-file-hooks 'maybe-eval-last-page t)

;;;###autoload
(defun maybe-eval-last-page ()
  "Checks local var `eval-last-page', and if set, calls `eval-last-page'."
  (if eval-last-page
      (eval-last-page)))

(make-local-hook 'eval-last-page-after-narrow-hook)

;;;###autoload
(defun eval-last-page ()
  "Evals last page as LISP code, then narrows to next-to-last page.
Runs hook `eval-last-page-after-narrow-hook' if defined."
  (interactive)
  (setq eval-last-page-after-narrow-hook nil) ; maybe not necessary
  (goto-char (point-max))
  (mark-page)
  (eval-region (point) (mark))
  (forward-page -1)
  (narrow-to-page)
  (run-hooks 'eval-last-page-after-narrow-hook))

(provide 'eval-last-page)

;;; eval-last-page.el,v1.9 ends here
