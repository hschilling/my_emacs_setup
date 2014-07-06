;;; if-window-system.el,v 1.15 1998/08/19 22:46:36 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Setup applicable if `window-system' non-nil.
;;; If loaded when `window-system' is nil, behavior is undefined.
;;;
;;; Sections: funcs, vars, hooks, keys, do-it-now.

(require 'emacs-vers)


;;;---------------------------------------------------------------------------
;;; Functions

(defun hs-already-hidden-p ()
  "Returns non-nil if point is in an already-hidden block otherwise nil."
  (save-excursion
    (let ((eol (progn (end-of-line) (point))))
      (beginning-of-line)
      (search-forward "\C-m" eol t))))

(defun mouse-toggle-nesting (e)
  (interactive "@e")
  (mouse-set-point e)
  (if (hs-already-hidden-p)
      (hs-show-block)
    (hs-hide-block)))


;;;---------------------------------------------------------------------------
;;; Variables

(defvar my-font-ring
  '("lucidasanstypewriter-18"
    "9x15"
    "10x20"
    "lucidasanstypewriter-24")
  "A ring of fonts used nicely.  Currently partially tested only w/ glug.")


;;;---------------------------------------------------------------------------
;;; Hooks


;;;---------------------------------------------------------------------------
;;; Keys

(if (emacs-type-eq 'fsf)
    (progn
      (global-set-key [S-up] 'scroll-down)
      (global-set-key [S-down] 'scroll-up))
  (global-set-key [(shift up)] 'scroll-down)
  (global-set-key [(shift down)] 'scroll-up))

;(require 'hideshow)
;(if (emacs-type-eq 'fsf)
;    (define-key hs-minor-mode-map [S-mouse-3] 'mouse-toggle-nesting)
;  (define-key hs-minor-mode-map [(shift mouse-3)] 'mouse-toggle-nesting))

(global-set-key "\C-c+" (progc
			 (let ((df (pop my-font-ring)))
			   (yo! df)
			   (rplacd (last my-font-ring) (list df))
			   (set-default-font df))))


;;;---------------------------------------------------------------------------
;;; Turn on mic-paren.

(unless noninteractive
  (turn-on-mic-paren))


;;; if-window-system.el,v1.15 ends here
