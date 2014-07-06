;;; ID: rcs-to-cvs.el,v 1.7 1998/09/27 06:47:44 ttn Exp
;;;
;;; Description: Wrapper around contributed rcs-to-cvs script.
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

(defvar rcs-to-cvs-program "/usr/lib/cvs/contrib/rcs-to-cvs") ; todo: delete

(defun rcs-to-cvs (repository &optional dir)
  "Recursively apply rcs-to-cvs script to add to REPOSITORY.
REPOSITORY is a relative directory from $CVSROOT, an environment variable.
Start recursive descent from DIR if non-nil.  DIR must end in \"/\".
If DIR is nil, descend from `default-directory'.

Directories under REPOSITORY are created as needed.
Subdirectories are identified by `file-directory-p',
excluding `.', `..' and `RCS'."
  (interactive "sRelative dir from $CVSROOT: ")
  (let ((root (getenv "CVSROOT"))
	(here default-directory)
	(cwd  default-directory)
	(obuf (generate-new-buffer "*rcs-to-cvs*")))
    (set-buffer obuf)
    (delete-region (point-min) (point-max))
    (if dir
	(progn
	  (cd dir)
	  (setq cwd default-directory)))
    (call-process rcs-to-cvs-program nil obuf t "-m" "from-RCS" repository)
    (mapc (lambda (file)
	    (if (and (file-directory-p file)
		     (not (string= file "."))
		     (not (string= file ".."))
		     (not (string= file "RCS")))
		(let* ((new-repos (concat repository "/" file))
		       (full (concat root "/" new-repos)))
		  (cd (concat cwd file))
		  (if (not (file-exists-p full))
		      (make-directory full))
		  (rcs-to-cvs new-repos))))
	  (directory-files cwd))
    (cd here)))

(provide 'rcs-to-cvs)

;;; rcs-to-cvs.el,v1.7 ends here
