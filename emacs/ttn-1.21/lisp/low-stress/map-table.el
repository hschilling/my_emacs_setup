;;; ID: map-table.el,v 1.7 1998/09/27 06:57:53 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Desciption: Provide "table" mapping funcs, which basically interpret a
;;; single sequence as tabular, chunking some number of CAR's and passing that
;;; to its function.

;;;###autoload
(defun map-table (n func seq)
  "Pass first N elements from SEQ as args to FUNC.  Repeat and accumulate."
  (let (retval)
    (while seq
      (push
       (apply func (subseq seq 0 n))
       retval)
      (setq seq (subseq seq n)))
    (nreverse retval)))

;;;###autoload
(defun map-table-2col (func table)
  "Apply FUNC to 2-column TABLE, of form (A1 B1 A2 B2 ...)."
  (map-table 2 func table))

;;;###autoload
(defun map-table-3col (func table)
  "Apply FUNC to 3-column TABLE, of form (A1 B1 C1 A2 B2 C2 ...)."
  (map-table 3 func table))

(provide 'map-table)

;;; map-table.el,v1.7 ends here
