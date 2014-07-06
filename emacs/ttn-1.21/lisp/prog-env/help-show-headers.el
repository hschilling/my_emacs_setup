;;; ID: help-show-headers.el,v 1.19 1998/09/27 06:47:06 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Show headers in code, allowing two-window browsing.
;;; This is bound to key `C-h h'.

(defvar help-show-headers-timeout 5
  "*Number of seconds to wait after choosing a header before the *Headers*
buffer is buried.  See `help-show-headers'.")

;;;---------------------------------------------------------------------------
;;; Internal vars.

(setq help-show-headers-found-points nil)
(make-variable-buffer-local 'help-show-headers-found-points)

;;;---------------------------------------------------------------------------
;;; Get all headers into buffer *Headers*.

;;;###autoload
(defun help-show-headers (p)
  "Accumulate headers into a selection window, w/ buffer name *Headers*.
In the selection window, typing `q' closes the window.
Typing SPC or RET jumps to the header at point and closes the window.
Typing `n' or `p' moves respectively to next and previous headers, keeping
both windows open.  After `help-show-headers-timeout' seconds, the selection
window is closed.

Headers start with a regexp formed by concatenating `comment-start' with a
string of dashes that goes to the end of the line.  The selection window
displays the line immediately after this regexp.  For example, if the buffer
looks like:

   ;;----------------------------
   ;; user-config vars go here

   ...

   ;;----------------------------
   ;; actual code

   ...

you will see

   ;; user-config vars go here
   ;; actual code

in the selection window."
  (interactive "d")

  (let* (xfer
	 found-some
	 (line 1)
	 (re (concat "^" (strip comment-start) "+\\s-*-+\n\\([^\n]*\\)")))
    (with-output-to-temp-buffer
	"*Headers*"
      (save-excursion
	(goto-char (point-min))
	(princ (line-at-point))
	(setq help-show-headers-found-points (list (point-min)))
	(while (re-search-forward re (point-max) t)
	  (setq found-some t)
	  (if (< (match-beginning 0) p)
	      (setq line (1+ line)))
	  (terpri)
	  (princ (format "%s" (buffer-substring (match-beginning 1)
						(match-end 1))))
	  (push (match-beginning 1) help-show-headers-found-points))))
    (if (not found-some)		; if no headers found,
	(delete-window			;  cleanup
	 (get-buffer-window		;
	  "*Headers*"))			;
      (setq xfer			; else do the rest
	    help-show-headers-found-points)
      (switch-to-buffer-other-window
       "*Headers*")
      (help-mode)
      (view-mode -1)
      (goto-line line)
      (shrink-window-if-larger-than-buffer)
      (make-variable-buffer-local 'help-show-headers-found-points)
      (setq help-show-headers-found-points (reverse xfer))
      (use-local-map (make-sparse-keymap))
      (local-set-keys
       (list
	"\C-m" 'help-goto-header
	 " "   'help-goto-header
	 "n"   (progc (forward-line 1)
		 (help-goto-header (point) t))
	 "p"   (progc (forward-line -1)
		 (help-goto-header (point) t))
	 "q"   (progc (delete-window (get-buffer-window "*Headers*")))
	 ;; Add keybindings here.
	 )))))

;;;---------------------------------------------------------------------------
;;; Go to the header.

(defun help-goto-header (p &optional just-visit)
  "Find a string in previous-buffer that is on line point is on.
If JUST-VISIT non-nil, update display, but stay in headers buffer."
  (interactive "d")

  (let ((target (nth (count-lines 1 p) help-show-headers-found-points))
	(str (line-at-point)))
    (switch-to-buffer-other-window
     (other-buffer (current-buffer) t))
    (let ((saved (point)))
      (if target
	  (progn
	    (goto-char target)
	    (recenter 1))
	(goto-char saved)))
    (when just-visit
      (switch-to-buffer-other-window "*Headers*"))
    (when (or (null just-visit)
	      (sit-for help-show-headers-timeout))
      (delete-window (get-buffer-window "*Headers*"))
      (bury-buffer "*Headers*"))))

;;;###autoload (define-key help-mode-map "h" 'help-show-headers)
;;;###autoload (global-set-key "\C-hh" 'help-show-headers)

(provide 'help-show-headers)

;;;---------------------------------------------------------------------------
;;; help-show-headers.el,v1.19 ends here
