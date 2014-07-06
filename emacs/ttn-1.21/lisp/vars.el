;;; vars.el,v 1.35 1998/09/27 06:16:42 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Desription: Sets variables for various things.


;;;---------------------------------------------------------------------------
;;; Garden-variety editing.

(setq

 inhibit-startup-message t		; hehe, no longer a novice
 default-major-mode 'text-mode		; (see text-mode-hook)
 default-fill-column 78			; big enough
 backup-by-copying-when-linked t	; for symlinks
 auto-save-interval 600			; keystrokes NOT seconds
 version-control nil			; heh, why be like vms?!
 delete-auto-save-files t		; limited disk space, yasee
 require-final-newline t		; for other programs
 scroll-step 1				; smoother scrolling
 completion-ignored-extensions		; don't do completion for these files
 '(".bak" "~" ".lpt" ".bin" ".o"
   ".elc" ".elc.gz" ".err" ".dvi"
   ".aux" ".otl" ".ckp" ".lst")
 gnus-use-full-window nil		; want ability to do other stuff
 gnus-default-article-saver		; save it as 'mail'
 'gnus-summary-save-in-mail
 gnus-default-distribution "world"	; spew to everyone
 gnus-novice-user nil			; hope not
 gnus-thread-indent-level 2		; 4 is too much
 ;gnus-mail-reply-method			; use tmh for reply
 ;'tmh-reply-to-shown-message
 ;gnus-mail-forward-method		; use tmh for forward
 ;'tmh-forward-shown-message
 gnus-optional-headers nil		; just the subject, please
 gnus-large-newsgroup 20		; ask if more than this
; ad-use-jwz-byte-compiler nil		; use v18 byte-comp (for now)
 auto-save-timeout nil			; disable saving based on time
 window-min-height 1			; sure, why not?
 display-time-24hr-format t		; save mode-line space
 next-line-add-newlines nil		; do not add newlines at EOB
 vc-keep-workfiles t			; sure, why not?
 vc-command-messages t			; keep me entertained
 vc-mistrust-permissions t		; use the SOURCE dammit!
 vc-make-backup-files nil		; don't need em
 vc-initial-comment nil			; why bother?
 visible-bell (not window-system)	; take the beep if window-system
 inferior-lisp-program "gcl"		; keep the faith, man!
 gnus-nntp-server "news"		; should move this to work-specific
 lpr-switches '("-Plp")			; ditto
 apropos-do-all t			; ???
 split-window-keep-point nil		; less motion is good
 view-scroll-auto-exit t		; get out!
 dired-listing-switches "-alFG"		; omit group info if possible

 ;; add simple var jamming here.

 )


;;;---------------------------------------------------------------------------
;;; Mail and rmail support.

(setq rmail-file-name "~/Mail/inbox"		; jb-fnar
      mail-yank-prefix "> "
      mail-self-blind t
      rmail-delete-after-output t)

(mapc (progsa (yuk)
	      (if (string-match (regexp-quote yuk) rmail-ignored-headers)
		  nil
		(setq rmail-ignored-headers
		      (concat rmail-ignored-headers yuk))))
      '("\\|^return-path:"
	"\\|^sender:"
	"\\|^precedence:"
	"\\|^\\S-.+-to:"
	"\\|^mime-version:"
	"\\|^content-.+:"
	"\\|^x\\S-*:"
	"\\|^references:"
	"\\|^\\S-*encoding:"
	"\\|^Resent-"
	))


;;;---------------------------------------------------------------------------
;;; Bookmark support.

(setq bookmark-default-file
      (concat ttn-elisp-home "lisp/bookmarks.bmk"))


;;;---------------------------------------------------------------------------
;;; Mode line customization.

(setq mode-line-format (delete-if (progsa (x)
				    (and (symbolp x)
					 (string-match "mule\\|frame"
						       (symbol-name x))))
				  mode-line-format))

(setq-default
 mode-line-buffer-identification	; save space
 '("%5b"))

(set-default 'mode-line-modified (list "-%1*%1*  %P  "))
(setf (nth (- (length mode-line-format) 2) mode-line-format) ; hmm
      (concat (getenv "USER") ":" (getenv "HOST")
	      (if (> (length (getenv "WINDOW")) 0)
		  (concat "/" (getenv "WINDOW")))))


;;;---------------------------------------------------------------------------
;;; Properties.

(mapc (progsa (cmd)
	      (put cmd 'disabled nil))
      '(eval-expression
	upcase-region
	downcase-region
	narrow-to-page
	narrow-to-region
	;; add liberated commands here.
	))


;;;---------------------------------------------------------------------------
;;; Munge `auto-mode-alist'.

(mapc (progsa (x)
	(pushnew x auto-mode-alist :test #'equal))
      '(("\\.pl\\'"	. perl-mode)
	("\\.ph\\'"	. perl-mode)
	("\\.perl\\'"	. perl-mode)
	("\\.thud\\'"	. scheme-mode)
	("\\.th\\'"	. scheme-mode)
	("\\.v\\'"	. verilog-mode)
	;; add auto-mode hints here.
	))


;;;---------------------------------------------------------------------------
;;; Non-conformant hooks.

(setq
 compilation-finish-function
 (function (lambda (buf status-string)
	     (yo! (substring status-string 0 -1) 'funky-flash))))


;;;---------------------------------------------------------------------------
;;; Hack to use own copy of hideshow.

(unless (featurep 'hideshow)
  (makunbound 'hs-special-modes-alist))

;;;---------------------------------------------------------------------------
;;; vars.el,v1.35 ends here
