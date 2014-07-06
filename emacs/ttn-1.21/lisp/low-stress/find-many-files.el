;;; ID: find-many-files.el,v 1.9 1998/09/27 06:55:01 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Slurp all files in some dir, given a regular expression.
;;;
;;; todo: Use globbing instead of rx.

;;;###autoload
(defun find-many-files (&optional dir pattern)
  "opens all the files in current directory or in DIR if non-nil"
  (interactive "DDirectory? \nsPattern? ")
  (cd dir)
  (if (string= "" pattern) (setq pattern nil))
  (let ((all (reverse (directory-files dir t pattern))))
    (mapcar 'find-file all)))

(provide 'find-many-files)

;;; find-many-files.el,v1.9 ends here
