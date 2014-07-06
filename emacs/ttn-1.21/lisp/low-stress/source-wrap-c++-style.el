;;; ID: source-wrap-c++-style.el,v 1.7 1998/09/27 07:08:17 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Put RCS tags around C++.

(require 'source-wrap)

;;;###autoload
(defun source-wrap-c++-style ()
  "Put RCS tags around current buffer in a C++ style."
  (interactive)
  (source-wrap "//"))

(provide 'source-wrap-c++-style)

;;; source-wrap-c++-style.el,v1.7 ends here
