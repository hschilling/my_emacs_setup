Article 1453 of gnu.emacs.sources:
Path: eagle!usenet.ins.cwru.edu!howland.reston.ans.net!agate!agate.berkeley.edu!dodd
From: dodd@mycenae.cchem.berkeley.edu (Lawrence R. Dodd)
Newsgroups: gnu.emacs.sources
Subject: dm-f.el : fortran support for dynamic macros
Date: 17 Mar 93 08:58:20
Organization: Polytechnic Univ, Chem Eng Dept, Brooklyn, NY, USA
Lines: 364
Distribution: gnu
Message-ID: <DODD.93Mar17085820@mycenae.cchem.berkeley.edu>
NNTP-Posting-Host: mycenae.cchem.berkeley.edu


here is an attempt at fortran support for Wayne Mesard's Dynamic Macros
(dmacro.el).

----------
;;; dm-f.el - dynamic macros for fortran mode

(defconst dm-f-version (substring "$Revision: 1.17 $" 11 -2) 

  "The revision number of dm-f.el - dynamic macros for fortran mode.
Please mention this number when sending reports to dodd@roebling.poly.edu.
Complete RCS identity is

   $Id: dm-f.el,v 1.17 1993/03/17 14:25:31 dodd Exp $

This file is available via anonymous ftp in:

   /roebling.poly.edu:/pub/dm-f.el
")

;;; Copyright (C) 1993 Lawrence R. Dodd
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; $Modified: Wed Mar 17 14:20:26 GMT 1993 by dodd $
;;; $Id: dm-f.el,v 1.17 1993/03/17 14:25:31 dodd Exp $
;;; $Revision: 1.17 $
;;; $Modified: Wed Mar 17 09:20:26 EST 1993 by dodd $


;;; INSTALLATION/USAGE
;;; 
;;; Save as `dm-f.el' in a directory where emacs can find it. Stick 
;;; 
;;;                   (require 'dm-f) 
;;;                   
;;; in your ~/.emacs or the site initialization file.
;;;  
;;; This file tries to load `dmacro,' which hopefully is somewhere emacs can
;;; find it.  Your `load-path' variable, as set in your Emacs init file, should
;;; include the directory containing the file `dmacro.el[c].'  It also tries
;;; to load fortran.el[c] which should be in the default emacs directory.
;;; 
;;; If the user defines an environment variable called DOMAIN, then the
;;; masthead will append it to whatever hostname returns (typically the
;;; machine name) and hence attempt to create a valid e-mail address.  For
;;; example, I have in my ~/.cshrc file the line
;;; 
;;;                 setenv DOMAIN "poly.edu"
;;;  
;;; Since `hostname' returns `roebling', the string "<dodd@roebling.poly.edu>"
;;; appears in the masthead of my fortran files.  However, if DOMAIN is not
;;; set, then the string "<dodd@roebling>" appears instead.
;;; 
;;; The masthead automatically sticks in RCS tags and a `modify.el' tag
;;; Users may wish to edit `auto-dmacro-alist' to turn off the automatic
;;; insertion of the masthead or edit the masthead itself (see below).
;;;  
;;; Note: modify.el is available via anonymous ftp in
;;; /roebling.poly.edu:/pub/modify.el and also in the elisp-archive in
;;; /archive.cis.ohio-state.edu:/pub/gnu/emacs/elisp-archive/misc/modify.el.Z.
;;;  
;;; This dmacros file works independently of the standard fortran abbreviation
;;; mode.  However, those users not already using it are encouraged to use
;;; fortran abbreviation mode too.  It is extremely useful for expanding often
;;; used commands.  Simply stick `(setq abbrev-mode t)' inside your
;;; `fortran-mode-hook' (see Emacs Manual - Fortran: Fortran Abbrev):
;;;  
;;;    (setq fortran-mode-hook 
;;;          '(lambda () 
;;;    
;;;                        [material not shown] 
;;;     
;;;             (setq abbrev-mode t)))
;;; 
;;; Users of dm-f.el are encouraged to modify this file to their own tastes 
;;; and to send and post additions that would be useful to others.


