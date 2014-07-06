Article 4112 of gnu.emacs.sources:
Path: lerc.nasa.gov!lerc.nasa.gov!news.larc.nasa.gov!lll-winken.llnl.gov!uop!pacbell.com!amdahl.com!amd!amd.com!ferrari!dwork
From: jeff.dwork@amd.com (Jeff Dwork)
Newsgroups: gnu.emacs.sources
Subject: Interactive buffer list in minibuffer
Date: 6 Feb 1995 21:36:59 GMT
Organization: AMD
Lines: 134
Sender: dwork@ferrari (Jeff Dwork)
Distribution: world
Message-ID: <3h64pr$aib@amdint.amd.com>
NNTP-Posting-Host: ferrari.amd.com

This code allows one to select a buffer to switch to from
among all active buffers with all messages in the minibuffer.

It is a very useful alternative to buff-menu or electric-buffer-menu
when running on a character terminal on a slow link.

It uses the history list navigation commands.

Emacs 19 is required.  It has only been tested with FSF Emacs.

;;; buf-hsel.el --- interactive buffer-list in minibuffer using history

;; Copyright (C) 1994 Jeff Dwork.

;; Author: Jeff Dwork <Jeff.Dwork@amd.com>
;; Version: 1.01

;; LCD Archive Entry:
;; buf-hsel|Jeff Dwork|Jeff.Dwork@amd.com|
;; Interactive buffer-list in minibuffer using history.|
;; 06-Nov-94|1.01|~/misc/buf-hsel.el.Z|

;; The archive is archive.cis.ohio-state.edu in /pub/gnu/emacs/elisp-archive.

;;; This file is not part of GNU Emacs.

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Purpose:
;;
;; To provide an interactive buffer selection capability that works
;; on character terminals.  Display changes are minimized for use on
;; slow terminals.
;;

;; Installation:
;; 
;; Put this file somewhere where Emacs can find it (i.e., in one of the paths
;; in your `load-path'), `byte-compile-file' it, and put in your ~/.emacs:
;;
;;   (autoload 'hselect-buffer "buf-hsel" nil t)
;;   (autoload 'hselect-buffer-other-window "buf-hsel" nil t)
;;   (global-set-key "\C-xb" 'hselect-buffer)
;;   (global-set-key "\C-x4b" 'hselect-buffer-other-window)
;;
;; When the function hselect-buffer is invoked, the minibuffer prompts you
;; for another buffer to select.  The default is the second buffer on the 
;; buffer-list.  The list of buffers is passed to completing-read as a 
;; history list, making all the history navigation commands available for
;; buffer selection.  Match is not required, so a new buffer may be created.
;;
;; The history list used by hselect-buffer is not a real history list.
;; It is set for each invocation to the current buffer-list.
;;
;; Hselect-buffer requires emacs 19 and has been tested only on FSF emacs 19.27.
;;

;; Feedback:
;;
;; Please send me bug reports, bug fixes, and extensions, so that I can
;; merge them into the master source.
;;     - Jeff Dwork (Jeff.Dwork@amd.com)

;; History:
;;
;; Based on select-buffer (~/misc/buf-sel.el.Z in the LCD archive) written
;; by Tom Horsley and Bob Weiner.
;; 
;; I changed the selection mechanism to use history to avoid rebinding keys.
;; It is no longer possible to kill buffers during the selection process, as
;; could be done with select-buffer.
;;

(defun hselect-buffer (&optional other-window)
  "Interactively select or kill buffer using the minibuffer.
Optional argument OTHER-WINDOW non-nil means display buffer in another window.
The default buffer is the second one in the buffer-list. Other buffers can
selected either explicitly, or by using the history commands."
   (interactive)
   (let (inpt 
	 pos 
	 buffer-hselect-local-names)
     (setq inpt
	   (unwind-protect
		(progn
		  (setq buffer-hselect-local-names
			  (reverse 
			    (mapcar 
			      '(lambda (buf)
				(buffer-name buf))
					; no names starting with a space
			      (delq nil 
				    (mapcar 
				      '(lambda (b)
					(if (= (aref (buffer-name b) 0) ? ) nil b))
				      (buffer-list))))))
		  (setq pos (+ -1 (length buffer-hselect-local-names)))
                  (completing-read (concat "Switch to buffer"
					   (if other-window " in other window")
					   ": ")
				   (mapcar
				    '(lambda (name)
				       (list name))
				    buffer-hselect-local-names)
				   nil nil
				   (nth (+ -1 pos) buffer-hselect-local-names)
				   (cons 'buffer-hselect-local-names pos))
		  )
	      ))
      (if other-window
	  (switch-to-buffer-other-window inpt)
	(switch-to-buffer inpt))
      ))

(defun hselect-buffer-other-window ()
  "See documentation for 'hselect-buffer'."
  (interactive)
  (hselect-buffer t))

;; end of buf-hsel.el


