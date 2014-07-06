;;; ID: find-files.el,v 1.5 1998/09/27 06:46:26 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.
;;;
;;; Description: Find all files matching shell wildcards.

;;;###autoload
(defun find-files (find-wildcard)
  "Selectively do `find-file' on find(1) output using FIND-WILDCARD.
Find(1) is invokedf from the current working directory.
Selection is interactive: `y' or `SPC' accepts, `n' or `DEL' rejects,
`.' accepts then stops, `!' accepts the rest, `q' just stops."
  (interactive "sCall find(1) with regexp: ")
  (let* ((cwd default-directory)
	 (pre-decided nil)
	 (same-for-rest nil)		; either 'yes or 'no
	 (candidates (split-string
		      (shell-command-to-string
		       (format  "find . -name '%s' -print" find-wildcard))))
	 (len (length candidates))
	 (count 0)
	 (km (let ((km (copy-keymap minibuffer-local-map)))
	       (define-key km "y"    (progc (insert "y") (exit-minibuffer)))
	       (define-key km " "    (progc (insert "y") (exit-minibuffer)))
	       (define-key km "n"    (progc (insert "n") (exit-minibuffer)))
	       (define-key km "\C-?" (progc (insert "n") (exit-minibuffer)))
	       (define-key km "."    (progc (insert "s") (exit-minibuffer)))
	       (define-key km "!"    (progc (insert "Y") (exit-minibuffer)))
	       (define-key km "q"    (progc (insert "N") (exit-minibuffer)))
	       km)))
    (flet ((prefix () (concat "[" (number-to-string count) "/" len "] "))
	   (query (file) (or same-for-rest
			     (read-from-minibuffer
			      (concat (prefix) "Find " file "? [yn.!q] ")
			      nil km)))
	   (do-it (file) (find-file (expand-file-name file cwd)))
	   (do-rest-as (type) (setq same-for-rest type))
	   (maybe (file)
		  (setq count (1+ count))
		  (let ((ans (query file)))
		    (cond		; `case' doesn't work!
		     ((equal ans "y") (do-it file))
		     ((equal ans "n") nil)
		     ((equal ans "s") (do-it file) (do-rest-as "n"))
		     ((equal ans "Y") (do-it file) (do-rest-as "y"))
		     ((equal ans "N")              (do-rest-as "n"))
		     (t (error "bad input"))))))
      (mapcar #'maybe candidates))))

(provide 'find-files)

;;; find-files.el,v1.5 ends here
