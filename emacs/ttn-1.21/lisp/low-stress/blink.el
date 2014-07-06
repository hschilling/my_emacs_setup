;;; ID: blink.el,v 1.11 1998/09/27 06:51:10 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Wannabe: Open a window around point.  It's ok to blink backwards!

;;;###autoload
(defun blink (beam)
  "Opens a window w/ BEAM text on it around point.
Ultimately, BEAM can be anything that `read' takes.  (Currently, some options
unimplemented.)"
  (interactive)
  (save-excursion
    (save-window-excursion
      (delete-other-windows)
      (setq blink-beam			; ("rest of programming", yeah right!)
	    (cons beam (type-of beam)))
      (setq blink-point
	    (point))
      (setq blink-window
	    (blink-open-window (blink-start) (blink-end)))
      (blink-fill blink-window blink-beam)
      (unless (sit-for 2)
	(delete-window blink-window))
      )))

(defvar blink-beam nil)
(defvar blink-point nil)
(defvar blink-window nil)

(defun blink-open-window (start end)
  "Open a window spanning START and END points, inclusive."
  (let (split-window-keep-point)	; less motion is good
    (do-twice
     (split-window-vertically))
    (let ((config (blink-window-config)))
      (blink-find-first-window)
      (while (> (nth 1 (blink-window-config)) blink-point)
	(sit-for 0)
	(message "top smaller!")
	(enlarge-window -1)
	(forward-line -1))
      (while (< (nth 1 (blink-window-config)) blink-point)
	(sit-for 0)
	(message "top larger!")
	(enlarge-window 1)))
    (blink-find-first-window)))

(defun blink-window-config ()
  (save-excursion
    (save-window-excursion
      (blink-find-first-window)
      (let* ((s0 (window-start))
	     (e0 (window-end))
	     (s1 (progn (other-window 1) (window-start)))
	     (e1 (window-end))
	     (s2 (progn (other-window 1) (window-start)))
	     (e2 (window-end)))
	(list s0 e0 s1 e1 s2 e2)))))

(defun blink-find-first-window ()
  (do-twice
   (if (blink-previous-window-should-be-sooner)
       (other-window -1)
     (other-window 0))))

(defun blink-fill (window beamier)
  (case (cdr beamier)
    (buffer
     (blink-find-first-window)
     (switch-to-buffer-other-window (car beamier)))
    (string

; this can be used if `blink-open-window' does nothing and no windows are
; munged in `blink'.  unfortunately, `momentary-string-display' tries to do a
; `recenter' first instead of doing it around point.  argh!
;
;     (let* ((start (progn (beginning-of-line) (forward-line -1) (point)))
;	    (delim (make-string (1- (window-width)) ?=))
;	    (str (concat delim "\n" (car beamier) "\n" delim "\n")))
;       (momentary-string-display str start)))

     (blink-find-first-window)
     (switch-to-buffer-other-window "*Blink*")
     (delete-region 1 (point-max))
     (insert (car beamier)))
    (t
     (message "no clue!"))))

(defun blink-start ()
  (save-excursion
    (beginning-of-line)
    (forward-line -2)
    (point)))

(defun blink-end ()
  (save-excursion
    (forward-line 5)			; TODO TODO TODO
    (point)))

(defmacro do-twice (&optional body)
  `(progn
     ,body
     ,body))

(defun blink-previous-window-should-be-sooner ()
  "Returns t if previous window should be ordered earlier."
  (and (equal (window-buffer) (window-buffer (previous-window)))
       (> (window-start) (window-start (previous-window)))))

(provide 'blink)

;;; blink.el,v1.11 ends here
