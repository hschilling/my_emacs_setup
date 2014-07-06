;;; ID: print-previous-revision.el,v 1.9 1998/09/27 07:00:28 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Print previous revision of a version-controlled file.
;;; Handles RCS and CVS currently.  This should probably be folded into vc.el.

;;;###autoload
(defun print-previous-revision (file rev)
  "Print previous revision."
  (interactive "fFile: \nsRevision (symbolic ok): ")
  (let* ((fnm (file-name-nondirectory file))
	 (buf (get-buffer-create (format "*%s:%s*" fnm rev)))
	 (cmd (list "-kv" "-p" (format "-r%s" rev) fnm)))
    (set-buffer buf)
    (delete-region (point-min) (point-max))
    (if (file-exists-p (concat (or (file-name-directory file) "./") "CVS"))
	(apply #'call-process "cvs" nil buf nil "update" cmd)
      (apply #'call-process "co" nil buf nil cmd))
    (switch-to-buffer buf)
    (goto-char (point-min))))

(provide 'print-previous-revision)

;;; print-previous-revision.el,v1.9 ends here
