;;; ID: gzip-or-gunzip-from-dired.el,v 1.11 1998/09/27 06:56:29 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: From dired, gzip or gunzip a file.  Probably bound to `z'.

(require 'dired-aux)

;; gzip-or-gunzip-from-dired
;;;###autoload
(defun gzip-or-gunzip-from-dired () "gzip or gunzip.  (only from dired)"
  (interactive)
  (let* ((fn (dired-get-filename nil t))
	 (buffer-read-only nil))
    (unless (or (not fn) (file-directory-p fn))
      (cond ((string= (substring fn -3) ".gz")
	     (call-process "gunzip" nil nil nil "--best" fn)
	     (setq fn (substring fn 0 (- (length fn) 3))))
	    (t
	     (call-process "gzip" nil nil nil "-f" fn)
	     (setq fn (concat fn ".gz"))))
      (dired-update-file-line fn))))

(provide 'gzip-or-gunzip-from-dired)

;;; gzip-or-gunzip-from-dired.el,v ends here
