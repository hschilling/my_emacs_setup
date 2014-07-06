;;; hooks.el,v 1.70 1998/09/19 06:41:12 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Hooks: Load time, major-mode and advice.


;;;---------------------------------------------------------------------------
;;; Load time hooks.
;;;
;;; Munge `after-load-alist'.  Set some things after loading some other
;;; things.  If there already exists something where we want to set some
;;; thing, put the new thing after the old thing.

(mapc (progsa (x)			; each X is (FILENAME FORMS...)
	(let* ((filename (car x))
	       (forms (cdr x))
	       (prev (assoc filename after-load-alist)))
	  (when (and prev (not (equal (cdr prev) forms)))
	    (setq forms (append (cdr prev) forms)))
	  (setq after-load-alist (delete prev after-load-alist))
	  (push (cons filename forms) after-load-alist)))

      (list

       '("info"
	 (mapc (progsa (x)
		 ;; unfortunately, `if' is not setf-able
		 (if (emacs-type-eq 'lucid)
		     (pushnew x Info-default-directory-list :test #'string=)
		   (pushnew x Info-directory-list :test #'string=)))
	       (list
		"/usr/info"
		"/usr/local/info"
		(expand-file-name "~/local/info"))))

       ;; Add after-load hints here.

       ))


;;;---------------------------------------------------------------------------
;;; Major-mode hooks.

