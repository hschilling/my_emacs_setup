;;; ID: describe-this.el,v 1.8 1998/09/27 06:54:14 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Describe args, but w/o very good documentation.

;;;###autoload
(defun describe-this (&rest stuff)
  (let ((this stuff))
    (describe-variable 'this)))

(provide 'describe-this)

;;; describe-this.el,v1.8 ends here
