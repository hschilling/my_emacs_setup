;;; ID: insert-separator.el,v 1.15 1998/09/27 07:07:30 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Insert code separator comment in mode-specific ways.  Fancy.

(require 'cl)
(require 'yo)

;;;###autoload
(defun insert-separator ()
  "Inserts line of dashes ending using a mode-specific comment prefix.
Because we have MIPS to spare these days (hee hee), why not animate it?"
  (interactive)

  (let* ((str (case major-mode
		((scheme-mode
		  lisp-mode
		  emacs-lisp-mode
		  inferior-lisp-mode
		  lisp-interaction-mode)	";;;")
		((c-mode
		  c++-mode)			"//")
		((texinfo-mode)			"@c ")
		(t				"")))
	 (len (length str))

	 ;; To make things interesting, choose a different way each time.
	 ;; Register them here.

	 (ways '[starfield
		 grow-from-left
		 instantly])

	 (way (aref ways (random (length ways))))

	 )

    ;; OK, now do it.  Take care of positioning first.

    (if (bolp)
	nil
      (forward-line 1)
      (beginning-of-line))

    ;; Based on the chosen way, put the thing in motion.

    (case way

     ('starfield			; starfield
      (do ((j 0 (1+ j)))
	  ((= j 10))
	(let ((printme (starfield-string 78)))
	  (insert printme)
	  (sit-for 0.05)
	  (delete-char (- (length printme)))))
      (insert (substring (concat str (make-string 78 ?-)) 0 78) "\n"))

     ('grow-from-left			; grow-from-left
      (while (< len 78)
	(setq str (concat str "-")
	      len (1+ len))
	(insert str)
	(sit-for 0.01)
	(delete-char (- len)))
      (insert str "\n"))

     ('instantly
       (insert str (make-string (- 78 (length str)) ?-) "\n"))

     ;; Add new methods here.

     )))

(provide 'insert-separator)

;;; insert-separator.el,v1.15 ends here
