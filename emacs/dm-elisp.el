;;; Copyright (c) 1991 Wayne Mesard.  May be redistributed only under the
;;; terms of the GNU Emacs General Public License.

;;; TP-ELISP  :  Dmacros for Emacs-Lisp mode

;; This file tries to load "dmacro.elc".
;; The "load-path" variable, as set in your Emacs init file, should include
;; a directory containing the file "dmacro.elc".

;;; HISTORY
;;    2.0 wmesard - Oct 23, 1991: Created.

;;; NOTES
;;    This is just the very beginning of a useful set of dmacros for
;;    Emacs Lisp.  If someone makes this real, please send it to me so I
;;    can include it in future releases.  (Of course I'll give you credit).

;;    Users can hit Esc-Tab to complete a symbol name when typing at 
;;    a prompt in the minibuffer.

;;;
;;; REQUIREMENTS
;;;

(require 'dmacro)


;;; 
;;; USER PARAMETERS
;;; 

(setq auto-dmacro-alist (cons '("\\.el$" . masthead) auto-dmacro-alist))


;;; 
;;; EMACS-LISP-MODE DMACROS
;;; 

(add-dmacros 'lisp-mode-abbrev-table '(
 ("car" "(car ~(@))" dmacro-expand "car")
 ("defun" "(defun ~(@) (~(mark))

  )" dmacro-indent "defun")
 ("lcdr" "(while ~(prompt variable nil tp-elisp-read-sexp)
  ~(@)
  (setq ~(prompt) (cdr ~(prompt))))" dmacro-indent "cdr down a list")
 ("let" "(let ((~(@)))
      ~(mark))" dmacro-indent "let clause")
 ("prepend" " (setq ~(prompt variable) (cons ~(@) ~(prompt)))" 
  dmacro-indent "cons an item onto a list")
 ("progn" "    (progn
      ~(@))" dmacro-indent "progn clause")
 ("history"	";;   ~@ ~(user-id) - ~mon ~date, ~year: ~(mark)"
  nil "new entry for the HISTORY section of the masthead")
 ("masthead"
";;; Copyright (c) ~(year) ~(user-name).  May be redistributed only under the
;;; terms of the GNU Emacs General Public License.

;;; ~((file-name) :up)  : ~@

;;; COMMANDS
;;    

;;; PUBLIC VARIABLES
;;    

;;; PUBLIC FUNCTIONS
;;    

;;; HISTORY
~(dmacro history)Created.

" nil "boilerplate info for elisp files.")
))

