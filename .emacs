
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;         Keyboard Mapping
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define function key sequences for TCP/Connect II terminals.
;; We have to do this via the hook since the term setup files
;; are run after the .emacs file is run

( add-hook 'term-setup-hook
 '( lambda ()
    (define-key function-key-map "\e[1~" [help])
    (define-key function-key-map "\e[2~" [home])
    (define-key function-key-map "\e[3~" [pgUp])
    (define-key function-key-map "\e[4~" [del])
    (define-key function-key-map "\e[5~" [end])
    (define-key function-key-map "\e[6~" [pgDown])
    
    (define-key function-key-map "\e[17~" [f1])
    (define-key function-key-map "\e[18~" [f2])
    (define-key function-key-map "\e[19~" [f3])
    (define-key function-key-map "\e[20~" [f4])
    (define-key function-key-map "\e[21~" [f5])
    
    (define-key function-key-map "\e[23~" [f6])
    (define-key function-key-map "\e[24~" [f7])
    (define-key function-key-map "\e[25~" [f8])
    (define-key function-key-map "\e[26~" [f9])
    
    (define-key function-key-map "\e[28~" [f10])
    (define-key function-key-map "\e[29~" [f11])
    (define-key function-key-map "\e[31~" [f12])
    (define-key function-key-map "\e[32~" [f13])
    (define-key function-key-map "\e[33~" [f14])
    (define-key function-key-map "\e[34~" [f15])
    )
 )


