;;; ID: narrowed-to-page-p.el,v 1.8 1998/09/27 06:58:37 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Return nil if not narrowed to page boundaries.

;;;###autoload
(defun narrowed-to-page-p ()
  "Returns nil if not narrowed to page boundaries."
  (or (/= (point-min) 1)
      (/= (point-max) (1+ (buffer-size)))))

(provide 'narrowed-to-page-p) 

;;; narrowed-to-page-p.el,v1.8 ends here
