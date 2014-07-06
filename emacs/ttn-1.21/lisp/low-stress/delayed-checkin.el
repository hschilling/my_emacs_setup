;;; delayed-checkin.el,v 1.29 1998/09/27 06:54:05 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Provide system for delayed checkin.
;;;
;;; Intended use: installed code needs to be patched cleanly.  Could do
;;; complete munge and then give one diff, but all version control benefit is
;;; lost.

;;; This code was produced under the following philosophical precepts: good
;;; source multiplies; history has wisdom; maintainers must at all levels.

;;; Backwards and less succinctly, a maintainer can best serve the source by
;;; applying to it all the wisdom of those who've hacked it.  This implies
;;; that between a maintainer and one who submits patches must exist a
;;; mutually beneficial, co-operative relationship.  [Does it?]  The thought
;;; processes governing the patch should be captured because ultimately, the
;;; maintainer must understand and agree with the patch.

;;; Quality can be perceived in the process and not just the end result.

;;; Quality of end result is good.  Quality of process is better.


(require 'vc)

;;; The sub-maintainer creates a partial version-control system and collects
;;; revisions there.  The maintainer has access to the actual source and
;;; grafts the little trees that come back onto differnent places.

;;;---------------------------------------------------------------------------
;;; Sub-maintainer side.

(defvar dci-init-comment "From INSTALLED "
  "Non-regexp string used to initialize and identify a delayed-checkin.")

(defun dci-discern-rev ()
  "In current buffer, return revision as string or signal error."
  (save-excursion
    (save-restriction
      (save-match-data
	(widen)
	(goto-char (point-max))
	(re-search-backward "Revision: \\([^ ]+\\)") ; error ok
	(match-string 1)))))

(defvar dci-brnum ".9999"
  "Branch dci uses for its own purposes.  Must start w/ dot.
Assumption: not used by anybody.  Questions: Any value to making it
user-configurable?  How about .99999999?  (Egad!)")

;;;###autoload
(defun dci-prep (file)
  "Find FILE and make ready for delayed checkin, or signal error.
Ready means: (1) installed revision is discernable, (2) RCS subdirectory
exists under FILE, (3) installed FILE is checked in as a branch of installed
revision, (4) the branch is tagged \"dci-branch\".

See `dci-brnum' for branch number.  The return value is not useful.  If FILE
is already under version control, signal error."
  (interactive "fFile to prep for delayed-checkin? ")
  (let* ((buf (find-file file))
	 (dir (file-name-directory (buffer-file-name buf)))
	 (fnm (file-name-nondirectory (buffer-file-name buf)))
	 (rev (dci-discern-rev)))
    (setq file (buffer-file-name buf))
    (when (vc-registered file)
      (error "%s already under version control" fnm))
    (or (file-exists-p (concat dir "RCS"))
	(make-directory (concat dir "RCS"))) ; error ok
    (or (and (file-exists-p (concat dir "RCS/" fnm ",v"))
	     (let ((your-rev (vc-your-latest-version file))
		   (mwrk-rev (vc-master-workfile-version file)))
	       (and (string= your-rev mwrk-rev)
		    (string-match (concat "\\" dci-brnum "$") your-rev))))
	(progn
	  (vc-admin file rev (concat dci-init-comment fnm " revision " rev))
	  (vc-resynch-buffer file t t)
	  (vc-checkout file t rev)
	  (let ((vc-checkin-switches "-f"))
	    (vc-backend-checkin file (concat rev dci-brnum) "dci branch!"))
	  (vc-backend-assign-name file "dci-branch")
	  (vc-resynch-buffer file t t)
	  ))))

;;;---------------------------------------------------------------------------
;;; Maintainer side.

(defun dci-last-checkout-numeric-revision ()
  "Return string representing numeric revision of last checkout.
Buffer `*vc*' is consulted."
  (save-excursion
    (save-match-data
      (set-buffer "*vc*")
      (goto-char (point-min))
      (re-search-forward "^revision \\(.*\\)") ; error ok
      (match-string 1))))

(defun dci-print-log-revision (file rev &optional outfile)
  "Print interesting part of log for FILE, revision REV.
Optional arg OUTFILE indicates buffer should be written there."
  (setq file (expand-file-name file))
  (let ((curbuf (current-buffer))
	(buf (get-buffer-create "*dci*")))
    (set-buffer buf)
    (delete-region (point-min) (point-max))
    (call-process "rlog" nil buf nil (format "-r%s" rev) file)
    (set-buffer buf)
    (delete-region 1 (progn
		       (goto-char 1)
		       (re-search-forward "^-+\n")
		       (forward-line 2)
		       (point)))
    (goto-char (point-max))
    (re-search-backward "^=+$")
    (delete-region (match-beginning 0) (match-end 0))
    (when outfile (write-region (point-min) (point-max) outfile))
    (set-buffer curbuf)))

(defun dci-extract-masterfile (file masterfile)
  "Find FILE, make subdir .dci/FILE, extract MASTERFILE contents there."
  (let* ((buf (find-file file))
	 (fnm (file-name-nondirectory (buffer-file-name buf)))
	 (default-directory default-directory)
	 (wrk-dir (concat default-directory ".dci/" fnm "/"))
	 wrk-file-base discerned-rev num-branch num-last)
    (setq file (expand-file-name file))
    (setq masterfile (expand-file-name masterfile))
    (condition-case err			; may not be there
	(dci-delete-extraction file)
      (error nil))
    (make-directory wrk-dir t)
    (setq default-directory wrk-dir)	; go down
    (setq wrk-file-base (expand-file-name fnm))
    (make-symbolic-link (file-name-directory masterfile) "RCS")

    ;; First, put elephant at the end of Africa.
    (vc-backend-checkout wrk-file-base nil nil wrk-file-base)
    (let ((raw (dci-last-checkout-numeric-revision)))
      (string-match (concat "\\(.*\\)" (regexp-quote dci-brnum) "\\(.*\\)")
		    raw)
      (setq num-last (substring (match-string 2 raw) 1))
      (setq num-branch (concat (match-string 1 raw) dci-brnum "."))
      (setq discerned-rev (match-string 1 raw)))
    (dci-print-log-revision wrk-file-base
			    (concat num-branch num-last)
			    (concat wrk-file-base "-" num-branch num-last "L"))
    (rename-file wrk-file-base (concat wrk-file-base "-" num-branch num-last))
    (vc-file-setprop file 'dci-num-last num-last)
    (vc-file-setprop file 'dci-num-branch num-branch)
    (vc-file-setprop file 'dci-discerned-rev discerned-rev)

    ;; Now find it, in the process creating the reference and several non-last
    ;; elephants.  (And non-elephants, too!)
    (vc-backend-checkout wrk-file-base
			 nil
			 discerned-rev
			 (concat wrk-file-base "-" discerned-rev))
    (let ((wrk (concat wrk-file-base "-" num-branch)))
      (do ((i "1" (int-to-string (1+ (string-to-int i)))))
	  ((file-exists-p (concat wrk i)) nil)
	(vc-backend-checkout wrk-file-base			; elephant
			     nil
			     (concat num-branch i)
			     (concat wrk i))
	(dci-print-log-revision wrk-file-base			; non-elephant
				(concat num-branch i)
				(concat wrk i "L"))
	))
    ))

(defun dci-do-it (file)
  "Do a delayed checkin for FILE, starting from discerned revision.
If full-formed revisions are not in .dci/FILE/FILE-*, signal error."
  (find-file file)
  (setq file (expand-file-name file))
  (let* ((fnm (file-name-nondirectory file))
	 (fully-formed-revs-dir (concat (file-name-directory file)
					".dci/" fnm))
	 (revs-base (concat fully-formed-revs-dir "/" fnm "-"))
	 (discerned-rev (vc-file-getprop file 'dci-discerned-rev))
	 (num-branch (vc-file-getprop file 'dci-num-branch))
	 (num-last (vc-file-getprop file 'dci-num-last)))

    ;; Check internal state.
    (or (null (vc-locking-user file))
	(error "File needs to be unlocked."))
    (or (and discerned-rev num-branch num-last)
	(error "Need to extract masterfile."))

    ;; Make sure all files exist: base (for check), and each checkin,
    ;; from 1 through `num-last', inclusive.
    (or (and (file-exists-p (concat revs-base discerned-rev))
	     (let ((last-file (concat revs-base num-branch num-last)))
	       (and (file-exists-p last-file)
		    (do ((i "1" (int-to-string (1+ (string-to-int i)))))
		   ((string= num-last i) t)
		   (if (file-exists-p (concat revs-base num-branch i))
		       nil
		     (return nil))))))
	(error "Masterfile extraction not complete -- report this bug."))

    ;; Is the base similar enough to consider the same?  (TODO: automate)
    (diff file (concat revs-base discerned-rev))
    (or (y-or-n-p "Similar enough to consider same? (Continue?) ")
	(error "Base versions differ."))

    ;; All checks pass, go for it!
    (do ((i "1" (int-to-string (1+ (string-to-int i)))))
	((= (1+ (string-to-int num-last)) (string-to-int i)) nil)
      (vc-checkout file t)
      (find-file file)
      (delete-region (point-min) (point-max))
      (insert-file-contents (concat revs-base num-branch i))
      (vc-toggle-read-only)
      (set-buffer "*VC-log*")
      (insert-file-contents (concat revs-base num-branch i "L"))
      (vc-finish-logentry)
      (find-file file))

    ))

;;;##autoload
(defun dci-delete-extraction (file)
  "Delete extraction for FILE, found in .dci/FILE under FILE's directory.
Also, delete dirs .dci/FILE and .dci if possible."
  (interactive "fFile to delete extraction of: ")
  (let* ((buf (find-file file))
	 (dir (file-name-directory (buffer-file-name buf)))
	 (fnm (file-name-nondirectory (buffer-file-name buf)))
	 (bye (directory-files (concat dir ".dci/" fnm "/") t)))
    (setq bye (remove (concat dir ".dci/" fnm "/.") bye))
    (setq bye (remove (concat dir ".dci/" fnm "/..") bye))
    (mapcar #'delete-file bye)
    (mapcar #'(lambda (d)
		(when (= 2 (length (directory-files d)))
		  (delete-directory d)))
	    (list
	     (concat dir ".dci/" fnm)
	     (concat dir ".dci")))))

;;;###autoload
(defun dci-maybe-graft (file dir)
  "For FILE, if DIR has a dci-branch, graft onto source if ok w/ user."
  (interactive "fFile: \nDLook in what dir for grafts? ")
  (when (string-match "/$" dir)
    (setq dir (substring dir 0 -1)))
  (let ((maybe (concat dir "/" (file-name-nondirectory file) ",v")))
    (when (and (file-exists-p maybe)
	       (y-or-n-p (format "Hey, extract dci-graft %s? " maybe)))
      (dci-extract-masterfile file maybe)
      (dci-do-it file)
      (when (y-or-n-p "Cleanup? ")
	(delete-file maybe)
	(dci-delete-extraction file))
      )))

;;;---------------------------------------------------------------------------
;;; That's it.

(provide 'delayed-checkin)

;;; delayed-checkin.el,v1.29 ends here
