;;; ID: symbol-at-point.el,v 1.7 1998/09/27 07:02:52 ttn Exp

;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Return symbol at point as a string.

;;;###autoload
(defun symbol-at-point ()
  "Returns current symbol as a string."
  (interactive)
  (let ((cur (copy-syntax-table (syntax-table))))
    (do ((i 0 (1+ i)))
	((= i 256) nil)
      (when (= ?_ (char-syntax i))
	(modify-syntax-entry i "w")))
    (prog1
	(word-at-point)
      (set-syntax-table cur))))

(provide 'symbol-at-point)

;;; symbol-at-point.el,v1.7 ends here
