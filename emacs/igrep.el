Article 4330 of gnu.emacs.sources:
Path: lerc.nasa.gov!lerc.nasa.gov!purdue!news.bu.edu!news3.near.net!paperboy.wellfleet.com!news-feed-1.peachnet.edu!gatech!swrinde!cs.utexas.edu!math.ohio-state.edu!cis.ohio-state.edu!ihs.com!kevinr
From: kevinr@ihs.com (Kevin Rodgers)
Newsgroups: gnu.emacs.sources
Subject: Re: grep-x.el -- grep-query-replace, find-grep
Date: 9 May 1995 11:39:08 -0400
Organization: IHS Electronic Systems Development
Lines: 664
Sender: daemon@cis.ohio-state.edu
Distribution: gnu
Message-ID: <9505091537.AA15060@airedale.ihsyp>
Reply-To: Kevin Rodgers <kevin.rodgers@ihs.com>

In article <SHOUMAN.95Apr26224953@goofy.cc.utexas.edu> Radey Shouman <shouman@goofy.cc.utexas.edu> wrote:
>find-grep is similar to find-dired: it runs `find' in the default
>directory with supplied arguments, and calls grep on every file found,
>putting the results in a *grep* buffer.

You might also be interested in igrep.el, which provides a similar
command called `igrep-recursively' (and an equivalent option of the same
name).  It's main features are (1) file names are read using completion
and a default pattern based on the extension of the current buffer's
visited file, (2) regular expressions are read with the symbol around
point as the default, (3) special minibuffer history lists remember
previous `grep` regular expressions and file name patterns, (4) various
options control the syntax of the `grep` and `find` shell commands, and
(5) analogous `egrep` and `fgrep` commands are defined.  Plus, it runs
under Emacs 18 or 19.

Here's the current version:

;;;; igrep.el --- An improved interface to `grep'.

;;; Description:
;;; 
;;; Define the \[igrep] command, which is like \[grep] except that it
;;; takes two required arguments (EXPRESSION and FILES) and an optional
;;; argument (OPTIONS) instead of just one argument (COMMAND).  Also
;;; define the analogous \[egrep] and \[fgrep] commands for convenience.
;;; 
;;; Define the \[igrep-recursively] command, which is like \[igrep]
;;; except that it uses `find' to recursively `grep' a directory.  Also
;;; define the analogous \[egrep-recursively] and \[fgrep-recursively]
;;; commands for convenience.
;;; 
;;; \[igrep] and \[igrep-recursively] (and their analogues) provide
;;; defaults for the required arguments when called interactively and
;;; there are global variables that control the syntax of the `grep' and
;;; `find' shell commands that are executed.

;;; Copyright:
;;; 
;;; Copyright (C) 1993,1994 Kevin Rodgers
;;; 
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; at your option) any later version.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;; 
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;; 
;;; Neither my former nor current employer (Martin Marietta and
;;; Information Handling Services, respectively) has disclaimed any
;;; copyright interest in igrep.el.
;;; 
;;; Kevin Rodgers <kevinr@ihs.com>		Project Engineer
;;; Information Handling Services		Electronic Systems Development
;;; 15 Inverness Way East, M/S A203		
;;; Englewood CO 80112 USA			(303)397-2599[voice]/-2620[fax]

