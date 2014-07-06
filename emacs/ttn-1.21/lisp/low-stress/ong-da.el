;;; ong-da.el,v 1.10 1998/09/27 06:59:24 ttn Exp
;;; /home/ttn/build/ttn/ttn-1.21/lisp/low-stress/RCS/ong-da.el,v
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; -Dai la` ^ong da`.  :-D>

;; Ong da (chua) biet nhieu chu?.

(defalias 'dai-la 'defalias)
(dai-la 'require 'cong)

(cong 'ttn-macros)

;; Ong da biet ong gia.

(defun ong-da-biet-ong-da ()
  "Co' the^~ ong da nhi`nh du?o?.c biet ong gia.  Co' the^~ kho^ng!"
  ;; Ong da biet doc.
  (let ((chu (concat
	      "ong-da:"))
	retval)
    (save-excursion
      (save-match-data
	(goto-char 1)			; point-min kho^ng -dung
	(if (re-search-forward chu (point-max) t)
	    (setq retval t))))
    retval))

;;; To^ ^ong da`.  :-D>

(defvar to-ong-da
  '(<author>    author
    <date>      date
    <header>    header
    <id>        id
    <locker>    locker
    <log>       log
    <name>      name
    <rcsfile>   rcsfile
    <revision>  revision
    <source>    source
    )
  "To^ o^ng da` co? nhie^u` <patterns>.")

;;;

(defun ong-da-cho-to ()
  ""
  (interactive)
  (unless buffer-read-only
    (mapcar
     (progsa (x)
	     (insert (case (intern (substring (symbol-name major-mode) 0 -5))
		       ((lisp emacs-lisp lisp-interaction)
			(make-string 3 (string-to-char comment-start)))
		       (t
			(strip comment-start)))
		     " $"
		     (capitalize (symbol-name x))
		     "$\n"))
     (ong-da-cho-to-tien-tien))))

;;;

;;

(defun ong-da-cho-to-tien-tien ()	; :-D>
  ""
  (interactive)
  (do* ((<acc> nil (push (nth 1 <tail>) <acc>))
	(<tail> to-ong-da (nthcdr 2 <tail>)))
      ((null <tail>) (nreverse <acc>))))

(provide 'ong-da)

;;; ttn
;;; 1998/09/27 06:59:24
;;; /home/ttn/build/ttn/ttn-1.21/lisp/low-stress/RCS/ong-da.el,v 1.10 1998/09/27 06:59:24 ttn Exp
;;; ong-da.el,v 1.10 1998/09/27 06:59:24 ttn Exp
;;; 
;;; 
;;; ong-da.el,v
;;; 1.10
;;; /home/ttn/build/ttn/ttn-1.21/lisp/low-stress/RCS/ong-da.el,v
;;; gun -dai
