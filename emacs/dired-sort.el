;;;
;;;				NO WARRANTY
;;; 
;;; This software is distributed free of charge and is in the public domain.
;;; Anyone may use, duplicate or modify this program.  Thinking Machines
;;; Corporation does not restrict in any way the use of this software by
;;; anyone.
;;; 
;;; Thinking Machines Corporation provides absolutely no warranty of any kind.
;;; The entire risk as to the quality and performance of this program is with
;;; you.  In no event will Thinking Machines Corporation be liable to you for
;;; damages, including any lost profits, lost monies, or other special,
;;; incidental or consequential damages arising out of the use of this program.
;;;
;;; Thu May  4 1989
;;;
;;; $Header: /tmp_mnt/am/p7/utility/gmacs/f2/RCS/dired-resort.el,v 1.1 88/11/03 13:22:08 fad Exp $

;;; Commands for reordering dired listings.

(provide 'dired-sort)
(require 'date-parse)

;; File property caching mechanism for dired:
(defvar dired-line-property-table nil
  "Buffer local obarray:  Each symbol is a file name whose plist caches
   file properties, accessed by #'dired-line-property")
(make-variable-buffer-local 'dired-line-property-table)

(defun dired-revert-and-decache (&optional arg noconfirm)
  (if dired-line-property-table
      (mapatoms (function (lambda (file) (setplist file nil)))
		dired-line-property-table))
  (dired-revert arg noconfirm))

(defun dired-line-property (func)
  "Call FUNC with one argument:  The (absolute) file name of this dired line.
   Cache the result, and return it the next time without calling FUNC.
   The caches are cleared when the buffer is reverted.
   See dired-line-property-table."
  (or dired-line-property-table
      (progn
	(if (eq revert-buffer-function 'dired-revert)
	    (setq revert-buffer-function 'dired-revert-and-decache))
	(setq dired-line-property-table (make-vector 31 0))))
  (let ((file (intern (dired-get-filename t) dired-line-property-table)))
    (or (get file func)
	(put file func
	     (funcall func (symbol-name file)))
	)))



(defun dired-move-to-date (&optional and-extract)
  ;; Depends on the details of dired-extract-size.
  (dired-move-to-filename)
  (skip-chars-backward " ")
  (let ((end (point)))
    (skip-chars-backward "^a-zA-Z")
    (skip-chars-backward "a-zA-Z")
    (if and-extract
	(parse-date (buffer-substring (point) end) t))))

(defun dired-extract-date ()
  (dired-move-to-date t))

(defun dired-extract-size ()
  (dired-move-to-date)
  (skip-chars-backward " ")
  (skip-chars-backward "0-9")
  (if (looking-at "[0-9]+ ")
      (read (current-buffer))
    -1))


(defun dired-header-line-p ()
  (save-excursion
    (minusp (dired-extract-size))))
(defun dired-first-file ()
  (interactive)
  (goto-char (point-min))
  (while (and (dired-header-line-p)
	      (not (eobp)))
    (forward-line))
  (dired-move-to-filename))
(defun dired-last-file ()
  (interactive)
  (goto-char (point-max))
  (while (and (dired-header-line-p)
	      (not (bobp)))
    (forward-line -1))
  (dired-move-to-filename))
(defun dired-narrow-to-files ()
  (interactive)
  (narrow-to-region
    (save-excursion
      (dired-first-file)
      (forward-line 0)
      (point))
    (save-excursion
      (dired-last-file)
      (forward-line 1)
      (point))))

(defun dired-extract-date-key (&optional ignore)
  (let ((date (dired-extract-date)))
    (if date (date-compare-key date))))

(defun dired-sort-by-date (&optional arg)
  "In dired, sort the lines by date, newest first.
With arg, sorts oldest first."
  (interactive "P")
  (save-restriction
    (dired-narrow-to-files)
    (let ((buffer-read-only nil))
      (goto-char (point-min))
      (sort-subr
	(not arg) 'forward-line 'end-of-line
	(function
	  (lambda ()
	    (or (dired-line-property 'dired-extract-date-key)
		(throw key 'nil))))
     )))
  (setq dired-last-sort (if arg 'oldest 'newest))
  (message "Now sorted by date, %s first." (if arg "oldest" "newest")))

(defun dired-sort-by-name (&optional arg skip-to sort-by)
  "In dired, sort the lines by file name.
With arg, sorts in reverse order."
  (interactive "P")
  (or sort-by (setq sort-by 'name))
  (save-restriction
    (dired-narrow-to-files)
    (let ((buffer-read-only nil)
	  (reverse-sort-p arg))
      (goto-char (point-min))
      (sort-subr
	reverse-sort-p 'forward-line 'end-of-line
	(function(lambda ()
		   (dired-move-to-filename)
		   (cond
		     ((null skip-to))
		     (reverse-sort-p
		       (let ((here (point)))
			 (end-of-line)
			 (re-search-backward
			   skip-to here 'move)))
		     ((re-search-forward
			skip-to
			(save-excursion (end-of-line) (point))
			'move)
		      (goto-char (match-beginning 0))))
		   nil))
	)))
  (setq dired-last-sort sort-by)
  (message "Now sorted by %s%s." sort-by
	   (if arg ", in reverse order" "")))
(defun dired-sort-by-type (&optional arg)
  (interactive "P")
  (dired-sort-by-name
    arg (if arg "[.#~]" "[.~0-9#]+") 'type))

(defun dired-sort-by-field (field)
  "In dired, sort the lines by FIELD (defaults to the mode field)."
  (interactive "p")
  (save-restriction
    (dired-narrow-to-files)
    (let ((buffer-read-only nil))
      (goto-char (point-min))
      (sort-fields-1
	field (point-min) (point-max)
	(function(lambda ()
		   (sort-skip-fields (1- field))
		   (skip-chars-backward " ")
		   nil))
	nil)))
  (setq dired-last-sort 'fields)
  (message "Now sorted by %s."
	   (cond ((= field 1) "file mode")
		 ((= field 2) "number of links")
		 ((= field 3) "file owner")
		 (t (format "field #%d" field)))))

(defun dired-sort-by-size-key-1 (incr-p)
  (let ((size (dired-extract-size))
	(char (save-excursion
		(forward-line 0)
		(skip-chars-forward " ")
		(following-char))))
    (setq char (downcase char))
    (cond
      ((not incr-p))
      ((= char ?-) (setq char ?~))
      ((>= char ?a) (setq char (- (+ ?a ?z) char))))
    (format "%c%09d" char size)))
(defun dired-sort-by-size-key (&optional ignore)
  (dired-sort-by-size-key-1 nil))
(defun dired-sort-by-size-increasing-key (&optional ignore)
  (dired-sort-by-size-key-1 t))

(defun dired-sort-by-size (&optional arg)
  "In dired, sort the lines by file size, largest first.
With arg, sorts in the reverse order (smallest first).
All directories are grouped together at the head of the buffer,
and other file types are also grouped."
  (interactive "P")
  (let ((buffer-read-only nil)
	(incr-p arg))
    (save-restriction
      (dired-narrow-to-files)
      (goto-char (point-min))
      (sort-subr
	(not incr-p) 'forward-line 'end-of-line
	(if incr-p
	    (function (lambda () (dired-line-property
				   'dired-sort-by-size-increasing-key)))
	  (function (lambda () (dired-line-property
				 'dired-sort-by-size-key))))
	))
    (setq dired-last-sort (if incr-p 'smallest 'largest))
    (message "Now sorted by type and size, %s first."
	     (if incr-p "smallest" "largest"))))

(defvar dired-resort-alist
  '(("name" dired-sort-by-name nil "ascending order")
    (nil dired-sort-by-name t "descending order")
    ("date" dired-sort-by-date nil "most recent first")
    (nil dired-sort-by-date t "oldest first")
    ("size" dired-sort-by-size nil "biggest first")
    (nil dired-sort-by-size t "smallest first")
    ("type" dired-sort-by-type t "alphabetically")
    ("modes" dired-sort-by-field 1 "file modes")
    ("links" dired-sort-by-field 2 "number of links")
    ("owner" dired-sort-by-field 3 "file owner")
    ("field" dired-sort-by-field (1) "textual field")))

(defvar dired-resort-last-kind '(date) "What the last sort did to the buffer.")
(make-variable-buffer-local 'dired-resort-last-kind)

(defun dired-resort-menu-options ()
  (list "Help"
	(cons "Sort Dired listing by:"
	      (mapcar
		(function(lambda (elt)
			   (cons
			     (format "%5s (%s)"
				     (capitalize (or (nth 0 elt) " '' "))
				     (nth 3 elt))
			     elt)))
		dired-resort-alist))))

(defun read-dired-resort-args (&optional res)
  "Produce a 1- or 2- list suitable for non-interactive calling of dired-resort.
   Optional RES is a line from dired-resort-alist."
  (or res
      (setq res
	    (completing-read
	      (format "Sort by: [%s] " (car dired-resort-last-kind))
	      dired-resort-alist
	      nil t)))
  (if (zerop (length res))
      dired-resort-last-kind
    (if (atom res)
	(setq res (or (assoc res dired-resort-alist) (error "reading resort"))))
    (let ((type (nth 0 res))
	  (func (nth 1 res))
	  (arg (nth 2 res))
	  (what (nth 3 res)))
      (let ((ptr dired-resort-alist) elt)
	(while (and ptr (null type))
	  (setq elt (car ptr) ptr (cdr ptr))
	  (if (eq func (nth 1 elt))
	      (setq type (nth 0 elt)))))
      (setq type (intern type))
      (cond
	((atom arg))
	(current-prefix-arg
	  (setq arg
		(if (integerp (car arg))
		    (prefix-numeric-value current-prefix-arg)
		  (and current-prefix-arg t))))
	((integerp (car arg))
	 (setq arg (read-minibuffer (format "What %s? " what))))
	(t (setq arg (y-or-n-p (format "%s? " what)))))
      (if (null arg)
	  type
	(list type arg)))))

(defun dired-resort (kind &optional args)
  "In dired, change the sorting of lines.  Prompts for the kind of sorting.
   Non-interactively, takes a sort-kind, and an optional argument for
   the associated function.  To get a list of such arguments interactively,
   call read-dired-resort-args."
  (interactive (list (read-dired-resort-args)))
  (if (null kind) (setq kind dired-resort-last-kind))
  (if (consp kind)
      (setq args (cdr kind) kind (car kind)))
  (if (symbolp kind) (setq kind (symbol-name kind)))
  (apply
    (or (nth 1 (assoc kind dired-resort-alist))
	(error "No such sorting method: %s" kind))
    args)
  (setq dired-resort-last-kind (cons kind args)))

(if (boundp 'dired-mode-map)
    (progn
      (if (memq (lookup-key dired-mode-map "S") '(nil undefined))
	  (define-key dired-mode-map "S" 'dired-resort))
      ;;(define-key dired-mode-map "\M-<" 'dired-first-file)
      ;;(define-key dired-mode-map "\M->" 'dired-last-file)
      ))

;; Other suggestions:
;; (define-key dired-mode-map "S" 'dired-sort-by-size)
;; (define-key dired-mode-map "D" 'dired-sort-by-date)
;; (define-key dired-mode-map "K" 'dired-sort-by-field)
;; (define-key dired-mode-map "N" 'dired-sort-by-name)
;; (define-key dired-mode-map "T" 'dired-sort-by-type)
;; (if xterm
;;     (define-key mouse-map x-button-right 'x-mouse-dired-help))




(defun x-mouse-dired-help (arg)
  (x-mouse-select arg);; Go to buffer first.
  (when (eq 'dired-mode major-mode)
    (let ((selection
	    (x-popup-menu
	      arg (dired-resort-menu-options))))
      (if (null selection)
	  nil;; Just stay there.
	(setq selection (read-dired-resort-args selection))
	(setq command-history
	      (cons (list 'dired-resort (list 'quote selection))
		    command-history))
	(dired-resort selection)
	nil))))

;; Not exported from sort.el, but we use it here:
(or (fboundp 'sort-subr)
    (autoload 'sort-subr "sort"))
(or (fboundp 'sort-fields-1)
    (autoload 'sort-fields-1 "sort"))

