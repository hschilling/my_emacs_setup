;; -*- Mode: Emacs-Lisp -*-
;; File:            c++-mode.el
;; Description:     Mode for editing C++ code
;; Authors:         1992 Barry A. Warsaw, Century Computing Inc.
;;                  1987 Dave Detlefs  (dld@cs.cmu.edu)
;;                   and Stewart Clamen (clamen@cs.cmu.edu)
;;                  Done by fairly faithful modification of:
;;                  c-mode.el, Copyright (C) 1985 Richard M. Stallman.
;; Last Modified:   $Date: 1992/05/08 20:47:38 $
;; Version:         $Revision: 2.40 $

;; Do a "C-h m" in a c++-mode buffer for more information on customizing
;; c++-mode.
;;
;; If you have problems or questions, you can contact me at the
;; following address: c++-mode-help@anthem.nlm.nih.gov
;;
;; To submit bug reports hit "C-c b" in a c++-mode buffer. This runs
;; the command c++-submit-bug-report and automatically sets up the
;; mail buffer with all the necessary information.
;;
;; Want to be a c++-mode victim, er, beta-tester?  Send add/drop
;; requests to c++-mode-victims-request@anthem.nlm.nih.gov.
;; Discussions go to c++-mode-victims@anthem.nlm.nih.gov, but bug
;; reports and such should still be sent to c++-mode-help only.
;;
;; The latest release (non-beta) version of this file should always be
;; available for anon-ftp on ftp.cme.nist.gov:pub/gnu/c++-mode.el. It
;; will also most likely be available on the elisp archive machine:
;; archive.cis.ohio-state.edu.
;; 
;; For those of you without aftp access, try sending a message to the
;; mail-server at library@cme.nist.gov.  Put this message in the body
;; of your email: "send pub/gnu/c++-mode.el" (without the quotes) to
;; get the file in uuencoded format, or send the message "help" to get
;; more information about using the mail-server.  Please don't email
;; me asking for the latest version, I may not have it readily
;; available to send to you. The mail-server should get it to you
;; pretty quickly.  Remember that if you want advanced access to beta
;; releases, get on the victims list -- but be forewarned, you should
;; be elisp-fluent to be a beta tester.
;;
;; LCD Archive Entry:
;; c++-mode|Barry A. Warsaw|c++-mode-help@anthem.nlm.nih.gov
;; |Mode for editing C++ code (was Detlefs' c++-mode.el)
;; |$Date: 1992/05/08 20:47:38 $|$Revision: 2.40 $|

(defvar c++-mode-abbrev-table nil
  "Abbrev table in use in C++-mode buffers.")
(define-abbrev-table 'c++-mode-abbrev-table ())

(defvar c++-mode-map ()
  "Keymap used in C++ mode.")
(if c++-mode-map
    ()
  (setq c++-mode-map (make-sparse-keymap))
  (define-key c++-mode-map "\C-j"      'reindent-then-newline-and-indent)
  (define-key c++-mode-map "{"         'c++-electric-brace)
  (define-key c++-mode-map "}"         'c++-electric-brace)
  (define-key c++-mode-map ";"         'c++-electric-semi)
  (define-key c++-mode-map "\e\C-h"    'mark-c-function)
  (define-key c++-mode-map "\e\C-q"    'c++-indent-exp)
  (define-key c++-mode-map "\177"      'backward-delete-char-untabify)
  (define-key c++-mode-map "\t"        'c++-indent-command)
  (define-key c++-mode-map "\C-c\C-i"  'c++-insert-header)
  (define-key c++-mode-map "\C-c\C-\\" 'c++-macroize-region)
  (define-key c++-mode-map "\C-c\C-c"  'c++-comment-region)
  (define-key c++-mode-map "\C-c\C-u"  'c++-uncomment-region)
  (define-key c++-mode-map "\e\C-a"    'c++-beginning-of-defun)
  (define-key c++-mode-map "\e\C-e"    'c++-end-of-defun)
  (define-key c++-mode-map "\e\C-x"    'c++-indent-defun)
  (define-key c++-mode-map "/"         'c++-electric-slash)
  (define-key c++-mode-map "*"         'c++-electric-star)
  (define-key c++-mode-map ":"         'c++-electric-colon)
  (define-key c++-mode-map "\177"      'c++-electric-delete)
  (define-key c++-mode-map "\C-c\C-t"  'c++-toggle-auto-hungry-state)
  (define-key c++-mode-map "\C-c\C-h"  'c++-toggle-hungry-state)
  (define-key c++-mode-map "\C-c\C-a"  'c++-toggle-auto-state)
  (define-key c++-mode-map "\C-c'"     'c++-tame-comments)
  (define-key c++-mode-map "'"         'c++-tame-insert)
  (define-key c++-mode-map "["         'c++-tame-insert)
  (define-key c++-mode-map "]"         'c++-tame-insert)
  (define-key c++-mode-map "("         'c++-tame-insert)
  (define-key c++-mode-map ")"         'c++-tame-insert)
  (define-key c++-mode-map "\C-cb"     'c++-submit-bug-report)
  )

(defvar c++-mode-syntax-table nil
  "Syntax table in use in C++-mode buffers.")

(if c++-mode-syntax-table
    ()
  (setq c++-mode-syntax-table (copy-syntax-table c-mode-syntax-table))
  (modify-syntax-entry ?/ ". 12" c++-mode-syntax-table)
  (modify-syntax-entry ?\n ">" c++-mode-syntax-table)
  (modify-syntax-entry ?\' "\"" c++-mode-syntax-table))

(defvar c++-tab-always-indent
  (if (boundp 'c-tab-always-indent) c-tab-always-indent t)
  "*Controls the operation of the TAB key.
t means always just reindent the current line.  nil means indent the
current line only if point is at the left margin or in the line's
indentation; otherwise insert a tab.  If not-nil-or-t, then the line
is first reindented, then if the indentation hasn't changed, a tab is
inserted. This last mode is useful if you like to add tabs after the #
of preprocessor commands.")
(defvar c++-block-close-brace-offset 0
  "*Extra indentation given to close braces which close a block. This
does not affect braces which close a top-level construct (e.g. function).")
(defvar c++-continued-member-init-offset nil
  "*Extra indent for continuation lines of member inits; NIL means to align
with previous initializations rather than with the colon on the first line.")
(defvar c++-member-init-indent 0
  "*Indentation level of member initializations in function declarations.")
(defvar c++-friend-offset -4
  "*Offset of C++ friend class declarations relative to member declarations.")
(defvar c++-empty-arglist-indent nil
  "*Indicates how far to indent an line following an empty argument
list.  Nil indicates to just after the paren.")
(defvar c++-comment-only-line-offset 4
  "*Indentation offset for line which contains only C or C++ style comments.")
(defvar c++-cleanup-}-else-{-p t
  "*Controls whether } else { style should remain on a single line.
When t, cleans up this style (when only whitespace intervenes).")
(defvar c++-hanging-braces t
  "*Controls the insertion of newlines before open (left) braces.
This variable only has effect when auto-newline is on.  If nil, open
braces do not hang (i.e. a newline is inserted before all open
braces).  If t, all open braces hang -- no newline is inserted before
open braces.  If not nil or t, newlines are only inserted before
top-level open braces; all other braces hang.")
(defvar c++-hanging-member-init-colon t
  "*If non-nil, don't put a newline after member initialization colon.")
(defvar c++-mode-line-format
  '("" mode-line-modified
    mode-line-buffer-identification
    "   " global-mode-string "   %[("
    mode-name (c++-hungry-delete-key
	       (c++-auto-newline "/ah" "/h")
	       (c++-auto-newline "/a"))
    minor-mode-alist "%n"
    mode-line-process
    ")%]----" (-3 . "%p") "-%-")
  "*Mode line format for c++-mode.")

(defvar c++-auto-hungry-initial-state 'none
  "*Initial state of auto/hungry mode when buffer is first visited.
Legal values are:
     'none         -- no auto-newline and no hungry-delete-key.
     'auto-only    -- auto-newline, but no hungry-delete-key.
     'hungry-only  -- no auto-newline, but hungry-delete-key.
     'auto-hungry  -- both auto-newline and hungry-delete-key enabled.
Nil is synonymous for 'none and t is synonymous for 'auto-hungry.")

(defvar c++-auto-hungry-toggle t
  "*Enable/disable toggling of auto/hungry states.
Legal values are:
     'none         -- auto-newline and hungry-delete-key cannot be enabled.
     'auto-only    -- only auto-newline state can be toggled.
     'hungry-only  -- only hungry-delete-key state can be toggled.
     'auto-hungry  -- both auto-newline and hungry-delete-key can be toggled.
Nil is synonymous for 'none and t is synonymous for 'auto-hungry.")

(defvar c++-hungry-delete-key nil
  "Internal state of hungry delete key.")
(defvar c++-auto-newline nil
  "Internal state of auto newline feature.")

(make-variable-buffer-local 'c++-auto-newline)
(make-variable-buffer-local 'c++-hungry-delete-key)

(defvar c++-mailer 'mail
  "*Mail package to use to generate bug report mail buffer.")
(defconst c++-mode-help-address "c++-mode-help@anthem.nlm.nih.gov"
  "Address accepting submission of bug reports.")

(defun c++-mode ()
  "Major mode for editing C++ code.  $Revision: 2.40 $
Do a \"\\[describe-function] c++-dump-state\" for information on
submitting bug reports.

1. Very much like editing C code.
2. Expression and list commands understand all C++ brackets.
3. Tab at left margin indents for C++ code
4. Comments are delimited with /* ... */ {or with // ... <newline>}
5. Paragraphs are separated by blank lines only.
6. Delete converts tabs to spaces as it moves back.

Key bindings:
\\{c++-mode-map}

These variables control indentation style. Those with names like
c-<thing> are inherited from c-mode.  Those with names like
c++-<thing> are unique for this mode, or have extended functionality
from their c-mode cousins.

 c-indent-level
    Indentation of C statements within surrounding block.
    The surrounding block's indentation is the indentation
    of the line on which the open-brace appears.
 c-continued-statement-offset
    Extra indentation given to a substatement, such as the
    then-clause of an if or body of a while.
 c-continued-brace-offset
    Extra indentation given to a brace that starts a substatement.
    This is in addition to c-continued-statement-offset.
 c-brace-offset
    Extra indentation for line if it starts with an open brace.
 c-brace-imaginary-offset
    An open brace following other text is treated as if it were
    this far to the right of the start of its line.
 c-argdecl-indent
    Indentation level of declarations of C function arguments.
 c-label-offset
    Extra indentation for line that is a label, or case or ``default:'', or
    ``public:'' or ``private:'', or ``protected:''.

 c++-tab-always-indent
    Controls the operation of the TAB key.  t means always just
    reindent the current line.  nil means indent the current line only
    if point is at the left margin or in the line's indentation;
    otherwise insert a tab.  If not-nil-or-t, then the line is first
    reindented, then if the indentation hasn't changed, a tab is
    inserted. This last mode is useful if you like to add tabs after
    the # of preprocessor commands. Default is value for
    c-tab-always-indent.
 c++-block-close-brace-offset
    Extra indentation give to braces which close a block. This does
    not affect braces which close top-level constructs (e.g. functions).
 c++-continued-member-init-offset
    Extra indentation for continuation lines of member initializations; nil
    means to align with previous initializations rather than with the colon.
 c++-member-init-indent
    Indentation level of member initializations in function declarations,
    if they are on a separate line beginning with a colon.
 c++-friend-offset
    Offset of C++ friend class declarations relative to member declarations.
 c++-empty-arglist-indent
    If non-nil, a function declaration or invocation which ends a line with a
    left paren is indented this many extra spaces, instead of flush with the
    left paren. If nil, it lines up with the left paren.
 c++-comment-only-line-offset
    Extra indentation for a line containing only a C or C++ style comment.
 c++-cleanup-}-else-{-p
    Controls whether } else { style (with only whitespace intervening)
    should be cleaned up so that it sits on only a single line.
 c++-hanging-braces
    Controls open brace hanging behavior when using auto-newline. Nil
    says no braces hang, t says all open braces hang. Not nil or t
    means top-level open braces don't hang, all others do.
 c++-hanging-member-init-colon
    If non-nil and auto-newline is on, newlines are not inserted after
    member initialization colons.
 c++-mode-line-format
    Mode line format for c++-mode buffers. Includes auto-newline and
    hungry-delete-key indicators.
 c++-auto-hungry-initial-state
    Initial state of auto/hungry mode when a C++ buffer is first visited.
 c++-auto-hungry-toggle
    Enable/disable toggling of auto/hungry states.

Auto-newlining is no longer an all or nothing proposition. To be
specific I don't believe it is possible to implement a perfect
auto-newline algorithm. Sometimes you want it and sometimes you don't.
So now auto-newline (and its companion, hungry-delete) can be toggled
on and off on the fly.  Hungry-delete is the optional behavior of the
delete key. When hungry-delete is enabled, hitting the delete key
once consumes all preceeding whitespace, unless point is within a
literal (defined as a C or C++ comment, or string).  Inside literals,
and with hungry-delete disabled, the delete key just calls
backward-delete-char-untabify.

Behavior is controlled by c++-auto-hungry-initial-state and
c++-auto-hungry-toggle.  Legal values for both variables are:

   'none (or nil)      -- no auto-newline or hungry-delete.
   'auto-only          -- function affects only auto-newline state.
   'hungry-only        -- function affects only hungry-delete state.
   'auto-hungry (or t) -- function affects both states.

Thus if c++-auto-hungry-initial-state is 'hungry-only, then only
hungry state is turned on when the buffer is first visited.  If
c++-auto-hungry-toggle is 'auto-hungry, and both auto-newline and
hungry-delete state are on, then hitting \"\\[c++-toggle-auto-hungry-state]\"
will toggle both states.  Hitting \"\\[c++-toggle-hungry-state]\" will
always toggle hungry-delete state and hitting \"\\[c++-toggle-auto-state]\"
will always toggle auto-newline state, regardless of the value of
c++-auto-hungry-toggle.   Hungry-delete state, when on, makes the
delete key consume all preceding whitespace.

Settings for K&R, BSD, and Stroustrup indentation styles are
  c-indent-level                5    8    4
  c-continued-statement-offset  5    8    4
  c-continued-brace-offset                0
  c-brace-offset               -5   -8    0
  c-brace-imaginary-offset                0
  c-argdecl-indent              0    8    4
  c-label-offset               -5   -8   -4
  c++-empty-arglist-indent                4
  c++-friend-offset                       0

Turning on C++ mode calls the value of the variable c++-mode-hook with
no args, if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map c++-mode-map)
  (set-syntax-table c++-mode-syntax-table)
  (setq major-mode 'c++-mode
	mode-name "C++"
	local-abbrev-table c++-mode-abbrev-table)
  (set (make-local-variable 'paragraph-start) (concat "^$\\|" page-delimiter))
  (set (make-local-variable 'paragraph-separate) paragraph-start)
  (set (make-local-variable 'paragraph-ignore-fill-prefix) t)
  (set (make-local-variable 'require-final-newline) t)
  (set (make-local-variable 'parse-sexp-ignore-comments) nil)
  ;; 
  (set (make-local-variable 'indent-line-function) 'c++-indent-line)
  (set (make-local-variable 'comment-start) "// ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-column) 32)
  (set (make-local-variable 'comment-start-skip) "/\\*+ *\\|// *")
  (set (make-local-variable 'comment-indent-hook) 'c++-comment-indent)
  ;;
  (setq mode-line-format c++-mode-line-format)
  (run-hooks 'c++-mode-hook)
  (c++-set-auto-hungry-state
   (memq c++-auto-hungry-initial-state '(auto-only   auto-hungry t))
   (memq c++-auto-hungry-initial-state '(hungry-only auto-hungry t))))

(defun c++-comment-indent ()
  "Used by indent-for-comment to decide how much to indent a comment
in C++ code based on its context."
  (if (looking-at "^\\(/\\*\\|//\\)")
      0					; Existing comment at bol stays there.
    (save-excursion
      (skip-chars-backward " \t")
      (max
       ;; leave at least one space on non-empty lines.
       (if (zerop (current-column)) 0 (1+ (current-column)))
       (let ((cur-pt (point)))
	 (beginning-of-line 0)
	 ;; If previous line had a comment, use it's indent
	 (if (re-search-forward comment-start-skip cur-pt t)
	     (progn
	       (goto-char (match-beginning 0))
	       (current-column))
	   comment-column))))))		; otherwise indent at comment column.

(defun c++-set-auto-hungry-state (auto-p hungry-p)
  "Set auto/hungry to state indicated by AUTO-P and HUNGRY-P.
Update mode line to indicate state to user."
  (setq c++-auto-newline auto-p
	c++-hungry-delete-key hungry-p)
  (set-buffer-modified-p (buffer-modified-p)))

(defun c++-toggle-auto-state (arg)
  "Toggle auto-newline state.
This function ignores c++-auto-hungry-toggle variable.  Optional
numeric ARG, if supplied turns on auto-newline when positive, turns
off auto-newline when negative and toggles when zero."
  (interactive "P")
  (let ((auto (cond ((not arg)
		     (not c++-auto-newline))
		    ((zerop (setq arg (prefix-numeric-value arg)))
		     (not c++-auto-newline))
		    ((< arg 0) nil)
		    (t t))))
    (c++-set-auto-hungry-state auto c++-hungry-delete-key)))

(defun c++-toggle-hungry-state (arg)
  "Toggle hungry-delete-key state.
This function ignores c++-auto-hungry-toggle variable.  Optional
numeric ARG, if supplied turns on hungry-delete-key when positive,
turns off hungry-delete-key when negative and toggles when zero."
  (interactive "P")
  (let ((hungry (cond ((not arg)
		       (not c++-hungry-delete-key))
		      ((zerop (setq arg (prefix-numeric-value arg)))
		       (not c++-hungry-delete-key))
		      ((< arg 0) nil)
		      (t t))))
    (c++-set-auto-hungry-state c++-auto-newline hungry)))

(defun c++-toggle-auto-hungry-state (arg)
  "Toggle auto-newline and hungry-delete-key state.
Actual toggling of these states is controlled by
c++-auto-hungry-toggle variable.

Optional argument has the following meanings when supplied:
     Universal argument \\[universal-argument]
          resets state to c++-auto-hungry-initial-state.
     negative number
          turn off both auto-newline and hungry-delete-key.
     positive number
          turn on both auto-newline and hungry-delete-key.
     zero
          toggle both states regardless of c++auto-hungry-toggle-p."
  (interactive "P")
  (let* ((numarg (prefix-numeric-value arg))
	 (apl (list 'auto-only   'auto-hungry t))
	 (hpl (list 'hungry-only 'auto-hungry t))
	 (auto (cond ((not arg)
		      (if (memq c++-auto-hungry-toggle apl)
			  (not c++-auto-newline)
			c++-auto-newline))
		     ((listp arg)
		      (memq c++-auto-hungry-initial-state apl))
		     ((zerop numarg)
		      (not c++-auto-newline))
		     ((< arg 0) nil)
		     (t t)))
	 (hungry (cond ((not arg)
			(if (memq c++-auto-hungry-toggle hpl)
			    (not c++-hungry-delete-key)
			  c++-hungry-delete-key))
		       ((listp arg)
			(memq c++-auto-hungry-initial-state hpl))
		       ((zerop numarg)
			(not c++-hungry-delete-key))
		       ((< arg 0) nil)
		       (t t))))
    (c++-set-auto-hungry-state auto hungry)))

(defun c++-tame-insert (arg)
  "Safely inserts certain troublesome characters in comment regions.
Because of a syntax bug in emacs' scan-lists function, characters with
string or parenthesis syntax must be escaped with a backslash or lots
of things get messed up. Unfortunately, setting
parse-sexp-ignore-comments to non-nil does not fix the problem."
  (interactive "p")
  (if (c++-in-comment-p)
      (insert "\\"))
  (self-insert-command arg))

(defun c++-electric-delete (arg)
  "If c++-hungry-delete-key is non-nil, consumes all preceding
whitespace unless ARG is supplied, or point is inside a C or C++ style
comment or string.  If ARG is supplied, this just calls
backward-delete-char-untabify passing along ARG.

If c++-hungry-delete-key is nil, just call
backward-delete-char-untabify."
  (interactive "P")
  (cond
   ((or (not c++-hungry-delete-key) arg)
    (backward-delete-char-untabify (prefix-numeric-value arg)))
   ((not (or (c++-in-comment-p)
	     (c++-in-open-string-p)))
    (let ((here (point)))
      (skip-chars-backward "[ \t\n]")
      (if (/= (point) here)
	  (delete-region (point) here)
	(backward-delete-char-untabify 1))))
   (t (backward-delete-char-untabify 1))))

(defun c++-electric-brace (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let (insertpos (last-command-char last-command-char))
    (if (and (not arg)
	     (eolp)
	     (or (save-excursion
		   (skip-chars-backward " \t")
		   (bolp))
		 (let ((c++-auto-newline c++-auto-newline)
		       (open-brace-p (= last-command-char ?{)))
		   (if (and open-brace-p
			    (or (eq c++-hanging-braces t)
				(and c++-hanging-braces
				     (not (c++-at-top-level-p)))))
		       (setq c++-auto-newline nil))
		   (c++-auto-newline)
		   ;; this may have auto-filled so we need to indent
		   ;; the previous line
		   (save-excursion
		     (forward-line -1)
		     (c++-indent-line))
		   t)))
	(progn
	  (if (c++-in-comment-p)
	      (insert "\\"))
	  (insert last-command-char)
	  (let ((here (make-marker)) mbeg mend)
	    (set-marker here (point))
	    (if (and c++-cleanup-}-else-{-p
		     (= last-command-char ?\{)
		     (let ((status (re-search-backward "}[ \t\n]*else[ \t\n]*{"
						       nil t)))
		       (setq mbeg (match-beginning 0)
			     mend (match-end 0))
		       status)
		     (not (c++-in-open-string-p))
		     (not (c++-in-comment-p)))
		(progn
		  ;; we should clean up brace-else-brace syntax
		  (delete-region mbeg mend)
		  (insert-before-markers "} else {")
		  (goto-char here)
		  (set-marker here nil))
	      (goto-char here)
	      (set-marker here nil)))
	  (c++-indent-line)
	  (if (c++-auto-newline)
	      (progn
		;; c++-auto-newline may have done an auto-fill
		(save-excursion
		  (let ((here (make-marker)))
		    (set-marker here (point))
		    (goto-char (- (point) 2))
		    (c++-indent-line)
		    (setq insertpos (- (goto-char here) 2))
		    (set-marker here nil)))
		(c++-indent-line)))
	  (save-excursion
	    (if insertpos (goto-char (1+ insertpos)))
	    (delete-char -1))))
    (if insertpos
	(save-excursion
	  (goto-char insertpos)
	  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun c++-electric-slash (arg)
  "Slash as first non-whitespace character on line indents as comment
unless we're inside a C style comment, or a string, does not do
indentation. if first non-whitespace character on line is not a slash,
then we just insert the slash.  in this case use indent-for-comment if
you want to add a comment to the end of a line."
  (interactive "P")
  (let ((c++-auto-newline c++-auto-newline))
    (if (= (preceding-char) ?/)
	(setq c++-auto-newline nil))
    (if (memq (preceding-char) '(?/ ?*))
	(c++-electric-terminator arg)
      (self-insert-command (prefix-numeric-value arg)))))

(defun c++-electric-star (arg)
  "Works with c++-electric-slash to auto indent C style comment lines."
  (interactive "P")
  (if (= (preceding-char) ?/)
      (let ((c++-auto-newline nil))
	(c++-electric-terminator arg))
    (self-insert-command (prefix-numeric-value arg))))

(defun c++-electric-semi (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let ((insertion-point (point)))
    (save-excursion
      (skip-chars-backward " \t\n")
      (if (= (preceding-char) ?})
	  (delete-region insertion-point (point)))))
  (c++-electric-terminator arg))

(defun c++-electric-colon (arg)
  "Electrify colon.  De-auto-newline double colons. No auto-new-lines
for member initialization list."
  (interactive "P")
  (let ((c++-auto-newline c++-auto-newline)
	(insertion-point (point)))
    (save-excursion
      (skip-chars-backward " \t\n")
      (if (= (preceding-char) ?:)	;check for double colon
	  (progn
	    (delete-region insertion-point (point))
	    (setq c++-auto-newline nil)))
      (if (and c++-hanging-member-init-colon
	       (progn (c++-backward-to-noncomment (point-min))
		      (= (preceding-char) ?\))))
	  (setq c++-auto-newline nil)))
    (c++-electric-terminator arg)))

(defun c++-electric-terminator (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let (insertpos (end (point)))
    (if (and (not arg) (eolp)
	     (not (save-excursion
		    (beginning-of-line)
		    (skip-chars-forward " \t")
		    (or (= (following-char) ?#)
			;; Colon is special only after a label, or
			;; case, or another colon.
			;; So quickly rule out most other uses of colon
			;; and do no indentation for them.
			(and (eq last-command-char ?:)
			     (not (looking-at "case[ \t]"))
			     (save-excursion
			       (forward-word 1)
			       (skip-chars-forward " \t")
			       (< (point) end))
			     ;; Do re-indent double colons
			     (save-excursion
			       (end-of-line 1)
			       (looking-at ":")))
			(progn
			  (beginning-of-defun)
			  (let ((pps (parse-partial-sexp (point) end)))
			    (or (nth 3 pps) (nth 4 pps) (nth 5 pps))))))))
	(progn
	  (insert last-command-char)
	  (c++-indent-line)
	  (and c++-auto-newline
	       (not (c++-in-parens-p))
	       (progn
		 ;; the new marker object, used to be just an integer
		 (setq insertpos (make-marker))
		 ;; changed setq to set-marker
		 (set-marker insertpos (1- (point)))
		 ;; do this before the newline, since in auto fill can break
		 (newline)
		 (c++-indent-line)))
	  (save-excursion
	    (if insertpos (goto-char (1+ insertpos)))
	    (delete-char -1))))
    (if insertpos
	(save-excursion
	  (goto-char insertpos)
	  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun c++-indent-command (&optional whole-exp)
  "Indent current line as C++ code, or in some cases insert a tab character.
If c++-tab-always-indent is t (the default), always just indent the
current line.  If nil, indent the current line only if point is at the
left margin or in the line's indentation; otherwise insert a tab.  If
not-nil-or-t, then tab is inserted only within literals (comments and
strings) and inside preprocessor directives, but line is always reindented.

A numeric argument, regardless of its value, means indent rigidly all
the lines of the expression starting after point so that this line
becomes properly indented.  The relative indentation among the lines
of the expression are preserved."
  (interactive "P")
  (if whole-exp
      ;; If arg, always indent this line as C
      ;; and shift remaining lines of expression the same amount.
      (let ((shift-amt (c++-indent-line))
	    beg end)
	(save-excursion
	  (if (eq c++-tab-always-indent t)
	      (beginning-of-line))
	  (setq beg (point))
	  (forward-sexp 1)
	  (setq end (point))
	  (goto-char beg)
	  (forward-line 1)
	  (setq beg (point)))
	(if (> end beg)
	    (indent-code-rigidly beg end shift-amt "#")))
    (cond ((and (eq c++-tab-always-indent nil)
		(save-excursion
		  (skip-chars-backward " \t")
		  (not (bolp))))
	   (insert-tab))
	  ((eq c++-tab-always-indent t)
	   (c++-indent-line))
	  ((or (c++-in-open-string-p)
	       (c++-in-comment-p)
	       (save-excursion
		 (back-to-indentation)
		 (eq (char-after (point)) ?#)))
	   (let ((boi (save-excursion
		       (back-to-indentation)
		       (point)))
		 (indent-p nil))
	     (c++-indent-line)
	     (save-excursion
	       (back-to-indentation)
	       (setq indent-p (= (point) boi)))
	     (if indent-p (insert-tab))))
	  (t (c++-indent-line)))))

(defun c++-indent-line ()
  "Indent current line as C++ code.
Return the amount the indentation changed by."
  (let ((indent (c++-calculate-indent nil))
	beg shift-amt
	(comcol nil)
	(case-fold-search nil)
	(pos (- (point-max) (point))))
    (beginning-of-line)
    (setq beg (point))
    (cond ((eq indent nil)
	   (setq indent (current-indentation)))
	  ((eq indent t)
	   (setq indent (calculate-c-indent-within-comment)))
	  ((looking-at "[ \t]*#")
	   (setq indent 0))
	  ((save-excursion
	     (and (not (back-to-indentation))
		  (looking-at "//\\|/\\*")
		  (/= (setq comcol (current-column)) 0)))
	   ;; we've found a comment-only line. we now must try to
	   ;; determine if the line is a continuation from a comment
	   ;; on the previous line.  we check to see if the comment
	   ;; starts in comment-column and if so, we don't change its
	   ;; indentation.
	   (if (= comcol comment-column)
	       (setq indent comment-column)
	     (setq indent (+ indent c++-comment-only-line-offset))))
	  (t
	   (skip-chars-forward " \t")
	   (if (listp indent) (setq indent (car indent)))
	   (cond ((looking-at "\\(default\\|public\\|private\\|protected\\):")
		  (setq indent (+ indent c-label-offset)))
		 ((or (looking-at "case\\b")
		      (and (looking-at "[A-Za-z]")
			   (save-excursion
			     (forward-sexp 1)
			     (looking-at ":[^:]"))))
		  (setq indent (max 1 (+ indent c-label-offset))))
		 ((and (looking-at "else\\b")
		       (not (looking-at "else\\s_")))
		  (setq indent (save-excursion
				 (c-backward-to-start-of-if)
				 (current-indentation))))
		 ((looking-at "friend\[ \t]class[ \t]")
		  (setq indent (+ indent c++-friend-offset)))
		 ((= (following-char) ?\))
		  (setq indent (+ (- indent c-indent-level)
				  (if (save-excursion
					(forward-char 1)
					(c++-at-top-level-p))
				      (- c++-block-close-brace-offset)
				    c++-block-close-brace-offset))))
		 ((= (following-char) ?})
		  (setq indent (+ (- indent c-indent-level)
				  (if (save-excursion
					(forward-char 1)
					(c++-at-top-level-p))
				      (- c++-block-close-brace-offset)
				    c++-block-close-brace-offset))))
		 ((= (following-char) ?{)
		  (setq indent (+ indent c-brace-offset))))))
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
    (if (zerop shift-amt)
	(if (> (- (point-max) pos) (point))
	    (goto-char (- (point-max) pos)))
      (delete-region beg (point))
      (indent-to indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	  (goto-char (- (point-max) pos))))
    shift-amt))

(defun c++-at-top-level-p ()
  "Return t if point is not inside a containing C++ expression, nil
if it is embedded in an expression."
  ;; hack to work around emacs comment bug
  (save-excursion
    (let ((indent-point (point))
	  (case-fold-search nil)
	  state containing-sexp parse-start)
      (beginning-of-defun)
      (while (< (point) indent-point)
	(setq parse-start (point))
	(setq state (parse-partial-sexp (point) indent-point 0))
	(setq containing-sexp (car (cdr state))))
      (null containing-sexp))))

(defun c++-in-comment-p ()
  "Return t if in a C or C++ style comment as defined by mode's syntax."
  (save-excursion
    (let ((here (point)))
      (beginning-of-defun)
      (nth 4 (parse-partial-sexp (point) here 0)))))

(defun c++-in-open-string-p ()
  "Return non-nil if in an open string as defined by mode's syntax."
  ;; temporarily change tick to string syntax, just for this check
  (save-excursion
    (let* ((here (point)))
      (beginning-of-defun)
      (nth 3 (parse-partial-sexp (point) here 0)))))

(defun c++-in-parens-p ()
  ;; hack to work around emacs comment bug
  (condition-case ()
      (save-excursion
	(save-restriction
	  (narrow-to-region (point)
			    (progn (beginning-of-defun) (point)))
	  (goto-char (point-max))
	  (= (char-after (or (scan-lists (point) -1 1) (point-min))) ?\()))
    (error nil)))

(defun c++-auto-newline ()
  "Insert a newline iff we're not in a literal.
Literals are defined as being inside a C or C++ style comment or open
string according to mode's syntax."
  (and c++-auto-newline
       (not (c++-in-comment-p))
       (not (c++-in-open-string-p))
       (not (newline))))

(defun c++-calculate-indent (&optional parse-start)
  "Return appropriate indentation for current line as C++ code.
In usual case returns an integer: the column to indent to.
Returns nil if line starts inside a string, t if in a comment."
  (save-excursion
    (beginning-of-line)
    (let ((indent-point (point))
	  (case-fold-search nil)
	  state do-indentation
	  containing-sexp)
      (if parse-start
	  (goto-char parse-start)
	(beginning-of-defun))
      (while (< (point) indent-point)
	(setq parse-start (point))
	(setq state (parse-partial-sexp (point) indent-point 0))
	(setq containing-sexp (car (cdr state))))
      (cond ((nth 3 state)
	     ;; in a string.
	     nil)
	    ((c++-in-comment-p)
	     ;; in a C comment.
	     t)
	    ;; is this a comment-only line in the first column or
	    ;; comment-column?  if so we don't change the indentation,
	    ;; otherwise, we indent relative to surrounding code
	    ;; (later on).
	    ((progn (goto-char indent-point)
		    (beginning-of-line)
		    (skip-chars-forward " \t")
		    (and (looking-at comment-start-skip)
			 (or (zerop (current-column))
			     (= (current-column) comment-column))))
	     (current-column))
	    ((null containing-sexp)
	     ;; Line is at top level.  May be comment-only line, data
	     ;; or function definition, or may be function argument
	     ;; declaration or member initialization.  Indent like the
	     ;; previous top level line unless:
	     ;;
	     ;; 1. the previous line ends in a closeparen without
	     ;; semicolon, in which case this line is the first
	     ;; argument declaration or member initialization, or
	     ;;
	     ;; 2. the previous line ends with a closeparen
	     ;; (closebrace), optional spaces, and a semicolon, in
	     ;; which case this line follows a multiline function
	     ;; declaration (class definition), or
	     ;;
	     ;; 3. the previous line begins with a colon, in which
	     ;; case this is the second line of member inits.  It is
	     ;; assumed that arg decls and member inits are not mixed.
	     ;;
	     (goto-char indent-point)
	     (skip-chars-forward " \t")
	     (if (looking-at "/[/*]")
		 ;; comment only line, but must not be in the first
		 ;; column since cond case above would have caught it
		 0
	       (if (= (following-char) ?{)
		   0   ; Unless it starts a function body
		 (c++-backward-to-noncomment (or parse-start (point-min)))
		 (if (= (preceding-char) ?\))
		     (progn		; first arg decl or member init
		       (goto-char indent-point)
		       (skip-chars-forward " \t")
		       (if (= (following-char) ?:)
			   c++-member-init-indent
			 c-argdecl-indent))
		   (if (= (preceding-char) ?\;)
		       (progn
			 (backward-char 1)
			 (skip-chars-backward " \t")))
		   (if (or (= (preceding-char) ?})
			   (= (preceding-char) ?\)))
		       0
		     (beginning-of-line) ; continued arg decls or member inits
		     (skip-chars-forward " \t")
		     (if (looking-at "/[/*]")
			 0
		       (if (= (following-char) ?:)
			   (if c++-continued-member-init-offset
			       (+ (current-indentation)
				  c++-continued-member-init-offset)
			     (progn
			       (forward-char 1)
			       (skip-chars-forward " \t")
			       (current-column)))
			 (current-indentation))))
		   ))))
	    ((/= (char-after containing-sexp) ?{)
	     ;; line is expression, not statement:
	     ;; indent to just after the surrounding open -- unless
	     ;; empty arg list, in which case we do what
	     ;; c++-empty-arglist-indent says to do.
	     (if (and c++-empty-arglist-indent
		      (or (null (nth 2 state))	;; indicates empty arg
						;; list.
			  ;; Use a heuristic: if the first
			  ;; non-whitespace following left paren on
			  ;; same line is not a comment,
			  ;; is not an empty arglist.
			  (save-excursion
			    (goto-char (1+ containing-sexp))
			    (not
			     (looking-at "\\( \\|\t\\)*[^/\n]")))))
		 (progn
		   (goto-char containing-sexp)
		   (beginning-of-line)
		   (skip-chars-forward " \t")
		   (goto-char (min (+ (point) c++-empty-arglist-indent)
				   (1+ containing-sexp)))
		   (current-column))
	       ;; In C-mode, we would always indent to one after the
	       ;; left paren.  Here, though, we may have an
	       ;; empty-arglist, so we'll indent to the min of that
	       ;; and the beginning of the first argument.
	       (goto-char (1+ containing-sexp))
	       ;; we want to skip any whitespace b/w open paren and
	       ;; first argurment. this handles while (thing) style
	       ;; and while( thing ) style
	       (skip-chars-forward " \t")
	       (current-column)))
	    (t
	     ;; Statement.  Find previous non-comment character.
	     (goto-char indent-point)
	     (c++-backward-to-noncomment containing-sexp)
	     (if (not (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?\{)))
		 ;; This line is continuation of preceding line's statement;
		 ;; indent  c-continued-statement-offset  more than the
		 ;; previous line of the statement.
		 (progn
		   (c-backward-to-start-of-continued-exp containing-sexp)
                   (+ (current-column)
                      ;; j.peck hack to prevent repeated continued indentation:
                      (if (save-excursion
                            (beginning-of-line 1)
                            (c++-backward-to-noncomment containing-sexp)
                            (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?\{)))
                          c-continued-statement-offset
			;; the following statements *do* indent even
			;; for single statements (are there others?)
			(if (looking-at
			     "\\(do\\|else\\|for\\|if\\|while\\)\\b")
			    c-continued-statement-offset
			  0))
                      ;; j.peck  [8/13/91]
		      ;; j.peck hack replaced this line:
		      ;; \(+ c-continued-statement-offset (current-column)
		      ;; Add continued-brace-offset? [weikart]
		      (if (save-excursion (goto-char indent-point)
					  (skip-chars-forward " \t")
					  (eq (following-char) ?{))
			  c-continued-brace-offset 0)))
	       ;; This line may start a new statement, or it could
	       ;; represent the while closure of a do/while construct
	       (if (save-excursion
		     (and
		      (progn
			(goto-char indent-point)
			(skip-chars-forward " \t\n")
			(looking-at "while\\b"))
		      (progn
			(c++-backward-to-start-of-do containing-sexp)
			(looking-at "do\\b"))
		      (setq do-indentation (current-column))))
		   do-indentation
		 ;; this could be a case statement. if so we want to
		 ;; indent it like the first case statement after a switch
		 (if (save-excursion
		       (goto-char indent-point)
		       (skip-chars-forward " \t\n")
		       (looking-at "case\\b"))
		     (progn
		       (goto-char containing-sexp)
		       (back-to-indentation)
		       (+ (current-column) c-indent-level))
		   ;; else, this is the start of a new statement
		   ;; Position following last unclosed open.
		   (goto-char containing-sexp)
		   ;; Is line first statement after an open-brace?
		   (or
		    ;; If no, find that first statement and indent like it.
		    (save-excursion
		      (forward-char 1)
		      (while (progn (skip-chars-forward " \t\n")
				    (looking-at
				     (concat
				      "#\\|/\\*\\|//"
				      "\\|case[ \t]"
				      "\\|[a-zA-Z0-9_$]*:[^:]"
				      "\\|friend[ \t]class[ \t]")))
			;; Skip over comments and labels following openbrace.
			(cond ((= (following-char) ?\#)
			       (forward-line 1))
			      ((looking-at "/\\*")
			       (search-forward "*/" nil 'move))
			      ((looking-at "//\\|friend[ \t]class[ \t]")
			       (forward-line 1))
			      ((looking-at "case\\b")
			       (forward-line 1))
			      (t
			       (re-search-forward ":[^:]" nil 'move))))
		      ;; The first following code counts
		      ;; if it is before the line we want to indent.
		      (and (< (point) indent-point)
			   (current-column)))
		    ;; If no previous statement, indent it relative to
		    ;; line brace is on.  For open brace in column
		    ;; zero, don't let statement start there too.  If
		    ;; c-indent-offset is zero, use c-brace-offset +
		    ;; c-continued-statement-offset instead.  For
		    ;; open-braces not the first thing in a line, add
		    ;; in c-brace-imaginary-offset.
		    (+ (if (and (bolp) (zerop c-indent-level))
			   (+ c-brace-offset c-continued-statement-offset)
			 c-indent-level)
		       ;; Move back over whitespace before the openbrace.
		       ;; If openbrace is not first nonwhite thing on the line,
		       ;; add the c-brace-imaginary-offset.
		       (progn (skip-chars-backward " \t")
			      (if (bolp) 0 c-brace-imaginary-offset))
		       ;; If the openbrace is preceded by a parenthesized exp,
		       ;; move to the beginning of that;
		       ;; possibly a different line
		       (progn
			 (if (eq (preceding-char) ?\))
			     (forward-sexp -1))
			 ;; Get initial indentation of the line we are on.
			 (current-indentation))))))))))))

(defun c++-backward-to-noncomment (lim)
  "Skip backwards to first preceding non-comment character."
  (let (opoint stop)
    (while (not stop)
      (skip-chars-backward " \t\n\r\f" lim)
      (setq opoint (point))
      (cond ((and (>= (point) (+ 2 lim))
		  (save-excursion
		    (forward-char -2)
		    (looking-at "\\*/")))
	     (search-backward "/*" lim 'move))
	    ((and
	      (let ((sblim (max (c++-point-bol) lim)))
		(if (< (point) sblim)
		    nil
		  (search-backward "//" (max (c++-point-bol) lim) 'move)))
	      (not (c++-in-open-string-p))))
	  (t (beginning-of-line)
	     (skip-chars-forward " \t")
	     (if (looking-at "#")
		 (setq stop (<= (point) lim))
	       (setq stop t)
	       (goto-char opoint)))))))

(defun c++-backward-to-start-of-do (&optional limit)
  "Move to the start of the last ``unbalanced'' do."
  (or limit (setq limit (save-excursion (beginning-of-defun) (point))))
  (let ((do-level 1)
	(case-fold-search nil))
    (while (not (zerop do-level))
      ;; we protect this call because trying to execute this when the
      ;; while is not associated with a do will throw an error
      (condition-case err
	  (progn
	    (backward-sexp 1)
	    (cond ((looking-at "while\\b")
		   (setq do-level (1+ do-level)))
		  ((looking-at "do\\b")
		   (setq do-level (1- do-level)))
		  ((< (point) limit)
		   (setq do-level 0)
		   (goto-char limit))))
	(error
	 (goto-char limit)
	 (setq do-level 0))))))

(defun c++-indent-exp ()
  "Indent each line of the C++ grouping following point."
  (interactive)
  (let ((indent-stack (list nil))
	(contain-stack (list (point)))
	(case-fold-search nil)
	restart outer-loop-done inner-loop-done state ostate
	this-indent last-sexp last-depth
	at-else at-brace
	(opoint (point))
	(next-depth 0))
    (save-excursion
      (forward-sexp 1))
    (save-excursion
      (setq outer-loop-done nil)
      (while (and (not (eobp)) (not outer-loop-done))
	(setq last-depth next-depth)
	;; Compute how depth changes over this line
	;; plus enough other lines to get to one that
	;; does not end inside a comment or string.
	;; Meanwhile, do appropriate indentation on comment lines.
	(setq inner-loop-done nil)
	(while (and (not inner-loop-done)
		    (not (and (eobp) (setq outer-loop-done t))))
	  (setq ostate state)
	  ;; fix by reed@adapt.net.com
	  ;; must pass in the return past the end of line, so that
	  ;; parse-partial-sexp finds it, and recognizes that a "//"
	  ;; comment is over. otherwise, state is set that we're in a
	  ;; comment, and never gets unset, causing outer-loop to only
	  ;; terminate in (eobp). old:
	  ;;(setq state (parse-partial-sexp (point)
	  ;;(progn (end-of-line) (point))
	  ;;nil nil state))
	  (let ((start (point))
		(line-end (progn (end-of-line) (point)))
		(end (progn (forward-char) (point))))
	    (setq state (parse-partial-sexp start end nil nil state))
	    (goto-char line-end))
	  (setq next-depth (car state))
	  (if (and (car (cdr (cdr state)))
		   (>= (car (cdr (cdr state))) 0))
	      (setq last-sexp (car (cdr (cdr state)))))
	  (if (or (nth 4 ostate))
	      (c++-indent-line))
	  (if (or (nth 3 state))
	      (forward-line 1)
	    (setq inner-loop-done t)))
	(if (<= next-depth 0)
	    (setq outer-loop-done t))
	(if outer-loop-done
	    nil
	  ;; If this line had ..))) (((.. in it, pop out of the levels
	  ;; that ended anywhere in this line, even if the final depth
	  ;; doesn't indicate that they ended.
	  (while (> last-depth (nth 6 state))
	    (setq indent-stack (cdr indent-stack)
		  contain-stack (cdr contain-stack)
		  last-depth (1- last-depth)))
	  (if (/= last-depth next-depth)
	      (setq last-sexp nil))
	  ;; Add levels for any parens that were started in this line.
	  (while (< last-depth next-depth)
	    (setq indent-stack (cons nil indent-stack)
		  contain-stack (cons nil contain-stack)
		  last-depth (1+ last-depth)))
	  (if (null (car contain-stack))
	      (setcar contain-stack (or (car (cdr state))
					(save-excursion (forward-sexp -1)
							(point)))))
	  (forward-line 1)
	  (skip-chars-forward " \t")
	  (if (eolp)
	      nil
	    (if (and (car indent-stack)
		     (>= (car indent-stack) 0))
		;; Line is on an existing nesting level.
		;; Lines inside parens are handled specially.
		(if (/= (char-after (car contain-stack)) ?{)
		    (setq this-indent (car indent-stack))
		  ;; Line is at statement level.
		  ;; Is it a new statement?  Is it an else?
		  ;; Find last non-comment character before this line
		  (save-excursion
		    (setq at-else (looking-at "else\\W"))
		    (setq at-brace (= (following-char) ?{))
		    (c++-backward-to-noncomment opoint)
		    (if (not (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?{)))
			;; Preceding line did not end in comma or semi;
			;; indent this line  c-continued-statement-offset
			;; more than previous.
			(progn
			  (c-backward-to-start-of-continued-exp
			   (car contain-stack))
			  (setq this-indent
				(+ c-continued-statement-offset
				   (current-column)
				   (if at-brace c-continued-brace-offset 0))))
		      ;; Preceding line ended in comma or semi;
		      ;; use the standard indent for this level.
		      (if at-else
			  (progn (c-backward-to-start-of-if opoint)
				 (setq this-indent (current-indentation)))
			(setq this-indent (car indent-stack))))))
	      ;; Just started a new nesting level.
	      ;; Compute the standard indent for this level.
	      (let ((val (c++-calculate-indent
			  (if (car indent-stack)
			      (- (car indent-stack))))))
		(setcar indent-stack
			(setq this-indent val))))
	    ;; Adjust line indentation according to its contents
	    (if (looking-at "\\(public\\|private\\|protected\\):")
		(setq this-indent (- this-indent c-indent-level)))
	    (if (or (looking-at "case[ \t]")
		    (and (looking-at "[A-Za-z]")
			 (save-excursion
			   (forward-sexp 1)
			   (looking-at ":[^:]"))))
		(setq this-indent (max 0 (+ this-indent c-label-offset))))
	    (if (looking-at "friend[ \t]class[ \t]")
		(setq this-indent (+ this-indent c++-friend-offset)))
	    (if (= (following-char) ?})
		(setq this-indent (- this-indent c-indent-level)))
	    (if (= (following-char) ?{)
		(setq this-indent (+ this-indent c-brace-offset)))
	    ;; Put chosen indentation into effect.
	    (or (= (current-column) this-indent)
		(= (following-char) ?\#)
		(progn
		  (delete-region (point) (progn (beginning-of-line) (point)))
		  (indent-to this-indent)))
	    ;; Indent any comment following the text.
	    (or (looking-at comment-start-skip)
		(if (re-search-forward
		     comment-start-skip
		     (save-excursion (end-of-line) (point)) t)
		    (progn (indent-for-comment) (beginning-of-line))))))))))

(defun c++-fill-C-comment ()
  "Fill a C style comment."
  (interactive)
  (save-excursion
    (let ((save fill-prefix))
      (beginning-of-line 1)
      (save-excursion
	(re-search-forward comment-start-skip
			   (save-excursion (end-of-line) (point))
			   t)
	(goto-char (match-end 0))
	(set-fill-prefix))
      (while (looking-at fill-prefix)
	(forward-line -1))
      (forward-line 1)
      (insert-string "\n")
      (fill-paragraph nil)
      (delete-char -1)
      (setq fill-prefix save))))

(defun c++-point-bol ()
  "Returns the value of the point at the beginning of the current
line."
  (save-excursion
    (beginning-of-line)
    (point)))

(defun c++-insert-header ()
  "Insert header denoting C++ code at top of buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "// "
	    "This may look like C code, but it is really "
	    "-*- C++ -*-"
	    "\n\n")))


;;; this page contains functions which try to tame single quotes in
;;; comment regions

(defun c++-tame-comments ()
  "Backslashifies all single quotes in comment regions found in the buffer.
This is the best available workaround for an emacs syntax bug in
scan-lists which exists at least as recently as v18.58"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "[^\\][][{}()']" (point-max) 'move)
      (if (c++-in-comment-p)
	  (progn (forward-char -1)
		 (insert "\\"))))))


;;; This page covers "macroization;" making C++ parameterized types
;;; via macros.

(defvar c++-default-macroize-column 78
  "*Place to insert backslashes.")

(defun c++-macroize-region (from to arg)
  "Insert backslashes at end of every line in region.  Useful for defining cpp
macros.  If called with negative argument, will remove trailing backslashes,
so that indentation will work right."
  (interactive "r\np")
  (save-excursion
    (goto-char from)
    (beginning-of-line 1)
    (let ((line (count-lines (point-min) (point)))
	  (to-line (save-excursion (goto-char to)
				   (count-lines (point-min) (point)))))
      (while (< line to-line)
	(c++-backslashify-current-line (> arg 0))
	(forward-line 1) (setq line (1+ line))))))

(defun c++-backslashify-current-line (doit)
  "Backslashifies current line."
  (end-of-line 1)
  (cond
   (doit
    ;; Note that "\\\\" is needed to get one backslash.
    (if (not (save-excursion (forward-char -1) (looking-at "\\\\")))
	(progn
	  (if (>= (current-column) c++-default-macroize-column)
	      (insert " \\")
	    (while (<= (current-column) c++-default-macroize-column)
	      (insert "\t") (end-of-line))
	    (delete-char -1)
	    (while (< (current-column) c++-default-macroize-column)
	      (insert " ") (end-of-line))
	    (insert "\\")))))
   (t
    (forward-char -1)
    (if (looking-at "\\\\")
	(progn (skip-chars-backward " \t")
	       (kill-line))))))


;;; This page covers commenting out multiple lines.

(defun c++-comment-region ()
  "Comment out all lines in a region between mark and current point by
inserting \"// \" (comment-start)in front of each line."
  (interactive)
  (let* ((m      (if (eq (mark) nil) (error "Mark is not set!") (mark)))
	 (start  (if (< (point) m) (point) m))
	 (end    (if (> (point) m) (point) m))
	 (mymark (copy-marker end)))
    (save-excursion
	(goto-char start)
	(while (< (point) (marker-position mymark))
	    (beginning-of-line)
	    (insert comment-start)
	    (beginning-of-line)
	    (forward-line 1)))))

(defun c++-uncomment-region ()
  "Uncomment all lines in region between mark and current point by deleting
the leading \"// \" from each line, if any."
  (interactive)
  (let* ((m      (if (eq (mark) nil) (error "Mark is not set!") (mark)))
	 (start  (if (< (point) m) (point) m))
	 (end    (if (> (point) m) (point) m))
	 (mymark (copy-marker end))
	 (len    (length comment-start))
	 (char   (string-to-char comment-start)))
    (save-excursion
	(goto-char start)
	(while (< (point) (marker-position mymark))
	    (beginning-of-line)
	    (if (looking-at (concat " *" comment-start))
		(progn
		  (zap-to-char 1 char)
		  (delete-char len)))
	    (beginning-of-line)
	    (forward-line 1)))))

;;; Below are two regular expressions that attempt to match defuns
;;; "strongly" and "weakly."  The strong one almost reconstructs the
;;; grammar of C++; the weak one just figures anything id or curly on
;;; the left begins a defun.  The constant "c++-match-header-strongly"
;;; determines which to use; the default is the weak one.

(defvar c++-match-header-strongly nil
  "*If NIL, use c++-defun-header-weak to identify beginning of definitions,
if nonNIL, use c++-defun-header-strong")

(defvar c++-defun-header-strong-struct-equivs "\\(class\\|struct\\|enum\\)"
  "Regexp to match names of structure declaration blocks in C++")

(defconst c++-defun-header-strong
  (let*
      (; valid identifiers
       ;; There's a real wierdness here -- if I switch the below
       (id "\\(\\w\\|_\\)+")
       ;; to be
       ;; (id "\\(_\\|\\w\\)+")
       ;; things no longer work right.  Try it and see!

       ; overloadable operators
       (op-sym1
	 "[---+*/%^&|~!=<>]\\|[---+*/%^&|<>=!]=\\|<<=?\\|>>=?")
       (op-sym2
	 "&&\\|||\\|\\+\\+\\|--\\|()\\|\\[\\]")	 
       (op-sym (concat "\\(" op-sym1 "\\|" op-sym2 "\\)"))
       ; whitespace
       (middle "[^\\*]*\\(\\*+[^/\\*][^\\*]*\\)*")
       (c-comment (concat "/\\*" middle "\\*+/"))
       (wh (concat "\\(\\s \\|\n\\|//.*$\\|" c-comment "\\)"))
       (wh-opt (concat wh "*"))
       (wh-nec (concat wh "+"))
       (oper (concat "\\(" "operator" "\\("
		     wh-opt op-sym "\\|" wh-nec id "\\)" "\\)"))
       (dcl-list "([^():]*)")
       (func-name (concat "\\(" oper "\\|" id "::" id "\\|" id "\\)"))
       (inits
	 (concat "\\(:"
		 "\\(" wh-opt id "(.*\\()" wh-opt "," "\\)\\)*"
		 wh-opt id "(.*)" wh-opt "{"
		 "\\|" wh-opt "{\\)"))
       (type-name (concat
		    "\\(" c++-defun-header-strong-struct-equivs wh-nec "\\)?"
		    id))
       (type (concat "\\(const" wh-nec "\\)?"
		     "\\(" type-name "\\|" type-name wh-opt "\\*+" "\\|"
		     type-name wh-opt "&" "\\)"))
       (modifier "\\(inline\\|virtual\\|overload\\|auto\\|static\\)")
       (modifiers (concat "\\(" modifier wh-nec "\\)*"))
       (func-header
	 ;;     type               arg-dcl
	 (concat modifiers type wh-nec func-name wh-opt dcl-list wh-opt inits))
       (inherit (concat "\\(:" wh-opt "\\(public\\|private\\)?"
			wh-nec id "\\)"))
       (cs-header (concat
		    c++-defun-header-strong-struct-equivs
		    wh-nec id wh-opt inherit "?" wh-opt "{")))
    (concat "^\\(" func-header "\\|" cs-header "\\)"))
  "Strongly-defined regexp to match beginning of structure or
function definition.")


;; This part has to do with recognizing defuns.

;; The weak convention we will use is that a defun begins any time
;; there is a left curly brace, or some identifier on the left margin,
;; followed by a left curly somewhere on the line.  (This will also
;; incorrectly match some continued strings, but this is after all
;; just a weak heuristic.)  Suggestions for improvement (short of the
;; strong scheme shown above) are welcomed.

(defconst c++-defun-header-weak "^{\\|^[_a-zA-Z].*{"
  "Weakly-defined regexp to match beginning of structure or function definition.")


(defun c++-beginning-of-defun (arg)
  (interactive "p")
  (let ((c++-defun-header (if c++-match-header-strongly
			      c++-defun-header-strong
			    c++-defun-header-weak)))
    (cond ((or (= arg 0) (and (> arg 0) (bobp))) nil)
	  ((and (not (looking-at c++-defun-header))
		(let ((curr-pos (point))
		      (open-pos (if (search-forward "{" nil 'move)
				    (point)))
		      (beg-pos
			(if (re-search-backward c++-defun-header nil 'move)
			    (match-beginning 0))))
		  (if (and open-pos beg-pos
			   (< beg-pos curr-pos)
			   (> open-pos curr-pos))
		      (progn
			(goto-char beg-pos)
			(if (= arg 1) t nil));; Are we done?
		    (goto-char curr-pos)
		    nil))))
	  (t
	    (if (and (looking-at c++-defun-header) (not (bobp)))
		(forward-char (if (< arg 0) 1 -1)))
	    (and (re-search-backward c++-defun-header nil 'move (or arg 1))
		 (goto-char (match-beginning 0)))))))


(defun c++-end-of-defun (arg)
  (interactive "p")
  (let ((c++-defun-header (if c++-match-header-strongly
			      c++-defun-header-strong
			    c++-defun-header-weak)))
    (if (and (eobp) (> arg 0))
	nil
      (if (and (> arg 0) (looking-at c++-defun-header)) (forward-char 1))
      (let ((pos (point)))
	(c++-beginning-of-defun 
	  (if (< arg 0)
	      (- (- arg (if (eobp) 0 1)))
	    arg))
	(if (and (< arg 0) (bobp))
	    t
	  (if (re-search-forward c++-defun-header nil 'move)
	      (progn (forward-char -1)
		     (forward-sexp)
		     (beginning-of-line 2)))
	  (if (and (= pos (point)) 
		   (re-search-forward c++-defun-header nil 'move))
	      (c++-end-of-defun 1))))
      t)))

(defun c++-indent-defun ()
  "Indents the current function def, struct or class decl."
  (interactive)
  (let ((restore (point)))
    (c++-end-of-defun 1)
    (beginning-of-line 1)
    (let ((end (make-marker)))
      (set-marker end (point))
      (c++-beginning-of-defun 1)
      (while (and (< (point) end))
	(c++-indent-line)
	(forward-line 1)
	(beginning-of-line 1))
      (set-marker end nil))
    (goto-char restore)))


;; this page is provided for bug reports. it dumps the entire known
;; state of c++-mode so that I know exactly how you've got it set up.

(defconst c++-version "$Revision: 2.40 $"
  "c++-mode version number.")

(defun c++-dump-state ()
  "Inserts into the c++-mode-state-buffer the current state of
c++-mode into the bug report mail buffer.

Use \\[c++-submit-bug-report] to submit a bug report."
  (let ((buffer (current-buffer))
	(varlist (list 'c++-continued-member-init-offset
		       'c++-member-init-indent
		       'c++-friend-offset
		       'c++-empty-arglist-indent
		       'c++-comment-only-line-offset
		       'c++-cleanup-}-else-{-p
		       'c++-hanging-braces
		       'c++-hanging-member-init-colon
		       'c++-mode-line-format
		       'c++-auto-hungry-initial-state
		       'c++-auto-hungry-toggle
		       'c++-hungry-delete-key
		       'c++-auto-newline
		       'c++-default-macroize-column
		       'c++-match-header-strongly
		       'c++-defun-header-strong-struct-equivs
		       'c++-tab-always-indent
		       'c-indent-level
		       'c-continued-statement-offset
		       'c-continued-brace-offset
		       'c-brace-offset
		       'c-brace-imaginary-offset
		       'c-argdecl-indent
		       'c-label-offset
		       'tab-width
		       )))
    (set-buffer buffer)
    (insert (emacs-version) "\n")
    (insert "c++-mode.el " c++-version
	    "\n\ncurrent state:\n==============\n(setq\n")
    (mapcar
     (function
      (lambda (varsym)
	(let ((val (eval varsym))
	      (sym (symbol-name varsym)))
	  (insert "     " sym " "
		  (if (or (listp val) (symbolp val)) "'" "")
		  (prin1-to-string val)
		  "\n"))))
     varlist)
    (insert "     )\n")))

(defun c++-submit-bug-report ()
  "Submit via mail a bug report using the mailer in c++-mailer."
  (interactive)
  (funcall c++-mailer)
  (insert c++-mode-help-address)
  (if (re-search-forward "^subject:[ \t]+" (point-max) 'move)
      (insert "Bug in c++-mode.el " c++-version))
  (if (not (re-search-forward mail-header-separator (point-max) 'move))
      (progn (goto-char (point-max))
	     (insert "\n" mail-header-separator "\n")
	     (goto-char (point-max)))
    (forward-line 1))
  (set-mark (point))			;user should see mark change
  (insert "\n\n")
  (c++-dump-state)
  (exchange-point-and-mark))