(flet
    (
     ;; Find a proper pair and then apply `add-hook' to it.  "There is no
     ;; reason to stop with one level."

     (hooks-walker
      (appp)				; a proper pair, perhaps?

      (if (eq (type-of (car appp)) 'symbol)
	  (add-hook (car appp) (cdr appp) t)
	(mapc 'hooks-walker appp)))

     )

  ;; The container structure is a list of possibly-recursive pairs, the first
  ;; element of a pair being the key, and the second either a symbol naming a
  ;; function or a lambda expression.  The possibly-recursive nature of the
  ;; data is why we do not use `map-table-2col'.  [This seems unnecessarily
  ;; complex and should probably be restricted to non-recursive data.]

  (mapc
   'hooks-walker

   (list

    ;; You might think that some text mode functionality should be bubbled up.
    ;; But, I ask: to where?  Since only bogus *scratch* buffer generation
    ;; seems to be uninterested, having text mode as default basically allows
    ;; it a large amount of the required functionality.  Btw, this hook fixes
    ;; that.

    (cons
     'text-mode-hook (progc
		       (setq fill-column 78)
		       ;; (abbrev-mode 1) ;; need abbrevs table
		       (auto-fill-mode 1)))

    ;; Keep things visually consistent in Dired.  Instant response is the
    ;; goal.  Hmmm, how many other modes have a `MODE-load-hook' available?

    (cons
     'dired-mode-hook (progs
			(setq truncate-lines t)))

    (cons
     'dired-load-hook (progs
			(let ((stashed-map (current-local-map)))
			  (use-local-map dired-mode-map)
			  (local-set-keys
			   (list
			    "["	   'scroll-left-20
			    "]"    'scroll-right-20
			    "\C-m" 'dired-view-file
			    "q"    (progc
				     (kill-buffer (current-buffer)))
			    "z"    'gzip-or-gunzip-from-dired
			    "W"    'dired-wipe-unseeables
			    "*"    'dired-mark-executables
			    "/"	   'dired-mark-directories
			    "@"    'dired-mark-symlinks
			    ))
			  (setq dired-deletion-confirmer (progsa (x) x))
			  (setq dired-listing-switches "-alF")
			  ;; Rest is cleanup.  Insert here.
			  (use-local-map stashed-map))))

    ;; C and C++ modes are similar.  There is no reason to stop with one
    ;; level.  I suppose generalizations can be a good thing (sometimes!).

    (mapcar
     (function (lambda (x)
		 (list
		  (` (c-mode-hook (,@ x)))
		  (` (c++-mode-hook (,@ x))))))
     (list 'my-prog-env
	   (progs
	     (local-set-keys
	      (list
	       "\C-c\C-d" (global-key-binding "\C-c\C-d")
	       "\C-?"     'backward-delete-char)))))

    (cons
     'shell-mode-hook (progs
			(setq comint-output-filter-functions
			      '(comint-strip-ctrl-m))
			(local-set-key "\C-a" 'comint-bol)))

    (cons
     'sh-mode-hook 'my-prog-env)

    (cons
     'emacs-lisp-mode-hook 'my-prog-env)

    (cons
     'emacs-lisp-mode-hook (progs
			     (local-set-key "\M-m" 'byte-compile-file)))

    (cons
     'lisp-mode-hook 'my-prog-env)

    (mapcar
     (function (lambda (x)
		 (list
		  (` (asm-mode-hook (,@ x))))))
     (list 'my-prog-env (progs
			  (setq comment-column 32))))

    (cons
     'hs-minor-mode-hook (progs
			   (local-set-keys
			    (list
			     "\C-cH" 'hs-hide-all
			     "\C-cS" 'hs-show-all
			     "\C-ch" 'hs-hide-block
			     "\C-cs" 'hs-show-block
			     "\C-co" 'hs-save-state
			     "\C-ci" 'hs-restore-state
			     "\C-cL" 'hs-hide-level
			     ))))

    (cons
     'compilation-mode-hook (progs
			      (local-set-keys
			       (list
				"]" 'scroll-right-20
				"[" 'scroll-left-20))
			      (setq truncate-lines t)))

    (cons
     'perl-mode-hook (progs
		       (my-prog-env)
		       (setq perl-indent-level                2 ; GNU style
			     perl-continued-statement-offset  2
			     perl-continued-brace-offset      0
			     perl-brace-offset                0
			     perl-brace-imaginary-offset      0
			     perl-label-offset               -2)))

    (cons
     'Man-mode-hook (progs		;psst, func-it next week
		      (local-set-keys
		       (list
			"["    'scroll-left-20
			"]"    'scroll-right-20
			"\M-n" 'down-holdcursor
			"\M-p" 'up-holdcursor
			"f"    'Man-follow-manual-reference
			))))

    (cons
     'electric-buffer-menu-mode-hook

     (progs
       (local-set-keys
	(list
	 "\C-m" 'Electric-buffer-menu-select
	 " "    'next-line
	 "\C-?" 'previous-line
	 "["    'scroll-left-20
	 "]"    'scroll-right-20))
       ;; Replace parentdirs w/ environment variables, plus others.
       (let (buffer-read-only)
	 (save-excursion
	   (mapc (progsa (ev)		; env var
		   ;; In buffer, replace EV w/ backward mapping.
		   (when (and (string-match "/" ev)
			      (not (string-match " " ev)))
		     (goto-char (point-max))
		     (let* ((x (string-match "=" ev))
			    (var (substring ev 0 x))
			    (val (substring ev (1+ x))))
		       (while (search-backward val (point-min) t)
			 (replace-match (concat "$" var))))))
		 ;; EV is a sorted canonicallized list, longest first.
		 (sort (mapcar (progsa (ev)
				 (if (string-match "\\(.*\\)=~\\(.*\\)" ev)
				     (concat (match-string 1 ev)
					     "=" (getenv "HOME")
					     (match-string 2 ev))
				   ev))
			       process-environment)
		       (progsa (a b)
			 (> (length a) (length b)))))
	   ;; Do HOME, then HOOD replacements.
	   (goto-char 1)
	   (while (search-forward "$HOME" (point-max) t)
	     (replace-match "~"))
	   (let* ((hood (file-name-directory (getenv "HOME"))))
	     (unless (string= hood "/")
	       (goto-char (point-max))
	       (while (search-backward hood (point-min) t)
		 (replace-match "~"))))))))

    (cons
     'verilog-mode-hook (progs
			  (my-prog-env)
			  (hs-minor-mode -1)
			  (auto-save-mode -1)
			  (abbrev-mode -1)
			  (make-local-variable 'compile-command)
			  (setq compile-command "make ")
			  (make-local-variable
			   'compilation-error-regexp-alist)
			  (setq
			   compilation-error-regexp-alist
			   '(("^Error!.*\n\\([^\n]+\n\\)*\\s-+\"\\(.*\\)\", \\([0-9]+\\):" 2 3)
			     ("^Warning!.*\n\\([^\n]+\n\\)*\\s-+\"\\(.*\\)\", \\([0-9]+\\):" 2 3)))))

    (cons
     'rmail-mode-hook (progs
			(local-set-keys
			 (list
			  "["    'scroll-left-20
			  "]"    'scroll-right-20
			  "\M-r" 'rmail-search-backwards
			  ))
			(setq truncate-lines t)))

    (cons
     'sgml-mode-hook 'my-prog-env)

    (cons
     'comint-mode-hook (progs
			 (setq comint-scroll-show-maximum-output t)))

    (cons
     'mail-mode-hook (progs
		       (set-fill-column 72) ; easier to quote
		       (local-set-key
			"\M-&"
			(progca (tag) "sTag: "
			  (rename-buffer (concat "*mail-" tag "*"))))))

    (cons
     'view-mode-hook (progs
		       (setq truncate-lines t)
		       (define-keys view-mode-map ; because view-mode is minor!
			 (list
			  "[" 'scroll-left-20
			  "]" 'scroll-right-20))))

    (cons
     'sc-load-hook (progs
		     (setq
		      sc-preferred-attribution-list
		      (let* ((i "initials")
			     (pref (remove i sc-preferred-attribution-list))
			     (split (1+ (position
					 "x-attribution" pref :test 'string=))))
			(concatenate 'list
				     (subseq pref 0 split)
				     (list i)
				     (subseq pref split))))))

    (cons
     'help-mode-hook (progs
		       (when (eq this-command 'describe-bindings)
			 (let ((buffer-read-only nil))
			   (goto-char (point-min))
			   (flush-lines "\t\tundefined$")))))

    ;; 1997-10-14 04:11. make "man -k" pretty and useful.  it surprises me
    ;; that this wasn't thought of before.  the best way to rephrase the
    ;; following is:
    ;;
    ;;   i like references to be useful.  the original code does not
    ;;   recognize the reference nature of the output.  thus, the output needs
    ;;   to be massaged.
    ;;
    ;; some hints to ong-da: (a) what do we look for?  (b) is there a better
    ;; way?

    (cons
     'Man-mode-hook
     (progs
       (when (string-match "[Mm]an -k" (buffer-name))
	 (let (buffer-read-only
	       ents ent txt sec pivot)
	   (goto-char (point-min))
	   (insert Man-see-also-regexp "\n\n")
	   (while (re-search-forward
		   "^\\(.*\\)\\(([^ ]+)\\)\\(\\s-+-\\s-+.*\\)$"
		   (point-max) t)
	     (setq ents (match-string 1)
		   pivot (list (match-beginning 2) (match-string 2))
		   txt (list (match-end 3) (match-string 3)))
	     (goto-char (match-beginning 1))
	     (do ((i (count ?, ents) (1- i)))
		 ((= i 0) nil)
	       (re-search-forward "\\(,\\|\n\\)" (point-max) t)
	       (delete-char -1)
	       (delete-horizontal-space)
	       (insert (cadr pivot) "\t" (cadr txt) "\n"))
	     (re-search-forward "\\(\\s-+\\)(")
	     (delete-region (match-beginning 1) (match-end 1))
	     (end-of-line)
	     (insert "\n"))
	   (Man-build-references-alist)))))

    ;; 1997.1122.02:57:53-0800.  middle of the night, why didn't i think of
    ;; this sooner?!

    (cons
     'scheme-mode-hook 'my-prog-env)

    (cons
     'scheme-mode-hook (progs
			 (local-set-key
			  "\M-m" 'scheme-send-definition-and-go)))

    ;; 1997.1211.03:37:27-0800.  Obviously, this should be done in
    ;; `comint-mode-hook', but I currently am not aware of the proper keymap
    ;; inheritence mechanism to do it.

    (cons
     'inferior-scheme-mode-hook (progs (local-set-key "\C-a" 'comint-bol)))
    (cons 'lisp-mode-hook       (progs (local-set-key "\C-a" 'comint-bol)))

    ;; 1998.0117.00:22:13-0800.  kfjc old-school belgium techno.  good for
    ;; reading linux newsgroups.

    (cons
     'gnus-summary-menu-hook (progs
			       (define-keys gnus-summary-mode-map
				 (list
				  "[" 'scroll-left-20
				  "]" 'scroll-right-20))))

    ;; 1998.0129.23:58:54-0800.  silence.  getting hungry.
    ;; this is support for the "go" programming convention.

    (cons
     'comint-mode-hook (progs (local-set-key "\M-\C-g" 'go)))

    ;; 1998.0730.15:55:35-0700.  useful for wrapping, etc.

    (cons
     'makefile-mode-hook 'my-prog-env)

    ;; 1998.0825.12:53:42-0700.  the whirring of the espresso machine gently
    ;; drowns out the baroque guitar (there is also some piano).  baroque
    ;; harmonies rule!  typical comment, i know, but all those geeks can't be
    ;; wrong!

    (cons
     'mail-send-hook (progs
		       (and (boundp 'ttn-jammed-from)
			    (save-excursion
			      (goto-char (point-min))
			      (let ((reply-to
				     (concat "Reply-to: " ttn-jammed-from)))
				(unless (search-forward reply-to nil t)
				  (goto-char (point-min))
				  (insert reply-to "\n")))))))

    ;; 1998.0911.11:44:32-0700.  silence, except for my sneezing.  damn
    ;; allergies move focus to the wrong part of the experience.  :-/

    (cons
     'vm-mode-hook (progs
		     (local-set-keys
		      (list
		       "x" 'vm-expunge-folder
		       "s" 'vm-save-folder
		       "o" 'vm-save-message
		       ))))

    ;; Add new hooks here.

    )))



;;;---------------------------------------------------------------------------
;;; Advice hooks.
;;;
;;; TODO: Define some consistent naming convention.

;; Pretty up `vc-print-log' output.
;;
(defadvice vc-print-log (after pretty-up-vc-print-log-output first activate)
  "Make `vc-print-log' output more readable."
  (interactive)
  (when (eq this-command 'vc-print-log)
    (let ((fn (file-name-nondirectory (buffer-file-name vc-parent-buffer)))
	  (sep (concat "#" (make-string (- (frame-width) 4) ?-) "\n")))
      (goto-char (point-max))
      (while (re-search-backward (concat
				  "^-+\nrevision \\(\\S-*\\).*\n"
				  "date: \\([^;]+\\);\\s-+"
				  "author: \\([^;]+\\);"
				  "\\(\\s-+.*\\s-+"
				  "lines: \\(.*\\)\\)*"
				  )
				 (point-min) t)
	(replace-match
	 (concat			; space is good
	  "\n\n"
	  sep
	  "# " fn " \\1      \\2      \\3      \\5\n"
	  sep
	  )))
      )))

;; Do the right thing after a `C-c C-l' when using gud.
;;
(defadvice gud-refresh (after gud-refresh-with-ttn-env)
  "Take into account recenter may be weird!"
  (call-interactively (key-binding "\M->")))

;; On error, disable fortunate-loop.
;;
;;-?
;;-? too bad, does not work.  todo: find out how to hook into `error'.
;;-?
;;-? (defadvice error (before disable-fortunate-loop first activate)
;;-?   "On error, disable fortunate-loop before the actual error."
;;-?   (when enable-fortunate-loop
;;-?     (setq enable-fortunate-loop nil)
;;-?     (message "Disabling fortunate-loop.")))

;; Add advice here.

;;;---------------------------------------------------------------------------
;;; hooks.el,v1.70 ends here
