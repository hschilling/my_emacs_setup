;;; ID: source-wrap.el,v 1.6 1998/09/27 07:02:11 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Put RCS tags around source.

;;;###autoload
(defun source-wrap (one-line-comment)
  "Put text around current buffer."
  (interactive)
  (goto-char (point-max))
  (insert one-line-comment (concat " $" "RCSfile"  "$"		; prevent
				   "$"  "Revision" "$"		;  expansion
				   " "  "ends here"))
  (goto-char (point-min))
  (insert one-line-comment " ID: $" "Id" "$\n")
  (insert one-line-comment "\n"))

(provide 'source-wrap)

;;; source-wrap.el,v1.6 ends here
