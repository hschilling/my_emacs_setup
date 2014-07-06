;;; ID: source-wrap-elisp-style.el,v 1.11 1998/09/27 07:08:24 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Put RCS tags around elisp.

(require 'source-wrap)

;;;###autoload
(defun source-wrap-elisp-style ()
  "Put RCS tags around current buffer in an elisp style."
  (interactive)
  (source-wrap ";;;"))

(provide 'source-wrap-elisp-style)

;;; source-wrap-elisp-style.el,v1.11 ends here
