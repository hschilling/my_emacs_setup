;;; ID: emacs-uptime.el,v 1.4 1998/09/27 07:38:05 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Give Emacs' uptime and some other stats in the modeline.

(require 'ttn-macros)

;;;###autoload
(defun emacs-uptime ()
  "Gives Emacs' uptime, based on global var `*emacs-start-time*'."
  (interactive)
  (let* ((st *emacs-start-time*)		; set in do-it-now.el
	 (cur (current-time))
	 (hi-diff (- (car cur) (car st)))
	 (tot-sec (+ (ash hi-diff 16) (- (cadr cur) (cadr st))))
	 (days (/ tot-sec (* 60 60 24)))
	 (hrs  (/ (- tot-sec (* days 60 60 24)) (* 60 60)))
	 (mins (/ (- tot-sec (* days 60 60 24) (* hrs 60 60)) 60))
	 (secs (/ (- tot-sec (* days 60 60 24) (* hrs 60 60) (* mins 60)) 1)))
    (message "Up %s (%dd %dh %dm %ds), %d buffers, %d files"
	     (format-time-string "%a %Y.%m%d.%T%z" st)
	     days hrs mins secs
	     (length (buffer-list))
	     (count t (buffer-list)
		    :test-not
		    (progsa (ignore buf)
		      (null
		       (cdr
			(assoc 'buffer-file-truename
			       (buffer-local-variables buf)))))))))

(provide 'emacs-uptime)

;;; emacs-uptime.el,v1.4 ends here
