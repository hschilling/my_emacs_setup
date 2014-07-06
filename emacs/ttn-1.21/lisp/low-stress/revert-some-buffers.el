;;; ID: revert-some-buffers.el,v 1.9 1998/09/27 07:00:52 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: For each file-related buffer, do `revert-buffer'.

(require 'ttn-macros)

;;;###autoload
(defun revert-some-buffers ()
  "Revert each file-related buffer."
  (interactive)
  (save-some-buffers)
  (save-excursion
    (mapc
     (progsa (buf)
       (when (buffer-file-name buf)
	 (set-buffer buf)
	 (revert-buffer nil t t)))
     (buffer-list))))

(provide 'revert-some-buffers)

;;; revert-some-buffers.el,v1.9 ends here
