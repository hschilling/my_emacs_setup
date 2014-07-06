;;; loaddefs.el,v 1.89 1998/09/27 07:50:31 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Auto-updated autoloads for everything.
;;;
;;; Do not edit; this file is automatically maintained by
;;; `ttn-update-autoload-file' (which should be invoked anytime
;;; something changes).


;;;### (autoloads (adhoc-clean-up adhoc-search-forward adhoc-find-file adhoc-display) "adhoc" "low-stress/adhoc.el" (13837 56842))
;;; Generated autoloads from low-stress/adhoc.el

(autoload (quote adhoc-display) "adhoc" "\
Displays output STRING using `adhoc-output', then wait.
Optional arg SPEEDUP is a numeric factor used to scale the wait time.
The waiting time is calculated from the length of STRING." nil nil)

(autoload (quote adhoc-find-file) "adhoc" "\
Find FILE and add it to `adhoc-temp-buffers'." nil nil)

(autoload (quote adhoc-search-forward) "adhoc" "\
Search forward for STRING, move to bol, and recenter at line 1.
If optional second arg LINE is a number, recenter there instead.
If optional third arg NO-BOL is non-nil, don't move to beginning of line.
If optional fourth arg NO-RECENTER is non-nil, don't recenter." nil nil)

(autoload (quote adhoc-clean-up) "adhoc" "\
Kill the `adhoc-output-buffer' as well as all `adhoc-temp-buffers'.
Also, delete that window and then reset `adhoc-temp-buffers'." nil nil)

(or (assoc "\\.adhoc\\'" auto-mode-alist) (setq auto-mode-alist (cons (quote ("\\.adhoc\\'" . emacs-lisp-mode)) auto-mode-alist)))

;;;***

;;;### (autoloads (ttn-make-readme-files ttn-make-subdirs-file ttn-make-autoload-file ttn-make ttn-with-RCS-file) "admin" "admin.el" (13818 16042))
;;; Generated autoloads from admin.el

(autoload (quote ttn-with-RCS-file) "admin" "\
For RCS locked FILE, execute BODY.
FILE is passed through `expand-file-name'.
Before BODY, assert no one is locking FILE and then check it out.
After BODY, check FILE back in even if it has not changed.
If there is no RCS version control, warn but do BODY anyway." nil (quote macro))

(autoload (quote ttn-make) "admin" "\
Call make -C $ttn-elisp-home ARGS.  ARGS is a string." t nil)

(autoload (quote ttn-make-autoload-file) "admin" "\
Make lisp/loaddefs.el consulting this and children directories." t nil)

(autoload (quote ttn-make-subdirs-file) "admin" "\
Make ttn-subdirs.el." t nil)

(autoload (quote ttn-make-readme-files) "admin" "\
Make the README files in each of `ttn-subdirs' using per-file code." t nil)

;;;***

;;;### (autoloads (ae) "ae" "low-stress/ae.el" (13837 57349))
;;; Generated autoloads from low-stress/ae.el

(autoload (quote ae) "ae" "\
Kicks off an auto-editing session.  Wow." t nil)

;;;***

;;;### (autoloads (another-line) "another-line" "low-stress/another-line.el" (13837 57369))
;;; Generated autoloads from low-stress/another-line.el

(autoload (quote another-line) "another-line" "\
Copies line, preserving cursor column, and increments any numbers found.
This should probably be generalized in the future." t nil)

;;;***

;;;### (autoloads (append-to-nth-buffer) "append-to-nth-buffer" "low-stress/append-to-nth-buffer.el" (13837 57385))
;;; Generated autoloads from low-stress/append-to-nth-buffer.el

(autoload (quote append-to-nth-buffer) "append-to-nth-buffer" "\
Append to specified buffer the text of the region.
It is inserted into that buffer before its point.

When calling from a program, give three arguments:
START, END and WHICH.
START and END specify the portion of the current buffer to be copied.
WHICH is a prefix argument interpreted as an index into the buffer-list.
  When no argument is given, the target buffer is the next one down." t nil)

;;;***

;;;### (autoloads (backward-page-ignore-narrow) "backward-page-ignore-narrow" "low-stress/backward-page-ignore-narrow.el" (13837 57417))
;;; Generated autoloads from low-stress/backward-page-ignore-narrow.el

(autoload (quote backward-page-ignore-narrow) "backward-page-ignore-narrow" "\
Like `backward-page', except ignores page narrowing." t nil)

;;;***

;;;### (autoloads (bg-shell-command) "bg-shell-command" "low-stress/bg-shell-command.el" (13837 57430))
;;; Generated autoloads from low-stress/bg-shell-command.el

(autoload (quote bg-shell-command) "bg-shell-command" "\
Do shell CMD in background, renaming controlling buffer.
If optional arg WATCH non-nil, switch to that buffer, otherwise show nothing." t nil)

;;;***

;;;### (autoloads (blink) "blink" "low-stress/blink.el" (13837 57438))
;;; Generated autoloads from low-stress/blink.el

(autoload (quote blink) "blink" "\
Opens a window w/ BEAM text on it around point.
Ultimately, BEAM can be anything that `read' takes.  (Currently, some options
unimplemented.)" t nil)

;;;***

;;;### (autoloads (blist bnum) "bnum" "low-stress/bnum.el" (13837 57454))
;;; Generated autoloads from low-stress/bnum.el

(autoload (quote bnum) "bnum" "\
Returns positive number N represented in boolean, as a string." nil nil)

(autoload (quote blist) "bnum" "\
Returns list of positive NUMS represented in boolean, as a string." nil nil)

;;;***

;;;### (autoloads (border) "border" "low-stress/border.el" (13837 57462))
;;; Generated autoloads from low-stress/border.el

(autoload (quote border) "border" "\
Find sublist, using ELEM of LST, where ELEM is the cadr.  Test w/ equal." nil nil)

;;;***

;;;### (autoloads (brb) "brb" "low-stress/brb.el" (13837 57469))
;;; Generated autoloads from low-stress/brb.el

(autoload (quote brb) "brb" "\
Don't use my cnxn, man!" t nil)

;;;***

;;;### (autoloads (c-macro-expand-and-clean) "c-macro-expand-and-clean" "low-stress/c-macro-expand-and-clean.el" (13837 57498))
;;; Generated autoloads from low-stress/c-macro-expand-and-clean.el

(autoload (quote c-macro-expand-and-clean) "c-macro-expand-and-clean" "\
Call `c-macro-expand', then do additional cleaning." t nil)

;;;***

;;;### (autoloads (ch-rcs-state) "ch-rcs-state" "low-stress/ch-rcs-state.el" (13837 57508))
;;; Generated autoloads from low-stress/ch-rcs-state.el

(autoload (quote ch-rcs-state) "ch-rcs-state" "\
Set FILE's RCS state to NEW-STATE." t nil)

;;;***

;;;### (autoloads (check-calendar-file) "check-calendar-file" "low-stress/check-calendar-file.el" (13837 57521))
;;; Generated autoloads from low-stress/check-calendar-file.el

(autoload (quote check-calendar-file) "check-calendar-file" "\
should be called only as part of calendar-hook" nil nil)

;;;***

;;;### (autoloads (clone-frame-just-text clone-frame) "clone-frame" "low-stress/clone-frame.el" (13837 57533))
;;; Generated autoloads from low-stress/clone-frame.el

(autoload (quote clone-frame) "clone-frame" nil t nil)

(autoload (quote clone-frame-just-text) "clone-frame" nil t nil)

;;;***

;;;### (autoloads (end-of-code-line beginning-of-code-line) "codeline" "low-stress/codeline.el" (13837 57554))
;;; Generated autoloads from low-stress/codeline.el

(autoload (quote beginning-of-code-line) "codeline" "\
moves point to first non-whitespace char on line, or indents.
second invocation moves point to beginning of line." t nil)

(autoload (quote end-of-code-line) "codeline" "\
moves to end of code line or end of line if comment.
second invocation moves point to end of line." t nil)

;;;***

;;;### (autoloads (dci-maybe-graft dci-prep) "delayed-checkin" "low-stress/delayed-checkin.el" (13837 57613))
;;; Generated autoloads from low-stress/delayed-checkin.el

(autoload (quote dci-prep) "delayed-checkin" "\
Find FILE and make ready for delayed checkin, or signal error.
Ready means: (1) installed revision is discernable, (2) RCS subdirectory
exists under FILE, (3) installed FILE is checked in as a branch of installed
revision, (4) the branch is tagged \"dci-branch\".

See `dci-brnum' for branch number.  The return value is not useful.  If FILE
is already under version control, signal error." t nil)

(autoload (quote dci-maybe-graft) "delayed-checkin" "\
For FILE, if DIR has a dci-branch, graft onto source if ok w/ user." t nil)

;;;***

;;;### (autoloads (describe-this) "describe-this" "low-stress/describe-this.el" (13837 57622))
;;; Generated autoloads from low-stress/describe-this.el

(autoload (quote describe-this) "describe-this" nil nil nil)

;;;***

;;;### (autoloads (dired-compile-last-change-log) "dired-compile-last-change-log" "low-stress/dired-compile-last-change-log.el" (13837 57629))
;;; Generated autoloads from low-stress/dired-compile-last-change-log.el

(autoload (quote dired-compile-last-change-log) "dired-compile-last-change-log" "\
In BUF, make a mail-able last change log.  Used in Dired-under-VC." t nil)

;;;***

;;;### (autoloads (dired-wipe-unseeables) "dired-wipe-unseeables" "low-stress/dired-wipe-unseeables.el" (13837 57643))
;;; Generated autoloads from low-stress/dired-wipe-unseeables.el

(autoload (quote dired-wipe-unseeables) "dired-wipe-unseeables" "\
in dired, don't bother w/ unseeable files/dirs" t nil)

;;;***

;;;### (autoloads (emacs-uptime) "emacs-uptime" "low-stress/emacs-uptime.el" (13837 60254))
;;; Generated autoloads from low-stress/emacs-uptime.el

(autoload (quote emacs-uptime) "emacs-uptime" "\
Gives Emacs' uptime, based on global var `*emacs-start-time*'." t nil)

;;;***

;;;### (autoloads (emacs-version-at-least emacs-type-eq) "emacs-vers" "emacs-vers.el" (13787 21927))
;;; Generated autoloads from emacs-vers.el

(autoload (quote emacs-type-eq) "emacs-vers" nil nil nil)

(autoload (quote emacs-version-at-least) "emacs-vers" nil nil nil)

;;;***

;;;### (autoloads (eval-expr eval-expr-install) "eval-expr" "import/eval-expr.el" (13767 27575))
;;; Generated autoloads from import/eval-expr.el

(defvar eval-expr-error-message-delay 3 "\
*Amount of time, in seconds, to display in echo area before continuing.")

(defvar eval-expr-prompt "Eval: " "\
*Prompt used by eval-expr.")

(defvar eval-expr-honor-debug-on-error t "\
*If non-nil, do not trap evaluation errors.
Instead, allow errors to throw user into the debugger, provided
debug-on-error specifies that the particular error is a debuggable condition.")

(defvar eval-expr-print-level (default-value (quote print-level)) "\
*Like print-level, but affect results printed by `eval-expr' only.")

(defvar eval-expr-print-length (default-value (quote print-length)) "\
*Like print-length, but affect results printed by `eval-expr' only.")

(autoload (quote eval-expr-install) "eval-expr" "\
Replace standard eval-expression command with enhanced eval-expr." t nil)

(autoload (quote eval-expr) "eval-expr" "\
Evaluate EXPRESSION and print value in minibuffer, temp, or current buffer.
A temp output buffer is used if there is more than one line in the
evaluated result.
If invoked with a prefix arg, or second lisp argument EE::INSERT-VALUE is
non-nil, then insert final value into the current buffer at point.

Value is also consed on to front of the variable `values'." t nil)

;;;***

;;;### (autoloads (eval-last-page maybe-eval-last-page) "eval-last-page" "low-stress/eval-last-page.el" (13837 57664))
;;; Generated autoloads from low-stress/eval-last-page.el
 (add-hook 'find-file-hooks 'maybe-eval-last-page t)

(autoload (quote maybe-eval-last-page) "eval-last-page" "\
Checks local var `eval-last-page', and if set, calls `eval-last-page'." nil nil)

(autoload (quote eval-last-page) "eval-last-page" "\
Evals last page as LISP code, then narrows to next-to-last page.
Runs hook `eval-last-page-after-narrow-hook' if defined." t nil)

;;;***

;;;### (autoloads (find-files) "find-files" "prog-env/find-files.el" (13837 57154))
;;; Generated autoloads from prog-env/find-files.el

(autoload (quote find-files) "find-files" "\
Selectively do `find-file' on find(1) output using FIND-WILDCARD.
Find(1) is invokedf from the current working directory.
Selection is interactive: `y' or `SPC' accepts, `n' or `DEL' rejects,
`.' accepts then stops, `!' accepts the rest, `q' just stops." t nil)

;;;***

;;;### (autoloads (find-many-files) "find-many-files" "low-stress/find-many-files.el" (13837 57669))
;;; Generated autoloads from low-stress/find-many-files.el

(autoload (quote find-many-files) "find-many-files" "\
opens all the files in current directory or in DIR if non-nil" t nil)

;;;***

;;;### (autoloads (fortunate-loop) "fortunate-loop" "low-stress/fortunate-loop.el" (13837 57676))
;;; Generated autoloads from low-stress/fortunate-loop.el

(autoload (quote fortunate-loop) "fortunate-loop" "\
Spews fortunes until user input." t nil)

;;;***

;;;### (autoloads (forward-page-ignore-narrow) "forward-page-ignore-narrow" "low-stress/forward-page-ignore-narrow.el" (13837 57695))
;;; Generated autoloads from low-stress/forward-page-ignore-narrow.el

(autoload (quote forward-page-ignore-narrow) "forward-page-ignore-narrow" "\
Like `forward-page', except ignores page narrowing." t nil)

;;;***

;;;### (autoloads (from) "from" "low-stress/from.el" (13837 57702))
;;; Generated autoloads from low-stress/from.el

(autoload (quote from) "from" "\
Where's the mail coming from?" t nil)

;;;***

;;;### (autoloads (hs-minor-mode hs-mouse-toggle-hiding hs-hide-all hs-show-hidden-short-form hs-hide-comments-when-hiding-all) "fsf-1.27-hideshow" "fsf-1.27-hideshow.el" (13826 11396))
;;; Generated autoloads from fsf-1.27-hideshow.el

(defvar hs-hide-comments-when-hiding-all t "\
Hide the comments too when you do an `hs-hide-all'.")

(defvar hs-show-hidden-short-form t "\
Leave only the first line visible in a hidden block.
If non-nil only the first line is visible when a block is in the
hidden state, else both the first line and the last line are shown.
A nil value disables `hs-adjust-block-beginning', which see.

An example of how this works: (in C mode)
original:

  /* My function main
     some more stuff about main
  */
  int
  main(void)
  {
    int x=0;
    return 0;
  }


hidden and `hs-show-hidden-short-form' is nil
  /* My function main...
  */
  int
  main(void)
  {...
  }

hidden and `hs-show-hidden-short-form' is t
  /* My function main...
  int
  main(void)...

For the last case you have to be on the line containing the
ellipsis when you do `hs-show-block'.")

(defvar hs-special-modes-alist (quote ((c-mode "{" "}" nil nil hs-c-like-adjust-block-beginning) (c++-mode "{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning) (java-mode "\\(\\(\\([ 	]*\\(\\(abstract\\|final\\|native\\|p\\(r\\(ivate\\|otected\\)\\|ublic\\)\\|s\\(tatic\\|ynchronized\\)\\)[ 	\n]+\\)*[.a-zA-Z0-9_:]+[ 	\n]*\\(\\[[ 	\n]*\\][ 	\n]*\\)?\\([a-zA-Z0-9_:]+[ 	\n]*\\)([^)]*)\\([ \n	]+throws[ 	\n][^{]+\\)?\\)\\|\\([ 	]*static[^{]*\\)\\)[ 	\n]*{\\)" "}" "/[*/]" java-hs-forward-sexp hs-c-like-adjust-block-beginning))) "\
*Alist for initializing the hideshow variables for different modes.
It has the form
  (MODE START END COMMENT-START FORWARD-SEXP-FUNC ADJUST-BEG-FUNC).
If present, hideshow will use these values as regexps for start, end
and comment-start, respectively.  Since Algol-ish languages do not have
single-character block delimiters, the function `forward-sexp' used
by hideshow doesn't work.  In this case, if a similar function is
available, you can register it and have hideshow use it instead of
`forward-sexp'.  See the documentation for `hs-adjust-block-beginning'
to see what is the use of ADJUST-BEG-FUNC.

If any of those is left nil, hideshow will try to guess some values
using function `hs-grok-mode-type'.

Note that the regexps should not contain leading or trailing whitespace.")

(autoload (quote hs-hide-all) "fsf-1.27-hideshow" "\
Hide all top-level blocks, displaying only first and last lines.
Move point to the beginning of the line, and it run the normal hook
`hs-hide-hook'.  See documentation for `run-hooks'.
If `hs-hide-comments-when-hiding-all' is t, also hide the comments." t nil)

(autoload (quote hs-mouse-toggle-hiding) "fsf-1.27-hideshow" "\
Toggle hiding/showing of a block.
Should be bound to a mouse key." t nil)

(autoload (quote hs-minor-mode) "fsf-1.27-hideshow" "\
Toggle hideshow minor mode.
With ARG, turn hideshow minor mode on if ARG is positive, off otherwise.
When hideshow minor mode is on, the menu bar is augmented with hideshow
commands and the hideshow commands are enabled.
The value '(hs . t) is added to `buffer-invisibility-spec'.
Last, the normal hook `hs-minor-mode-hook' is run; see the doc
for `run-hooks'.

The main commands are: `hs-hide-all', `hs-show-all', `hs-hide-block',
`hs-show-block', `hs-hide-level' and `hs-show-region'.
Also see the documentation for the variable `hs-show-hidden-short-form'.

Turning hideshow minor mode off reverts the menu bar and the
variables to default values and disables the hideshow commands.

Key bindings:
\\{hs-minor-mode-map}" t nil)

;;;***

;;;### (autoloads (give-me-a-scratch-buffer-now) "give-me-a-scratch-buffer-now" "low-stress/give-me-a-scratch-buffer-now.el" (13837 57709))
;;; Generated autoloads from low-stress/give-me-a-scratch-buffer-now.el

(autoload (quote give-me-a-scratch-buffer-now) "give-me-a-scratch-buffer-now" "\
Bring up *scratch* or younger siblings if prefixed." t nil)

;;;***

;;;### (autoloads (glf glt go) "go" "prog-env/go.el" (13837 57168))
;;; Generated autoloads from prog-env/go.el

(autoload (quote go) "go" "\
Go.  With prefix arg, do in the background; don't pop to command buffer." t nil)

(autoload (quote glt) "go" "\
Set \"load\" bit in `go-file' to true.  See var `go-file'." t nil)

(autoload (quote glf) "go" "\
Set \"load\" bit in `go-file' to false.  See var `go-file'." t nil)

;;;***

;;;### (autoloads (gud-cont-redisplay) "gud-cont-display" "low-stress/gud-cont-display.el" (13837 57745))
;;; Generated autoloads from low-stress/gud-cont-display.el

(autoload (quote gud-cont-redisplay) "gud-cont-display" "\
Invoke `gud-cont' then sit for INTERVAL seconds.  Loop until user input." t nil)

;;;***

;;;### (autoloads (gzip-or-gunzip-from-dired) "gzip-or-gunzip-from-dired" "low-stress/gzip-or-gunzip-from-dired.el" (13837 57757))
;;; Generated autoloads from low-stress/gzip-or-gunzip-from-dired.el

(autoload (quote gzip-or-gunzip-from-dired) "gzip-or-gunzip-from-dired" "\
gzip or gunzip.  (only from dired)" t nil)

;;;***

;;;### (autoloads (help-show-headers) "help-show-headers" "prog-env/help-show-headers.el" (13837 57194))
;;; Generated autoloads from prog-env/help-show-headers.el

(autoload (quote help-show-headers) "help-show-headers" "\
Accumulate headers into a selection window, w/ buffer name *Headers*.
In the selection window, typing `q' closes the window.
Typing SPC or RET jumps to the header at point and closes the window.
Typing `n' or `p' moves respectively to next and previous headers, keeping
both windows open.  After `help-show-headers-timeout' seconds, the selection
window is closed.

Headers start with a regexp formed by concatenating `comment-start' with a
string of dashes that goes to the end of the line.  The selection window
displays the line immediately after this regexp.  For example, if the buffer
looks like:

   ;;----------------------------
   ;; user-config vars go here

   ...

   ;;----------------------------
   ;; actual code

   ...

you will see

   ;; user-config vars go here
   ;; actual code

in the selection window." t nil)
 (define-key help-mode-map "h" 'help-show-headers)
 (global-set-key "\C-hh" 'help-show-headers)

;;;***

;;;### (autoloads (hs-minor-mode hs-mouse-toggle-hiding hs-hide-all hs-buffer-state-saving hs-show-hidden-short-form hs-hide-comments-when-hiding-all) "hideshow" "hideshow.el" (13836 27163))
;;; Generated autoloads from hideshow.el

(defvar hs-hide-comments-when-hiding-all t "\
Hide the comments too when you do an `hs-hide-all'.")

(defvar hs-show-hidden-short-form t "\
Leave only the first line visible in a hidden block.
If non-nil only the first line is visible when a block is in the
hidden state, else both the first line and the last line are shown.
A nil value disables `hs-adjust-block-beginning', which see.

An example of how this works: (in C mode)
original:

  /* My function main
     some more stuff about main
  */
  int
  main(void)
  {
    int x=0;
    return 0;
  }


hidden and `hs-show-hidden-short-form' is nil
  /* My function main...
  */
  int
  main(void)
  {...
  }

hidden and `hs-show-hidden-short-form' is t
  /* My function main...
  int
  main(void)...

For the last case you have to be on the line containing the
ellipsis when you do `hs-show-block'.")

(defvar hs-special-modes-alist (quote ((c-mode "{" "}" nil nil hs-c-like-adjust-block-beginning) (c++-mode "{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning) (java-mode "\\(\\(\\([ 	]*\\(\\(abstract\\|final\\|native\\|p\\(r\\(ivate\\|otected\\)\\|ublic\\)\\|s\\(tatic\\|ynchronized\\)\\)[ 	\n]+\\)*[.a-zA-Z0-9_:]+[ 	\n]*\\(\\[[ 	\n]*\\][ 	\n]*\\)?\\([a-zA-Z0-9_:]+[ 	\n]*\\)([^)]*)\\([ \n	]+throws[ 	\n][^{]+\\)?\\)\\|\\([ 	]*static[^{]*\\)\\)[ 	\n]*{\\)" "}" "/[*/]" java-hs-forward-sexp hs-c-like-adjust-block-beginning))) "\
*Alist for initializing the hideshow variables for different modes.
It has the form
  (MODE START END COMMENT-START FORWARD-SEXP-FUNC ADJUST-BEG-FUNC).
If present, hideshow will use these values as regexps for start, end
and comment-start, respectively.  Since Algol-ish languages do not have
single-character block delimiters, the function `forward-sexp' used
by hideshow doesn't work.  In this case, if a similar function is
available, you can register it and have hideshow use it instead of
`forward-sexp'.  See the documentation for `hs-adjust-block-beginning'
to see what is the use of ADJUST-BEG-FUNC.

If any of those is left nil, hideshow will try to guess some values
using function `hs-grok-mode-type'.

Note that the regexps should not contain leading or trailing whitespace.")

(defvar hs-buffer-state-saving nil "\
Per buffer, controls if and when hideshow should save state.
Nil means don't save state.  Otherwise, recognized symbols are:

  on-kill  -- Save state on buffer-kill.
  on-write -- Save state on buffer write (includes save-buffer).

Any other value is set to nil.  This variable is buffer-local and should
be set before turning on hideshow.  In the case where a file is read-only,
hideshow will interpret `on-write' as `on-kill'.

Hideshow state information is saved in the `hs-state-file', which see.
Upon a later opening of the file, hideshow will automatically attempt
to restore the state of the file.

You may wish to save and restore state manually with the commands
`hs-save-state' and `hs-restore-state', respectively.  In that case,
it is best to set `hs-buffer-state-saving' to nil.")

(autoload (quote hs-hide-all) "hideshow" "\
Hide all top-level blocks, displaying only first and last lines.
Move point to the beginning of the line, and it run the normal hook
`hs-hide-hook'.  See documentation for `run-hooks'.
If `hs-hide-comments-when-hiding-all' is t, also hide the comments." t nil)

(autoload (quote hs-mouse-toggle-hiding) "hideshow" "\
Toggle hiding/showing of a block.
Should be bound to a mouse key." t nil)

(autoload (quote hs-minor-mode) "hideshow" "\
Toggle hideshow minor mode.
With ARG, turn hideshow minor mode on if ARG is positive, off otherwise.
When hideshow minor mode is on, the menu bar is augmented with hideshow
commands and the hideshow commands are enabled.
The variable `kill-buffer-hook' is made buffer-local and `hs-save-state'
is added to it.
The value '(hs . t) is added to `buffer-invisibility-spec'.
Last, the normal hook `hs-minor-mode-hook' is run; see the doc
for `run-hooks'.

The main commands are: `hs-hide-all', `hs-show-all', `hs-hide-block',
`hs-show-block', `hs-hide-level' and `hs-show-region'.
Also see the documentation for the variable `hs-show-hidden-short-form'.

Turning hideshow minor mode off reverts the menu bar and the
variables to default values and disables the hideshow commands.

Key bindings:
\\{hs-minor-mode-map}" t nil)

;;;***

;;;### (autoloads (idx-of) "idx-of" "low-stress/idx-of.el" (13837 57764))
;;; Generated autoloads from low-stress/idx-of.el

(autoload (quote idx-of) "idx-of" nil nil nil)

;;;***

;;;### (autoloads (insert-separator) "insert-separator" "low-stress/insert-separator.el" (13837 58418))
;;; Generated autoloads from low-stress/insert-separator.el

(autoload (quote insert-separator) "insert-separator" "\
Inserts line of dashes ending using a mode-specific comment prefix.
Because we have MIPS to spare these days (hee hee), why not animate it?" t nil)

;;;***

;;;### (autoloads (insert-time-stamp) "insert-time-stamp" "low-stress/insert-time-stamp.el" (13837 57788))
;;; Generated autoloads from low-stress/insert-time-stamp.el

(autoload (quote insert-time-stamp) "insert-time-stamp" "\
Insert time string in current buffer.  Be verbose w/ prefix arg." t nil)

;;;***

;;;### (autoloads (line-at-point) "line-at-point" "low-stress/line-at-point.el" (13837 57795))
;;; Generated autoloads from low-stress/line-at-point.el

(autoload (quote line-at-point) "line-at-point" "\
Returns current line as a string." t nil)

;;;***

;;;### (autoloads (lisp-dir-retrieve lisp-dir-apropos) "lispdir" "import/lispdir.el" (13486 47118))
;;; Generated autoloads from import/lispdir.el

(autoload (quote lisp-dir-apropos) "lispdir" "\
Display entries in Lisp Code Directory for TOPIC in separate window.
Calls value of lisp-dir-apropos-hook with no args if that value is non-nil." t nil)

(autoload (quote lisp-dir-retrieve) "lispdir" "\
Retrieves a copy of the NAMEd package.  The NAME must be an exact match.
Calls value of lisp-dir-retrieve-hook with no args if that value is non-nil." t nil)

;;;***

;;;### (autoloads (locate) "locate" "low-stress/locate.el" (13837 57811))
;;; Generated autoloads from low-stress/locate.el

(autoload (quote locate) "locate" "\
Do shell command locate(1) w/ ARGS, a string." t nil)

;;;***

;;;### (autoloads (macintosh-word-cleanup) "macintosh-word-cleanup" "low-stress/macintosh-word-cleanup.el" (13837 57821))
;;; Generated autoloads from low-stress/macintosh-word-cleanup.el

(autoload (quote macintosh-word-cleanup) "macintosh-word-cleanup" "\
Replace Macintosh \"Word\" document crap w/ text." t nil)

;;;***

;;;### (autoloads nil "mail-this-buffer" "low-stress/mail-this-buffer.el" (13837 57830))
;;; Generated autoloads from low-stress/mail-this-buffer.el

(fset (quote mail-this-buffer) "h÷ømail")

;;;***

;;;### (autoloads (map-table-3col map-table-2col map-table) "map-table" "low-stress/map-table.el" (13837 57841))
;;; Generated autoloads from low-stress/map-table.el

(autoload (quote map-table) "map-table" "\
Pass first N elements from SEQ as args to FUNC.  Repeat and accumulate." nil nil)

(autoload (quote map-table-2col) "map-table" "\
Apply FUNC to 2-column TABLE, of form (A1 B1 A2 B2 ...)." nil nil)

(autoload (quote map-table-3col) "map-table" "\
Apply FUNC to 3-column TABLE, of form (A1 B1 C1 A2 B2 C2 ...)." nil nil)

;;;***

;;;### (autoloads (paren-activate) "mic-paren" "import/mic-paren.el" (13486 47119))
;;; Generated autoloads from import/mic-paren.el

(autoload (quote paren-activate) "mic-paren" "\
Activates mic-paren parenthesis highlighting.
paren-activate deactivates the paren.el and stig-paren.el packages if they are
active
Options:
  paren-priority
  paren-sexp-mode
  paren-highlight-at-point
  paren-highlight-offscreen
  paren-message-offscreen
  paren-message-no-match
  paren-ding-unmatched
  paren-delay
  paren-dont-touch-blink
  paren-dont-activate-on-load
  paren-face
  paren-mismatch-face" t nil)

;;;***

;;;### (autoloads (multi-shell) "multi-shell" "low-stress/multi-shell.el" (13837 57849))
;;; Generated autoloads from low-stress/multi-shell.el

(autoload (quote multi-shell) "multi-shell" "\
Do `shell', naming buffer based on SHELL-CHOICE, interpreted as prefix arg.
The history for the shell is taken from ~/.multi-shell-history-SHELL-CHOICE.
See documention for `shell'." t nil)

;;;***

;;;### (autoloads (munge-root-window) "munge-root-window" "low-stress/munge-root-window.el" (13837 57856))
;;; Generated autoloads from low-stress/munge-root-window.el

(autoload (quote munge-root-window) "munge-root-window" "\
Display command list and let user choose one by hitting RET.
Use `Electric-command-loop' to receive input." t nil)

;;;***

;;;### (autoloads (my-prog-env) "my-prog-env" "prog-env/my-prog-env.el" (13837 57212))
;;; Generated autoloads from prog-env/my-prog-env.el

(autoload (quote my-prog-env) "my-prog-env" "\
Sets up programming env the way i like it." t nil)
 (defalias 'elm 'emacs-lisp-mode)
 (defalias 'lim 'lisp-interaction-mode)

;;;***

;;;### (autoloads (my-term-fixups) "my-term-fixups" "low-stress/my-term-fixups.el" (13837 57878))
;;; Generated autoloads from low-stress/my-term-fixups.el

(autoload (quote my-term-fixups) "my-term-fixups" "\
if on vt220, sets find to be [C-s] and sets f11 to be really [f11]." nil nil)

;;;***

;;;### (autoloads (narrowed-to-page-p) "narrowed-to-page-p" "low-stress/narrowed-to-page-p.el" (13837 57885))
;;; Generated autoloads from low-stress/narrowed-to-page-p.el

(autoload (quote narrowed-to-page-p) "narrowed-to-page-p" "\
Returns nil if not narrowed to page boundaries." nil nil)

;;;***

;;;### (autoloads (phone) "phone" "low-stress/phone.el" (13837 58436))
;;; Generated autoloads from low-stress/phone.el

(autoload (quote phone) "phone" "\
Looks up name based on NAME-REGEXP in phone database." t nil)

;;;***

;;;### (autoloads (ping) "ping" "low-stress/ping.el" (13837 58450))
;;; Generated autoloads from low-stress/ping.el

(autoload (quote ping) "ping" "\
Ping HOST once a second, interpreting optional prefix arg as INTERVAL." t nil)

;;;***

;;;### (autoloads (praise-emacs) "praise" "low-stress/praise.el" (13837 57970))
;;; Generated autoloads from low-stress/praise.el

(autoload (quote praise-emacs) "praise" "\
Says something in the modeline." t nil)

;;;***

;;;### (autoloads (previous-buffer) "previous-buffer" "low-stress/previous-buffer.el" (13837 57978))
;;; Generated autoloads from low-stress/previous-buffer.el

(autoload (quote previous-buffer) "previous-buffer" "\
switches to previous buffer" t nil)

;;;***

;;;### (autoloads (print-buffer-local-variables) "print-buffer-local-variables" "low-stress/print-buffer-local-variables.el" (13837 57989))
;;; Generated autoloads from low-stress/print-buffer-local-variables.el

(autoload (quote print-buffer-local-variables) "print-buffer-local-variables" "\
Print buffer-local variables.
If interactive, print number of vars.  Return that number in all cases." t nil)

;;;***

;;;### (autoloads (print-previous-revision) "print-previous-revision" "low-stress/print-previous-revision.el" (13837 57996))
;;; Generated autoloads from low-stress/print-previous-revision.el

(autoload (quote print-previous-revision) "print-previous-revision" "\
Print previous revision." t nil)

;;;***

;;;### (autoloads nil "reset-emacs-font" "low-stress/reset-emacs-font.el" (13837 58003))
;;; Generated autoloads from low-stress/reset-emacs-font.el

(fset (quote reset-emacs-font) [24 6 1 11 126 47 46 88 100 101 102 97 117 108 116 115 return 19 120 127 101 109 97 99 115 42 102 111 110 116 58 32 45 2 67108896 5 -134217609 -134217670 40 109 101 115 115 97 103 101 32 34 104 105 34 41 return -134217608 115 101 116 45 100 101 102 tab return 25 return 24 107 return])

;;;***

;;;### (autoloads nil "reset-x-bell" "low-stress/reset-x-bell.el" (13837 58011))
;;; Generated autoloads from low-stress/reset-x-bell.el

(defalias (quote reset-x-bell) (read-kbd-macro "C-x C-f C-a C-k ~/.xsession-common RET C-s b SPC 2*C-s RET C-a C-SPC C-e C-a\n C-SPC C-e M-C-x C-x k RET"))

;;;***

;;;### (autoloads (revert-some-buffers) "revert-some-buffers" "low-stress/revert-some-buffers.el" (13837 58020))
;;; Generated autoloads from low-stress/revert-some-buffers.el

(autoload (quote revert-some-buffers) "revert-some-buffers" "\
Revert each file-related buffer." t nil)

;;;***

;;;### (autoloads (run-guile-gtk run-guile-tcltk run-guile run-like-scheme) "run-guile" "low-stress/run-guile.el" (13837 58041))
;;; Generated autoloads from low-stress/run-guile.el

(autoload (quote run-like-scheme) "run-guile" "\
Run an inferior interpreter PROGRAM using `run-scheme'.
The variable `scheme-buffer' is set to the new buffer." t nil)

(autoload (quote run-guile) "run-guile" "\
Run an inferior guile process using `run-scheme'." t nil)

(autoload (quote run-guile-tcltk) "run-guile" "\
Run an inferior guile-tcltk process using `run-scheme'." t nil)

(autoload (quote run-guile-gtk) "run-guile" "\
Run an inferior guile-gtk process using `run-scheme'." t nil)

;;;***

;;;### (autoloads (saved-shell-command) "saved-shell-command" "low-stress/saved-shell-command.el" (13837 58047))
;;; Generated autoloads from low-stress/saved-shell-command.el

(autoload (quote saved-shell-command) "saved-shell-command" "\
Does a `shell-command', renames buffer, optionally kills it." t nil)

;;;***

;;;### (autoloads (scroll-right-20 scroll-left-20) "scroll-LR-by-20" "low-stress/scroll-LR-by-20.el" (13837 58054))
;;; Generated autoloads from low-stress/scroll-LR-by-20.el

(autoload (quote scroll-left-20) "scroll-LR-by-20" nil t nil)

(autoload (quote scroll-right-20) "scroll-LR-by-20" nil t nil)

;;;***

;;;### (autoloads (set-font-at-point xlsfonts) "set-font-at-point" "low-stress/set-font-at-point.el" (13837 58060))
;;; Generated autoloads from low-stress/set-font-at-point.el

(autoload (quote xlsfonts) "set-font-at-point" "\
Displays xlsfonts(1) output in a buffer.  RET or SPC sets default font." t nil)

(autoload (quote set-font-at-point) "set-font-at-point" "\
Set default font based on point.  Manually re-enters with list if error." t nil)

;;;***

;;;### (autoloads (define-keys global-set-keys local-set-keys) "set-keys" "low-stress/set-keys.el" (13837 58069))
;;; Generated autoloads from low-stress/set-keys.el

(autoload (quote local-set-keys) "set-keys" "\
Like local-set-keys.  TABLE has form (key1 binding1 key2 binding2 ...)." nil nil)

(autoload (quote global-set-keys) "set-keys" "\
Like global-set-keys.  TABLE has form (key1 binding1 key2 binding2 ...)." nil nil)

(autoload (quote define-keys) "set-keys" "\
Modify KEYMAP from TABLE, of form (key1 binding1 key2 binding2 ...)." nil nil)

;;;***

;;;### (autoloads (source-wrap) "source-wrap" "low-stress/source-wrap.el" (13837 58099))
;;; Generated autoloads from low-stress/source-wrap.el

(autoload (quote source-wrap) "source-wrap" "\
Put text around current buffer." t nil)

;;;***

;;;### (autoloads (source-wrap-c++-style) "source-wrap-c++-style" "low-stress/source-wrap-c++-style.el" (13837 58465))
;;; Generated autoloads from low-stress/source-wrap-c++-style.el

(autoload (quote source-wrap-c++-style) "source-wrap-c++-style" "\
Put RCS tags around current buffer in a C++ style." t nil)

;;;***

;;;### (autoloads (source-wrap-elisp-style) "source-wrap-elisp-style" "low-stress/source-wrap-elisp-style.el" (13837 58472))
;;; Generated autoloads from low-stress/source-wrap-elisp-style.el

(autoload (quote source-wrap-elisp-style) "source-wrap-elisp-style" "\
Put RCS tags around current buffer in an elisp style." t nil)

;;;***

;;;### (autoloads (source-wrap-shell-style) "source-wrap-shell-style" "low-stress/source-wrap-shell-style.el" (13837 58481))
;;; Generated autoloads from low-stress/source-wrap-shell-style.el

(autoload (quote source-wrap-shell-style) "source-wrap-shell-style" "\
Put RCS tags around current buffer in a sh(1)-like style." t nil)

;;;***

;;;### (autoloads (split-into-3-windows) "split-into-3-windows" "low-stress/split-into-3-windows.el" (13837 58107))
;;; Generated autoloads from low-stress/split-into-3-windows.el

(autoload (quote split-into-3-windows) "split-into-3-windows" "\
Splits one window into three, highest first.  Optional ARG inverts axis.
Currently, doesn't work while minibuffer is busy." t nil)

;;;***

;;;### (autoloads (strip) "strip" "low-stress/strip.el" (13837 58118))
;;; Generated autoloads from low-stress/strip.el

(autoload (quote strip) "strip" "\
Return a new string derived by stripping whitespace surrounding string S." t nil)

;;;***

;;;### (autoloads (su-shell) "su-shell" "low-stress/su-shell.el" (13837 58126))
;;; Generated autoloads from low-stress/su-shell.el

(autoload (quote su-shell) "su-shell" "\
Runs `multi-shell' w/ superuser privs.
If the buffer already exists, just switch to it.
Otherwise, ask for password and do \"su\".
As a security measure, the password is immediately
overwritten upon use." t nil)

;;;***

;;;### (autoloads (surround-w-if-block) "surround-w-if-block" "low-stress/surround-w-if-block.el" (13837 58133))
;;; Generated autoloads from low-stress/surround-w-if-block.el

(autoload (quote surround-w-if-block) "surround-w-if-block" "\
Surrounds region w/ conditional.  Use prefix arg to specify \"0\",
otherwise the inputted conditional string is automagically upcased and
whitespace replaced w/ underscore.  [Currently, prefix does not work!]" t nil)

;;;***

;;;### (autoloads (symbol-at-point) "symbol-at-point" "low-stress/symbol-at-point.el" (13837 58140))
;;; Generated autoloads from low-stress/symbol-at-point.el

(autoload (quote symbol-at-point) "symbol-at-point" "\
Returns current symbol as a string." t nil)

;;;***

;;;### (autoloads (toggle-case-fold-search) "toggle-vars" "low-stress/toggle-vars.el" (13837 58148))
;;; Generated autoloads from low-stress/toggle-vars.el

(autoload (quote toggle-case-fold-search) "toggle-vars" "\
If `case-fold-search' is currently nil, make it t.  Otherwise make it nil." t nil)

;;;***

;;;### (autoloads (ttn-base64-decode-to-file) "ttn-base64" "low-stress/ttn-base64.el" (13837 55128))
;;; Generated autoloads from low-stress/ttn-base64.el

(autoload (quote ttn-base64-decode-to-file) "ttn-base64" "\
Do base64 decode on region to FILE." t nil)

;;;***

;;;### (autoloads (up-holdcursor down-holdcursor) "tuckey-holdcursor" "tuckey-holdcursor.el" (13787 22761))
;;; Generated autoloads from tuckey-holdcursor.el

(defvar holdcursor-ladder-rung 1 "\
the last arg used for down-holdcursor or up-holdcursor")

(autoload (quote down-holdcursor) "tuckey-holdcursor" nil t nil)

(autoload (quote up-holdcursor) "tuckey-holdcursor" nil t nil)

;;;***

;;;### (autoloads (turn-on-gnuserv) "turn-on-gnuserv" "low-stress/turn-on-gnuserv.el" (13837 58171))
;;; Generated autoloads from low-stress/turn-on-gnuserv.el

(autoload (quote turn-on-gnuserv) "turn-on-gnuserv" "\
Set some variables and then turn on gnuserv." t nil)

;;;***

;;;### (autoloads (turn-on-hilit19) "turn-on-hilit19" "low-stress/turn-on-hilit19.el" (13837 58176))
;;; Generated autoloads from low-stress/turn-on-hilit19.el

(autoload (quote turn-on-hilit19) "turn-on-hilit19" "\
Set some variables and then turn on hilit19." t nil)

;;;***

;;;### (autoloads (turn-on-mic-paren) "turn-on-mic-paren" "low-stress/turn-on-mic-paren.el" (13837 58185))
;;; Generated autoloads from low-stress/turn-on-mic-paren.el

(autoload (quote turn-on-mic-paren) "turn-on-mic-paren" "\
Sets some related variables and then does `paren-activate'." t nil)

;;;***

;;;### (autoloads (turn-on-mouse-avoidance-mode) "turn-on-mouse-avoidance-mode" "low-stress/turn-on-mouse-avoidance-mode.el" (13837 58193))
;;; Generated autoloads from low-stress/turn-on-mouse-avoidance-mode.el

(autoload (quote turn-on-mouse-avoidance-mode) "turn-on-mouse-avoidance-mode" "\
As advertized." t nil)

;;;***

;;;### (autoloads (updating-shell-command) "updating-shell-command" "low-stress/updating-shell-command.el" (13837 58202))
;;; Generated autoloads from low-stress/updating-shell-command.el

(autoload (quote updating-shell-command) "updating-shell-command" "\
In a shell, run CMD every five seconds." t nil)

;;;***

;;;### (autoloads (verilog-mode) "verilog-mode" "import/verilog-mode.el" (13821 43232))
;;; Generated autoloads from import/verilog-mode.el

(autoload (quote verilog-mode) "verilog-mode" "\
Major mode for editing Verilog code. \\<verilog-mode-map>
NEWLINE, TAB indents for Verilog code.  
Delete converts tabs to spaces as it moves back.
Supports highlighting.

Variables controlling indentation/edit style:

 verilog-indent-level           (default 3)
    Indentation of Verilog statements with respect to containing block.
 verilog-indent-level-module    (default 3)
    Absolute indentation of Module level Verilog statements. 
    Set to 0 to get initial and always statements lined up 
    on the left side of your screen.
 verilog-indent-level-declaration    (default 3)
    Indentation of declarations with respect to containing block. 
    Set to 0 to get them list right under containing block.
 verilog-indent-level-behavioral    (default 3)
    Indentation of first begin in a task or function block
    Set to 0 to get such code to linedup underneath the task or function keyword
 verilog-cexp-indent            (default 1)
    Indentation of Verilog statements broken across lines IE:
    if (a)
     begin
 verilog-case-indent            (default 2)
    Indentation for case statements.
 verilog-auto-newline           (default nil)
    Non-nil means automatically newline after semicolons and the punctation 
    mark after an end.
 verilog-auto-indent-on-newline (default t)
    Non-nil means automatically indent line after newline
 verilog-tab-always-indent      (default t)
    Non-nil means TAB in Verilog mode should always reindent the current line,
    regardless of where in the line point is when the TAB command is used.
 verilog-indent-begin-after-if  (default t)
    Non-nil means to indent begin statements following a preceding
    if, else, while, for and repeat statements, if any. otherwise,
    the begin is lined up with the preceding token. If t, you get:
      if (a)
         begin // amount of indent based on verilog-cexp-indent
    otherwise you get:
      if (a)
      begin
 verilog-auto-endcomments       (default t)
    Non-nil means a comment /* ... */ is set after the ends which ends 
      cases, tasks, functions and modules.
    The type and name of the object will be set between the braces.
 verilog-minimum-comment-distance (default 40)
    Minimum distance between begin and end required before a comment
    will be inserted.  Setting this variable to zero results in every
    end aquiring a comment; the default avoids too many redundanet
    comments in tight quarters. 
 verilog-auto-lineup            (default `(all))
    List of contexts where auto lineup of :'s or ='s should be done.

Turning on Verilog mode calls the value of the variable verilog-mode-hook with
no args, if that value is non-nil.
Other useful functions are:
\\[verilog-complete-word]	-complete word with appropriate possibilities 
   (functions, verilog keywords...)
\\[verilog-comment-region]	- Put marked area in a comment, fixing 
   nested comments.
\\[verilog-uncomment-region]	- Uncomment an area commented with \\[verilog-comment-region].
\\[verilog-insert-block]	- insert begin ... end;
\\[verilog-star-comment]	- insert /* ... */
\\[verilog-mark-defun]	- Mark function.
\\[verilog-beg-of-defun]	- Move to beginning of current function.
\\[verilog-end-of-defun]	- Move to end of current function.
\\[verilog-label-be]	- Label matching begin ... end, fork ... join 
  and case ... endcase statements;
" t nil)

;;;***

;;;### (autoloads (vt220-term) "vt220-term" "low-stress/vt220-term.el" (13837 58208))
;;; Generated autoloads from low-stress/vt220-term.el

(autoload (quote vt220-term) "vt220-term" "\
Sets up vt220 terminals." t nil)

;;;***

;;;### (autoloads (what-defun-am-i-in) "what-defun-am-i-in" "prog-env/what-defun-am-i-in.el" (13837 57249))
;;; Generated autoloads from prog-env/what-defun-am-i-in.el

(autoload (quote what-defun-am-i-in) "what-defun-am-i-in" "\
Returns string of current mode-specific \"defun\".
If run interactively, display using `message'." t nil)

;;;***

;;;### (autoloads (word-at-point) "word-at-point" "low-stress/word-at-point.el" (13837 58214))
;;; Generated autoloads from low-stress/word-at-point.el

(autoload (quote word-at-point) "word-at-point" "\
Returns current word as a string." t nil)

;;;***

;;;### (autoloads (xmsg) "xmsg" "low-stress/xmsg.el" (13837 58219))
;;; Generated autoloads from low-stress/xmsg.el

(autoload (quote xmsg) "xmsg" "\
invokes 'xmsg' program to display a message in a separate X window.
all args are optional:
STRING is the string to display.  xmsg recognizes \\n as newline.
GEOM if non-nil is the window geometry.
PROCESS-NAME if non-nil is the internal process object's name." t nil)

;;;***

;;;### (autoloads (xscreensaver-command-restart xscreensaver-command-activate xscreensaver-command) "xscreensaver-command" "low-stress/xscreensaver-command.el" (13837 58225))
;;; Generated autoloads from low-stress/xscreensaver-command.el

(autoload (quote xscreensaver-command) "xscreensaver-command" "\
Run xscreensaver-command(1) with CMD, a string." t nil)

(autoload (quote xscreensaver-command-activate) "xscreensaver-command" "\
Activate xscreensaver(1)." t nil)

(autoload (quote xscreensaver-command-restart) "xscreensaver-command" "\
Restart xscreensaver(1)." t nil)

;;;***

;;;### (autoloads (yo! starfield-string) "yo" "low-stress/yo.el" (13837 58230))
;;; Generated autoloads from low-stress/yo.el

(autoload (quote starfield-string) "yo" nil nil nil)

(autoload (quote yo!) "yo" "\
Reworks mode line to display MSG in high STYLE.
Styles are: simple-message, message, funky, funky-flash, bounce, t." nil nil)

;;;***


;;; loaddefs.el,v1.89 ends here
