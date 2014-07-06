;; Ray Nickson [nickson@cs.uq.oz.au] - 02:25:30 PM, Fri 27 May 1994
(defun duplicate-line (n dir &optional col)
  "Copy the Nth following line to point.
If the last command was a duplication, replace the current line by the next
line in direction DIR.
If COL is specified, copy starts at column COL of the selected line."
  (if (eq (car-safe last-command) 'duplicate-line)
      (progn
        (setq n (+ dir (nth 1 last-command))
              col (nth 2 last-command))
        (delete-region (point-at (move-to-column col))
                       (point-at (end-of-line nil))))
    (kill-region (point-at (move-to-column (or col (setq col 0))))
                 (point-at (end-of-line nil))))
  (if (= n 0)
      (insert (current-kill 0))
    (insert (save-excursion
              (beginning-of-line (1+ n))
              (move-to-column col)
              (buffer-substring (point)
                                (point-at (end-of-line nil)))))
    (setq this-command (list 'duplicate-line n col))))

(defun duplicate-previous-line (n)
  "Copy the Nth previous line to point.
If repeated, replace by the line preceding the one that was copied last time.
This command can be interleaved with \\[duplicate-following-line].
With just a C-U arg, copy just the part of the previous line that is to the
right of the current column."
  (interactive "P")
  (if (consp n)
      (duplicate-line -1 -1 (current-column))
    (duplicate-line (- (prefix-numeric-value n)) -1 0)))

(defun duplicate-following-line (n)
  "Copy the Nth following line to point.
If repeated, replace by the line following the one that was copied last time.
This command can be interleaved with \\[duplicate-previous-line].
With just a C-U arg, copy just the part of the previous line that is to the
right of the current column."
  (interactive "p")
  (if (consp n)
      (duplicate-line 1 1 (current-column))
    (duplicate-line (prefix-numeric-value n) 1 0)))


