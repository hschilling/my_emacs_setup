;;; codeline.el --- move to beginning/end of code on a line

;;; Copyright (C) 1993, 1994, 1998 Thien-Thi Nguyen

;;; Author: Thien-Thi Nguyen <ttn@netcom.com>
;;; Version: codeline.el,v 1.6 1998/05/31 10:22:15 ttn Exp
;;; Keywords: editing
;;; Number-of-Guitars-the-Author-Lives-With: 3 (was 4)

;;; This file is not part of GNU Emacs.

;;; codeline is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the
;;; Free Software Foundation; either version 2 of the License, or (at your
;;; option) any later version.
;;;
;;; codeline is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;;; for more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with this program; if not, write to the Free Software Foundation, Inc.,
;;; 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;;; got tired of hitting C-a and C-e only to go to the absolute edge
;;; of a line, where either whitespace (beginning) or a comment (end)
;;; necessitated extra keystrokes to get to the code.  the following
;;; two commands move the point to the beginning and end of the code
;;; part of the line, respectively, essentially ignoring leading white-
;;; space and trailing comments.  subsequent invocations just call
;;; their less-lengthly-named cousins.
;;;
;;; there are two special cases:
;;; a) line consists of all whitespace (including just \n).  C-a moves
;;; point to the proper mode-specific column.  C-e moves to end of line.
;;; b) line has no code, only comment.  C-a and C-e move point to the
;;; edge of the comment.
;;;
;;; code enhancement opportunities (aka bugs/caveats):
;;; - cannot handle comments at the beginning of the line.
;;; - cannot handle comment-start if in a 'incomplete' string.
;;; - depends on mode-provided comment-start variable, which means that
;;;   if you have
;;;      int a;   /*comment with no space after slash-star */
;;;   C-e will do the wrong thing.  (just use M-; eh?)

;;; suggested use:

;;; in your .emacs you will want to load in codeline.el by:
;;;   (load-file "$SOMEPATH/codeline.el")
;;; as well as bind C-a and C-e to the commands by:
;;;   (add-hook 'c-mode-hook
;;; 	    '(lambda ()
;;;  	     (define-key c-mode-map "\C-a" 'beginning-of-code-line)
;;; 	     (define-key c-mode-map "\C-e" 'end-of-code-line)))
;;; for c-mode, for example.  similar add-hook calls need to be made for
;;; any other modes you wish to use the commands in.  (nb:  add-hook is
;;; an emacs19 addition.  if no access, get crypt++.el and snarf the one
;;; from there -- around line 2090.)  the adventurous may wish to bind
;;; these globally with:
;;;   (global-set-key "\C-a" 'beginning-of-code-line)
;;;   (global-set-key "\C-e" 'end-of-code-line)
;;; don't forget to byte-compile.
;;;
;;; feedback welcome!

;;; Code:

;;;--------------------------------------------------------------------------
;;; internal variables

(defvar codeline-last-arg nil
  "enables passing through of args to subsequent command invocations.")


;;;--------------------------------------------------------------------------
;;; entry points

;;;###autoload
(defun beginning-of-code-line (arg)
  "moves point to first non-whitespace char on line, or indents.
second invocation moves point to beginning of line."
  (interactive "p")
  (if (eq this-command last-command)
      (beginning-of-line codeline-last-arg)
    (beginning-of-line)
    (if (looking-at "\\s-*\n")
	(indent-according-to-mode)
      (back-to-indentation)))
  (setq codeline-last-arg arg))

;;;###autoload
(defun end-of-code-line (arg)
  "moves to end of code line or end of line if comment.
second invocation moves point to end of line."
  (interactive "p")
  (if (eq this-command last-command)
      (end-of-line codeline-last-arg)
    (or (and (boundp 'comment-start-regexp)
	     comment-start-regexp)
	(progn
	  (make-local-variable 'comment-start-regexp)
	  (setq comment-start-regexp (regexp-quote (or comment-start "")))))
    (let ((eol (progn (end-of-line) (point)))
	  (stop (progn (beginning-of-line) (point))))
      (if (looking-at (concat "\\s-*\n\\|\\s-*" comment-start-regexp ".*\n"))
	  (end-of-line)
	(while (if (re-search-forward "\"[^\"]*\"" eol t)
		   (setq stop (1- (point)))))
	(end-of-line)
	(while (re-search-backward comment-start-regexp stop t))
	(re-search-backward "\\S-" stop t)
	(forward-char 1))))
  (setq codeline-last-arg arg))

;;;--------------------------------------------------------------------------
;;; that's it

(provide 'codeline)

;;; codeline.el,v1.6 ends here
