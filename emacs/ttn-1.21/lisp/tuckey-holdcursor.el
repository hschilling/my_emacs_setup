;;; tuckey-holdcursor.el,v 1.10 1998/08/19 22:59:53 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: User interface layer for `scroll-in-place'.
;;; Thanks go to Jeff Tuckey for introducing the idea.

(require 'scroll-in-place)

;;;###autoload
(defvar holdcursor-ladder-rung 1
  "the last arg used for down-holdcursor or up-holdcursor")

(if (not (boundp 'scroll-in-place))
    (setq scroll-in-place nil))


;;;###autoload
(defun down-holdcursor (&optional arg)
  (interactive "p")
  (if (or (eq last-command 'down-holdcursor)
	  (eq last-command 'up-holdcursor))
      (setq arg holdcursor-ladder-rung)
    (setq holdcursor-ladder-rung arg))
  (if scroll-in-place
      (scroll-up-in-place arg)
    (scroll-up arg)
    (forward-line arg)))

;;;###autoload
(defun up-holdcursor (&optional arg)
  (interactive "p")
  (if (or (eq last-command 'down-holdcursor)
	  (eq last-command 'up-holdcursor))
      (setq arg holdcursor-ladder-rung)
    (setq holdcursor-ladder-rung arg))
  (if scroll-in-place
      (scroll-down-in-place arg)
    (scroll-down arg)
    (forward-line (- arg))))

;; these are to be explored.  specifically, why does `redraw-frame' not have a
;; defualt?  also, is there a more primitive: "refresh-frame"?

(defun down-holdcursor-maybe (&optional arg)
  (interactive "p")
  (if (or (eq last-command 'down-holdcursor)
	  (eq last-command 'up-holdcursor))
      (setq arg holdcursor-ladder-rung)
    (setq holdcursor-ladder-rung arg))
  (if scroll-in-place
      (progn
	(scroll-up-in-place arg)
	(sleep-for 0 100)
	(redraw-frame (caadr (current-frame-configuration))))
    (scroll-up arg)
    (forward-line arg)))

(defun up-holdcursor-maybe (&optional arg)
  (interactive "p")
  (if (or (eq last-command 'down-holdcursor)
	  (eq last-command 'up-holdcursor))
      (setq arg holdcursor-ladder-rung)
    (setq holdcursor-ladder-rung arg))
  (if scroll-in-place
      (progn
	(scroll-down-in-place arg)
	(sleep-for 0 100)
	(redraw-frame (caadr (current-frame-configuration))))
    (scroll-down arg)
    (forward-line (- arg))))

;;; tuckey-holdcursor.el,v1.10 ends here
