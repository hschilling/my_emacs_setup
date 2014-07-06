;;; emacs-vers.el,v 1.9 1998/08/19 22:45:59 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Which emacs are we using anyway?!  "One" True Editor, ha!

(defvar emacs-type nil
  "Either `lucid' or `fsf'.")

;;;###autoload
(defun emacs-type-eq (flavor)
  (eq flavor emacs-type))

;;;###autoload
(defun emacs-version-at-least (num)
  (>= emacs-major-version num))

(setq emacs-type (if (string-match "lucid" emacs-version) 'lucid 'fsf))

(provide 'emacs-vers)

;;; emacs-vers.el,v1.9 ends here
