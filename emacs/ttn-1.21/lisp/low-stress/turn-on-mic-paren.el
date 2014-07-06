;;; ID: turn-on-mic-paren.el,v 1.9 1998/09/27 07:03:37 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Turn on mic-paren, a fancy paren-fun package by mic.

;;;###autoload
(defun turn-on-mic-paren ()
  "Sets some related variables and then does `paren-activate'."
  (interactive)
  (setq paren-face                   'bold
	paren-sexp-mode              t
	paren-dont-activate-on-load  t
	;; Add other mic-paren vars here.
	)
  (paren-activate))

(provide 'turn-on-mic-paren)

;;; turn-on-mic-paren.el,v1.9 ends here
