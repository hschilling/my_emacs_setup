;;; ID: pll-spreadsheet.el,v 1.7 1998/09/27 06:59:51 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Interactive spreadsheet for PLL numbers tuning.

;;; How to use this file: (1) `M-x load-file'.  (2) `M-x pll-ss'.  A new
;;; buffer will be created.  In that buffer, type `C-h m' for help.

(require 'cl)

(defvar f-range	'(1 129)	"Inclusive range of `f' values.")
(defvar r-range	'(1 30)		"Inclusive range of `r' values.")
(defvar d-list	'(1 2 4)	"List of `d' values.")
(defvar f-in-ls	'(8.192 13.0)	"List of `f-in' values.")
(defvar gran	1		"Granularity of ranges.")
(defvar b-range '(0 200)	"Binning range in MHz.")
(defvar epsilon	0.5		"How close.")
(defvar binmax	100		"How many to return in each bin.")

(setq pll-ss-vars '(f-range r-range d-list f-in-ls gran
			    b-range epsilon binmax))

(defun pll-ss-func (f r d f-in)
  (/ (* f-in f)
     1.0 d r))				; 1.0 => cast to fp

(defun pll-ss-range (range)
  (let (retlist)
    (do ((i (car range) (+ gran i)))
	((> i (cadr range)) retlist)
      (setq retlist (cons i retlist)))
    retlist))

(defun pll-ss-table ()
  (let (table)
    (dolist (f (pll-ss-range f-range))
      (dolist (r (pll-ss-range r-range))
	(dolist (d d-list)
	  (dolist (f-in f-in-ls)
	    (message "%f %f %f %f" f r d f-in)
	    (setq table (cons
			 (list (pll-ss-func f r d f-in) f r d f-in)
			 table))))))
    table))

(defun pll-ss-bin-by-fives (table)
  (let ((bins (mapcar #'list (mapcar #'truncate (pll-ss-range b-range))))
	(count 0))
    (mapc (lambda (entry)
	    (let* ((freq (car entry))
		   (rbin (round freq 5.0))
		   (diff (- freq (* rbin 5.0)))
		   (keep (< (abs diff) epsilon)))
	      (message "%d -- %s" count freq)
	      (when keep
		(let ((bin (assoc (* 5 rbin) bins)))
		  (when bin
		    (setcdr bin (cons (cons diff (cdr entry))
				      (cdr bin)))))))
	    (setq count (1+ count)))
	  table)
    bins))

(defun pll-ss (bin-only)
  "Provide simple spreadsheet for PLL calculations.

In this buffer, type `C-c C-c' to form table and do binning (complete recalc).

After the table is formed, if you only change the binning parameters (epsilon
and binmax), type `C-u C-c C-c' to do binning only (skip table formation).

In the future, there may be xref functions."

  (interactive "P")

  (if (eq major-mode 'pll-ss)
      (save-excursion
	(goto-char 1)
	(re-search-forward "^;;; vars.*\n(setq")
	(eval-defun nil)
	(re-search-forward "^-+$")
	(delete-region (point) (point-max))
	(sit-for 0)
	(let (table bins)
	  (setq table (if (and bin-only pll-ss-table-cache)
			  pll-ss-table-cache
			(pll-ss-table)))
	  (setq pll-ss-table-cache table)
	  (insert (format "\nfull table has %d entries\n" (length table)))
	  (sit-for 0)
	  (setq bins (pll-ss-bin-by-fives table))
	  (insert "binned by 5:\n")
	  (mapc (lambda (bin)
		  (when (cdr bin)
		    (setcdr bin (sort (cdr bin)
				      (lambda (x y)
					(< (abs (car x)) (abs (car y))))))
		    (insert (format "bin: %d\n" (car bin)))
		    (do ((i 0 (1+ i)) (ls (cdr bin) (cdr ls)))
			((or (null ls) (= i binmax)))
		      (insert (format " %s\n" (car ls))))))
		bins))
	(message "Done."))

    ;; set up
    (switch-to-buffer "*PLL Spreadsheet*")
    (kill-all-local-variables)
    (make-local-variable 'pll-ss-table-cache)
    (make-local-variable 'pll-ss-xref)
    (setq pll-ss-table-cache nil)
    (setq pll-ss-xref nil)
    (setq major-mode 'pll-ss)
    (setq mode-name "PLL-SS")
    (use-local-map (make-sparse-keymap))
    (local-set-key "\M-\C-x" 'pll-ss)
    (local-set-key "\C-c\C-c" 'pll-ss)
    (mapc #'make-local-variable pll-ss-vars)
    (widen)
    (delete-region (point-min) (point-max))
    (insert ";;; Type `C-h m' for help.\n")
    (insert ";;; vars (do not delete this line)\n")
    (insert "(setq\n")
    (mapc (lambda (sym)
	    (insert (format " %-20s\t%s%s\n" (symbol-name sym)
			    (if (listp (eval sym)) "'" "")
			    (eval sym))))
	  pll-ss-vars)
    (insert ")\n")
    (insert "\n\nOutput is below this line\n")
    (insert (make-string 50 ?-) "\n")
    ))

(provide 'pll-spreadsheet)

;;; pll-spreadsheet.el,v1.7 ends here