( define-key global-map [f1]  'undo )                 
( define-key global-map [f2]  'search-forward-remember )
( define-key global-map [f3]  're-search-forward-remember )
( define-key global-map [f4]  'search-again )          ;; really F4 on Mac
( define-key global-map [f5]  'buffer-menu )               ;; really F5 on Mac
( define-key global-map [f6]  'repeat-complex-command )    ;; really F6 on Mac
( define-key global-map [f7]  'beginning-of-buffer )       ;; really F7 on Mac
( define-key global-map [f8]  'end-of-buffer )             ;; really F8 on Mac
( define-key global-map [f9]  'help )                      ;; F9
( define-key global-map [f10]  'save-buffer )               ;; F10
( define-key global-map [f11]  'call-last-kbd-macro )       ;; F11
( define-key global-map [f12]  'execute-extended-command )  ;; F12

( define-key global-map [f13]  'save-buffers-kill-emacs )  ;; F13
( define-key global-map [kp-f4]  'scroll-down )  ;; Keypad asterisk
( define-key global-map [kp-subtract]  'scroll-up )  ;; Keypad minus


;; Keys above the arrow keys
( define-key global-map [help]    'help )
( define-key global-map [home]    'beginning-of-buffer )
( define-key global-map [pgUp]    'scroll-down )
( define-key global-map [del]     'delete-char )
( define-key global-map [end]     'end-of-buffer )
( define-key global-map [pgDown]     'scroll-up )


 ;; The Arrow keys
 (define-key function-key-map "\eOA" [up])
 (define-key function-key-map "\eOB" [down])
 (define-key function-key-map "\eOC" [right])
 (define-key function-key-map "\eOD" [left])


( define-key ctl-x-map "\C-c" 'save-buffers-kill-emacs )
( define-key global-map "\C-\\" 'quoted-insert )	;; use ^\ instead of ^q

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                Set Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
( setq next-line-add-newlines nil )
( setq-default indent-tabs-mode nil )
( setq default-major-mode 'text-mode )
( setq default-abbrev-mode t )
( setq abbrev-mode t )
( setq scroll-step 1 )
( setq next-screen-context-line 1 )
(set-variable (quote save-abbrevs) nil)
(set-variable (quote indent-mode) nil)          ;; so no tabs are used
(set-variable (quote indent-tabs-mode) nil)     ;; so no tabs are used
(setq-default indent-tabs-mode nil)     ;; so no tabs are used
( setq auto-save-interval 1000 )
( setq tab-stop-list ( list 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 36 38 40 44 48 52 56 60 64 ) )
(setq visible-bell t)
(setq line-number-mode t)

;; Fortran mode
( setq fortran-do-indent 2 )
( setq fortran-if-indent 2 )

(setq load-path (cons "/home/hschilli/emacs/" load-path) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               Fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-default-font "-adobe-courier-medium-r-normal-*-*-140-*-*-*-*-iso8859-1")
;;(set-default-font "-Adobe-Courier-Medium-R-Normal--18-180-75-75-M-110-ISO8859-1")
;;(set-default-font "-b&h-lucidatypewriter-medium-r-normal-sans-18-240-75-75-m-140-iso8859-1")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               Font Lock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(make-face 'my-comment-face)
(set-face-foreground 'my-comment-face "red")
;(set-face-font 'my-comment-face "-b&h-lucida sans-bold-r-*-sans-12-120-72-72-*-*-iso8859-1")
(setq font-lock-comment-face 'my-comment-face)

(make-face 'my-string-face)
(set-face-foreground 'my-string-face "brown")
(setq font-lock-string-face 'my-string-face)

(make-face 'my-function-name-face)
(set-face-foreground 'my-function-name-face "royalblue")
(setq font-lock-function-name-face 'my-function-name-face)

(make-face 'my-type-face)
(set-face-foreground 'my-type-face "royalblue")
(setq font-lock-type-face 'my-type-face)

(make-face 'my-variable-name-face)
(set-face-foreground 'my-variable-name-face "forestgreen")
(setq font-lock-variable-name-face 'my-variable-name-face)

(make-face 'my-preprocessor-face)
(set-face-foreground 'my-preprocessor-face "salmon")
(setq font-lock-preprocessor-face 'my-preprocessor-face)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

(autoload 'perl-mode "~/emacs-dir/cperl-mode" "alternate mode for editing Perl programs" t)

(setq auto-mode-alist
      (append '(("\\.\\([pP][Llm]\\|al\\)$" . perl-mode))  auto-mode-alist ))
(setq interpreter-mode-alist (append interpreter-mode-alist
				        '(("miniperl" . perl-mode))))

;;(setq auto-mode-alist
;;      (append '(("\\.[pP][Llm]$" . perl-mode))  auto-mode-alist ))


(if (boundp 'transient-mark-mode)
    (setq transient-mark-mode t))
(setq mark-even-if-inactive t)

;;;---------------------------------------------------------------------
;;; The mode line and the frame header.
;;;
;;; The following section adds the line number to the mode line, and
;;; the time and date to the frame header line.  The date is displayed
;;; in standard european 24 hour format, the format americans tends to
;;; refer to as "military" time...

(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; `system-name' variable is not defined in XEmacs.
(defvar my-system-name (system-name)
  "The name of the system we are running on.")

(cond (window-system
       (line-number-mode t)
       (setq frame-title-format 
	     '((multiple-frames ("%b   ") 
				("" invocation-name "@" my-system-name))
	       "    " 
	       display-time-string))
       ;; Per default, the time and date goes into the mode line.
       ;; We want's it in the header line, so lets remove it.
       (remove-hook 'global-mode-string 'display-time-string)))
      


;;; Python mode
(autoload 'python-mode "python-mode" "Python editing mode." t)
(setq auto-mode-alist
           (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist
           (cons '("python" . python-mode) interpreter-mode-alist))


        (add-hook 'python-mode-hook
                  '(lambda ()
                     (require 'pycc)
                     (setq py-indent-offset 4)
                     ;; Always insert spaces, never tabs.
                     (setq indent-tabs-mode nil)
                     (setq pycc-copyright-owner "Your Company Here, Inc.")
                     (local-set-key "\C-ct" 'pycc-insert-module-template)
                     (local-set-key "\C-cf" 'pycc-insert-func-template)
                     (local-set-key "\C-cc" 'pycc-insert-class-template)
                     (local-set-key "\C-cm" 'pycc-insert-method-template)
                     ;; (...callback-template just inserts a Python method
                     ;; which has an 'event=None' argument)
                     (local-set-key "\C-cb" 'pycc-insert-callback-template)
                     (local-set-key "\C-c#" 'pycc-insert-comment-box)
                     (local-set-key "\C-ci" 'pycc-insert-curr-classname)))


;;; XML mode
(load "~/emacs/nxml-mode-20041004/rng-auto.el")

;;; XHTML mode - does not work with Emacs 21
;;;;;;;;(load "~/emacs/nxhtml/autostart.el")


(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
( display-time )
( text-mode )

( define-key ctl-x-map "\C-k" 'hws-kill-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                load packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;( load "~/emacs/cycle-mini" )
;;( load "~/emacs/dup-line" )
;;( load "~/emacs/zap-to-regexp" )

;;(setq term-file-prefix nil ) ;; !!!!! temporary !!!!!!!


;; (require 'table)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar last-search-arg ""
   "Remembers the argument for last search.")

(defun search-forward-remember (arg)
   "search-forward with memory of last search."
   (interactive "sSearch For: ")
   (if (= (length arg) 0)
       (setq arg last-search-arg)
       (setq last-search-arg arg))
   (search-forward arg))

(defun set-screen-height-hws (arg)
   "set the screen height (in rows)."
   (interactive "nScreen Height(rows): ")
   (set-screen-height (* 1 arg)) ;;  don't ask me why I need the mutliply 
)

(defun re-search-forward-remember (arg)
   "re-search-forward with memory of last search."
   (interactive "sSearch For: ")
   (if (= (length arg) 0)
       (setq arg last-search-arg)
       (setq last-search-arg arg))
   (re-search-forward arg))

(defun search-again ()
   "search just like last search."
   (interactive)
   (search-forward last-search-arg))

(defun beginning-of-next-line ()
  "Move to the beginning of the next line."
  (interactive)
  (forward-line 1))

(defun beginning-of-previous-line ()
  "Move to the beginning of the previous line."
  (interactive)
  (forward-line -1))

(defun hws-kill-line ( &optional arg)
   "Kill the current line plus additional lines depending on the argument.
The absolute value of the argument gives the number of lines deleted.
A negative argument indicates delete lines backward."
	( interactive "*P" )
	( if arg
		( progn (setq arg (prefix-numeric-value arg))
			( if ( > arg 0)
				(beginning-of-line) )
			( if ( < arg 0 )
				( beginning-of-next-line ) )
			( kill-region (point)
				(scan-buffer (point)
					 ( if (> arg 0 )
					     arg ( - arg 1 ) ) ?\n ) )
		)
		( if ( eobp )
			( signal 'end-of-buffer nil )
			( progn
				(beginning-of-line)
				 ( kill-region (point)
					(progn (beginning-of-next-line)
					       (point) ) )
			)
		)
	)
)

;;( defun next-line (count) (interactive "p") ( previous-line ( - count)))

;; supposedly better than the other one
(defun next-line (arg)
  "Move down ARG lines or complain if at the end of the buffer"
  (interactive "p")
  (if (eobp) (progn (beep)(message "End of buffer"))
      (previous-line (- arg))))


(put 'narrow-to-region 'disabled nil)

(put 'downcase-region 'disabled nil)
