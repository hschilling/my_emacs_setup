;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; c-style.el --- sets c-style control variables.
;; 
;; Author          : Daniel LaLiberte (liberte@a.cs.uiuc.edu)
;; Created On      : Wed Aug 12 08:00:20 1987
;; Last Modified By: Daniel LaLiberte
;; Last Modified On: Wed Nov 16 22:37:43 1988
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; From liberte@m.cs.uiuc.edu  Thu Nov 17 00:14:53 1988
;;; Received: from A.CS.UIUC.EDU by prep.ai.mit.edu; Thu, 17 Nov 88 00:14:53 EST
;;; Received: from m.cs.uiuc.edu by a.cs.uiuc.edu with SMTP (UIUC-5.52/9.7)
;;; 	id AA12177; Wed, 16 Nov 88 23:19:59 CST
;;; Received: by m.cs.uiuc.edu (4.12/9.7)
;;; 	id AA10413; Wed, 16 Nov 88 23:21:44 cst
;;; Date: Wed, 16 Nov 88 23:21:44 cst
;;; From: liberte@m.cs.uiuc.edu (Daniel LaLiberte)
;;; Message-Id: <8811170521.AA10413@m.cs.uiuc.edu>
;;; To: info-gnu-emacs@prep.ai.mit.edu
;;; Subject: c-style.el
;;; 
;;; I made a number of changes to c-style.el.   It turns out that it
;;; does not work (and maybe never did?) to set the c-style in the
;;; Local Variables list because the c-mode-hook (and thus set-c-style)
;;; is called before hack-local-variables.
;;; 
;;; Dan LaLiberte
;;; uiucdcs!liberte
;;; liberte@cs.uiuc.edu
;;; liberte%a.cs.uiuc.edu@uiucvmd.bitnet
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Definitions for buffer local c-mode indentation style.
;;; Put either (autoload 'set-c-style "c-style" nil t)
;;;         or (load "c-style") in your .emacs.

(defvar default-c-style 'GNU
  "*The default value of c-style.  Set this in your .emacs.")

;;; =====================================================
;;; There are several ways to call set-c-style
;;;
;;; - Just add set-c-style to your c-mode-hook.
;;;    Without style argument, default-c-style will be used.
;;;    With style argument, this will set the style for every 
;;;    c-mode buffer the same.
;;;
;;; - Call set-c-style from the Local Variables list.
;;;    e.g. "eval:(set-c-style 'C++)"
;;;
;;; - Call set-c-style interactively.  It prompts for the style name
;;;    with completion using default-c-style.
;;; =====================================================

;; Predefined styles
(defvar c-style-alist '(
			(GNU (c-indent-level . 2)
			     (c-continued-statement-offset . 2)
			     (c-brace-offset . 0)
			     (c-argdecl-indent . 5)
			     (c-label-offset . -2))
			(BSD (c-indent-level . 8)
			     (c-continued-statement-offset . 8)
			     (c-brace-offset . -8)
			     (c-argdecl-indent . 8)
			     (c-label-offset . -8))
			(K&R (c-indent-level . 5)
			     (c-continued-statement-offset . 5)
			     (c-brace-offset . -5)
			     (c-argdecl-indent . 0)
			     (c-label-offset . -5))
			(C++ (c-indent-level . 4)
			     (c-continued-statement-offset . 4)
			     (c-brace-offset . -4)
			     (c-argdecl-indent . 4)
			     (c-label-offset . -4))
			;; From Lynn Slater
			(LRS (c-indent-level . 4)
			     (c-continued-statement-offset . 4)
			     (c-brace-offset . 0)
			     (c-argdecl-indent . 4)
			     (c-label-offset . -2)
			     (c-auto-newline . nil)
			     )
			))

(defvar c-style nil
  "The buffer local c-mode indentation style.")

(defun set-c-style (&optional style)
  "Set up the c-mode style variables from STYLE if it is given, or
default-c-style otherwise.  It makes the c indentation style variables
buffer local."

  (interactive)

  (let ((c-styles (mapcar 'car c-style-alist))) ; for completion
    (if (interactive-p)
	(setq style
	      (let ((style-string	; get style name with completion
		     (completing-read
		      (format "Set c-mode indentation style to (default %s): "
			      default-c-style)
		      (vconcat c-styles)
		      (function (lambda (arg) (memq arg c-styles)))
		      )))
		(if (string-equal "" style-string)
		    default-c-style
		  (intern style-string))
		)))
    
    ;; if style is nil, use default-c-style.
    (setq style (or style default-c-style))
    
    (make-local-variable 'c-style)
    (if (memq style c-styles)
	(setq c-style style)
      (error (message "Undefined c style: %s" style))
      )
    (message "c-style: %s" c-style)
    
    ;; finally, set the indentation style variables making each one local
    (mapcar (function (lambda (c-style-pair)
			(make-local-variable (car c-style-pair))
			(set (car c-style-pair)
			     (cdr c-style-pair))))
	    (cdr (assq c-style c-style-alist)))
    c-style
    ))

