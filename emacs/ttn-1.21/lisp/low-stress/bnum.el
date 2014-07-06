;;; ID: bnum.el,v 1.8 1998/09/27 06:51:18 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Convert a number to a binary string.  Also a list variant.

;;;###autoload
(defun bnum (n)
  "Returns positive number N represented in boolean, as a string."
  (if (= 0 n)
      "0"
    (let ((s ""))
      (while (/= 0 n)
	(setq s (concat (if (= 0 (% n 2)) "0" "1") s))
	(setq n (/ n 2)))
      s)))

;;;###autoload
(defun blist (&rest nums)
  "Returns list of positive NUMS represented in boolean, as a string."
  (mapcar #'bnum nums))

(provide 'bnum)

;;; bnum.el,v1.8 ends here
