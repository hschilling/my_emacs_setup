;;; ID: my-term-fixups.el,v 1.9 1998/09/27 06:58:30 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Fix keys for vt220.

;;;###autoload
(defun my-term-fixups ()
  "if on vt220, sets find to be [C-s] and sets f11 to be really [f11]."
  (when (string= (getenv "TERM") "vt220")
    (define-key function-key-map "\e[1~" [?\C-s])
    (define-key function-key-map "\e[23~" [f11])))

(provide 'my-term-fixups)

;;; my-term-fixups.el,v1.9 ends here
