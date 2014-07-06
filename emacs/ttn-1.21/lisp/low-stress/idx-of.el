;;; ID: idx-of.el,v 1.5 1998/09/27 06:56:36 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Return zero-based index of item in list.  Use `equal'.

;;;###autoload
(defun idx-of (item list)
  (let ((retval 0))
    (while (and list (not (equal item (car list))))
      (incf retval)
      (setq list (cdr list)))
    (and list retval)))

(provide 'idx-of)

;;; idx-of.el,v1.5 ends here
