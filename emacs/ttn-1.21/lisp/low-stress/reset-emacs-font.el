;;; ID: reset-emacs-font.el,v 1.8 1998/09/27 07:00:35 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Simple keyboard macro to reset Emacs font via ~/.Xdefaults.

;;; Command: reset-emacs-font
;;; Key: none
;;;
;;; Macro:
;;;
;;; C-x C-f
;;; C-a			;; beginning-of-code-line
;;; C-k			;; kill-line
;;; ~/.Xdefaults	;; self-insert-command * 12
;;; RET			;; newline
;;; C-s			;; isearch-forward
;;; x			;; self-insert-command
;;; DEL			;; delete-backward-char
;;; emacs*font:		;; self-insert-command * 11
;;; SPC			;; self-insert-command
;;; -			;; self-insert-command
;;; C-b			;; backward-char
;;; C-SPC		;; set-mark-command
;;; C-e			;; end-of-code-line
;;; M-w			;; kill-ring-save
;;; M-:			;; eval-expression
;;; (message		;; self-insert-command * 8
;;; SPC			;; self-insert-command
;;; "hi")		;; self-insert-command * 5
;;; RET			;; newline
;;; M-x			;; execute-extended-command
;;; set-def		;; self-insert-command * 7
;;; TAB			;; indent-for-tab-command
;;; RET			;; newline
;;; C-y			;; hilit-yank
;;; RET			;; newline
;;; C-x k		;; kill-buffer
;;; RET			;; newline


;;;###autoload
(fset 'reset-emacs-font
   [?\C-x ?\C-f ?\C-a ?\C-k ?~ ?/ ?. ?X ?d ?e ?f ?a ?u ?l ?t ?s return ?\C-s ?x ?\C-? ?e ?m ?a ?c ?s ?* ?f ?o ?n ?t ?: ?  ?- ?\C-b ?\C-  ?\C-e ?\M-w ?\M-: ?( ?m ?e ?s ?s ?a ?g ?e ?  ?" ?h ?i ?" ?) return ?\M-x ?s ?e ?t ?- ?d ?e ?f tab return ?\C-y return ?\C-x ?k return])

(provide 'reset-emacs-font)

;;; reset-emacs-font.el,v1.8 ends here
