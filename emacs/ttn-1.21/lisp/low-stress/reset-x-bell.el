;;; ID: reset-x-bell.el,v 1.11 1998/09/27 07:00:43 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Simple kbd macro to reset the X server bell via ~/.xsession.

;;; Command: last-kbd-macro
;;; Key: none
;;;
;;; Macro:
;;;
;;; C-x C-f
;;; C-a			;; beginning-of-code-line
;;; C-k			;; kill-line
;;; ~/.xsession-common	;; self-insert-command * 18
;;; RET			;; newline
;;; C-s			;; isearch-forward
;;; b			;; self-insert-command
;;; SPC			;; self-insert-command
;;; 2*C-s		;; isearch-forward
;;; RET			;; newline
;;; C-a			;; beginning-of-code-line
;;; C-SPC		;; set-mark-command
;;; C-e			;; end-of-code-line
;;; C-a			;; beginning-of-code-line
;;; C-SPC		;; set-mark-command
;;; C-e			;; end-of-code-line
;;; M-C-x		;; eval-defun
;;; C-x k		;; kill-buffer
;;; RET			;; newline

;;;###autoload
(defalias 'reset-x-bell (read-kbd-macro
"C-x C-f C-a C-k ~/.xsession-common RET C-s b SPC 2*C-s RET C-a C-SPC C-e C-a
 C-SPC C-e M-C-x C-x k RET"))

(provide 'reset-x-bell)

;;; reset-x-bell.el,v$Version$ ends here
