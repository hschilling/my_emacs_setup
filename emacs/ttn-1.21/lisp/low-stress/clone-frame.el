;;; ID: clone-frame.el,v 1.5 1998/09/27 06:52:45 ttn Exp
;;;
;;; Copyright (C) 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Commands to clone the current frame.

;;;###autoload
(defun clone-frame ()
  (interactive)
  (let ((cur-params (frame-parameters)))
    (new-frame (mapcar #'(lambda (x) (assoc x cur-params))
		       '(font height width)))))

;;;###autoload
(defun clone-frame-just-text ()
  (interactive)
  (let ((cur-params (frame-parameters)))
    (new-frame (append (mapcar #'(lambda (x) (assoc x cur-params))
			       '(font height width left top))
		       '((minibuffer . nil)
			 (modeline   . nil) ; apparently doesn't work
			 )))))

(provide 'clone-frame)

;;; clone-frame.el,v1.5 ends here
