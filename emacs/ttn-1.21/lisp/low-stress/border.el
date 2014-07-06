;;; ID: border.el,v 1.6 1998/09/27 06:51:34 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Given a list and break element, return "border" list.
;;; E.g., (border 3 '(1 2 3 4 5)) => (2 3 4 5).
;;; In conjunction w/ setcdr, this is useful for list splitting.

;;;###autoload
(defun border (elem lst)
  "Find sublist, using ELEM of LST, where ELEM is the cadr.  Test w/ equal."
  (and (consp lst)
       (consp (cdr lst))
       (or (and (equal elem (cadr lst))
		lst)
	   (border elem (cdr lst)))))

(provide 'border)

;;; border.el,v1.6 ends here
