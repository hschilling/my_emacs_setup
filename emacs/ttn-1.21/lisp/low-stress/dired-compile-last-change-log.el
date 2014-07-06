;;; ID: dired-compile-last-change-log.el,v 1.10 1998/09/27 06:54:21 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: With dired-under-vc, compile a last-change log to a buffer.
;;; Useful for mail messages, etc.

(require 'ttn-macros)

;;;###autoload
(defun dired-compile-last-change-log (buf)
  "In BUF, make a mail-able last change log.  Used in Dired-under-VC."
  (interactive "bBuffer: ")
  (save-window-excursion
    (goto-line 3)
    (let* (files
	   (delim "----------------------------")
	   (log-re (concat "^" delim "\n")))
      (while (re-search-forward ":[0-9][0-9]\\s-\\(.+\\)$" (point-max) t)
	(setq files (cons (buffer-substring (match-beginning 1)
					    (match-end 1))
			  files)))
      (mapcar
       (progsa (file)
	 (save-window-excursion
	   (find-file file)
	   (vc-print-log)
	   (set-buffer "*vc*")
	   (goto-char 1)
	   (re-search-forward "^Working file: \\(.+\n\\)")
	   (append-to-buffer buf (1- (match-end 1)) (match-end 1))
	   (append-to-buffer buf (match-beginning 1) (match-end 1))
	   (append-to-buffer buf
			     (progn
			       (re-search-forward log-re)
			       (forward-line -1)
			       (point))
			     (progn
			       (forward-line 1)
			       (re-search-forward log-re)
			       (point)))))
       files))))

(provide 'dired-compile-last-change-log)

;;; dired-compile-last-change-log.el,v1.10 ends here
