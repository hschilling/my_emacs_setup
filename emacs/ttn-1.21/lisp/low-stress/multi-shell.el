;;; ID: multi-shell.el,v 1.12 1998/09/27 06:58:01 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Modification of ``shell'' allows multiple shells w/ prefix.

;;;###autoload
(defun multi-shell (shell-choice)
  "Do `shell', naming buffer based on SHELL-CHOICE, interpreted as prefix arg.
The history for the shell is taken from ~/.multi-shell-history-SHELL-CHOICE.
See documention for `shell'."
  (interactive "p")
  (require 'shell)
  (let* ((shell-choice (int-to-string shell-choice))
	 (shell-name (concat "shell " shell-choice))
	 (buf-name (concat "*" shell-name "*"))
	 (histfile (expand-file-name
		    (concat "~/.multi-shell-history-" shell-choice)))
	 (process-environment process-environment))
    (cond ((not (comint-check-proc buf-name))
	   (let* ((prog (or (getenv "ESHELL")
			    (getenv "SHELL")
			    "/bin/sh"))
		  (name (file-name-nondirectory prog))
		  (startfile (concat "~/.emacs_" name))
		  (xargs-name (intern-soft (concat "explicit-" name "-args"))))
	     (setenv "HISTFILE" histfile)
	     (set-buffer (apply 'make-comint shell-name prog
				(if (file-exists-p startfile) startfile)
				(if (and xargs-name (boundp xargs-name))
				    (symbol-value xargs-name)
				  '("-i"))))
	     (shell-mode))))
    (switch-to-buffer buf-name)))

(provide 'multi-shell)

;;; multi-shell.el,v1.12 ends here