;;; Installation:
;;; 
;;; 1. Put this file in a directory that is a member of load-path, and
;;;    byte-compile it (e.g. with `M-x byte-compile-file') for better
;;;    performance.  You can ignore any warnings about the functions
;;;    `emacs-version=', `read-with-history-in' and `read-file-name-
;;;    with-history-in'.
;;; 2. Put these forms in default.el or ~/.emacs:
;;;    (autoload (function igrep) "igrep"
;;;       "*Run `grep' to match EXPRESSION in FILES..." t)
;;;    (autoload (function egrep) "igrep"
;;;       "*Run `egrep'..." t)
;;;    (autoload (function fgrep) "igrep"
;;;       "*Run `fgrep'..." t)
;;;    (autoload (function igrep-recursively) "igrep"
;;;       "*Run `grep' recursively..." t)
;;;    (autoload (function egrep-recursively) "igrep"
;;;       "*Run `egrep' recursively..." t)
;;;    (autoload (function fgrep-recursively) "igrep"
;;;       "*Run `fgrep' recursively..." t)
;;; 3. If you are using Emacs version 18, you may want to install (and
;;;    load) gmhist.el to enable the default-in-history argument editing
;;;    mechanism that's directly supported by version 19.  gmhist is
;;;    available via anonymous ftp from
;;;    	ftp.thp.Uni-Koeln.DE[134.95.64.1]:/pub/gnu/emacs/gmhist.tar.Z
;;;    or as part of  (the extra features of) tree dired, available via
;;;    anonymous ftp from
;;;    	ftp.thp.Uni-Koeln.DE[134.95.64.1]:/pub/gnu/emacs/diredall.tar.Z

;;; Usage:
;;; 
;;; M-x igrep			M-x egrep		M-x fgrep
;;; M-x igrep-recursively	M-x egrep-recursively	M-x fgrep-recursively
;;; (Each of the 6 igrep commands accepts 1, 2, or 3 `C-u' prefix arguments).
;;; C-x ` (M-x next-error)

;;; Customization examples:
;;; 
;;; To ignore case by default:
;;; 	(setq igrep-options
;;; 	      (if (boundp 'igrep-options)
;;; 		  (concat igrep-options " -i")
;;; 		"-ni"))
;;; To search subdirectories by default:
;;; 	(setq igrep-recursively t)
;;; To search compressed files with GNU gzip scripts:
;;; 	(setq igrep-command "zgrep"
;;; 	      ;; `zegrep' & `zfgrep' aren't installed by default (as of gzip
;;; 	      ;; version 1.2.4); see gnu.utils.bug message <9404111844.AA18194@
;;; 	      ;; traffic.den.mmc.com>:
;;; 	      egrep-command "zegrep"
;;; 	      fgrep-command "zfgrep")
;;; To avoid exceeding the shell's limit on command argument length
;;; (this only works when grep'ing files in the current directory):
;;; 	(setq igrep-recursively t
;;; 	      igrep-recursivley-prune-option "\\! -name .")

;;; LCD Archive Entry:
;;; 
;;; igrep|Kevin Rodgers|kevinr@ihs.com|
;;; An improved interface to grep/egrep/fgrep; plus recursive versions.|
;;; 94/09/27|2.15|~/misc/igrep.el.Z|


;;; Package interface:

(provide 'igrep)

(require 'backquote)			; igrep-with-default-in-history and
					; the Emacs 18 support macros.
(require 'compile)			; compile-internal and grep-regexp-alist
					; (Emacs 19), compile1 (Emacs 18)


;;; User options:

(defvar igrep-options "-n"
  "*The options passed by \\[igrep] to `igrep-command', or nil.
It should contain `-n' to generate the output expected by \\[next-error].")

(defvar igrep-recursively nil
  "*If non-nil, \\[igrep] recursively searches files using `find'.
See \\[igrep-recursively.")

(defvar igrep-verbose-prompts t
  "*If t, \\[igrep] prompts for arguments verbosely;
if not t but non-nil, \\[igrep] prompts for arguments semi-verbosely;
if nil, \\[igrep] prompts for arguments tersely.")


;;; User variables:

(defvar igrep-command "grep"
  "The shell command run by \\[igrep] and \\[igrep-recursively].
It must take a `grep' expression argument and one or more file names.")

(defvar egrep-command "egrep"
  "The shell command run by \\[egrep] and \\[egrep-recursively].
It must take an `egrep' expression argument and one or more file names.")

(defvar fgrep-command "fgrep"
  "The shell command run by \\[fgrep] and \\[fgrep-recursively].
It must take an `fgrep' expression argument and one or more file names.")

(defvar igrep-expression-quote-char ?'
  "The character used to delimit the EXPRESSION argument to \\[igrep],
to protect it from shell filename expansion.")

(defvar igrep-recursively-prune-options "-name SCCS -o -name RCS"
  "The `find' clause used to prune directories, or nil;
see \\[igrep-recursively].")

(defvar igrep-recursively-file-options "-type f -o -type l"
  "The `find' clause used to filter files passed to `grep', or nil;
see \\[igrep-recursively].")

(defvar igrep-recursively-use-xargs
  (if (equal (call-process "find" nil nil nil "/dev/null" "-print0") 0)
      'gnu)
  "If `gnu', \\[igrep-recursively] executes
	`find ... -print0 | xargs -0 -e grep ...';
if not `gnu' but non-nil, \\[igrep-recursively] executes
	`find ... -print | xargs -e grep ...';
if nil, \\[igrep-recursively] executes
	`find ... -exec grep ...'.")

(defvar igrep-expression-history '()
  "The minibuffer history list for \\[igrep]'s EXPRESSION argument.")

(defvar igrep-files-history '()
  "The minibuffer history list for \\[igrep]'s FILES argument.")


;;; Emacs 18 support:

(defmacro igrep-emacs-version-18-p ()
  ;; Returns t if Emacs version is 18; nil otherwise.
  (` (if (featurep 'emacs-vers)
	 (or (emacs-type-eq 'epoch)	; Epoch is based on FSF 18 but uses
	     (emacs-version= 18))	; different version numbers.
       ;; See emacs-vers.el, by Eric Eide <eeide@cs.utah.edu>:
       (let ((match-data (match-data)))
	 (unwind-protect
	     (and (or (and (boundp 'epoch::version)
			   (stringp (symbol-value 'epoch::version))
			   (string-match "Epoch"
					 (symbol-value 'epoch::version)))
		      (string-match "\\`18\\." emacs-version))
		  t)
	   (store-match-data match-data))))))

(defmacro igrep-compile-internal (command error-message &optional mode-name
  &rest emacs-19-args)
  ;; Just like compile-internal (Emacs 19) or compile1 (Emacs 18).
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      (` (compile1 (, command) (, error-message) (, mode-name)))
    (` (progn
	 (save-some-buffers)
	 (compile-internal (, command) (, error-message) (, mode-name)
			   (,@ emacs-19-args))))))

(defmacro igrep-where-is-internal (definition &optional keymap firstonly
				                        noindirect)
  ;; Just like where-is-internal (Emacs 19).
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      (` (where-is-internal (, definition) (, keymap)
			    (, firstonly)))
    (` (where-is-internal (, definition) (, keymap) (, firstonly)
			  (, noindirect)))))

(defmacro igrep-member (object list)
  ;; Just like member (Emacs 19).
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      ;; See bytecomp.el, by Jamie Zawinski <jwz@lucid.com>:
      (` (let ((object (, object))
	       (list (, list)))
	   (while (and list (not (equal object (car list))))
	     (setq list (cdr list)))
	   list))
    (` (member (, object) (, list)))))

(defmacro igrep-defsubst (&rest defsubst-args)
  ;; Just like defsubst (Emacs 19, and 18 with bytecomp2) or defun (Emacs 18).
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      (if (fboundp 'defsubst)
	  (` (defsubst (,@ defsubst-args)))
	(` (defun (,@ defsubst-args))))
    (` (defsubst (,@ defsubst-args)))))

(defmacro igrep-read-string (prompt default &optional history)
  ;; Just like read-string (Emacs 19 and 18), but with optional HISTORY.
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      (` (if (and (, history) (featurep 'gmhist))
	     (progn
	       ;; Don't use history for initial contents of minibuffer:
	       (or (get (, history) 'no-default)
		   (put (, history) 'no-default t))
	       (read-with-history-in (, history) (, prompt)))
	   (read-string (, prompt) (, default))))
    (` (read-from-minibuffer (, prompt) nil nil nil (, history)))))

(defmacro igrep-read-file-name (prompt
  &optional directory default existing initial history)
  ;; Just like read-file-name (Emacs 19 and 18), but with optional HISTORY.
  (if (condition-case nil		; The version 18 byte-compiler is
					; ignorant of macro definitions.
	  (igrep-emacs-version-18-p)
	(error t))
      (` (if (and (, history) (featurep 'gmhist))
	     (progn
	       ;; Don't use history for initial contents of minibuffer:
	       (or (get (, history) 'no-default)
		   (put (, history) 'no-default t))
	       (read-file-name-with-history-in (, history)
					       (, prompt)
					       (, directory)
					       (, default)
					       (, existing)))
	   (read-file-name (, prompt)
			   (, directory) (, default) (, existing))))
    (` (if (, history)
	   (let ((file-name-history (symbol-value (, history))))
	     (prog1 (read-file-name (, prompt)
				    (, directory)
				    (, default)
				    (, existing)
				    (, initial))
	       (set (, history) file-name-history)))
	 (read-file-name (, prompt)
			 (, directory) (, default) (, existing) (, initial))))))


;;; Commands:

(defun igrep (expression files &optional options)
  "*Run `grep' to match EXPRESSION in FILES.
The output is displayed in a *compilation* buffer, which \\[next-error] parses
to find each line of matched text.

EXPRESSION is interpreted by the command named by `igrep-command'; see
`igrep-expression-quote-char'.

FILES is either a file name pattern (expanded by the shell named by
`shell-file-name') or a list of file name patterns.

Optional OPTIONS is also passed to `igrep-command'; it defaults to
`igrep-options'.

If a prefix argument \
\(\\[universal-argument]\) \
is given when called interactively,
OPTIONS is read from the minibuffer.

If two prefix arguments \
\(\\[universal-argument] \\[universal-argument]\) \
are given when called interactively,
FILES is read from the minibuffer multiple times.

If three prefix arguments \
\(\\[universal-argument] \\[universal-argument] \\[universal-argument]\) \
are given when called interactively,
OPTIONS is read and FILES is read multiple times.

If `igrep-recursively' is non-nil, the directory or directories
containing FILES is recursively searched for files whose name matches
the file name component of FILES \(and whose contents match
EXPRESSION\)."
  (interactive
   (igrep-read-args))
  (if (null options)
      (setq options igrep-options))
  (if (not (listp files))		; (stringp files)
      (setq files (list files)))
  (if (string-match "^[rj]?sh$" (file-name-nondirectory shell-file-name))
      ;; (restricted, job-control, or standard) Bourne shell doesn't expand ~:
      (setq files
	    (mapcar 'expand-file-name files)))
  (let ((command (format "%s %s %c%s%c %s /dev/null"
			 igrep-command
			 options
			 igrep-expression-quote-char
			 expression
			 igrep-expression-quote-char
			 (if igrep-recursively
			     (if igrep-recursively-use-xargs
				 ""
			       "\"{}\"")
			   (mapconcat (function identity) files " ")))))
    (if igrep-recursively
	(setq command
	      (igrep-format-recursive-command command files)))
    (igrep-compile-internal command
			    (format "No more '%s' matches" igrep-command)
			    "igrep" nil grep-regexp-alist)))

(defun egrep (&rest igrep-args)
  "*Run `egrep'; see \\[igrep] and `egrep-command'.
All arguments \(including prefix arguments, when called interactively\)
are handled by `igrep'."
  (interactive
   (let ((igrep-command egrep-command)
	 (prefix-arg current-prefix-arg))
     (igrep-read-args)))
  (let ((igrep-command egrep-command))
    (apply (function igrep) igrep-args)))

(defun fgrep (&rest igrep-args)
  "*Run `fgrep'; see \\[igrep] and `fgrep-command'.
All arguments \(including prefix arguments, when called interactively\)
are handled by `igrep'."
  (interactive
   (let ((igrep-command fgrep-command)
	 (prefix-arg current-prefix-arg))
     (igrep-read-args)))
  (let ((igrep-command fgrep-command))
    (apply (function igrep) igrep-args)))

(defun igrep-recursively (&rest igrep-args)
  "*Run `grep' recursively; see \\[igrep] and `igrep-recursively'.
All arguments \(including prefix arguments, when called interactively\)
are handled by `igrep'."
  (interactive
   (let ((igrep-recursively t)
	 (prefix-arg current-prefix-arg))
     (igrep-read-args)))
  (let ((igrep-recursively t))
    (apply (function igrep) igrep-args)))

(defun egrep-recursively (&rest igrep-args)
  "*Run `egrep' recursively; see \\[igrep-recursively] and `egrep-command'.
All arguments \(including prefix arguments, when called interactively\)
are handled by `igrep'."
  (interactive
   (let ((igrep-command egrep-command)
	 (prefix-arg current-prefix-arg))
     (igrep-read-args)))
  (let ((igrep-command egrep-command))
    (apply (function igrep-recursively) igrep-args)))

(defun fgrep-recursively (&rest igrep-args)
  "*Run `fgrep' recursively; see \\[igrep-recursively] and `fgrep-command'.
All arguments \(including prefix arguments, when called interactively\)
are handled by `igrep'."
  (interactive
   (let ((igrep-command fgrep-command)
	 (prefix-arg current-prefix-arg))
     (igrep-read-args)))
  (let ((igrep-command fgrep-command))
    (apply (function igrep-recursively) igrep-args)))


;;; Utilities:

(igrep-defsubst igrep-file-directory (name)
  ;; Return the directory component of NAME, or "." if it has no
  ;; directory component.
  (directory-file-name (or (file-name-directory name)
			   (file-name-as-directory "."))))

(igrep-defsubst igrep-file-pattern (name)
  ;; Return the file component of NAME, or "*" if it has no file
  ;; component.
  (let ((pattern (file-name-nondirectory name)))
       (if (string= pattern "")
	   "*"
	 pattern)))

(defun igrep-format-recursive-command (command files)
  ;; Format `grep' COMMAND to be recursively invoked on FILES.
  (let ((directories '())
	(patterns '()))
    (while files
      (let ((dir (igrep-file-directory (car files)))
	    (pat (igrep-file-pattern (car files))))
	(if (not (igrep-member dir directories))
	    (setq directories (cons dir directories)))
	(cond ((equal pat "*")
	       (setq patterns t))
	      ((and (listp patterns)
		    (not (igrep-member pat patterns)))
	       (setq patterns (cons pat patterns)))))
      (setq files (cdr files)))
    (format (cond ((eq igrep-recursively-use-xargs 'gnu)
		   "find %s %s %s %s -print0 | \\\nxargs -0 -e %s")
		  (igrep-recursively-use-xargs
		   "find %s %s %s %s -print | \\\nxargs -e %s")
		  (t
		   "find %s %s %s %s \\\n\t-exec %s \\;"))
	    (mapconcat (function identity) (nreverse directories)
		       " ")
	    (if igrep-recursively-prune-options
		(format "-type d \\( %s \\) -prune -o"
			igrep-recursively-prune-options)
	      "")
	    (if igrep-recursively-file-options
		(format "\\( %s \\)" igrep-recursively-file-options)
	      "")
	    (if (listp patterns)
		(if (cdr patterns)	; (> (length patterns) 1)
		    (concat "\\( "
			    (mapconcat (function (lambda (pat)
						   (format "-name \"%s\"" pat)))
				       (nreverse patterns)
				       " -o ")
			    " \\)")
		  (format "-name \"%s\"" (car patterns)))
	      "")
	    command)))

(defun igrep-read-args ()
  ;; Read and return a list: (EXPRESSION FILES OPTIONS).
  (let* ((prompt-prefix
	  (if igrep-verbose-prompts
	      (apply (function concat)
		     (if igrep-recursively
			 "[recursive] ")
		     (if (eq igrep-verbose-prompts t)
			 (list igrep-command " ")))))
	 (options
	  (igrep-read-options prompt-prefix)))
    (if (eq igrep-verbose-prompts t)
	(setq prompt-prefix
	      (concat prompt-prefix options " ")))
    (list (igrep-read-expression prompt-prefix)
	  (igrep-read-files prompt-prefix)
	  options)))

(igrep-defsubst igrep-prefix (prefix string)
  ;; If PREFIX is non-nil, concatenate it and STRING; otherwise, return STRING.
  (if prefix
      (concat prefix string)
    string))

(defun igrep-read-options (&optional prompt-prefix)
  ;; If current-prefix-arg is '(4) or '(64), read and return an options
  ;; string from the minibuffer; otherwise, return igrep-options.
  ;; Optional PROMPT-PREFIX is prepended to the "Options: " prompt.
  (if (and (consp current-prefix-arg)
	   (memq (prefix-numeric-value current-prefix-arg)
		 '(4 64)))
      (let ((prompt "Options: "))
	(read-string (igrep-prefix prompt-prefix prompt)
		     igrep-options))
    igrep-options))

(defun igrep-read-expression (&optional prompt-prefix)
  ;; Read and return a `grep' expression string from the minibuffer.
  ;; Optional PROMPT-PREFIX is prepended to the "Expression: " prompt.
  (let ((default-expression (igrep-default-expression)))
    (if (string= default-expression "")
	(igrep-read-string (igrep-prefix prompt-prefix "Expression: ")
			   nil
			   'igrep-expression-history)
      (let ((expression
	     (igrep-read-string-with-default-in-history
	      (igrep-prefix prompt-prefix (format "Expression (default %s): "
						  default-expression))
	      default-expression
	      'igrep-expression-history)))
	(if (string= expression "")
	    default-expression
	  expression)))))

(igrep-defsubst igrep-default-key ()
  ;; Return the key bound to `exit-minibuffer', preferably "\r".
  (if (eq (lookup-key minibuffer-local-completion-map "\r")
	  (quote exit-minibuffer))	; The version 18 byte-compiler doesn't
					; grok a `function' form here.
      "\r"
    (igrep-where-is-internal (function exit-minibuffer)
			     minibuffer-local-completion-map
			     t)))

(defun igrep-read-files (&optional prompt-prefix)
  ;; Read and return a file name pattern from the minibuffer.  If
  ;; current-prefix-arg is '(16) or '(64), read multiple file name
  ;; patterns and return them in a list.  Optional PROMPT-PREFIX is
  ;; prepended to the "File(s): " prompt.
  (let* ((default-files (igrep-default-file-pattern))
	 (prompt (format "File(s) (default %s): " default-files))
	 (insert-default-directory nil)	; use relative path names
	 (file (igrep-read-file-name-with-default-in-history
		(igrep-prefix prompt-prefix prompt)
		default-files
		'igrep-files-history)))
    (if (and (consp current-prefix-arg)
	     (memq (prefix-numeric-value current-prefix-arg)
		   '(16 64)))
	(let ((files (list file)))
	  (setq prompt
		(igrep-prefix prompt-prefix
			      (if igrep-verbose-prompts
				  (format "File(s): [Type `%s' to continue] "
					  (key-description (igrep-default-key)))
				"File(s): ")))
	  (while (not (string= (setq file
				     (igrep-read-file-name prompt
							   nil "" nil nil
							   'igrep-files-history))
			       ""))
	    (setq files (cons file files)))
	  (nreverse files))
      file)))

(defmacro igrep-with-default-in-history (default history &rest body)
  ;; Temporarily append DEFAULT to HISTORY, and execute BODY forms.
  (` (progn
       ;; Append default to history:
       (set history
	    (cons (, default)
		  (if (boundp (, history))
		      (symbol-value (, history))
		    '())))
       (unwind-protect			; Make sure the history is restored.
	   ;; Execute body:
	   (progn (,@ body))
	 ;; Delete default from history (undo the append above):
	 (setcdr (symbol-value (, history))
		 (nthcdr 2 (symbol-value (, history))))))))

(defun igrep-read-string-with-default-in-history (prompt default history)
  ;; Read a string from the minibuffer, prompting with string PROMPT.
  ;; DEFAULT can be inserted into the minibuffer with `previous-
  ;; history-element' (Emacs 19) or `gmhist-previous' (Emacs 18, with
  ;; gmhist loaded); HISTORY is a symbol whose value (if bound) is a
  ;; list of previous results, most recent first.
  (let ((string (igrep-with-default-in-history default history
		  (igrep-read-string prompt nil history))))
    ;; Replace empty string in history with default:
    (if (string= string "")
	(setcar (symbol-value history) default))
    string))

(defun igrep-read-file-name-with-default-in-history (prompt default history)
  ;; Read a file name from the minibuffer, prompting with string PROMPT.
  ;; DEFAULT can be inserted into the minibuffer with `previous-
  ;; history-element' (Emacs 19) or `gmhist-previous' (Emacs 18, with
  ;; gmhist loaded); HISTORY is a symbol whose value (if any) is a list
  ;; of previous results, most recent first.
  (igrep-with-default-in-history default history
    (igrep-read-file-name prompt nil default nil nil history)))

(defun igrep-default-file-pattern (&optional buffer)
  ;; Return a shell file name pattern that matches files with the same
  ;; extension as the file being visited in the current buffer, or in
  ;; the optional argument BUFFER.
  ;; (Based on other-possibly-interesting-files in ~/as-is/unix.el, by
  ;; Wolfgang Rupprecht <wolfgang@mgm.mit.edu>.)
  (let* ((buffer-file-name (buffer-file-name buffer))
	 (file-name (if buffer-file-name
			(file-name-nondirectory buffer-file-name))))
    (concat "*"
	    (if file-name
		(let ((match-data (match-data)))
		  (unwind-protect
		      (if (string-match "\\.[^.]+\\(\\.g?[zZ]\\)?$" file-name)
			  (substring file-name
				     (match-beginning 0) (match-end 0)))
		    (store-match-data match-data)))))))

(defun igrep-default-expression ()
  ;; Return the symbol around, immediately following, or most closely
  ;; preceding point.
  ;; (Based on symbol-around-point in ~/as-is/unix.el, by Wolfgang
  ;; Rupprecht <wolfgang@mgm.mit.edu>.)
  (save-excursion
    (let ((match-data (match-data)))
      (unwind-protect
	  (if (not (looking-at "\\sw\\|\\s_"))
	      (re-search-backward "\\sw\\|\\s_" nil t))
	(store-match-data match-data)))
    (buffer-substring (progn (forward-sexp 1) (point))
		      (progn (backward-sexp 1) (point)))))

;;; Local Variables:
;;; eval: (put 'igrep-with-default-in-history 'lisp-indent-hook 2)
;;; eval: (put 'igrep-defsubst 'lisp-indent-hook 'defun)
;;; End:

;;;; igrep.el ends here
-- 
Kevin Rodgers <kevin.rodgers@ihs.com>   Project Engineer
Information Handling Services           Electronic Systems Development
15 Inverness Way East, M/S A203         GO BUFFS!
Englewood CO 80112 USA                  1+ (303) 397-2807[voice]/-2779[fax]


