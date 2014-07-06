;;; ID: what-defun-am-i-in.el,v 1.10 1998/09/27 06:48:01 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Determine where cursor is syntactically for several modes.

;;;###autoload
(defun what-defun-am-i-in ()
  "Returns string of current mode-specific \"defun\".
If run interactively, display using `message'."
  (interactive)
  (let (ret)
    (save-excursion
      (let ((defun-prompt-regexp (case major-mode
				   ((verilog-mode)
				    "module\\s-+\\S-+\\s-*")
				   (t
				    nil))))
	(beginning-of-defun))
      (case major-mode
	((scheme-mode)
	 (re-search-forward "define\\S-* +\\(.*\\)"))
        ((lisp-interaction-mode lisp-mode emacs-lisp-mode)
         (re-search-forward "defun +\\(\\S-+\\)"))
        ((c-mode c++-mode)
         (re-search-backward "\\(^\\S-+\\)"))
	((verilog-mode)
	 (re-search-forward "module +\\(\\S-+\\)"))
	))
    (setq ret (buffer-substring (match-beginning 1) (match-end 1)))
    (if (interactive-p)
        (message ret)
      ret)))

(provide 'what-defun-am-i-in)

;;; what-defun-am-i-in.el,v1.10 ends here
