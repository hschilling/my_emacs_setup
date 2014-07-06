;;; ID: go.el,v 1.8 1998/09/27 06:46:40 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Central command console procedures.  :->

;;;---------------------------------------------------------------------------
;;; The variable `go-file'.

(defvar go-file "go"
  "File that understands the go convention.
The go convention is in philosophy an extension of `comint-mode'.
The command file `go-file' has features which can be toggled.  The first
feature is called the \"load\" feature.

The following commands are available: `go', glt', `glf'.")

;;;---------------------------------------------------------------------------
;;; Other vars.

(setq -go-target-buffer nil)
(make-variable-buffer-local '-go-target-buffer)

;;;---------------------------------------------------------------------------
;;; Library procedures.
;;; These all have names beginning w/ "-".

(defun -go-target-buffer ()
  (or -go-target-buffer
      (setq -go-target-buffer (read-buffer "Go target buffer: "))))

(defun -go-mode-specific (item)
  (nth
   (idx-of major-mode '(scheme-mode))
   (nth
    (idx-of item '(tstr fstr enable-re go-cmd comment peek))
    '(("#t")				; Major mode goes horizontal here.
      ("#f")
      ("and \\(#.\\)")
      ("(load %S)")
      (";;;")
      ("(peek 'go-doing %S)\n")
      ;; Features go vertical here.
      ))))

(defmacro -go-w/-go-file (&rest body)
  `(if (not (file-exists-p go-file))
       (error "Sorry, no go-file `%s%s'." default-directory go-file)
     (save-window-excursion
       (save-excursion
	 (let ((buf (find-file go-file)))
	   (progn
	     ,@body)
	   (bury-buffer buf))))))

(defun -go-load (value)
  (-go-w/-go-file
   (goto-char 1)
   (re-search-forward (-go-mode-specific 'enable-re))
   (delete-region (match-beginning 1) (match-end 1))
   (insert (-go-mode-specific (if value 'tstr 'fstr)))
   (save-buffer)))

;;;---------------------------------------------------------------------------
;;; Commands.

;;;###autoload
(defun go (&optional background)
  "Go.  With prefix arg, do in the background; don't pop to command buffer."
  (interactive "P")
  (message "hi!")
  (let ((tb (-go-target-buffer)))
    (-go-w/-go-file
     (let ((cmd (format (-go-mode-specific 'go-cmd) go-file)))
       (comint-send-string tb (format (-go-mode-specific 'peek) cmd))
       (comint-send-string tb cmd)
       (comint-send-string tb "\n")))
    (unless
      (pop-to-buffer tb))))

;;;###autoload
(defun glt ()
  "Set \"load\" bit in `go-file' to true.  See var `go-file'."
  (interactive)
  (-go-load t))

;;;###autoload
(defun glf ()
  "Set \"load\" bit in `go-file' to false.  See var `go-file'."
  (interactive)
  (-go-load nil))

(provide 'go)

;;;---------------------------------------------------------------------------
;;; go.el,v1.8 ends here
