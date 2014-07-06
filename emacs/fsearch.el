Article 4637 of gnu.emacs.sources:
Path: lerc.nasa.gov!lerc.nasa.gov!magnus.acs.ohio-state.edu!math.ohio-state.edu!howland.reston.ans.net!torn!nott!bcarh189.bnr.ca!bcarh8ab.bnr.ca!carnews0!yanzhou
From: yanzhou@bnr.ca (Yan Zhou)
Newsgroups: gnu.emacs.sources
Subject: Yet another file search utility, fsearch.
Date: 01 Sep 1995 06:42:27 GMT
Organization: Bell Northern Research
Lines: 310
Distribution: world
Message-ID: <YANZHOU.95Sep1164227@bwolh00a.bnr.ca>
NNTP-Posting-Host: bwolh00a.bnr.ca

Here is a file search utility I wrote a couple of months ago.  I am
wandering if anybody else will be interested in using it.

o what is fsearch?

  For finding files, especially when C/C++ files are being
  edited. Hitting one key can normally switch you from foo.c to foo.h
  or vice versa.  And if you are on a '#include ' line, it attempts to
  find the include file for you.  Wildcard character * is allowed in
  the search path, the default setting of which is '("./*"
  "/usr/include/*/*").

o why fsearch, now that we have already got find-... search-... utils?

  why not?  it is only a couple of hundreds lines long :-)

Comments, recommendations, bug reports and patches welcome, please
direct them to yanzhou@bnr.ca

-----
;;; fsearch.el --- a fast file search utility

;;; Author:     Yan Zhou (yanzhou@bnr.ca)
;;; Version:    1.0
;;; Time-stamp: <September 1 1995 16:11 yanzhou@bnr.ca>
;;; Keywords:   c, file, search, find

