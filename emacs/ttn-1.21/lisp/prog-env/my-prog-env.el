;;; ID: my-prog-env.el,v 1.25 1998/09/27 06:47:24 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Set up programming env the way I like it.

;;;###autoload
(defun my-prog-env ()
  "Sets up programming env the way i like it."

  (interactive)
  (setq comment-column (if (eq major-mode 'asm-mode) 32 40)
	fill-column 78
	C-l-gravity (if (or window-system (> (window-height) 30)) -15 -4)
	hs-buffer-state-saving 'on-kill
	hs-hide-comments-when-hiding-all nil
	)

  (local-set-keys
   (list
    "\C-a"  'beginning-of-code-line
    "\C-e"  'end-of-code-line
    "\C-\?" 'delete-backward-char
    "\C-x[" 'backward-page-ignore-narrow
    "\C-x]" 'forward-page-ignore-narrow
    "\C-c-" 'insert-separator
    "\M-s"  'tags-search
    "\M-j"  (progc
	      (end-of-line)
	      (newline-and-indent))
    "\M-?"  'what-defun-am-i-in
    "\M-#"  (case major-mode
	      ((emacs-lisp-mode lisp-interaction-mode lisp-mode scheme-mode)
	       'source-wrap-elisp-style)
	      ((sh-mode perl-mode makefile-mode text-mode)
	       'source-wrap-shell-style)
	      ((c-mode c++-mode)
	       'source-wrap-c++-style))

    "\M-\C-g" 'go

    "\C-cd"    'insert-time-stamp

    ;; 1997.1107.21:39:51-0800.  miles.  back to the basics.
    ;;
    ;; as always, this will probably appear in some form or other.  nothing
    ;; new under the sun, it seems.

    "\C-c\C-p"
    (progca (b e) "r"
      (case major-mode
	((c-mode c++-mode)
	 (require 'cmacexp)
	 (let ((curbuf (current-buffer))
	       (cme (c-macro-expansion b e "/lib/cpp")))
	   (string-match "^\\(\n\\|.\\)*\\\*/" cme)
	   (setq cme (replace-match "" nil t cme))
	   (while (string-match "\\(\t\\|\n\\)" cme)
	     (setq cme (replace-match " " nil t cme)))
	   (save-excursion
	     (let ((bufs (buffer-list)))
	       (while (not (string-match "^.gud-." (buffer-name)))
		 (set-buffer (pop bufs))))
	     (switch-to-buffer (current-buffer))
	     (delete-other-windows)
	     (insert "p " cme)
	     (comint-send-input)
	     (gud-refresh)		; todo: make less flickery
	     (switch-to-buffer-other-window curbuf)
	     )))))

    ;; 1998.0116.02:56:54-0800.  kfjc techno.  very hypnotic.
    ;;
    ;; search for a standard source code string.

    [?\C-c ?\M-\C-h]
    (progc
      (let ((here-re "here[.!]$"))
	(or (re-search-forward here-re (point-max) t)
	    (progn
	      (goto-char (point-min))
	      (or (progn
		    (message "(Wrapped)")
		    (re-search-forward here-re (point-max) t))
		  (message "No `%s' tags found." here-re))))))

    ;; 1998.0707.02:31:16-0700.  silence.
    ;;
    ;; must be getting old.  :->

    [f10]
    (key-binding [?\C-c ?\M-\C-h])

    ;; Add new interesting keybindings here!

    ))

  (mapc (progsa (mode) (funcall mode 1))
	'(abbrev-mode
	  auto-fill-mode
	  hs-minor-mode
	  ;; Enable minor modes here.
	  ))

  (hs-restore-state))

(defun C-l-gravity ()
  "Set var `C-l-gravity' to be window-line at POINT."
  (interactive)
  (setq C-l-gravity (count-lines (window-start)
				 (save-excursion
				   (beginning-of-line)
				   (point)))))

;;;###autoload (defalias 'elm 'emacs-lisp-mode)
;;;###autoload (defalias 'lim 'lisp-interaction-mode)

(provide 'my-prog-env)

;;; my-prog-env.el,v1.25 ends here
