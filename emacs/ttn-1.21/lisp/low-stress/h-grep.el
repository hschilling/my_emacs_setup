;;; ID: h-grep.el,v 1.2 1997/11/13 11:53:36 ttn Exp

;; This doesn't work due to the newline.
;!done	(defun h-grep (wildcard)
;!done	  "Grep for headers in files denoted by WILDCARD."
;!done	  (interactive "sFiles: ")
;!done	  (let ((re
;!done		;(concat comment-start "+-+")
;!done		 (concat comment-start "+-+\n" comment-start "+ .*")
;!done		 ))
;!done	    (grep (concat "egrep -n '" re "' " wildcard))))

;;; h-grep.el,v1.2 ends here
