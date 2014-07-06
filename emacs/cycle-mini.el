;;; cycle-mini.el --- Cycle through possible minibuffer completions
;; Copyright (C) 1994 Joseph W. Reiss

;; Author:   Joe Reiss <jreiss@magnus.acs.ohio-state.edu>
;; Created:  26 Aug 1994
;; Version:  1.00
;; Keywords: minibuffer, completion
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or 
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;; LCD Archive Entry:
;; cycle-mini|Joe Reiss|jreiss@magnus.acs.ohio-state.edu|
;; Make arrows keys cycle through completions in minibuffer.|
;; 26-Aug-1994|1.00|~/misc/cycle-mini.el.Z|

;;; Commentary:

;; This is an extension to the completing-read commands in the
;; minibuffer.  It allows you to cycle through the current list of
;; completions.  This works when changing buffers, with any command
;; which reads a function or variable name, or a programmer specified
;; completion list.  It even works with functions which read a file
;; name!  In addition, if you have part of a name already typed in,
;; cycle-mini will use that string to narrow down the matches and will
;; only cycle through the completions which contain that initial
;; substring.
;;
;; [up]		Display previous matching completion.
;; [down]	Display next matching completion.
;; TAB		Accept currently displayed completion and move cursor
;;		to end of line.  If no completion is displayed, call
;;		minibuffer-complete as usual.
;;
;; Typing any other key other than one bound to
;; cycle-mini-yank-next-completion or cycle-mini-yank-previous-completion 
;; will clear the currently displayed completion and allow you to edit
;; as normal.

;;; Installation:

;; Byte-compile, then put this file in one of your elisp load
;; directories and add the following line to your .emacs file
;;
;; (load "cycle-mini")
;;
;; If, for some strange reason, you use different commands to exit the
;; minibuffer than the standard commands normally bound to RET, you
;; can modify the cycle-mini-exit-commands list to include the names
;; of any functions for which the current completion should *NOT* be
;; deleted prior to their execution.
;;
;; (setq cycle-mini-exit-commands
;;       '(exit-minibuffer minibuffer-complete-and-exit
;;         my-exit-minibuffer-command))

;;; History:

;; This code is inspired by elec-mini.el, found on the elisp-archive
;; but without any credit given to the original author.  In fact, this
;; is pretty much an enhanced version of that code.  Some portions of
;; this code are also borrowed from Ken Manheimer's icomplete.el in
;; the GNU Emacs 19.25 distribution

;;; Known bugs: (?)

;; Not really a bug, but an ugly kludge.  In order to make file
;; completions work, cycle-mini has to make some assumptions about
;; minibuffer-completion-predicate, namely that if it's a string and
;; minibuffer-completion-table is a symbol, then we're performing file
;; name completion.  Currently, of all the elisp code distributed with
;; FSF Emacs and all the source, at least for versions 19.25 and above,
;; only file completions use the predicate this strange way.  But if
;; that use should change, or if someone else should use a string for
;; a predicate in some other way, then...
;;
;; Also note that this has only been tested with FSF Emacs 19.25 and
;; above.  I don't think it should be too difficult to make cycle-mini
;; work with other variations, but I just don't have access to them.
;; Anyone who wants to try is welcome to, but please send me your
;; modifications.

