;;; ID: ln-mode.el,v 1.5 1998/09/27 06:57:14 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Line-numbering mode.

(defun ln-buf (min)
  "Return a buffer of line numbers at least MIN lines long."
  (save-excursion
    (switch-to-buffer "*line numbers*")
    (goto-char (point-max))
    (do ((i (1+ (count-lines (point-min) (point))) (1+ i)))
	((> i min) (current-buffer))
      (insert (format "%d\n" i)))))

(defun ln-on ()
  "Create buffer to the side displaying line numbers of current buffer."
  (interactive)
  (let* ((cur (current-buffer))
	 (max (save-restriction
		(widen)
		(count-lines (point-min) (point-max))))
	 (lbf (ln-buf max))
	 )
    (switch-to-buffer lbf)
    (goto-char (point-min))
    (split-window-horizontally 10)
    (switch-to-buffer-other-window cur)
    (goto-char (point-min))
    ;; Add synchronizing hooks here.
    ))

(provide 'ln-mode)

;;; ln-mode.el,v1.5 ends here
