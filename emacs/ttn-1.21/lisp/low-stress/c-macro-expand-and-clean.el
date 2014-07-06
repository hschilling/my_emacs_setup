;;; ID: c-macro-expand-and-clean.el,v 1.12 1998/09/27 06:52:10 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Expand a region of C code into another buffer, then clean it.

(require 'ttn-macros)

;;;###autoload
(defun c-macro-expand-and-clean (beg end)
  "Call `c-macro-expand', then do additional cleaning."
  (interactive "r")
  (message "Calling c-macro-expand ...")
  (c-macro-expand beg end nil)
  (let* ((cb (current-buffer))
	 (mb (get-buffer "*Macroexpansion*"))
	 (buffer-read-only nil))
    (set-buffer mb)
    (map-table-2col
     (progsa (from to)
       (message "Cleaning -- '%s' ..." from)
       (goto-char (point-min))
       (while (re-search-forward from nil t)
	 (replace-match to nil nil)))
     '("/\\*\\([^*]\\|\\(\\*[^/]\\)\\)*\\*/" ""
       "[ \t]*[ \t]"                         " "
       "(\\s-"                               "("
       "{\\|}"                               "\n\\&\n"
       ";"                                   ";\n"
       "\n\\s-*\n"                           "\n"
       ;; Add regexp / string pairs here.
       ))
    (indent-region 1 (point-max) nil)
    (message "Cleaning ... done")
    (set-buffer cb)))

(provide 'c-macro-expand-and-clean)

;;; c-macro-expand-and-clean.el,v1.12 ends here
