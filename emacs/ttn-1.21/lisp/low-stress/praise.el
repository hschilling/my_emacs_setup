;;; ID: praise.el,v 1.7 1998/08/19 22:54:46 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Drop-in replacement for praise.el at large.

;;;###autoload
(defun praise-emacs (&optional repeat-count)
  "Says something in the modeline."
  (interactive "p")
  (let ((rc repeat-count))
    (while (> rc 0)
      (let ((w (- (window-width) 5)))
	(while (< (abs w) (1+ (window-width)))
	  (message "%s" (concat (make-string (abs w) 32) "/^O^\\"))
	  (sit-for 0.01)
	  (setq w (1- w))))
      (setq rc (1- rc)))))

(provide 'praise)

;;; praise.el,v1.7 ends here
