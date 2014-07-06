;;; ID: previous-buffer.el,v 1.8 1998/09/27 07:00:10 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Switch to previous buffer in buffer list.

;; previous-buffer
;;;###autoload
(defun previous-buffer () "switches to previous buffer"
  (interactive)
  (while (progn
	   (switch-to-buffer (car (last (buffer-list))))
	   (string= " " (substring (buffer-name) 0 1)))))


(provide 'previous-buffer)

;;; previous-buffer.el,v1.8 ends here
