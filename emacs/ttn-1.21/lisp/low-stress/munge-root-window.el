;;; ID: munge-root-window.el,v 1.24 1998/09/27 06:58:08 ttn Exp
;;;
;;; Copyright (C) 1997, 1998 Thien-Thi Nguyen
;;; This file is part of ttn's personal elisp library, released under GNU
;;; GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

;;; Description: Munge root window in luser-selectable ways.

(require 'ttn-macros)
(require 'electric)

(defun munge-root-window-commands ()
  "Return a list of commands (each a string) to munge the root window.
Those ending in \"&\" are backgroundable."
  (append
   `("xsetroot -solid black"
     "xsetroot -solid gray30"
     ,@(mapcar
	(progsa (s) (concat "xlock -mode " s " -nolock -inroot &"))
	'("ifs"
	  "drift -grow"
	  "flame"
	  "wator -delay 0"
	  "rock -delay 0 -mono -batchcount 1000"
	  "bouboule -delay 10000"
	  "bouboule -delay 15000"
	  "worm -batchcount 100"
	  "qix"
	  "hop"
	  "pyro -batchcount 100"
	  "slip"
	  "swarm"
	  ;; Add xlock modes here.
	  ))
     "oclock -transparent -bd gold -fg gold"
     ;; Add non-xlock programs here.
     )
   (mapcar (progsa (x)
	     (concat "kill " (buffer-name x)))
	   (delete-if-not (progsa (x)
			    (string-match ".bg job. " (buffer-name x)))
			  (copy-sequence (buffer-list))))))

;;;###autoload
(defun munge-root-window ()
  "Display command list and let user choose one by hitting RET.
Use `Electric-command-loop' to receive input."
  (interactive)
  (let ((cur-win-config (current-window-configuration)))
    (switch-to-buffer-other-window "*Munge Root Window*")
    (delete-region (point-min) (point-max))
    (use-local-map (make-sparse-keymap))
    (local-set-keys
     '("n"    next-line
       "p"    previous-line
       " "    next-line
       "\177" previous-line
       "\C-m" munge-root-window-act))
    (flet ((display (cmd-list)
		    (if (null cmd-list)
			nil
		      (insert "  " (car cmd-list) "\n")
		      (display (cdr cmd-list)))))
      (display (munge-root-window-commands)))
    (delete-region (1- (point-max)) (point-max))
    (goto-char (point-min))
    (shrink-window-if-larger-than-buffer)
    (catch 'munge-root-window-select
      (Electric-command-loop 'munge-root-window-select
			     "Move cursor and hit RET (or hit C-g to quit)."))
    (kill-buffer "*Munge Root Window*")
    (message "")
    (set-window-configuration cur-win-config)))

(defun munge-root-window-act ()
  "Execute the command on the current line.
If the command ends in \"&\", execute using `bg-shell-command'.
If the command starts with \"kill bg job\", kill the associated buffer.
Otherwise execute using `saved-shell-command'.
When done, throw control back to `munge-root-window'."
  (interactive)
  (let* ((end (progn (end-of-line) (point)))
	 (beg (progn (beginning-of-line) (+ 2 (point))))
	 (cmd (buffer-substring beg end)))
    (cond ((eq ?& (aref cmd (1- (length cmd))))
	   (bg-shell-command (substring cmd 0 -1)))
	  ((string-match "kill \\(.bg job. .*\\)" cmd)
	   (kill-buffer (match-string 1 cmd)))
	  (t
	   (saved-shell-command cmd))))
  (throw 'munge-root-window-select nil))

(provide 'munge-root-window)

;;; munge-root-window.el,v1.24 ends here
