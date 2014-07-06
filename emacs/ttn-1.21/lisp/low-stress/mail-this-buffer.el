;;; ID: mail-this-buffer.el,v 1.10 1998/09/27 06:57:42 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Simple keyboard macro to prepare mail buffer from current.
;;; Remember to hit `C-c C-c' to actually send the mail.

;;;###autoload
(fset 'mail-this-buffer
      "\C-xh\M-w\M-xmail\C-m\C-c\C-t\C-y\C-c\C-f\C-t")

(provide 'mail-this-buffer)

;;; mail-this-buffer.el,v1.10 ends here
