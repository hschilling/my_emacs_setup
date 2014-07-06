;;; ID: admin.el,v 1.25 1998/09/12 09:28:09 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Top level package management (for developer).
;;;
;;; Provide autoload-file and subdirs-file maintenance funcs that can be
;;; called via "emacs -batch".

;;;---------------------------------------------------------------------------
;;; Variables.

;; Might as well.
(setq ttn-autoload-file "loaddefs.el")	; no defvar since not user-servicible

(setq interactive (not noninteractive))

;;;---------------------------------------------------------------------------
;;; Support macros and functions.

;;;###autoload
(defmacro ttn-with-RCS-file (file &rest body)
  "For RCS locked FILE, execute BODY.
FILE is passed through `expand-file-name'.
Before BODY, assert no one is locking FILE and then check it out.
After BODY, check FILE back in even if it has not changed.
If there is no RCS version control, warn but do BODY anyway."
  `(let ((file (expand-file-name ,file)))
     (if (not (file-exists-p "RCS"))
	 (progn
	   (message "WARNING: No RCS version control.")
	   ,@body)
       (let ((dumb-ass (vc-locking-user file)))
	 (unless (or (null dumb-ass)
		     (eq dumb-ass 'none)
		     (eq dumb-ass 'nil))
	   (error
	    (format "Looks like %s is locking %s. Stop." dumb-ass file))))

       (message "Doing RCS co on: %s" file)
       (message (shell-command-to-string (format "co -l %s" file)))

       ,@body

       (message "Doing RCS ci on: %s" file)
       (message (shell-command-to-string
		 (format "ci -u -f -mAuto-update. %s" file))))))

;;;###autoload
(defun ttn-make (args)
  "Call make -C $ttn-elisp-home ARGS.  ARGS is a string."
  (interactive "sIn $ttn-elisp-home, do: make ")
  (compile (format "make -C %s %s" ttn-elisp-home args)))

;;;---------------------------------------------------------------------------
;;; Commands.  All of these re-enter via Makefile if run interactively.

;;;###autoload
(defun ttn-make-autoload-file ()
  "Make lisp/loaddefs.el consulting this and children directories."
  (interactive)
  (if interactive
      (ttn-make "autoload-file")
    (let ((autoload-file
	   (format "%slisp/%s" ttn-elisp-home ttn-autoload-file)))
      (ttn-with-RCS-file
       autoload-file

       (message "Updating autoload file: %s" autoload-file)
       ;; NOTE: We depend on update-autoloads-from-directories to maintain
       ;; "AUTOLOAD-FILE" == "SOURCE-DIRECTORY/lisp/TTN-AUTOLOAD-FILE".
       ;; [This is not a well published relationship!]
       (let ((generated-autoload-file ttn-autoload-file)
	     (source-directory ttn-elisp-home))
	 (apply 'update-autoloads-from-directories ttn-subdirs)))))

  (message "Done."))

;;;###autoload
(defun ttn-make-subdirs-file ()
  "Make ttn-subdirs.el."
  (interactive)
  (if interactive
      (ttn-make "subdirs-file")
    (let ((subdirs-file (format "%sttn-subdirs.el" ttn-elisp-home))
	  (cmd (concat
		"cd " ttn-elisp-home "; "
		"find . -type d -a -path '*/RCS' -prune -o -type d -print")))

      (ttn-with-RCS-file
       subdirs-file

       (message "Subdirs found: %s"
		(setq ttn-subdirs
		      (split-string (shell-command-to-string cmd))))
       (message "Updating subdirs file: %s" subdirs-file)
       (set-buffer (find-file subdirs-file))
       (delete-region (point-min) (point-max))
       (insert (format "\n\n(setq ttn-subdirs '%S)\n\n" ttn-subdirs))
       (insert "(mapc\n")
       (insert " (progsa (dir)\n")
       (insert "   (pushnew (expand-file-name dir ttn-elisp-home)\n")
       (insert "	    load-path\n")
       (insert "	    :test #'string=))\n")
       (insert " ttn-subdirs)\n")
       (insert "\n\n")
       (source-wrap-elisp-style)
       (save-buffer)
       (kill-buffer (current-buffer)))))
  (message "Done."))

;;;###autoload
(defun ttn-make-readme-files ()
  "Make the README files in each of `ttn-subdirs' using per-file code."
  (interactive)
  (if interactive
      (ttn-make "readme-files")
    (mapc
     (progsa (d)
       (let ((f (expand-file-name
		 (expand-file-name "README" d) ttn-elisp-home)))
	 (when (file-exists-p f)
	   (ttn-with-RCS-file
	    f
	    (message "Updating README file: %s/README" d)
	    (find-file f)
	    (goto-char 1)
	    (when (search-forward "[HERE]" nil t)
	      (eval-defun nil))
	    (save-buffer)
	    (kill-buffer (current-buffer))))))
     ttn-subdirs))
  (message "Done."))

;;;---------------------------------------------------------------------------
;;; admin.el,v1.25 ends here
