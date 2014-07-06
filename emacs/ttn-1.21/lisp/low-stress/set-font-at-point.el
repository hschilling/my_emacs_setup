;;; ID: set-font-at-point.el,v 1.14 1998/09/27 07:01:32 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Set font at cursor position, useful w/ xlsfonts(1) output.
;;; If cursor doesn't seem to be on a font, do "xlsfonts".
;;;
;;; TODO: Ensure setting of `bold'.

;;;###autoload
(defun xlsfonts ()
  "Displays xlsfonts(1) output in a buffer.  RET or SPC sets default font."
  (interactive)
  (let ((buf (switch-to-buffer (get-buffer-create "*set-font-at-point*"))))
    (when (= 1 (point-max))
      (call-process "xlsfonts" nil t nil))
    (goto-char 1)			; todo: heuristic
    (setq major-mode 'choose)		; todo: go electric
    (setq mode-name "choose")
    (use-local-map (let ((map (make-sparse-keymap)))
		     (define-keys map
		       '("\C-m" set-font-at-point
			 " "    set-font-at-point))
		     map))))

;; FSF Emacs compatibility for XEmacs.  todo: Is there a unified model?
;;
(if (emacs-type-eq 'lucid)
    (defun set-default-font (font)
      "FSF Emacs compatibility."
      (if (font-specifier-p font)
	  (set-face-font 'default font)
	(xlsfonts))))

;;;###autoload
(defun set-font-at-point (p)
  "Set default font based on point.  Manually re-enters with list if error."
  (interactive "p")
  (let* ((e (progn (end-of-line) (point)))
	 (b (progn (beginning-of-line) (point)))
	 (font (strip (buffer-substring b e))))
    (condition-case nil			; todo: make into advice
	(set-default-font font)
      (error (xlsfonts)))
    (forward-line 1)))

(provide 'set-font-at-point)

;;; set-font-at-point.el,v1.14 ends here
