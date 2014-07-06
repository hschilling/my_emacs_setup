;;; ttn.el,v 1.19 1998/08/19 22:44:24 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Provide (1) personal setup; (2) a clean way to export it.
;;;
;;; Loading this library runs the normal hook `ttn-load-hook'.

;; Use the force, luke!
(require 'cl)

;; If we are in batch mode, infer ttn-elisp-home to be directory where this
;; file is found.  It is assumed that non-nil `noninteractive' implies proper
;; command-line arguments.
(when noninteractive
  (message
   "Guessing `ttn-elisp-home' to be: %s"
   (let ((file (find ".*ttn\\.el$" command-line-args :test #'string-match)))
     (or file
	 (error (format "Improper command-line args: %s" command-line-args)))
     (let ((dir (file-name-directory file)))
       (setq ttn-elisp-home (or (and (or (null dir)
					 (string= dir ""))
				     default-directory)
				dir))))))

;; Preliminary checks.
(when (or (not (boundp 'ttn-elisp-home))
	  (null ttn-elisp-home))
  (error "Need to define `ttn-elisp-home'.  Don't forget final slash."))

;; Now load everything.
;;
;; First, define macros, find subdirs and consult the autoload file.  Macros
;; simplify things and are fundamental!  Each subdir found is also added to
;; `load-path'.
;;
;; If this is a batch session, do not load anything else.
;;
;; For an interactive session, load vars, hooks, keys and do-it-now.

(load (format "%sttn-macros" ttn-elisp-home))
(load (format "%sttn-subdirs" ttn-elisp-home))
(load (format "%slisp/loaddefs" ttn-elisp-home))

(setq
 *ttn-load-status*
 (if noninteractive
     nil
   (mapcar
    (progsa (file-symbol)
      (let ((file (format "lisp/%s" (symbol-name file-symbol))))
	(condition-case err
	    (and (load file) file-symbol)
	  (error (cons file err)))))
    '(vars				; variables
      hooks				; mode hooks
      keys				; key bindings
      do-it-now				; dynamic initialization
      ))))

;; Lastly, do anything else requested.
(run-hooks 'ttn-load-hook)

(provide 'ttn)

;;; ttn.el,v1.19 ends here
