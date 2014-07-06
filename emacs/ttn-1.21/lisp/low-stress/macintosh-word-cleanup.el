;;; ID: macintosh-word-cleanup.el,v 1.14 1998/09/27 06:57:33 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Replace Macintosh "Word" document crap w/ text.

(require 'ttn-macros)

;;;###autoload
(defun macintosh-word-cleanup ()
  "Replace Macintosh \"Word\" document crap w/ text."
  (interactive)
  (map-table-2col
   (progsa (from to)
     (message "looking at `%s' -> `%s'" from to)
     (goto-char 1)
     (while (search-forward from nil t)
       (replace-match to)))
   '("Ñ"  ""				; 8-pt italic
     "\C-m"  "\C-j"			; newline
     "’"  "i"			; i aigue
     "”"  "i"			; i ???
     "Ž"  "e"			; e aigue
     "Ð"  "-"			; n-dash
     "¦"  ""				; ???
     "—"  "a"			; a aigue
     "Ô"  "`"			; begin single quote
     "Õ"  "'"			; end single quote
     "©"  "(C)"			; copyright
     "Ã"  "?"			; question mark
     "Ò"  "<it>"			; italic on
     "Ó"  "</it>"			; italic off
     "\C-o"  "--"			; m-dash
     "ÿ"  "\C-j"			; newline + center
     "‰"  "e"			; e grave
     "¨"  ""				; 8-pt italic
     "‚"  "e"			; e aigue
     "Œ"  "i"			; i aigue
     ;; Add translations here.
     )))

(provide 'macintosh-word-cleanup)

;;; macintosh-word-cleanup.el,v1.14 ends here
