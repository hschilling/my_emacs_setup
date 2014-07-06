;;; turn-on-mouse-avoidance-mode.el,v 1.8 1998/09/27 07:03:45 ttn Exp
;;;
;;; Copyright (C) 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Turns on `mouse-avoidance-mode' amusement.

;;;###autoload
(defun turn-on-mouse-avoidance-mode ()
  "As advertized."
  (interactive)
  (require 'avoid)
  (let ((found (assoc 'mouse-avoidance-mode minor-mode-alist)))
    (if found
	(setcdr found (list ""))))
  (mouse-avoidance-mode 'animate))

(provide 'turn-on-mouse-avoidance-mode)

;;; turn-on-mouse-avoidance-mode.el,v1.8 ends here
