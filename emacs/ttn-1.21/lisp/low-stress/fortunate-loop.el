;;; ID: fortunate-loop.el,v 1.24 1998/09/27 06:55:08 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Fortune cookie factory!  :->

(require 'ttn-macros)

(defvar enable-fortunate-loop t
  "If nil, fortunate-loop just returns.")

;;;###autoload
(defun fortunate-loop (&optional nice-time)
  "Spews fortunes until user input."
  (interactive "p")
  (when enable-fortunate-loop
    (when (or (null nice-time) (= 1 nice-time))
      (setq nice-time 3600))
    (flet ((timestamp ()
		      (let ((time (current-time)))
			(logior (lsh (car time) 16) (cadr time)))))
      (save-window-excursion
	(let ((start-time (timestamp))
	      (hey (concat "idle at " (current-time-string) " -- waiting "))
	      (cmd "fortune"))
	  (switch-to-buffer "*Fortunate Loop*")
	  (goto-char (point-max))
	  (while
	      (let* ((cookie (shell-command-to-string cmd))
		     (len (length cookie)))
		(insert cookie "\n\n")
		(when (> (point-max) 2000)
		  (delete-region 1 200))
		(end-of-buffer) (recenter -1)
		(prog1
		    (let ((wait (+ 4 (/ (* 3.5 len) 80))))
		      (message (concat hey (number-to-string wait) "s"))
		      (sit-for wait))
		  (when (> (- (timestamp) start-time) nice-time)
		    (setq cmd "fortune"))))))))))

(unless (or (not (emacs-type-eq 'fsf))
	    (find 'fortunate-loop timer-idle-list
		  :key (progsa (x) (aref x 5))))
  (run-with-idle-timer (* 30 60) t 'fortunate-loop))

(provide 'fortunate-loop)

;;; fortunate-loop.el,v1.24 ends here
