;;; -*- eval-last-page: t; -*-

;;; base.el,v 1.4 1998/08/19 22:45:28 ttn Exp

;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Base layer required by all objects.  High-metric permutation
;;; is desirable as time goes on; the process should never end.  ("May the rev
;;; be high!" --AHM)

;; local vars

(setq
 fill-column 79
 make-backup-files nil)

;; key bindings.

(local-set-key "\C-cd"
	       '(lambda ()
		  (interactive)
		  (let* ((cts (current-time-string))
			 (time (substring cts 11 16)))
		    (insert time))))

;;; base.el,v1.4 ends here

;;; but not really!
;;; .visit count. 0

;(require 'ahm)				; will this break emacs?!!

; TODO:
; - map requirements to current capability.
; - estimate implementation parameters.  commit to prediction.
; - do it.
; - correlate.

(message "don't forget to do something. :->")
