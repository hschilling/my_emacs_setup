;;; This comes for free no need to redefine this here.
;; (define-key esc-map "z" 'zap-to-char)
(define-key esc-map "Z" 'zap-to-regexp) ; originally 'zap-to-char

;;;
;; zap-to-regexp
;;
;; Tue May 7, 1996 - feren@ctron.com (Andrew C. Feren)
;; The basic code for this was borrowed from zap-to-char in simple.el
;;
(defun zap-to-regexp (arg regexp)
  "Kill up to and including ARG'th occurrence of REGEXP.
Goes backward if ARG is negative; error if REGEXP not found."
  (interactive "p\nsZap to regexp: ")
  (kill-region (point) (progn
			 (search-forward-regexp regexp nil nil arg)
			 ;; This line makes zap-to-regexp behave like
			 ;; d/ and d? in vi (ie with forward deletion
			 ;; the regexp is left intact).  Is this
			 ;; really the right thing?  zap-to-char
			 ;; dropped this behavior.  Was there a good
			 ;; reason?  I like this behavior since I use
			 ;; vi frequently enough to get some benefit
			 ;; from the orthogonality.
			 (if (>= arg 0) (search-backward-regexp regexp 1))
			 ;; p.s.  Yes I know the '=' doesn't really do
			 ;; much.
			 (point)))
  )
