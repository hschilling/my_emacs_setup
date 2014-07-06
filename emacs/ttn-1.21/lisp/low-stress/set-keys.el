;;; ID: set-keys.el,v 1.9 1998/09/27 07:01:41 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Bind many keys in a keymap, not just one.
;;; This is an application of `map-table' and ilk.

;;;###autoload
(defun local-set-keys (table)
  "Like local-set-keys.  TABLE has form (key1 binding1 key2 binding2 ...)."
  (map-table-2col 'local-set-key table))

;;;###autoload
(defun global-set-keys (table)
  "Like global-set-keys.  TABLE has form (key1 binding1 key2 binding2 ...)."
  (map-table-2col 'global-set-keys table))

;;;###autoload
(defun define-keys (keymap table)
  "Modify KEYMAP from TABLE, of form (key1 binding1 key2 binding2 ...)."
  (let ((cur (current-local-map)))
    (use-local-map keymap)
    (local-set-keys table)
    (use-local-map cur)))

(provide 'set-keys)

;;; set-keys.el,v1.9 ends here
