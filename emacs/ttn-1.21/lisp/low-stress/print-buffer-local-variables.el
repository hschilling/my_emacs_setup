;;; ID: print-buffer-local-variables.el,v 1.16 1998/09/27 07:00:21 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Print buffer-local variables and count them, too.

;;;###autoload
(defun print-buffer-local-variables ()
  "Print buffer-local variables.
If interactive, print number of vars.  Return that number in all cases."
  (interactive)
  (let* ((cur (current-buffer))
	 (blv (buffer-local-variables cur))
	 (count (length blv)))
    (with-output-to-temp-buffer (concat "*buffer-local vars for "
					(buffer-name cur)
					"*")
      (princ (format "%d buffer-local variables\n\n" count))
      (while blv
	(let* ((var (car (car blv)))
	       (len (length (symbol-name var)))
	       (val (cdr (car blv))))
	  (princ (make-string len ?=))
	  (print var)
	  (princ (make-string len ?=))
	  (princ "\n")
	  (pp val)
	  (if (not val)
	      (princ "\n")
	    (or (listp val) (vectorp val) (princ "\n")))
	  (princ "\n")
	  (setq blv (cdr blv)))))
    (if (interactive-p)
	(message "%d buffer-local variables" count))
    count))

(provide 'print-buffer-local-variables)

;;; print-buffer-local-variables.el,v1.16 ends here
