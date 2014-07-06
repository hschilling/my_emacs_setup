;;; ID: browse-console-fonts.el,v 1.5 1998/09/27 06:51:55 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Browse console fonts.

(require 'ttn-macros)

;;;autoload
(defun browse-console-fonts (&optional arg)
  "Consider dired to be a font list and do setfont(1) on a file."
  (interactive "P")
  (if arg
      (shell-command (format "setfont %s" (dired-get-filename)))
    (dired "/usr/lib/kbd/consolefonts")
    (use-local-map (copy-keymap (current-local-map)))
    (local-set-key "\C-m" (progc (browse-console-fonts t)))))

(provide 'browse-console-fonts)

;;; browse-console-fonts.el,v1.5 ends here
