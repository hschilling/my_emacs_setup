;;; ID: ping.el,v 1.8 1998/09/27 07:08:02 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Ping a host infinitely, with variable interval.
;;; A new buffer is set up via `bg-shell-command' and you are placed there.

(require 'bg-shell-command)

;;;###autoload
(defun ping (host &optional interval)
  "Ping HOST once a second, interpreting optional prefix arg as INTERVAL."
  (interactive "sHost? \np")
  (bg-shell-command (format "ping -i %d %s" (or interval 1) host) t))

(provide 'ping)

;;; ping.el,v1.8 ends here
