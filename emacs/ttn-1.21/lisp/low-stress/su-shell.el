;;; ID: su-shell.el,v 1.11 1998/09/27 07:02:38 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Get a superuser shell using `multi-shell'.  Password secure.

(require 'shell)

;;;###autoload
(defun su-shell ()
  "Runs `multi-shell' w/ superuser privs.
If the buffer already exists, just switch to it.
Otherwise, ask for password and do \"su\".
As a security measure, the password is immediately
overwritten upon use."
  (interactive)
  (if (get-buffer "*shell -666*")
      (switch-to-buffer "*shell -666*")
    (let ((pw (comint-read-noecho "Root password: ")))
      (multi-shell -666)		; bofh would approve
      (comint-send-string (current-buffer) "exec su\n")
      (sit-for 1)
      (comint-send-string (current-buffer) (concat pw "\n"))
      (fillarray pw 0)			; security
      (sit-for 1)
      (comint-send-string "\n"))))

(provide 'su-shell)

;;; su-shell.el,v1.11 ends here
