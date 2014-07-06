;;; turn-on-hilit19.el,v 1.10 1998/09/27 07:03:28 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Set some variables and then turn on hilit19.

;;;###autoload
(defun turn-on-hilit19 ()
  "Set some variables and then turn on hilit19."
  (interactive)
  (setq
   hilit-mode-enable-list	'(Info-mode)
   hilit-background-mode	'dark
   hilit-inhibit-hooks		nil
   hilit-auto-rehighlight	'visible
   hilit-auto-highlight-maxout	100000
   hilit-quietly		t
   hilit-inhibit-rebinding	t
   ;; Add other hilit vars here.
   )
  (when (emacs-type-eq 'fsf)
    (require 'hilit19)))

(provide 'turn-on-hilit19)

;;; turn-on-hilit19.el,v1.10 ends here
