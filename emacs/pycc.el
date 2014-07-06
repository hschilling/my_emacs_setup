;;; pycc.el --- "Python Code Creator" for generating code stubs.

;; Copyright (C) 1996,1997 Mitch Chapman

;; Author:        Mitch Chapman
;; Maintainer:    mchapman@dnaco.net
;; Created:       1996/08/01
;; Version:       1.6
;; Last Modified: 97/08/21 10:17:30
;; Keywords: python languages oop code-generation

;; This software is provided as-is, without express or implied
;; warranty.  Permission to use, copy, modify, distribute or sell this
;; software, without fee, for any purpose and by any individual or
;; organization, is hereby granted, provided that the above copyright
;; notice and this paragraph appear in all copies.

;;; Commentary:

;; This is a set of functions for generation of Python module templates,
;; comment blocks, function and method stubs, etc.  You can bind these
;; functions to key sequences in python-mode buffers.
;;
;; Several years ago I stumbled across the Objective-C mode for Emacs
;; (ftp://ftp.cis.ohio-state.edu/pub/gnu/emacs/elisp-archive/modes/objective-C-mode.el.Z)
;; and was inspired by its boilerplate code generation.  I've been
;; re-implementing the idea ever since. :)

;; Here's one way to "plug in" these functions, in your .emacs file:
;;        (add-hook 'python-mode-hook
;;                  '(lambda ()
;;                     (require 'pycc)
;;                     (setq py-indent-offset 4)
;;                     ;; Always insert spaces, never tabs.
;;                     (setq indent-tabs-mode nil)
;;        ...
;;                     (setq pycc-copyright-owner "Your Company Here, Inc.")
;;                     (local-set-key "\C-ct" 'pycc-insert-module-template)
;;                     (local-set-key "\C-cf" 'pycc-insert-func-template)
;;                     (local-set-key "\C-cc" 'pycc-insert-class-template)
;;                     (local-set-key "\C-cm" 'pycc-insert-method-template)
;;                     ;; (...callback-template just inserts a Python method
;;                     ;; which has an 'event=None' argument)
;;                     (local-set-key "\C-cb" 'pycc-insert-callback-template)
;;                     (local-set-key "\C-c#" 'pycc-insert-comment-box)
;;                     (local-set-key "\C-ci" 'pycc-insert-curr-classname)))

;; User entry points:
;;   pycc-insert-module-template
;;   pycc-insert-func-template
;;   pycc-insert-class-template
;;   pycc-insert-method-template
;;   pycc-insert-callback-template  (for Tkinter event handlers)
;;   pycc-insert-comment-box
;;   pycc-insert-curr-classname
;;
;; User variables:
;;   pycc-shebang-path
;;   pycc-vc-string
;;   pycc-vc-version-string
;;   pycc-copyright-owner
;;
;; See the docstrings for more information.

;;; Code:


;; Need Python mode because it tells how many spaces per indentation level.
(require 'python-mode)

;; user definable variables
;; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

(defvar pycc-shebang-path "/usr/bin/env python"
  "Where to find the Python executable.
This variable's value is inserted at the top of a Python module,
following a 'shebang' comment.  E.g.:

#!<pycc-shebang-path>
")

;; Note:  Anything which looks like an SCCS data keyword is "escaped",
;;        by breaking it into multiple, concatenated strings.
;;        This is because I maintain this code using SCCS, and don't want
;;        the user's version control strings to be replaced with the
;;        version information for this Lisp code. :)
(defvar pycc-vc-string (concat "%W" "% %G" "%")
  "Version-control string, including version ID, date and time of latest rev.")

(defvar pycc-vc-version-string (concat "%I" "%")
  "Version-control string, showing just the latest rev ID.")

(defvar pycc-copyright-owner ""
  "String naming the owner of copyrighted Python code.")


;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;; NO USER DEFINABLE VARIABLES BEYOND THIS POINT


(defun pycc-insert-comment-line (comment-char &optional fill-col)
  "Insert a 'comment line' at point.
This is just a line of `#' characters, typically."
  (interactive)
  (insert "#")
  (insert-char comment-char (- (or fill-col fill-column) (current-column)))
  (insert "\n"))

(defun pycc-insert-docstring (&optional body)
  "Insert an empty docstring at point.
BODY, if provided, is the pre-indented body of the docstring.
Return the point preceding the line of closing quotes."
  (interactive)
  (let* ((startcol (current-column))
	 (prefix (make-string startcol ? ))
	 (insert-point (point)))
    (insert "\"\"\"\n")
    (cond ((and body (not (string= body "")))
	   (insert body)
	   (setq insert-point (- (point) 1)))
	  (t (insert prefix)
	     (setq insert-point (point))
	     (insert "\n")))
    ;; Match current indentation.
    (insert prefix "\"\"\"\n")
    insert-point))

(defun pycc-curr-year ()
  "Return the current year as a string."
  (interactive)
  (let* ((date-time (current-time-string))
	 (len (length date-time)))
    (substring date-time (- len 4))))

(defun pycc-insert-curr-classname ()
  "Insert the name of the class most nearly preceding point."
  (interactive)
  (let* ((className ""))
    (save-excursion
      (if (re-search-backward "^[ \t]*class[ \t]\\([A-Za-z0-9]*\\)"
			      (point-min) t)
	  (setq className (buffer-substring (match-beginning 1)
					    (match-end 1)))))
    (insert className)))
	

(defun pycc-insert-module-template (&optional default-module-name)
  "Insert a code template for a Python source module."
  (interactive)
  (let* ((indent (make-string py-indent-offset ? )))
    (save-excursion
      (goto-char (point-min))
      (insert "#!" pycc-shebang-path "\n")
      (pycc-insert-docstring
	     (concat "\n"
		     "Copyright " (pycc-curr-year) " " pycc-copyright-owner
		     "\n"
		     pycc-vc-string "\n"
		     (user-full-name) "\n"))
      (insert "\n__version__ = \"" pycc-vc-version-string "\"\n\n\n")
      (pycc-insert-func-template
       "main()"
       (concat indent
	       "Module mainline (for standalone execution)\n"))
      (goto-char (point-max))
      (insert "\n"
	      "if __name__ == \"__main__\":\n"
	      indent
	      "main()\n"))
    ;; Goto the top of the module, and then skip down to the first blank
    ;; line in the module's docstring.
    (goto-char (point-min))
    (forward-line 2)))

(defun pycc-insert-empty-comment ()
  "Insert an empty comment box.
Return the point where the first character of comment text should go."
  (interactive)
  (let* ((start-col (current-column))
	 so-comment)
    (pycc-insert-comment-line ?#)
    (insert-char ?  start-col)
    (insert "# ")
    (setq so-comment (point))
    (insert "\n")
    (insert-char ?  start-col)
    (pycc-insert-comment-line ?#)
    so-comment))

(defun pycc-insert-comment-box ()
  "Insert an empty comment box.
Leave point at the first blank line of the comment box."
  (interactive)
  (goto-char (pycc-insert-empty-comment)))

(defun pycc-insert-class-template (&optional class-name superclass-names)
  "Insert a code template for a Python class."
  (interactive "sClass Name: (T) 
sSuperclasses: ")
  (let* ((start-col (current-column))
	 (indent (make-string (+ start-col py-indent-offset) ? ))
	 so-comment)
    (if (string= class-name "")
	(setq class-name "T"))
    (insert "class " class-name
	    (if (and superclass-names (not (string-equal superclass-names "")))
		(concat "(" superclass-names ")")
	      ""))
    (insert ":\n"
	    indent)
    (setq so-comment (pycc-insert-docstring))
    (insert indent)
    (pycc-insert-init-template)
    (goto-char so-comment)))

(defun pycc-insert-func-template (&optional template comment)
  "Insert a Python function template."
  (interactive "sFunction Template: ")
  (let* ((start-col (current-column))
	 (prefix (make-string (+ start-col py-indent-offset) ? ))
	 (comment-str (or comment ""))
	 so-comment)
    (insert "def " template ":\n")
    (insert prefix)
    (setq comment-str (concat prefix template "\n" comment))
    (setq so-comment (pycc-insert-docstring comment-str))
    ;; Stub out the function with a return statement, because emacs
    ;; python-mode knows to auto-dedent when it sees a return statement.
    (insert prefix "return\n\n")
    (goto-char so-comment)))

(defun pycc-insert-init-template ()
  "Insert a template for an __init__ method."
  (interactive)
  (pycc-insert-method-template
   "__init__(self)"
   (concat (make-string (+ (current-column) py-indent-offset) ? )
	   "Initialize a new instance.\n")))

(defun pycc-insert-method-template (&optional template comment)
  "Insert a Python method template.
Automatically prepends a 'self' argument to the parameter list, if
it is not already present."
  (interactive "sMethod Template: ")
  ;; Split the template into method name and parameter list.
  (let* ((startlist (string-match "(" template))
	 (name template)
	 (args "()"))
    (if startlist
	(progn
	  (setq name (substring template 0 startlist)
		args (substring template startlist))))
	
    (if (not (string-match "( *self[,)]" args))
	(if (string-match "()" args)
	    (setq args "(self)")
	  (setq args (concat "(self, " (substring args 1)))))
    (pycc-insert-func-template (concat name args) comment)))

(defun pycc-insert-callback-template (&optional template comment)
  "Insert a Python callback template.
Automatically builds the callback argument list."
  (interactive "sCallback Name: ")
  (pycc-insert-method-template (concat template "(self, event=None)")
			       comment))


(provide 'pycc)
