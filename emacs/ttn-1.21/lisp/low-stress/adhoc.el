;;; ID: adhoc.el,v 1.6 1998/09/27 06:41:14 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Functions useful for .adhoc scripts.

;;; Commentary:

;; Accompanied demo-ing: Hands on/off computer!
;; Apathetic documentation hack: Online chagrin!

;;; Code:

;;;---------------------------------------------------------------------------
;;; Variables

(defvar adhoc-output-buffer "*Apathetic documentation hack: Online chagrin!*"
  "*Buffer where `adhoc-output' does things.")

(defvar adhoc-orig-buffer nil
  "Buffer where `adhoc-output' is called.  Returned by `adhoc-orig-buffer'.")

(defvar adhoc-temp-buffers '()
  "List of buffers killed by `adhoc-clean-up'.")

;;;---------------------------------------------------------------------------
;;; Support functions

(defun adhoc-find-adhoc-output-window ()
  (while (not (string= (buffer-name (current-buffer))
		       adhoc-output-buffer))
    (other-window 1))
  (selected-window))

(defmacro adhoc-output (&rest body)
  "Do BODY in `adhoc-output-buffer', then maybe shrink window.
This doesn't seem to work with more than one initial window. :-/"
  `(let ((adhoc-orig-buffer (current-buffer)))
     (save-selected-window
       (with-output-to-temp-buffer adhoc-output-buffer ,@body)
       (adhoc-find-adhoc-output-window)
       (shrink-window-if-larger-than-buffer))))

(defun adhoc-wait (time)
  (sit-for time)
  (delete-window (adhoc-find-adhoc-output-window)))

(defun adhoc-orig-buffer ()
  adhoc-orig-buffer)

;;;---------------------------------------------------------------------------
;;; Entry points

;;;###autoload
(defun adhoc-display (string &optional speedup)
  "Displays output STRING using `adhoc-output', then wait.
Optional arg SPEEDUP is a numeric factor used to scale the wait time.
The waiting time is calculated from the length of STRING."
  (adhoc-output (princ string))
  (adhoc-wait (+ 4 (/ (* (or speedup 1) 4.0 (length string)) 80))))

;;;###autoload
(defun adhoc-find-file (file)
  "Find FILE and add it to `adhoc-temp-buffers'."
  (setq adhoc-temp-buffers (cons (find-file file) adhoc-temp-buffers)))

;;;###autoload
(defun adhoc-search-forward (string &optional line no-bol no-recenter)
  "Search forward for STRING, move to bol, and recenter at line 1.
If optional second arg LINE is a number, recenter there instead.
If optional third arg NO-BOL is non-nil, don't move to beginning of line.
If optional fourth arg NO-RECENTER is non-nil, don't recenter."
  (search-forward string nil t)
  (or no-bol (beginning-of-line))
  (or no-recenter (recenter (or line 1))))

;;;###autoload
(defun adhoc-clean-up ()
  "Kill the `adhoc-output-buffer' as well as all `adhoc-temp-buffers'.
Also, delete that window and then reset `adhoc-temp-buffers'."
  (adhoc-output nil)
  (delete-window (adhoc-find-adhoc-output-window))
  (kill-buffer adhoc-output-buffer)
  (mapcar #'kill-buffer adhoc-temp-buffers)
  (setq adhoc-temp-buffers '()))

;;;---------------------------------------------------------------------------
;;; Load-time actions

;;;###autoload
(or (assoc "\\.adhoc\\'" auto-mode-alist)
    (setq auto-mode-alist (cons '("\\.adhoc\\'" . emacs-lisp-mode)
				auto-mode-alist)))

;;;---------------------------------------------------------------------------
;;; That's it!

(provide 'adhoc)

;;; adhoc.el,v1.6 ends here
