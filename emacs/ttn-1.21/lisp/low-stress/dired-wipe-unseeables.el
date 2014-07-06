;;; ID: dired-wipe-unseeables.el,v 1.9 1998/09/27 06:54:35 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: In dired, remove lines w/ unseeable files/dirs.
;;; Currently, a little pessimistic.

;;;###autoload
(defun dired-wipe-unseeables ()
  "in dired, don't bother w/ unseeable files/dirs"
  (interactive)
  (save-excursion
    (goto-char 1)
    (let (buffer-read-only)
      (delete-matching-lines "---  "))))

(provide 'wipe-unseeables)

;;; dired-wipe-unseeables.el,v1.9 ends here