;;; Copyright (C) 1995 Yan Zhou

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 1, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; Description:
;;; 
;;; This package is a file search utility for GNU Emacs.
;;; It does its job in two separate steps:
;;;
;;;     1 GUESSING A FILE NAME
;;;
;;;       A list of functions `fs-guess-file-name-funcs' are called
;;;       sequentially.  Each of the functions can return either
;;;       a nil, a string-type file name or a list:
;;;
;;;             o nil 
;;;               Failure.
;;;
;;;             o file name
;;;               Success
;;;
;;;             o list
;;;               Success. (car list) is a base file name, and
;;;               (cdr list) is a list of possible extensions.
;;;               For example, '("String" "c" "C") means to look
;;;               for either "String.c" or "String.C".
;;;
;;;       `fs-guess-file-name-funcs' has a default value of
;;;               '(fs-guess-include-file-name
;;;                 fs-guess-other-file-name)
;;;
;;;             o fs-guess-include-file-name
;;;               Checking the current line for the C/C++ 
;;;               "#include <filename>" directive.
;;;
;;;             o fs-guess-other-file-name
;;;               Guessing a proper file name from current buffer.
;;;               It uses variable `fs-other-file-alist', whose
;;;               default value is:
;;;                     '(("c" "h")("C" "h")("h" "c" "C")))
;;;               which means, if the current buffer file name 
;;;               is "x.c", then search for "x.h"; if the buffer
;;;               file is "x.h" then search for either "x.c" or
;;;               "x.C".
;;;
;;;
;;;     2 SEARCHING
;;;       Searching through a list of directories for the guessed
;;;       file. Each of the directory in the list can have wildcard
;;;       characters ('*'s) in it. For example, "/usr/include/*/*"
;;;       means to search through /usr/include, its level 1 
;;;       sub-directories and its level 2 sub-directories.
;;;
;;;       Variable `fs-search-path' is a list that specifies which
;;;       directories are to be searched.  Its default value is
;;;       '("../*" "/usr/include/*"). "./*" is always automatically
;;;       searched first, so there is no need to include it in the
;;;       list.
;;;
;;;       The wildcard characters ('*'s) are expanded dynamically and
;;;       on demand, which means that there is no long delay in forming
;;;       a complete search list when this utility is evoked.
;;;
;;;       The searching algorithm is designed with a STACK in
;;;       mind. The search path list is viewed as a stack, the path on
;;;       the top of the stack is looked at first and popped. If it
;;;       contains wildcard characters, the leftmost wildcard
;;;       character is expanded.  The expansion can generate a list of
;;;       paths, they are pushed back to the stack.
;;;
;;;       Given fs-search-path = '(/usr/include/*/*), the example
;;;       below shows how "xlogo16" is found in
;;;       /usr/include/X11/bitmaps:
;;;
;;;       Step Stack                                               Operation
;;;       ---- -------------------------------------------------------------
;;;       1    /usr/include/*/*                              pop,expand,push
;;;       2    /usr/include /usr/include/X11/* /usr/include/net/* etc.   pop
;;;       ->   /usr/include/xlogo16 does not exist                     check
;;;       4    /usr/include/X11/* etc.                       pop,expand,push
;;;       5    /usr/include/X11 /usr/include/X11/bitmaps etc.            pop
;;;       ->   /usr/include/X11/xlogo16 does not exist                 check
;;;       6    /usr/include/X11/bitmaps etc.                             pop
;;;       ->   /usr/include/X11/bitmaps/xlogo16 found!                  done
;;;       
;;; Installation:
;;;
;;; Byte-compile fsearch.el to fsearch.elc and put both of them in a
;;; directory on your load-path.  And add the lines below to your
;;; ~/.emacs:
;;;       (autoload 'fsearch "fsearch" nil t)
;;;       (autoload 'fsearch-with-prompt "fsearch" nil t)
;;;       (global-set-key [f10] 'fsearch)
;;;       (global-set-key [C-f10] 'fsearch-with-prompt)
;;;

;;; variables
(defvar fs-search-path '("../*" "/usr/include/*")
  "List of directories to search for a particular file.")

(defvar fs-other-file-alist
  '(("c" "h")
    ("C" "h")
    ("h" "c" "C"))
  "Alist of plain extensions (without the `.').")

(defvar fs-always-in-other-window nil
  "Always in other window?")
(defvar fs-guess-file-name-funcs 
  '(fs-guess-include-file-name fs-guess-other-file-name)
  "List of file name guessing functions.")

(defvar fs-working-path nil
  "Internal working copy of \\[fs-search-path].")

;;; path name
(defun fs-path-dir-name (pathname)
  "Extracts the directory part from a given path name."
  (directory-file-name 
   (file-name-directory (directory-file-name pathname))))
(defun fs-path-file-name (pathname)
  "Extracts the non-directory part from a given path name."
  (directory-file-name 
   (file-name-nondirectory (directory-file-name pathname))))
(defun fs-path-wildcard-p (pathname)
  "Is the given path name a wildcard one?"
  (string= (fs-path-file-name pathname) "*"))
(defun fs-path-base-name (pathname)
  "Returns the base part of a given path name."
  (and (string-match "^\\(.*\\)\\.[^.]+$" pathname)
       (substring pathname (match-beginning 1) (match-end 1))))
(defun fs-path-ext-name (pathname)
  "Returns the extension part of a given path name."
  (and (string-match "^.*\\.\\([^.]+\\)$" pathname)
       (substring pathname (match-beginning 1) (match-end 1))))

;;;
;;; sub-directory
;;;
(defun fs-list-subdirs (apath)
  "Lists all the sub-directories of a given path."
  (delq nil 
        (mapcar '(lambda (file)
                   (and (file-directory-p file) file))
                (directory-files (expand-file-name apath) t "[A-Za-z0-9]" t))))

(defun fs-resolve-first-wildcard (pathlist)
  "Resolves the first path name in the given path list."
  (let ((first (expand-file-name (car pathlist))))

    (if (not (fs-path-wildcard-p first))
        pathlist
      ; the first path does contain wildcard(s)
      (setq first (fs-path-dir-name first))
      (let ((wildcard ""))
        (while (fs-path-wildcard-p first)
          (setq first (fs-path-dir-name first)
                wildcard (concat "/*" wildcard)))
        (cons first
              (append (mapcar '(lambda (path) (concat path wildcard))
                              (fs-list-subdirs first))
                      (cdr pathlist)))))))
        
(defun fs-init-working-path ()
  "Initializes \\[fs-working-path]."
  (setq fs-working-path (cons "./*" fs-search-path)))

(defun fs-pop-first-working-path ()
  "Extracts the first path from \\[fs-working-path]."
  (while (fs-path-wildcard-p (car fs-working-path))
    (setq fs-working-path (fs-resolve-first-wildcard fs-working-path)))
  (let ((first (car fs-working-path)))
    (setq fs-working-path (cdr fs-working-path))
    (expand-file-name first)))

(defun fs-file-exists-p (file)
  "Does the given file exist as a buffer or a file?"
  (or (bufferp (get-file-buffer file))
      (file-exists-p file)))

(defun fs-get-file-path (filename &optional extensions)
  "Given a file name, searches for the file through \\[fs-search-path],
returns an absolute path name if successful."
  (fs-init-working-path)

  (let (found dir fullname)
    (while (and fs-working-path (not found))
      (message (concat "DIR: " (setq dir (fs-pop-first-working-path))))
      (if extensions
          (let ((exts extensions))
            (while (and exts (not found))
              (setq fullname (concat dir "/" filename "." (car exts))
                    found (fs-file-exists-p fullname)
                    exts (cdr exts))))
        (setq fullname (concat dir "/" filename)
              found (fs-file-exists-p fullname))))
    (and (not found) (message ""))
    (and found fullname)))
      
(defun fs-find-file (in-other-window filename &optional extensions)
  "Finds the given file and presents it in a buffer."
  (let ((found (fs-get-file-path filename extensions)))
    (and found
         (if (or in-other-window fs-always-in-other-window)
             (find-file-other-window found)
           (find-file found)))))

(defun fs-guess-file-name ()
  "Guesses a file name."
  (let ((funcs fs-guess-file-name-funcs) done)
    (while (and funcs (not done))
      (setq done (save-excursion (funcall (car funcs)))
            funcs (cdr funcs)))
    done))
    
;;;
;;; main entry
;;;
(defun fsearch (&optional in-other-window)
  "A fast file search utility."
  (interactive "P")
  (let ((guess (fs-guess-file-name)))
    (and guess
         (cond
          ((listp guess)
           (fs-find-file in-other-window (car guess) (cdr guess)))
          ((stringp guess)
           (fs-find-file in-other-window guess))))))

(defun fsearch-with-prompt (&optional filename)
  "Allows keyboard input of a file name to be searched."
  (interactive "sSearch file: ")
  (and filename
       (fs-find-file nil filename)))

;;;
;;; guessing
;;;
(defun fs-guess-include-file-name ()
  "Checks #include."
  (beginning-of-line)
  (and (looking-at "^[#-]?\\s *include\\s +[<\"]\\(.*\\)[\">]\\s *$")
       (buffer-substring (match-beginning 1) (match-end 1))))

(defun fs-guess-other-file-name ()
  "Guesses a proper `other' file name."
  (and buffer-file-name
       (let ((extname  (fs-path-ext-name buffer-file-name))
             found)
         (and extname
              (setq found (assoc extname fs-other-file-alist))
              (cons (fs-path-base-name buffer-file-name)
                    (cdr found))))))

;;;
;;; useful functions that are currently not used. :-)
;;;
;(defun fs-resolve-all-wildcard (apath)
;  "Resolves all the embedded wildcard characters."
;  (if (fs-path-wildcard-p apath)
;      (apply 'nconc
;             (mapcar 'fs-list-subdirs
;                     (fs-resolve-all-wildcard
;                      (directory-file-name (fs-path-dir-name apath)))))
;    (list apath)))

;(defun fs-list-all-subdirs ()
;  "Generates a list of absolute path names from \\[fs-search-path]."
;  (apply 'nconc
;         (mapcar 'fs-resolve-all-wildcard (cons "./*" fs-search-path))))

(provide 'fsearch)
;;; End
-- 
Yan Zhou (yanzhou@bnr.ca)	BNR/nt Wollongong, Australia