(provide 'cycle-mini)

(defvar cycle-mini-exit-commands
  '(exit-minibuffer minibuffer-complete-and-exit)
  "* List of functions that exit the minibuffer.
cycle-mini will not delete the current completion if one of these commands
is called, thus allowing the displayed string to be used as the completion.")

(defvar cycle-mini-last-default nil
  "Indicates where we are in the list of possible completions.")
(defvar cycle-mini-eoinput 1
  "Indicates where actual user input ends.")

(define-key minibuffer-local-completion-map [down]
  'cycle-mini-yank-next-completion)
(define-key minibuffer-local-completion-map [up]
  'cycle-mini-yank-previous-completion)
(define-key minibuffer-local-completion-map "\C-i"
  'cycle-mini-accept-this-completion)

(define-key minibuffer-local-must-match-map [down]
  'cycle-mini-yank-next-completion)
(define-key minibuffer-local-must-match-map [up]
  'cycle-mini-yank-previous-completion)
(define-key minibuffer-local-must-match-map "\C-i"
  'cycle-mini-accept-this-completion)

(defun cycle-mini-assoc-tail (element list)
  "Returns tail of list whose car matches element"
  (let ((continue t))
    (while continue
      (cond
       ((null list) (setq continue nil))
       ((equal element (car list))
	(setq continue nil))
       (t (setq list (cdr list)))))
    list))

(defun cycle-mini-mod+ (x y mod)
  "Add X and Y and take MOD"
  (setq x (+ y x))
  (if (>= x mod) (setq x (- x mod)))
  (if (< x 0) (setq x (+ x mod)))
  x)

(defun cycle-mini-accept-this-completion ()
  "Treat completed string as if it were part of the user input.
If there is no completed string, call minibuffer-complete."
  (interactive)
  (if (null cycle-mini-last-default)	; Don't have completion displayed
      (call-interactively 'minibuffer-complete)
    (goto-char (point-max))
    (setq cycle-mini-eoinput (point)
	  cycle-mini-last-default nil)))

(defun cycle-mini-yank-next-completion (&optional incr)
  "Replace input by next possible default input."
  (interactive)
  (or incr (setq incr 1))
  (let* ((input (buffer-substring (point-min)(point-max)))
	 (inlen (length input))
	 (comps
	  (sort (all-completions input minibuffer-completion-table
				 minibuffer-completion-predicate)
		'string<))
	 (complen (length comps))
	 (filecomp (and (symbolp minibuffer-completion-table)
			(stringp minibuffer-completion-predicate))))
    (cond
     ((null comps)			; No matches
      (save-excursion
	(goto-char (point-max))
	(ding)
	(insert-string " [No match]")
	(goto-char (+ (point-min) inlen))
	(sit-for 2)
	(delete-region (point) (point-max))
	(setq cycle-mini-last-default nil)))
     ((= 1 complen)			; Only one exact match
      (erase-buffer)
      (insert-string
       (if filecomp
	   (file-name-directory input) "")
       (car comps) " [Sole completion]")
      (goto-char (+ (point-min) inlen))
      (sit-for 2)
      (delete-region (+ (point-min) (length (car comps))
			(if filecomp (length (file-name-directory input)) 0))
		     (point-max))
      (setq cycle-mini-last-default
	    (if (string= input (car comps)) nil 0)))
     (t
      (erase-buffer)
      (if (not (and (numberp cycle-mini-last-default)
		    (>= cycle-mini-last-default 0)
		    (< cycle-mini-last-default complen)))
	  (setq cycle-mini-last-default
		(cond
		 ;; If doing filename completion, start after dot files
		 ((and filecomp (string-match "/$" input))
		  (if (< incr 0) (1- complen)
		    (let ((i 0))
		      (while (<= (aref (nth i comps) 0) ?.)
			(setq i (1+ i)))
		      i)))
		 ;; If we have exact match, start with *next* match
		 ((and (string= input
				(concat
				 (if filecomp (file-name-directory input)
				   "")
				 (car comps)))
		       (> complen 1))
		  (if (> incr 0) 1 (1- complen)))
		 ;; Otherwise, start at beginning (or end if going up)
		 (t (if (> incr 0) 0 (1- complen)))))
	(setq cycle-mini-last-default
	      (cycle-mini-mod+ cycle-mini-last-default incr complen)))
      (insert-string
       (if filecomp
	   (file-name-directory input) "")
       (nth cycle-mini-last-default comps))
      (goto-char (+ (point-min) inlen))))
    (setq cycle-mini-eoinput (+ (point-min) inlen))))

(defun cycle-mini-yank-previous-completion ()
  "Replace input by previous possible default input."
  (interactive)
  (cycle-mini-yank-next-completion -1))

(defun cycle-mini-pre-command-hook ()
  "Do all necessary setup before a command runs in the minibuffer."
  (if (or (memq this-command cycle-mini-exit-commands)
	  (and (eq this-command 'cycle-mini-accept-this-completion)
	       cycle-mini-last-default))
      ()
    (if (> cycle-mini-eoinput (point-max))
	;; Oops, got rug pulled out from under us - reinit:
	(setq cycle-mini-eoinput (point-max))
      (let ((buffer-undo-list buffer-undo-list)) ; prevent entry
	(delete-region cycle-mini-eoinput (point-max))))))

(defun cycle-mini-post-command-hook ()
  "Do all necessary setup after a command runs in the minibuffer."
  (if (or (eq this-command 'cycle-mini-yank-next-completion)
	  (eq this-command 'cycle-mini-yank-previous-completion))
      ()
    (setq cycle-mini-eoinput (point-max)
	  cycle-mini-last-default nil)))

(defun cycle-mini-reset ()
  "Reset electic minibuffer list to the beginning."
  (make-local-variable 'pre-command-hook)
  (make-local-variable 'post-command-hook)
  (add-hook 'pre-command-hook 'cycle-mini-pre-command-hook)
  (add-hook 'post-command-hook 'cycle-mini-post-command-hook)
  (make-local-variable 'cycle-mini-eoinput)
  (setq cycle-mini-eoinput (point-min)
	cycle-mini-last-default nil))

(add-hook 'minibuffer-setup-hook 'cycle-mini-reset)



