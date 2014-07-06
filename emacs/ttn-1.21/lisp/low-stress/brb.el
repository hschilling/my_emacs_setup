;;; ID: brb.el,v 1.8 1998/09/27 06:51:41 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: "Be right back" to terminal.  Uses alternative notification.

;;;###autoload
(defun brb ()
  "Don't use my cnxn, man!"
  (interactive)
  (let ((cts (current-time-string)))
    (save-window-excursion
      (delete-other-windows)
      (enlarge-window (- (/ (frame-height) 2)))
      (yo! (concat "left at " cts " -ttn") 'bounce))))

(provide 'brb)

;;; brb.el,v1.8 ends here