;;; Log History 
;;;  
;;; 1.1 -
;;;   lrd: check in code originally send to Ulrich Mueller <ulm@vsnhd2.cern.ch>
;;;    by MOSS_R@SUMMER.CHEM.SU.OZ.AU 
;;; 1.2 - 
;;;   lrd: merged with a `fortranized' version of dm-c.el; lifted cpp 
;;;   directives code directly from dm-c.el 
;;; 1.3 - 
;;;   lrd: put `implicit none' in `prog,' `subr,' and `func'; standardized the 
;;;   blank lines throughout; defined `dont-bind-my-keys' so byte-compiler 
;;;   stops complaining 
;;; 1.4 - 
;;;   lrd: created `print' macro
;;; 1.5 - 
;;;   lrd: fixed up cpp directive stuff (removed some of it)
;;; 1.6 - 1.8 - 
;;;   lrd: doc mod
;;; 1.9 - 
;;;   lrd: adopted some ideas from the dmacro file written by Denis Girou 
;;;   <girou@circe.fr> (e.g., sticking in comment strings and `doith')
;;; 1.10 - 
;;;   lrd: doc mod
;;; 1.11 - 
;;;   lrd: created open and open/close macros.  the leading character is
;;;   important in fortran mode as regards indentation so the `close' must
;;;   have space before it or the indentation will break the word `close' into
;;;   the comment `c lose' -- this is a general feature of fortran mode so
;;;   modifiers of this file should beware.  Likewise for cpp directives there
;;;   should be no space before the `#' as the indentation will be screwed
;;;   unless fortran.el is fixed so this does not happen.
;;; 1.12 - 
;;;   lrd: added in do-continue constructs (like those by Denis Girou), I
;;;   guess there are still people out there who use statement labels.  added
;;;   in if-then/else-if construct.
;;; 1.13 - 
;;;   lrd: added in `close' macro
;;; 1.14 - 
;;;   lrd: doc modification
;;; 1.15 -
;;;   lrd: created shorter version of masthead called `mastheadshort'
;;; 1.16 - 
;;;   lrd: modified comments inserted by `subr' and `func'
;;; 1.17 - 
;;;   lrd: modified comment inserted by `prog'; created some intrinsic 
;;;   functions.


;;; requirements
(require 'dmacro)   ; dmacro package
(require 'fortran)  ; fortran mode

;;; Define this variable in case modify.el is not being used.  we could stick
;;; in (require 'modify) but that would be presumptuous.

(defvar modify-tag "Modified")

;;; key bindings
(defvar dont-bind-my-keys)
(if (not (and (boundp 'dont-bind-my-keys) dont-bind-my-keys))
    (global-set-key "\C-ct" 
                    (dmacro-function "dstamp" "dtstamp" 'insert-timestamp))
  )

;;; automatic insertion of masthead
(setq auto-dmacro-alist (append '(("\\.[fF]$" . masthead)
                                  )
                                auto-dmacro-alist))

;;; aliases
(def-dmacro-alias
  dn ((month-num) :pad nil)
  dd ((chron) 8 10 :pad nil)
  dy ((chron) 22)
  )
  
;;; global dmacros
(add-dmacros 'global-abbrev-table '(
    ("dstamp"   " -~((user-initials) :down)~dn/~dd/~dy."
     nil        "user id and date")
    ("dtstamp"  " -~((user-initials) :down)~dn/~dd/~dy ~((hour) :pad nil):~min~ampm."
     nil        "user id, date and time")
    ))

;;; fortran-mode dmacros

(add-dmacros 'fortran-mode-abbrev-table '(
;
; masthead banner 
; inserts RCS and modify tags
 ("masthead" "c     ~(file-name).~(file-ext) - ~(point)
c     
c     Copyright (c) ~(year) by ~(user-name).  This program is free
c     software; you can redistribute it and/or modify it under the 
c     terms of the GNU General Public License.
c     
c     description - ~(mark)
c     
c     created - ~((shell \"date\") 0 -1)
c     author  - ~(user-name) <~(user-id)@~((shell \"hostname\") 0 -1)\
~(if (eval (getenv \"DOMAIN\")) (eval (concat \".\" (getenv \"DOMAIN\"))))>
c     
c     $~(eval modify-tag)$
c     $~(eval \"Id\")$
c     $~(eval \"Revision\")$

      ~(mark)\n" dmacro-expand "masthead for fortran files")
;
; short masthead banner 
 ("mastheadshort" "c     ~(file-name).~(file-ext) - ~(point)
c     
c     Copyright (c) ~(year) by ~(user-name).
c     
c     description - ~(mark)
c     
c     created - ~((shell \"date\") 0 -1)
c     author  - ~(user-name) <~(user-id)@~((shell \"hostname\") 0 -1)\
~(if (eval (getenv \"DOMAIN\")) (eval (concat \".\" (getenv \"DOMAIN\"))))>

      ~(mark)\n" dmacro-expand "short masthead for fortran files")
;
;
 ("if" " if (~@) then
 ~(mark)
end if\n" dmacro-indent "if-then statement")
;
; if-then-else construct
 ("ife" " if (~@) then
 ~(mark)
else
 ~(mark)
end if\n" dmacro-indent "if-then/else statement")
;
; if-then-else-if construct
 ("ifeif" " if (~@) then
 ~(mark)
else if (~mark) then
 ~(mark)
end if\n" dmacro-indent "if-then/else-if statement")
;
; do-end-do construct
("do" " do ~(prompt counter) = ~(prompt start), ~(prompt end)
         ~(point)
       end do ! ~(prompt counter)\n" dmacro-indent "do loop")
;
; do-end-do construct for ith = 1 to ?
; (lrd: I personally use `ith' because `i' occurs too frequently to make 
; searching for it meaningful -- others may disagree...)
("doith" " do ith = 1, ~@, 1
            ~(mark)
          end do ! ith\n"
dmacro-indent "simple incremental do loop, ith = 1, ?")
; 
; do-continue construct (blah!)
("doc" " do ~(prompt label) ~(prompt counter) = ~(prompt start), ~(prompt end)
         ~(point)
~(prompt label) continue ! ~(prompt counter)\n" dmacro-indent "do loop with continue")
; 
; do-continue construct for ith = 1 to ?
("doithc" " do ~(prompt label) ith = 1, ~@, 1
            ~(mark)
          ~(prompt label) continue ! ith\n"
dmacro-indent "simple incremental do loop, ith = 1, ? with continue")
; 
 ("while" " do while (~@)
     ~mark
   end do\n" dmacro-indent "do-while statement")
;
("write" " write (~(prompt unit \"unit number? \"),'(~@)') ~(mark)"
dmacro-indent "write statement (prompts for unit number)")
;
("read" " read (~(prompt unit \"unit number? \"),'(~@)') ~(mark)"
dmacro-indent "read statement (prompts for unit number)")
;
("readff" " read (~(prompt unit \"unit number? \"),*) ~@"
dmacro-indent "free format read statement (prompts for unit number)")
;
("opencl" " open ( unit = ~(prompt unit \"unit number? \"), \
file = '~(prompt filename)', status = '~@' )
           ~(mark)
       close ( unit= ~(prompt unit \"unit number? \") ) ! ~(prompt filename)\n"
dmacro-indent "open/close statement (prompts for unit number and filename)")
;
("open" " open ( unit = ~(prompt unit \"unit number? \"), \
file = '~(prompt filename)', status = '~@' )
          ~(mark)\n"
dmacro-indent "open statement (prompts for unit number and filename)")
;
("close" " close (unit = ~(prompt unit \"unit number? \"))
          ~(mark)\n"
dmacro-indent "close statement (prompts for unit number)")
;
("print" " print '(~@)'~(mark), ~(mark)"
dmacro-indent "print statement (standard output)")
; 
; intrinsics
; 
("i-dble" "dble(~@)~(mark)" dmacro-indent "dble statement")
("i-sqrt" "sqrt(~@)~(mark)" dmacro-indent "sqrt statement")
("i-int" "int(~@)~(mark)" dmacro-indent "int statement")
("i-abs" "abs(~@)~(mark)" dmacro-indent "abs statement")
("i-sin" "sin(~@)~(mark)" dmacro-indent "sin statement")
("i-cos" "cos(~@)~(mark)" dmacro-indent "cos statement")
("i-tan" "tan(~@)~(mark)" dmacro-indent "tan statement")
("i-exp" "exp(~@)~(mark)" dmacro-indent "exp statement")
("i-log" "log(~@)~(mark)" dmacro-indent "log (ln) statement")
;
("prog" " program ~(prompt name)

      implicit none  

      ~(point)

      stop
      end ! program ~(prompt name) \n" dmacro-indent "program heading")
;
;
("func" " ~(prompt type) function ~(prompt name) (~(point) )

      implicit none  

      ~(mark)

      return
      end ! function ~(prompt name)\n" dmacro-indent "function header")
;
("subr" " subroutine ~(prompt name) (~(point) )

      implicit none  

      ~(mark)

      return
      end ! subroutine ~(prompt name)\n" dmacro-indent "subroutine header")
;
("history"      "     ~(user-id) - ~(mon) ~dd, ~(year): "       expand
     "a new HISTORY entry in the masthead")
;
; for those fortran hackers who use cpp directives --
;
; do _not_ put a space b/w `"' and `#' 
; user _has_ to be in the first column for this to work seamlessly
;;;
 ("ifd" "#if ~@
~(mark)
#endif\n" dmacro-indent "#if/#endif (no prompting)")
;;;
 ("iifd" "#if ~(prompt constant \"#if condition: \")
~@
#endif /* ~(prompt) */\n" dmacro-indent "#if/#endif (prompts for condition)")
;;;
 ("iifed" "#if ~(prompt constant \"#if condition: \")
~@
#else /* NOT ~(prompt) */
 ~(mark)
#endif /* ~(prompt) */\n" dmacro-indent "#if/#else/#endif (prompts for condition)")
;;;
 ("i" "#include \"~@.h\"
" dmacro-indent "simple #include directive")
;;;
 ("ifddebug" "#if DEBUG
~@
#endif /* DEBUG */\n" dmacro-indent "debug ifdef")
;;;
 ("ifdnever" "#if NEVER
~@
#endif /* NEVER */\n" dmacro-indent "#ifdef NEVER (ideal for use with dmacro-wrap-region)")
))


;;; provide this package
(provide 'dm-f)
----------


