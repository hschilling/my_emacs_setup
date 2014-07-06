;;; ID: phone.el,v 1.10 1998/09/27 07:07:48 ttn Exp
;;;
;;; Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Issue shell command "phone NAME-REGEXP".

(require 'saved-shell-command)

;;;###autoload
(defun phone (name-re)
  "Looks up name based on NAME-REGEXP in phone database."
  (interactive "sName regexp: ")
  (saved-shell-command (concat "phone " name-re)))

;; Currently, not useful (since "phone -a" doesn't work).

;(defun phone-add (name info)
;  "add NAME and INFO to the phone database"
;  (interactive "sName: \nsInfo: ")
;  (saved-shell-command (concat "phone -a '" name "\t" info "'")))

(provide 'phone)

;;; phone.el,v1.10 ends here
