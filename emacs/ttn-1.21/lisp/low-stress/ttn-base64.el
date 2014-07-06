;;; ID: ttn-base64.el,v 1.10 1998/09/27 06:12:40 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Funcs to handle text representing base64 MIME encoding.

;; Return base64 encoding map, implemented as a 65-element vector.
(defun ttn-base64-enc-map ()
  (let ((map (make-vector 65 nil)))
    (aset map 62 ?+)
    (aset map 63 ?/)
    (aset map 64 ?=)
    (do ((i 0 (1+ i)))
	((= i 26) map)
      (when (< i 10)
	(aset map (+ 52 i) (+ ?0 i)))
      (aset map (+ 0 i) (+ ?A i))
      (aset map (+ 26 i) (+ ?a i)))))

;; Returnsbase64 decoding map, implemented as a 256-element vector.
(defun ttn-base64-dec-map ()
  (let ((enc-map (ttn-base64-enc-map))
	(map (make-vector 256 nil)))
    (do ((i 0 (1+ i)))
	((= i 65) map)
      (aset map (aref enc-map i) i))))

;;; test
;(let ((enc-map (ttn-base64-enc-map))
;      (dec-map (ttn-base64-dec-map)))
;  (describe-this enc-map dec-map)
;  (do ((i 0 (1+ i)))
;      ((= i 65) t)
;    (if (/= i (aref dec-map (aref enc-map i)))
;	(error (format "%d fubar: enc[]=%c dec[enc[]]=%c"
;		       i
;		       (aref enc-map i)
;		       (aref dec-map (aref enc-map i)))))))

(defun ttn-base64-decode-region (beg end &optional out)
  "Decode base64 region.  Output dependent on optional arg OUT.
If OUT is a buffer, replace contents in that buffer with output.
If OUT is a string, interpret it as a filename and write output there.
If OUT is t, replace region with output.
If OUT is none of the above, return the output as a string, otherwise
return nil."
  (goto-char beg)
  (let ((beg beg)
	(curbuf (current-buffer))
	(dec-map (ttn-base64-dec-map))
	(four "====")
	a b c d x y z)
    (with-output-to-temp-buffer "*ttn-base64-scratch*"
      (catch 'done
	(while (<= beg end)
	  (do ((i 0 (1+ i)))
	      ((= i 4) four)
	    (while (null (aref dec-map (char-after beg)))
	      (setq beg (1+ beg))
	      (when (null (char-after beg))
		(throw 'done nil)))		; yuk
	    (aset four i (char-after beg))
	    (setq beg (1+ beg))
	    (when (null (char-after beg))
		(throw 'done nil)))		; yuk yuk!
	  (setq a (aref dec-map (aref four 0))
		b (aref dec-map (aref four 1))
		c (aref dec-map (aref four 2))
		d (aref dec-map (aref four 3))
		x (logior (lsh a 2) (lsh b -4))
		y (logior (lsh (logand b 15) 4) (lsh c -2))
		z (logior (lsh (logand c 3) 6) d))
	  (mapc #'write-char (list x y z))
	  )))
    (ttn-base64-output "*ttn-base64-scratch*"
		   (if (eq t out)
		       (list curbuf beg end)
		     out))
    ))

(defun ttn-base64-output (output where)
  "Do various things w/ contents of OUTPUT buffer, depending on WHERE.
If WHERE is a buffer, replace contents in that buffer with output.
If WHERE is a string, interpret it as a filename and write output there.
If WHERE is a list in the form of (BUF BEG END), replace region in BUF
with output.
If WHERE is none of the above, return the output as a string, otherwise
return nil."
  (cond ((bufferp where)
	 (set-buffer where)
	 (delete-region (point-min) (point-max))
	 (set-buffer output)
	 (append-to-buffer where (point-min) (point-max))
	 nil)
	((stringp where)
	 (set-buffer output)
	 (write-file where t)
	 nil)
	((and (listp where)
	      (= (length where) 3)
	      (bufferp (car where)))
	 (set-buffer (car where))
	 (apply #'delete-region (cdr where))
	 (goto-char (second where))
	 (set-buffer output)
	 (append-to-buffer (car where) (point-min) (point-max))
	 nil)
	(t
	 (set-buffer output)
	 (buffer-string))))

;;;###autoload
(defun ttn-base64-decode-to-file (beg end file)
  "Do base64 decode on region to FILE."
  (interactive "r\nFWrite output to file: ")
  (ttn-base64-decode-region beg end file))

(provide 'ttn-base64)

;;; ttn-base64.el,v1.10 ends here
