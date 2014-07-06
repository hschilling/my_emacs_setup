;;; ID: gud-cont-display.el,v 1.7 1998/09/27 06:56:17 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Experimental -- more of an amusement than anything useful.

;;;###autoload
(defun gud-cont-redisplay (interval)
  "Invoke `gud-cont' then sit for INTERVAL seconds.  Loop until user input."
  (interactive "nSeconds: ")
  (while
      (progn
	(gud-cont 1)
	(when (> (point-max) 50000)
	  (delete-region (point-min) 50000))
	(sit-for interval))))

(provide 'gud-cont-redisplay)

;;; gud-cont-display.el,v1.7 ends here
