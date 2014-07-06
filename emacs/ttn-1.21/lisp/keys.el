;;; keys.el,v 1.50 1998/09/04 21:55:12 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Global and specific keymap bindings.


;;;---------------------------------------------------------------------------
;;; Selective rebinding.

(defvar ttn-select-global-keys '(only)
  "Control how many global keys are rebound when keys.el is loaded.

If a list of the form `(only KEY1 KEY2 ...)', then only those named keys
  are rebound.
If a list of the form `(except KEY1 KEY2 ...)', then those named keys
  will not be rebound, but others may be.
If neither of these forms are used, `ttn-select-global-keys' has the effect
  of disabling all global key rebindings.

The default value for `ttn-select-global-keys' is `(only)', which disables
all rebindings.

Examples:

To prevent `C-x r' and `C-l' from being rebound, put in your ~/.emacs the
following form (note no SPC for `C-x r'):

	(setq ttn-select-global-keys '(except \"\\C-xr\" \"\\C-l\"))

To only rebind `C-x C-b', use the form:

	(setq ttn-select-global-keys '(only \"\\C-x\\C-b\"))

To accept all rebindings, use the form:

	(setq ttn-select-global-keys '(except))")



;;;---------------------------------------------------------------------------
;;; Global key bindings.

(map-table-2col

 (progsa (key binding)
   (and (listp ttn-select-global-keys)
	(and (or (and (eq 'only (car ttn-select-global-keys))
		      (member key (cdr ttn-select-global-keys)))
		 (and (eq 'except (car ttn-select-global-keys))
		      (not (member key (cdr ttn-select-global-keys)))))
	     (global-set-key key binding))))


 ;; The container is a list of pairs, the first element of a pair being the
 ;; keystroke, and the second either a command expression (progc/progca) or a
 ;; symbol naming a command.

 (list

  ;; First the simple...

  "\C-x\C-b" 'electric-buffer-list	; thanks, dave asher!

  "\M-n" 'down-holdcursor		; ah, this is the way it should be!
  "\M-p" 'up-holdcursor			;

  "\C-xvm" 'vm				; mail reading stuff

  "\M-m" 'compile			; water the seed

  "\C-cr" 'revert-buffer		; basic editing and movement
  "\C-xg" 'grep				;
  "\M-+" 'delete-region			;
  "\M-g" 'goto-line			;
  [home] 'delete-other-windows		;
  [end] 'delete-window			;
  [pause] 'split-window-vertically	;
  "\M-*" 'replace-string		;
  "\C-x\C-v" 'view-file			;
  "\C-cv" 'view-buffer			;

  "\M-l" 'what-line			;

  "\M-!" 'saved-shell-command		;
  "\C-xs" 'multi-shell			;

  "\C-x[" 'backward-page-ignore-narrow	;
  "\C-x]" 'forward-page-ignore-narrow	;

  "\C-x\M-b" bookmark-map		;

  "\C-x\C-m\C-m" 'mail-this-buffer	;

  "\C-ct" 'insert-time-stamp		;

  "\C-c-" 'insert-separator		;

  ;; Add new simple global keybindings here.

  ;; Then the complex.

  "\M-\""
  (progc
    (if (looking-at "\"")
	(forward-char 1)
      (insert ?" ?")
      (forward-char -1)))

  "\M-o"
  (progc
    (if (/= 1 (length (remove 'icon (mapcar #'frame-visible-p (frame-list)))))
	(other-frame 1)
      (switch-to-buffer
       (let ((bl (cdr (buffer-list))))
	 ;; SPC after question-mark intentional
	 (while (= (elt (buffer-name (car bl)) 0) ? )
	   (setq bl (cdr bl)))
	 (car bl)))))

  ;; [i] We assume `menu-bar-mode' is always off.  This assumption affects
  ;; relationship between `window-height' and `frame-height'.

  "\C-x\C-k"
  (progca (arg) "P"			; kill-buffer-close-window
    (if arg
	(bury-buffer)
      (kill-buffer (current-buffer)))
    (unless (one-window-p 'nomini)
      (delete-window)))

  "%"
  (progc				; match-parens
    (cond ((looking-at "\\s(") (forward-list) (forward-char -1))
	  ((looking-at "\\s)") (forward-char 1) (backward-list))
	  (t
	   (self-insert-command 1))))

  "\C-c\C-d"
  (progc				; delete-eol-dead-space
    (save-excursion
      (goto-char 1)
      (while (re-search-forward "[ \t]+$" (point-max) t)
	(delete-region
	 (match-beginning 0) (match-end 0)))))

  "\M->"
  (progc				; my-end-of-buffer
    (end-of-buffer)
    (recenter -1))

  "\M-<"
  (progc				; my-beginning-of-buffer
    (beginning-of-buffer)
    (recenter 1))

  "\C-cl"
  (progc				; line-to-top-of-window
    (recenter 1))

  "\C-xt"
  (progc				; toggle-truncate-lines
    (setq truncate-lines (not truncate-lines)))

  "\C-xw"
  (progc				; where-am-i
    (message (or (buffer-file-name)
		 (concat default-directory " (no file)"))))

  "\M-]"
  (progc				; rotate-top-2-windows
    (message "`rotate-top-2-windows' not implemented yet!"))

  "\C-xp"
  (progc				; other-previous-window
    (other-window -1))

  "\C-x\C-i"
  (progca (start end prefix)		; indent-rigidly-with-prefix
    "*r\nsPrefix to insert (don't need quotes): "
    (save-restriction
      (save-excursion
	(if (= 1 start)
	    (progn
	      (goto-char 1)
	      (insert prefix)
	      (setq start 2)))
	(narrow-to-region (1- start) (1- end))
	(goto-char (1- start))
	(replace-string "\n" (concat "\n" prefix))
	(widen))))

  "\C-x3"
  (progca (arg) "P"			; split-into-3-windows
    (let* ((old (if arg (window-width) (window-height)))
	   (v (/ (- old 2) 3)))
      (if arg
	  (progn
	    (split-window-horizontally)
	    (while (> (window-width) v)
	      (shrink-window-horizontally 1))
	    (other-window 1)
	    (split-window-horizontally)
	    (other-window -1))
	(split-window-vertically)
	(while (> (window-height) v) (shrink-window 1))
	(other-window 1)
	(split-window-vertically)
	(other-window -1))))

  "\C-x\C-c"
  (progca (arg) "P"			; make-sure-before-exiting
    (when (or arg (y-or-n-p "Logout? "))
      (save-buffers-kill-emacs)))

  "\C-x\C-f"
  (progca (filename) "FFilename: "	; find-file-possibly-rcs
    (if (not (string-match ",v$" filename))
	(find-file filename)
      (if (y-or-n-p
	   "RCS master file: `y' to open, or `n' to d.t.r.t. ")
	  (find-file filename)
	(let* ((cut-point (string-match "RCS/" filename))
	       (new-filename
		(concat (substring filename 0 cut-point)
			(substring filename (+ 4 cut-point) -2))))
	  (find-file new-filename)))))

  "\C-c\C-@"
  (progc				; xx
    (save-excursion
      (let (buffer-read-only)
	(goto-char 1)
	(while (search-forward "\C-@" nil t)
	  (replace-match "" nil t)))))

  "\C-cp"
  (progc
    (save-window-excursion
      (shell-command "xterm -geom 100x45 -e top -d1 &")))

  ;; 1997-10-11 19:38.  listening to some interesting banjo (i think).  i
  ;; really like the tightness and yet looseness -- the principal is slightly
  ;; on the lagging side.  :-D
  ;;
  ;; anyway, the best way to rephrase the following is:
  ;;
  ;;   i like `C-l' to move me to a better place.  the original name captures
  ;;   some of it, we can all see and appreciate that.  a better place means
  ;;   more higher comfort but with the memories not lost.  the memories are
  ;;   important.
  ;;
  ;;   binding for `M-r' has right idea but does not cover all the cases.
  ;;   so, merge the two, you can call it `home'.
  ;;
  ;; some hints to ong-da: (a) how many dimensions does this expression have?
  ;; (b) where is the most data motion?

  "\C-l"
  (progca (arg &optional arg1) "P"	; gnarly, dude!
    (if arg1
	(let ((arg0 arg))
	  (and (<= (point-min) arg0)
	       (< arg1 (point-max))
	       (<= arg0 arg1)
	       (font-lock-fontify-region arg0 arg1)))

      (cond

       ((null arg)
	(recenter (or (and (boundp 'C-l-gravity)
			   C-l-gravity)
		      '(4))))

       ((integerp arg)
	(recenter arg))

       ((and (listp arg)
	     (integerp (car arg)))
	(if (or (= 4 (car arg))
		(not (featurep 'font-lock)))
	    (recenter nil)
	  (setq arg (car arg))
	  (case arg
	    (16 (font-lock-fontify-buffer))
	    (64 (font-lock-fontify-buffer))))

	))))

  ;; 1997.1213.05:40:23-0800.  too early in the morning!

  "\C-xm"
  (progca (to subj) "sTo: \nsSubject: "
    (let* ((bufname (format "*mail %s*" to))
	   (anon-anon (get-buffer bufname)))
      (when anon-anon
	(setq anon-anon
	      (if (progn (switch-to-buffer bufname)
			 (and (y-or-n-p "Kill this noise? ")))
		  (not (kill-buffer bufname))
		anon-anon)))
      (when anon-anon
	(set-buffer anon-anon)
	(rename-buffer "*mail*"))	; bogus!
      (compose-mail to subj (not 'other-headers) anon-anon
		    'switch-to-buffer)
      (rename-buffer bufname)))

  ;; 1998.0506.00:01:20-0700.  see above for meaning of `C-x C-k'.

  [mode-line mouse-3]
  (key-binding "\C-x\C-k")

  ;; 1998.0707.02:41:49-0700.  this used to be just `bury-buffer', but it's
  ;; better to make Emacs understand Real Intent.  :->

  "\M-_"
  (progca (below-electric-buffer-notice) "P"
    (and below-electric-buffer-notice
	 (rename-buffer (concat " " (buffer-name))))
    (bury-buffer))

  ;; Add new global keybindings here.

  ))



;;;---------------------------------------------------------------------------
;;; Specific keymap bindings.

(map-table-3col

 ;; [d] The container structure is a list of 3-tuples, the first element of a
 ;; tuple being the keymap, the second the key, and the third either a command
 ;; expression (progc/progca) or a symbol naming a command.

 (progsa (map key binding)
   (define-key map key binding))

 (list

  help-map "a"				; usually `C-h a'
  'apropos

  vc-prefix-map "p"			; usually `C-x v p'
  'print-previous-revision

  bookmark-map "?"			; usually `C-x M-b ?'
  (progc
    (message "Make Jump Save Load Edit Rename Delete Insert"))

  isearch-mode-map "\C-y"		; usually `C-s C-y'
  (progc
    (x-set-selection 'PRIMARY
		     (buffer-substring
		      (point) (save-excursion (forward-sexp) (point))))
    (isearch-yank 'x-sel))

  ;; Add new mode-specific keymap bindings here.

  ))



;;; keys.el,v1.50 ends here
