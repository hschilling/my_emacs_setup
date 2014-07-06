
(require 'dmacro)

;;(require 'fortran)

( load "fortran" )

(add-dmacros 'fortran-mode-abbrev-table '(
 ("f-program" "C**********************************************************************
C       
C             Fortran main program
C       
C             Name        : ~(prompt name \"Program name: \") 
C             Purpose     : ~@
C             Created by  : ~(user-name)
C             Date created: ~(chron)
C             Revisions   :
C       
C**********************************************************************

      program ~(prompt name)
      implicit none

      ~@

      end !  End of ~((prompt name):cap) main program

" expand "Header for a Fortran main program")
))

(add-dmacros 'fortran-mode-abbrev-table '(
 ("f-subroutine" "C**********************************************************************
C       
C             Fortran subroutine
C       
C             Name        : ~(prompt name \"Subroutine name: \") 
C             Purpose     : ~@
C             Created by  : ~(user-name)
C             Date created: ~(chron)
C             Revisions   :
C       
C**********************************************************************

      subroutine ~(prompt name) ( ~mark )
      implicit none

      ! Inputs

      ! Outputs

      ! Locals

      ~mark

      end !  End of ~((prompt name):cap) subroutine

" expand "Header for a Fortran subroutine")
))

(add-dmacros 'fortran-mode-abbrev-table '(
 ("f-function" "C**********************************************************************
C       
C             Fortran function
C       
C             Name        : ~(prompt name \"Function name: \") 
C             Purpose     : ~@
C             Created by  : ~(user-name)
C             Date created: ~(chron)
C             Revisions   :
C       
C**********************************************************************

      ~(prompt type \"Function type: \") function ~(prompt name) ( ~mark )
      implicit none

      ! Inputs

      ! Locals

      ~mark

      ~(prompt name) = ???

      end !  End of ~((prompt name):cap) function

" expand "Header for a Fortran function")
))

(setq auto-dmacro-alist (append '(("\\.f$" . f-program) )
		  auto-dmacro-alist))

