;;; ID: surround-w-if-block.el,v 1.9 1998/09/27 07:02:45 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Surround region w/ C preprocessor block w/ luser-chosen tag.

;;;###autoload
(defun surround-w-if-block (begin end condition &optional arg)
  "Surrounds region w/ conditional.  Use prefix arg to specify \"0\",
otherwise the inputted conditional string is automagically upcased and
whitespace replaced w/ underscore.  [Currently, prefix does not work!]"
  (interactive "r\nsCondition: \np")
  (if (= 1 arg)
      (let ((s "")
	    (b 0))
	(while (string-match "\\S-+" condition b)
	  (setq s (concat s (substring condition (match-beginning 0)
				       (setq b (match-end 0)))
			  "_")))
	(setq condition (upcase (substring s 0 -1)))))
  (save-excursion
    (goto-char end)
    (if (not (bolp)) (progn (end-of-line) (forward-char 1)))
    (insert "#endif /* " condition " */\n")
    (goto-char begin)
    (if (not (bolp)) (beginning-of-line))
    (insert "#if " condition "\n")))

(provide 'surround-w-if-block)

;;; surround-w-if-block.el,v1.9 ends here
