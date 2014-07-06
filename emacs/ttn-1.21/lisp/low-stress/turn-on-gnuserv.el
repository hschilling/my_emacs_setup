;;; ID: turn-on-gnuserv.el,v 1.5 1998/09/27 07:03:23 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Set some variables, then turn on gnuserv.

(case emacs-type
  ('lucid (require 'gnuserv))
  ('fsf   (require 'server)
	  (defalias 'gnuserv-start 'server-start)))

;;;###autoload
(defun turn-on-gnuserv ()
  "Set some variables and then turn on gnuserv."
  (interactive)
  ;; (no vars to be set at this time)
  (gnuserv-start))

(provide 'turn-on-gnuserv)

;;; turn-on-gnuserv.el,v1.5 ends here
