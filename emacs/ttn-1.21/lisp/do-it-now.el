;;; do-it-now.el,v 1.61 1998/09/27 06:01:48 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: No definitions, just actions.


;;;---------------------------------------------------------------------------
;;; Set some directory env vars.

(map-table-2col (progsa (var dir-re)
		  (setenv var (find dir-re load-path :test #'string-match)))
		'("l"  "ttn/lisp/*$"
		  "lp" "lisp/prog-env"
		  "ll" "low-stress"
		  "L"  "share/emacs/[0-9.]+/lisp$"
		  "LL" "share/emacs/[0-9.]+/lisp/emacs-lisp$"
		  ;; add here.
		  ))

(setenv "c" "~/codebits")
(setenv "s" (concat (getenv "c") "/scheme"))


;;;---------------------------------------------------------------------------
;;; Ensure the agreeableness of things.

(map-table-2col (progsa (thing setting)
		  (when (fboundp thing) (funcall thing setting)))
		'(line-number-mode     -1
                  menu-bar-mode        -1
		  transient-mark-mode	1
		  scroll-bar-mode      -1
		  ;; add here.
		  ))


;;;---------------------------------------------------------------------------
;;; Keep track of time.

(progn
  (setq display-time-24hr-format t)	; move?
  (display-time))


;;;---------------------------------------------------------------------------
;;; Window system stuff.

(when window-system
  (load "if-window-system"))


;;;---------------------------------------------------------------------------
;;; Load customization stuff.

(when (> emacs-major-version 19)
  (load-file
   (setq custom-file (concat ttn-elisp-home "lisp/customized-state.el"))))


;;;---------------------------------------------------------------------------
;;; Autoloads

;; vm
(autoload 'vm "vm" "Start VM on your primary inbox." t)
(autoload 'vm-other-frame "vm" "Like `vm' but starts in another frame." t)
(autoload 'vm-visit-folder "vm" "Start VM on an arbitrary folder." t)
(autoload 'vm-visit-virtual-folder "vm" "Visit a VM virtual folder." t)
(autoload 'vm-mode "vm" "Run VM major mode on a buffer" t)
(autoload 'vm-mail "vm" "Send a mail message using VM." t)
(autoload 'vm-submit-bug-report "vm" "Send a bug report about VM." t)


;;;---------------------------------------------------------------------------
;;; Aliases

(defalias 'make 'compile)
(defalias 'next-buffer 'bury-buffer)


;;;---------------------------------------------------------------------------
;;; Miscellaneous initializations

(setq *emacs-start-time* (current-time))


;;; do-it-now.el,v1.61 ends here
