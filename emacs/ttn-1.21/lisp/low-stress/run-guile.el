;;; ID: run-guile.el,v 1.11 1998/09/27 07:01:13 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Provide `run-guile', `run-guile-tcltk' and `run-guile-gtk'.

;;;###autoload
(defun run-like-scheme (program)
  "Run an inferior interpreter PROGRAM using `run-scheme'.
The variable `scheme-buffer' is set to the new buffer."
  (interactive "sProgram: ")
  (let ((scheme-program-name program))
    (run-scheme scheme-program-name)
    (setq scheme-buffer (rename-buffer (format "*%s*" scheme-program-name)))))

;;;###autoload
(defun run-guile ()
  "Run an inferior guile process using `run-scheme'."
  (interactive)
  (run-like-scheme "guile"))

;;;###autoload
(defun run-guile-tcltk ()
  "Run an inferior guile-tcltk process using `run-scheme'."
  (interactive)
  (run-like-scheme "guile-tcltk"))

;;;###autoload
(defun run-guile-gtk ()
  "Run an inferior guile-gtk process using `run-scheme'."
  (interactive)
  (run-like-scheme "guile-gtk"))

(provide 'run-guile)

;;; run-guile.el,v1.11 ends here
