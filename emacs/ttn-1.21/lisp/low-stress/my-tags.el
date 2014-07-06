;;; ID: my-tags.el,v 1.6 1998/09/27 06:58:18 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Set up the prefered environment for etags.
;;; I prefer awareness of different "domains", including read-only.

;;; [hey look into ../import/sure-tags.el!]

;; What is a domain?  Fundamentally, it is one side of a mapping.
;; Comprehensively, application specifics include:
;;
;; - Multiple representations -- see `mytags-xlat-to-domain' and
;;   `mytags-mappers'.
;; - whatever else i think of later!
;;
;; [blah blah blah]

(make-variable-buffer-local 'tags-file-name)

(defun mytags-make-domain (type &rest detail)
  "Create a domain of internal TYPE with any amount of DETAIL.
TYPE is either `mode' or `dir'.  DETAIL can be omitted."
  (list
   type
   (case type
     ((mode) '(mytags-map-mode))
     (t      '()))
   detail))

(defun mytags-xlat-to-domain (x)
  "Translate X into a domain for mytags.
If X is a symbol, consider it a major mode."
  (cond ((symbolp x)
	 (mytags-make-domain 'mode x))
	(t
	 nil)))

(provide 'my-tags)

;;; my-tags.el,v1.6 ends here
