;;; ID: xmsg.el,v 1.9 1998/09/27 07:04:11 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Wrapper for old X program xmessage(1).

;;;###autoload
(defun xmsg (&optional string geom process-name)
  "invokes 'xmsg' program to display a message in a separate X window.
all args are optional:
STRING is the string to display.  xmsg recognizes \\n as newline.
GEOM if non-nil is the window geometry.
PROCESS-NAME if non-nil is the internal process object's name."
  (interactive)
  (if (string= "x" window-system)
      (let* ((name (or process-name "xmessage"))
	     (geom-option (or geom "+0+0")))
	(start-process name nil
		       "xmessage"
		       "-geometry" geom-option
		       (or string
			   "Emacs says hi!")))))

(provide 'xmsg)

;;; xmsg.el,v1.9 ends here
