;;; table.el --- create and edit text based embedded tables

;; Copyright (C) 2000 Takaaki "Tak" Ota

;; Emacs Lisp Archive Entry
;; Filename:      table.el
;; Version:       1.020
;; Keywords:      wp, convenience
;; Author:        Takakki Ota <Takaaki.Ota@am.sony.com>
;; Maintainer:    Takakki Ota <Takaaki.Ota@am.sony.com>
;; Created:       Sun, 05 Nov 2000 10:04:40 (PST)
;; Description:   create and edit text based embedded tables
;; Compatibility: Emacs20.7.1, Emacs21.0.90.1, XEmacs21.1.9(some known issues)

(defconst table-version "1.020"
  "Table version number.")

;; NOTE: Read the commentary below for how to use this package and
;; report bugs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;
;;
;; -------------
;; Introduction:
;; -------------
;;
;; This package provides text based table creation and editing
;; feature.  With this package Emacs is capable of editing tables that
;; are embedded inside a document, the feature similar to the ones
;; seen in modern WYSIWYG word processors.  A table is a rectangular
;; text area consisting from a surrounding frame and content inside
;; the frame.  The content is usually subdivided into multiple
;; rectangular cells, see the actual tables used below in this
;; document.  Once a table is recognized, editing operation inside a
;; table cell is confined into that specific cell's rectangular area.
;; This means that typing and deleting characters inside a cell do not
;; affect any outside text but introduces appropriate formatting only
;; to the cell contents.  If necessary for accommodating added text in
;; the cell, the cell automatically grows vertically and/or
;; horizontally.  The package uses no major mode nor minor mode for
;; its implementation because the subject text is localized within a
;; buffer.  Therefore the special behaviors inside a table cells are
;; implemented by using local-map text property instead of buffer wide
;; mode-map.  Also some commonly used functions are advised so that
;; they act specially inside a table cell.
;;
;;
;; -------------
;; Entry Points:
;; -------------
;;
;; If this is the first time for you to try this package, go ahead and
;; load the package by M-x `load-file' RET.  Specify the package file
;; name "table.el".  Then switch to a new test buffer and issue the
;; command M-x `table-insert' RET.  It'll ask you number of columns,
;; number of rows, cell width and cell height.  Give some small
;; numbers for each of them.  Play with the resulted table for a
;; while.  If you have menu system find the item "Table" under "Tools"
;; and "Table" in the menu bar.  Some of them are pretty intuitive and
;; you can easily guess what they do.  When you are tired of guessing
;; how it works come back to this document again.
;;
;; To use the package regularly place this file in the site library
;; directory and add the next expression in your .emacs file.  Make
;; sure that directory is included in the `load-path'.
;;
;;   (require 'table)
;;
;; Have the next expression also, if you want always be ready to edit
;; tables inside text files.  This mechanism is analogous to
;; fontification in a sense that tables are recognized at editing time
;; without having table information saved along with the text itself.
;;
;;   (add-hook 'text-mode-hook 'table-recognize)
;;
;; Following is a table of entry points and brief description of each
;; of them.  The tables below are of course generated and edited by
;; using this package.  You can try out yourself by invoking a command
;; `table-recognize' in this buffer after loading this package.  Not
;; all the commands are bound to keys.  Many of them must be invoked
;; by "M-x"(`execute-extended-command') command.  Refer to the section
;; "Keymap" below for the commands available from keys.
;;
;; +-------------------------------+----------------------------------+
;; |`table-insert'                 |Insert a table consisting of grid |
;; |                               |of cells by specifying the number |
;; |                               |of COLUMNS, number of ROWS, cell  |
;; |                               |WIDTH and cell HEIGHT.            |
;; +-------------------------------+----------------------------------+
;; |`table-insert-row'             |Insert row(s) of cells that       |
;; |                               |matches the current row structure |
;; |                               |before the current row.           |
;; +-------------------------------+----------------------------------+
;; |`table-insert-column'          |Insert column(s) of cells that    |
;; |                               |matches the current column        |
;; |                               |structure before the current      |
;; |                               |column.                           |
;; +-------------------------------+----------------------------------+
;; |`table-recognize'              |Recognize all tables in the       |
;; |`table-unrecognize'            |current buffer and                |
;; |                               |activate/inactivate them.         |
;; +-------------------------------+----------------------------------+
;; |`table-recognize-region'       |Recognize all the cells in a      |
;; |`table-unrecognize-region'     |region and activate/inactivate    |
;; |                               |them.                             |
;; +-------------------------------+----------------------------------+
;; |`table-recognize-table'        |Recognize all the cells in a      |
;; |`table-unrecognize-table'      |single table and                  |
;; |                               |activate/inactivate them.         |
;; +-------------------------------+----------------------------------+
;; |`table-recognize-cell'         |Recognize a cell.  Find a cell    |
;; |`table-unrecognize-cell'       |which contains the current point  |
;; |                               |and activate/inactivate that cell.|
;; +-------------------------------+----------------------------------+
;; |`table-forward-cell'           |Move point to the next Nth cell in|
;; |                               |a table.                          |
;; +-------------------------------+----------------------------------+
;; |`table-backward-cell'          |Move point to the previous Nth    |
;; |                               |cell in a table.                  |
;; +-------------------------------+----------------------------------+
;; |`table-span-cell'              |Span the current cell toward the  |
;; |                               |specified direction and merge it  |
;; |                               |with the adjacent cell.  The      |
;; |                               |direction is right, left, above or|
;; |                               |below.                            |
;; +-------------------------------+----------------------------------+
;; |`table-split-cell-vertically'  |Split the current cell vertically |
;; |                               |and create a cell above and a cell|
;; |                               |below the point location.         |
;; +-------------------------------+----------------------------------+
;; |`table-split-cell-horizontally'|Split the current cell            |
;; |                               |horizontally and create a cell on |
;; |                               |the left and a cell on the right  |
;; |                               |of the point location.            |
;; +-------------------------------+----------------------------------+
;; |`table-split-cell'             |Split the current cell vertically |
;; |                               |or horizontally.  This is a       |
;; |                               |wrapper command to the other two  |
;; |                               |orientation specific commands.    |
;; +-------------------------------+----------------------------------+
;; |`table-heighten-cell'          |Heighten the current cell.        |
;; +-------------------------------+----------------------------------+
;; |`table-shorten-cell'           |Shorten the current cell.         |
;; +-------------------------------+----------------------------------+
;; |`table-widen-cell'             |Widen the current cell.           |
;; +-------------------------------+----------------------------------+
;; |`table-narrow-cell'            |Narrow the current cell.          |
;; +-------------------------------+----------------------------------+
;; |`table-fixed-width-mode'       |Toggle fixed width mode.  In the  |
;; |                               |fixed width mode, typing inside a |
;; |                               |cell never changes the cell width,|
;; |                               |where in the normal mode the cell |
;; |                               |width expands automatically in    |
;; |                               |order to prevent a word being     |
;; |                               |folded into multiple lines.  Fixed|
;; |                               |width mode reverses video or      |
;; |                               |underline the cell contents for   |
;; |                               |its indication.                   |
;; +-------------------------------+----------------------------------+
;; |`table-query-dimension'        |Compute and report the current    |
;; |                               |cell dimension, current table     |
;; |                               |dimension and the number of       |
;; |                               |columns and rows in the table.    |
;; +-------------------------------+----------------------------------+
;; |`table-version'                |Show the current table package    |
;; |                               |version.                          |
;; +-------------------------------+----------------------------------+
;;
;;
;; -------
;; Keymap:
;; -------
;;
;; Although this package does not use a mode it does use its own
;; keymap inside a table cell by way of keymap text property.  Some of
;; the standard basic editing commands bound to certain keys are
;; replaced with the table specific version of corresponding commands.
;; This replacement combination is listed in the constant alist
;; `table-command-replacement-alist' declared below.  This alist is
;; not meant to be user configurable but mentioned here for your
;; better understanding of using this package.  In addition, table
;; cells have some table specific bindings for cell navigation and
;; cell reformation.  You can find these additional bindings in the
;; constant `table-cell-bindings'.  There is a "normal hooks" variable
;; `table-cell-map-hook' prepared for users to override the default
;; table cell bindings.  Following is the table of predefined default
;; key bound commands inside a table cell.  Remember these bindings
;; exist only inside a table cell.
;;
;; +------------------------------------------------------------------+
;; |                Default Bindings in a Table Cell                  |
;; +-------+----------------------------------------------------------+
;; |  Key  |                      Function                            |
;; +-------+----------------------------------------------------------+
;; |  TAB  |Move point forward to the beginning of the next cell.     |
;; +-------+----------------------------------------------------------+
;; | "C->" |Widen the current cell.                                   |
;; +-------+----------------------------------------------------------+
;; | "C-<" |Narrow the current cell.                                  |
;; +-------+----------------------------------------------------------+
;; | "C-}" |Heighten the current cell.                                |
;; +-------+----------------------------------------------------------+
;; | "C-{" |Shorten the current cell.                                 |
;; +-------+----------------------------------------------------------+
;; | "C--" |Split current cell vertically. (one above and one below)  |
;; +-------+----------------------------------------------------------+
;; | "C-|" |Split current cell horizontally. (one left and one right) |
;; +-------+----------------------------------------------------------+
;; | "C-*" |Span current cell into adjacent one.                      |
;; +-------+----------------------------------------------------------+
;; | "C-+" |Insert row(s)/column(s).                                  |
;; +-------+----------------------------------------------------------+
;; | "C-!" |Toggle between normal mode and fixed width mode.          |
;; +-------+----------------------------------------------------------+
;; | "C-#" |Report cell and table dimension.                          |
;; +-------+----------------------------------------------------------+
;;
;;
;; -----
;; Menu:
;; -----
;;
;; If a menu system is available a group of table specific menu items,
;; "Table" under "Tools" section of the menu bar, is globally added
;; after this package is loaded.  The commands in this group are
;; limited to the ones that are related to creation and initialization
;; of tables, such as insert a table, rows and columns, or recognize
;; and unrecognize tables.  Once tables are created and point is
;; placed inside of a table a table specific menu item "Table" appears
;; directly on the menu bar.  The commands in this menu give full
;; control on table manipulation that include cell navigation,
;; insertion, splitting, spanning, shrinking, expansion and
;; unrecognizing.  In addition to above two types of menu there is a
;; pop-up menu available within a table cell.  The content of pop-up
;; menu is identical to the full table menu.  [mouse-3] is the default
;; button, defined in `table-cell-bindings', to bring up the pop-up
;; menu.  It can be reconfigured via `table-cell-map-hook'.  The
;; benefit of a pop-up menu is that it combines selection of the
;; location (which cell, where in the cell) and selection of the
;; desired operation into a single clicking action.
;;
;;
;; ---------------------------------
;; Function Advising (Modification):
;; ---------------------------------
;;
;; Some functions that are desired to run specially inside a table
;; cell are modified by way of function advice mechanism instead of
;; using key binding replacement.  The reason for this is that they
;; are such primitive that they may often be used as a building block
;; of other commands which are not known to this package, i.e. user
;; defined commands in a .emacs file.  To make sure the correct
;; behavior of them in a table cell, those functions are slightly
;; modified.  When the function executes, it checks if the point is
;; located in a table cell.  If so, the function behaves in a slightly
;; modified fashion otherwise executes normally.  The drawback of this
;; mechanism is there is a small overhead added to these functions for
;; testing if the location is within a table cell or not.  Due to the
;; limitation of advice mechanism those built-in subr functions in a
;; byte compiled package are out of reach from this package.
;;
;; In general, redefining (or advising) an Emacs primitive is
;; discouraged.  If you think those advising in this package are not
;; safe enough or you simply do not feel comfortable with having them
;; you can set the variable `table-disable-advising' to non-nil before
;; loading this package for the first time.  This will disable the
;; advising all together.
;;
;; The next table lists the functions that are advised to act
;; specially when used in a table cell.
;;
;; +---------------------+--------------------------------------------+
;; |`kill-region'        |Kill between point and mark.  When both     |
;; |                     |point and mark reside in a same table cell  |
;; |                     |the text in the region within the cell is   |
;; |                     |deleted and saved in the kill ring.         |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`delete-region'      |Delete the text between point and mark.     |
;; |                     |When both point and mark reside in a same   |
;; |                     |table cell the text in the region within the|
;; |                     |cell is deleted.  Otherwise it retains the  |
;; |                     |original behavior.                          |
;; +---------------------+--------------------------------------------+
;; |`copy-region-as-kill'|Save the region as if killed, but don't kill|
;; |                     |it.  When both point and mark reside in a   |
;; |                     |same table cell the text in the region      |
;; |                     |within the cell is saved.  Otherwise it     |
;; |                     |retains the original behavior.              |
;; +---------------------+--------------------------------------------+
;; |`kill-line'          |Kill the rest of the current line within a  |
;; |                     |table cell when point is in an active table |
;; |                     |cell.  Otherwise it retains the original    |
;; |                     |behavior.                                   |
;; +---------------------+--------------------------------------------+
;; |`yank'               |Reinsert the last stretch of killed text    |
;; |                     |within a cell when point resides in a       |
;; |                     |cell.  Otherwise it retains the original    |
;; |                     |behavior.                                   |
;; +---------------------+--------------------------------------------+
;; |`beginning-of-line'  |Move point to beginning of current line     |
;; |                     |within a cell when current point resides in |
;; |                     |a cell.  Otherwise it retains the original  |
;; |                     |behavior.                                   |
;; +---------------------+--------------------------------------------+
;; |`end-of-line'        |Move point to end of current line within a  |
;; |                     |cell when current point resides in a cell.  |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`forward-word'       |Move point forward word(s) within a cell    |
;; |                     |when current point resides in a cell.       |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`backward-word'      |Move point backward word(s) within a cell   |
;; |                     |when current point resides in a cell.       |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`forward-paragraph'  |Move point forward paragraph(s) within a    |
;; |                     |cell when current point resides in a cell.  |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`backward-paragraph' |Move point backward paragraph(s) within a   |
;; |                     |cell when current point resides in a cell.  |
;; |                     |Otherwise it retains the original behavior. |
;; +---------------------+--------------------------------------------+
;; |`center-line'        |Center the line point is on within a cell   |
;; |                     |when current point resides in a             |
;; |                     |cell. Otherwise it retains the original     |
;; |                     |behavior.                                   |
;; +---------------------+--------------------------------------------+
;; |`center-region'      |Center each non-blank line between point and|
;; |                     |mark.  When both point and mark reside in a |
;; |                     |same table cell the text in the region      |
;; |                     |within the cell is centered.  Otherwise it  |
;; |                     |retains the original behavior.              |
;; +---------------------+--------------------------------------------+
;;
;;
;; -------------------------------
;; Definition of tables and cells:
;; -------------------------------
;;
;; There is no artificial-intelligence magic in this package.  The
;; definition of a table and the cells inside the table is reasonably
;; limited in order to achieve acceptable performance in the
;; interactive operation under Emacs lisp implementation.  A valid
;; table is a rectangular text area completely filled with valid
;; cells.  A valid cell is a rectangle text area, which four borders
;; consist of valid border characters.  Cells can not be nested one to
;; another or overlapped to each other except sharing the border
;; lines.  A valid character of a cell's vertical border is either
;; table-cell-vertical-char `|' or table-cell-intersection-char `+'.
;; A valid character of a cell's horizontal border is either
;; table-cell-horizontal-char `-' or table-cell-intersection-char `+'.
;; A valid character of the four corners of a cell must be
;; table-cell-intersection-char `+'.  A cell must contain at least one
;; character space inside.  There is no restriction about the contents
;; of a table cell, however it is advised if possible to avoid using
;; any of the border characters inside a table cell.  Normally a few
;; boarder characters inside a table cell are harmless. But it is
;; possible that they accidentally align up to emulate a bogus cell
;; corner on which software relies for cell recognition.  When this
;; happens the software may be fooled by it and fail to determine
;; correct cell dimension.
;;
;; Following are the examples of valid tables.
;;
;; +--+----+---+     +-+     +--+-----+
;; |  |    |   |     | |     |  |     |
;; +--+----+---+     +-+     |  +--+--+
;; |  |    |   |             |  |  |  |
;; +--+----+---+             +--+--+  |
;;                           |     |  |
;;                           +-----+--+
;;
;; The next four tables are the examples of invalid tables.  (From
;; left to right, 1. nested cells 2. overlapped cells and a
;; non-rectangle cell 3. non-rectangle table 4. zero width/height
;; cells)
;;
;; +-----+    +-----+       +--+    +-++--+
;; |     |    |     |       |  |    | ||  |
;; | +-+ |    |     |       |  |    | ||  |
;; | | | |    +--+  |    +--+--+    +-++--+
;; | +-+ |    |  |  |    |  |  |    +-++--+
;; |     |    |  |  |    |  |  |    | ||  |
;; +-----+    +--+--+    +--+--+    +-++--+
;;
;; Although the program may recognizes some of these invalid tables,
;; results from the subsequent editing operations inside those cells
;; are not predictable and will most likely start destroying the table
;; structures.
;;
;;
;; -------------------------
;; Cell contents formatting:
;; -------------------------
;;
;; The cell contents are formatted by filling a paragraph immediately
;; after characters are inserted into or deleted from a cell.  Because
;; of this, cell contents always remain fit inside a cell neatly.  One
;; drawback of this is that users do not have full control over
;; spacing between words and line breaking.  Only one space can be
;; entered between words and up to two spaces between sentences.  For
;; a newline to be effective the new line must form a beginning of
;; paragraph, otherwise it'll automatically be merged with the
;; previous line in a same paragraph.  To form a new paragraph the
;; line must start with some space characters or immediately follow a
;; blank line.  Here is a typical example of how to list items within
;; a cell.  Without a space at the beginning of each line each item
;; can not stand on its own.
;;
;; +---------------------------------+
;; |Each one of the following three  |
;; |items starts with a space        |
;; |character thus forms a paragraph |
;; |of its own.  Limitations in cell |
;; |contents formatting are:         |
;; |                                 |
;; | 1. Only one space between words.|
;; | 2. Up to two spaces between     |
;; |sentences.                       |
;; | 3. A paragraph must start with  |
;; |spaces or follow a blank line.   |
;; |                                 |
;; |This paragraph stays away from   |
;; |the item 3 because there is a    |
;; |blank line between them.         |
;; +---------------------------------+
;;
;; In the normal operation table cell width grows automatically when
;; certain word has to be folded into the next line if the width had
;; not been increased.  This normal operation is useful and
;; appropriate for most of the time, however, it is sometimes useful
;; or necessary to fix the width of table and width of table cells.
;; For this purpose the package provides fixed width mode.  You can
;; toggle between fixed width mode and normal mode by "C-!".
;;
;; Here is a simple example of the fixed width mode.  Suppose we have
;; a table like this one.
;;
;; +-----+
;; |     |
;; +-----+
;;
;; In normal mode if you type a word "antidisestablishmentarianism" it
;; grows the cell horizontally like this.
;;
;; +----------------------------+
;; |antidisestablishmentarianism|
;; +----------------------------+
;;
;;  In the fixed width mode the same action produces the following
;;  result.  The folded locations are indicated by a continuation
;;  character (`\' is the default).  The continuation character is
;;  treated specially so it is recommended to choose a character that
;;  does not appear elsewhere in the document.  This character is
;;  configurable via customization and is kept in the variable
;;  `table-word-continuation-char'.  The continuation character is
;;  treated specially only in the fixed width mode and has no special
;;  meaning in the normal mode however.
;;
;; +-----+
;; |anti\|
;; |dise\|
;; |stab\|
;; |lish\|
;; |ment\|
;; |aria\|
;; |nism |
;; +-----+
;;
;;
;; -----
;; Todo: (in the order of priority, some are just possibility)
;; -----
;;
;; Resolve conflict with flyspell
;; Consider the use of variable width font under Emacs 21
;; Consider the use of `:box' face attribute under Emacs 21
;; Consider the use of `modification-hooks' text property instead of
;; rebinding the keymap
;; Generate HTML table? Render table from HTML? Collaborate with w3?
;; Maybe provide complete XEmacs support in the future however the
;; "extent" is the single largest obstacle lying ahead, read the
;; document (eval '(Info-find-node "elisp" "Not Intervals")) in Emacs
;; info.
;;
;;
;; ---------------
;; Acknowledgment:
;; ---------------
;;
;; Table would not have been possible without the help and
;; encouragement of the following spirited contributors.
;;
;; Paul Georgief <pgeorgie@doctordesign.com> has been the best tester
;; of the code as well as the constructive criticizer.
;;
;; Gerd Moellmann <gerd@gnu.org> gave me useful suggestions from Emacs
;; 21 point of view.
;;
;; Richard Stallman <rms@gnu.org> showed the initial interest in this
;; attempt of implementing the table feature to Emacs.  This greatly
;; motivated me to follow through to its completion.
;;
;; Kenichi Handa <handa@etl.go.jp> kindly guided me through to
;; overcome many technical issues while I was struggling with quail
;; related internationalization problems.
;;
;; Christoph Conrad <christoph.conrad@gmx.de> suggested making symbol
;; names consistent as well as fixing several bugs.
;;
;; Paul Lew <paullew@cisco.com> suggested implementing fixed width
;; mode as well as multi column width (row height) input interface.

;;; Code:



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compatibility:
;;;

(if (featurep 'custom) nil
  ;; ignore or use substitution
  (defmacro defgroup (&rest args))
  (defmacro defface (symbol value doc &rest args)
    (` (make-face (, symbol))))
  (defmacro defcustom (symbol value doc &rest args)
    (` (defvar (, symbol) (, value) (, doc)))))

(require 'advice) ;; can't get around without this
(require 'rect)
(require 'tabify)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Customization:
;;;

(defgroup table nil
  "Text based table manipulation utilities.
See `table-insert' for examples about how to use."
  :tag "Table"
  :prefix "table-"
  :group 'editing
  :group 'wp
  :group 'paragraphs
  :group 'fill)

(defcustom table-time-before-update 0.2
  "*Time in seconds before updating the cell contents.
Updating the cell contents on the screen takes place only after this
specified amount of time has passed after the last modification to the
cell contents.  When the contents of a table cell changes repetitively
and frequently the updating the cell contents on the screen is
deferred until at least this specified amount of quiet time passes.  A
smaller number wastes more computation resource by unnecessarily
frequent screen update.  A large number presents noticeable and
annoying delay before the typed result start appearing on the screen."
  :tag "Time Before Cell Update"
  :type 'number
  :group 'table)

(defface table-cell-face
  '((((class color))
     (:foreground "gray90" :background "blue"))
    (t (:bold t)))
  "*Face used for table cell contents."
  :tag "Cell Face"
  :group 'table)

(defcustom table-cell-horizontal-char ?\-
  "*Character that forms table cell's horizontal border line."
  :tag "Cell Horizontal Boundary Character"
  :type 'character
  :group 'table)

(defcustom table-cell-vertical-char ?\|
  "*Character that forms table cell's vertical border line."
  :tag "Cell Vertical Boundary Character"
  :type 'character
  :group 'table)

(defcustom table-cell-intersection-char ?\+
  "*Character that forms table cell's corner."
  :tag "Cell Intersection Character"
  :type 'character
  :group 'table)

(defcustom table-word-continuation-char ?\\
  "*Character that indicates word continuation into the next line.
This character has a special meaning only in the fixed width mode,
that is when `table-fixed-width-mode' is non-nil .  In the fixed width
mode this character indicates that the location is continuing into the
next line.  Be careful about the choice of this character.  It is
treated substantially different manner than ordinary characters.  Try
select a character that is unlikely to appear in your document."
  :tag "Cell Word Continuation Character"
  :type 'character
  :group 'table)

(defun table-set-table-fixed-width-mode (variable value)
  (if (fboundp variable)
      (funcall variable (if value 1 -1))))

(defun table-initialize-table-fixed-width-mode (variable value)
  (set variable value))

(defcustom table-fixed-width-mode nil
  "*Cell width is fixed when this is non-nil.
Normally it should be nil for allowing automatic cell width expansion
that widens a cell when it is necessary.  When non-nil, typing in a
cell does not automatically expand the cell width.  A word that is too
long to fit in a cell is chopped into multiple lines.  The chopped
location is indicated by `table-word-continuation-char'.  This
variable's value can be toggled by \\[table-fixed-width-mode] at
run-time."
  :tag "Fix Cell Width"
  :type 'boolean
  :initialize 'table-initialize-table-fixed-width-mode
  :set 'table-set-table-fixed-width-mode
  :group 'table)

(defcustom table-cell-map-hook nil
  "*Normal hooks run when finishing construction of `table-cell-map'.
User can modify `table-cell-map' by adding custom functions here."
  :tag "Cell Keymap Hooks"
  :type 'hook
  :group 'table)

(defvar table-disable-menu nil
  "*When non-nil, use of menu by table package is disabled.
It must be set before loading this package `table.el' for the first
time.")

(defvar table-disable-advising nil
  "*When non-nil, all function advising are disabled.
It must be set before loading this package `table.el' for the first
time.")

(if (require 'easymenu) nil
  (setq table-disable-menu t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Implementation:
;;;

;;; Internal variables and constants
;;; No need of user configuration

(defconst table-cache-buffer-name " *table cell cache*"
  "Cell cache buffer name.")
(defvar table-cell-info-lu-coordinate nil
  "Zero based coordinate of the cached cell's left upper corner.")
(defvar table-cell-info-rb-coordinate nil
  "Zero based coordinate of the cached cell's right bottom corner.")
(defvar table-cell-info-width nil
  "Number of characters per cached cell width.")
(defvar table-cell-info-height nil
  "Number of lines per cached cell height.")
(defvar table-cell-self-insert-command-count 0
  "Counter for undo control.")
(defvar table-cell-map nil
  "Keymap for table cell contents.")
(defvar table-cell-global-map-alist nil
  "Alist of copy of global maps that are substituted in `table-cell-map'.")
(defvar table-global-menu-map nil
  "Menu map created via `easy-menu-define'.")
(defvar table-cell-menu-map nil
  "Menu map created via `easy-menu-define'.")
(defvar table-cell-buffer nil
  "Buffer that contains the table cell.")
(defvar table-cell-cache-point-coordinate nil
  "Cache point coordinate based from the cell origin.")
(defvar table-update-timer nil
  "Timer id for deferred cell update.")
(defvar table-widen-timer nil
  "Timer id for deferred cell update.")
(defvar table-inhibit-update nil
  "Non-nil inhibits implicit cell and cache updates.
It inhibits `table-with-cache-buffer' to update data in both direction, cell to cache and cache to cell.")
(defvar table-inhibit-auto-fill-paragraph nil
  "Non-nil inhibits auto fill paragraph when `table-with-cache-buffer' exits.
This is always set to nil at the entry to `table-with-cache-buffer' before executing body forms.")
(defvar table-inhibit-advice nil
  "Non-nil inhibits running advised functions.
All top-level table commands set t to this variable before its
execution in order to prevent infinite recursion of advised functions.
Do not get confused with `table-disable-advising' which use is
statically disabling advising feature of this package at all, while
`table-inhibit-advice' is dynamically turned on and off in the couse
of table command execution.
")
(defvar table-mode-indicator nil
  "For mode line indicator")
(defvar table-fixed-mode-indicator nil
  "For mode line indicator")
;;; These are not real minor-mode but placed in the minor-mode-alist
;;; so that we can show the indicator on the mode line handy.
(mapcar (function (lambda (indicator)
		    (make-variable-buffer-local (car indicator))
		    (unless (assq (car indicator) minor-mode-alist)
		      (setq minor-mode-alist
			    (cons indicator minor-mode-alist)))))
	'((table-mode-indicator " Table")
	  (table-fixed-mode-indicator " Fixed-Table")))
;;; The following history containers not only keep the history of user
;;; entries but also serve as the default value providers.  When an
;;; interactive command is invoked it offers a user the latest entry
;;; of the history as a default selection.  Therefore the values below
;;; are the first default value when a command is invoked for the very
;;; first time when there is no real history existing yet.
(defvar table-cell-span-direction-history '("right"))
(defvar table-cell-split-orientation-history '("horizontally"))
(defvar table-cell-split-squeeze-side-history '("left"))
(defvar table-insert-row-column-history '("row"))
(defvar table-justify-history '("center"))
(defvar table-columns-history nil)
(defvar table-rows-history nil)
(defvar table-cell-width-history '("5"))
(defvar table-cell-height-history '("1"))

;;; Some entries in `table-cell-bindings' are duplicated in
;;; `table-command-replacement-alist'.  There is a good reason for
;;; this.  Common key like return key may be taken by some other
;;; function than normal `newline' function.  Thus binding return key
;;; directly for `table-cell-newline' ensures that the correct enter
;;; operation in a table cell.  However
;;; `table-command-replacement-alist' has an additional role than
;;; replacing commands.  It is also used to construct a table command
;;; list.  This list is very important because it is used to check if
;;; the previous command was one of them in this list or not.  If the
;;; previous command is found in the list the current command will not
;;; refill the table cache.  If the command were not listed fast
;;; typing can cause unwanted cache refill.
(defconst table-cell-bindings
  '(([tab]          . table-forward-cell)
    ([(control i)]  . table-forward-cell)
    ([(shift tab)]  . table-backward-cell)
    ([(control I)]  . table-backward-cell)
    ([return]       . table-cell-newline)
    ([(control m)]  . table-cell-newline)
    ([(control j)]  . table-cell-newline-and-indent)
    ([(mouse-3)]    . table-present-cell-popup-menu)
    ([(control \>)] . table-widen-cell)
    ([(control \<)] . table-narrow-cell)
    ([(control \})] . table-heighten-cell)
    ([(control \{)] . table-shorten-cell)
    ([(control \-)] . table-split-cell-vertically)
    ([(control \|)] . table-split-cell-horizontally)
    ([(control \*)] . table-span-cell)
    ([(control \+)] . table-insert-row-column)
    ([(control \!)] . table-fixed-width-mode)
    ([(control \#)] . table-query-dimension)
    )
  "Bindings for table cell commands.")

(defconst table-command-replacement-alist
  '((self-insert-command . table-cell-self-insert-command)
    (completion-separator-self-insert-autofilling . table-cell-self-insert-command)
    (completion-separator-self-insert-command . table-cell-self-insert-command)
    (delete-char . table-cell-delete-char)
    (delete-backward-char . table-cell-delete-backward-char)
    (newline . table-cell-newline)
    (newline-and-indent . table-cell-newline-and-indent)
    (open-line . table-cell-open-line)
    (quoted-insert . table-cell-quoted-insert)
    (describe-mode . table-describe-mode)
    (describe-bindings . table-describe-bindings)
    )
  "List of cons cells consisting of (ORIGINAL-COMMAND . TABLE-VERSION-COMMAND).")

(defconst table-command-list nil
  "List of commands that override original commands.")
;; construct the real contents of the `table-command-list'
(let ((repl-alist table-command-replacement-alist))
  (setq table-command-list nil)
  (while repl-alist
    (setq table-command-list (cons (cdar repl-alist) table-command-list))
    (setq repl-alist (cdr repl-alist))))

(defconst table-global-menu
  '("Table"
    ("Insert"
     ["a Table..." table-insert (and (not buffer-read-only)
					   (not (table-probe-cell)))]
     ["Row" table-insert-row (and (not buffer-read-only)
				  (or (table-probe-cell)
				      (save-excursion
					(table-find-row-column nil t))))]
     ["Column" table-insert-column (and (not buffer-read-only)
					(or (table-probe-cell)
					    (save-excursion
					      (table-find-row-column 'column t))))])
    "----"
    ("Recognize"
     ["in Buffer" table-recognize t]
     ["in Region" table-recognize-region t]
     ["a Table" table-recognize-table (table-probe-cell)]
     ["a Cell" table-recognize-cell
      (let ((cell (table-probe-cell)))
	(and cell (null (table-at-cell-p (car cell)))))])
    ("Unrecognize"
     ["in Buffer" table-unrecognize t]
     ["in Region" table-unrecognize-region t]
     ["a Table" table-unrecognize-table (table-probe-cell)]
     ["a Cell" table-unrecognize-cell
      (let ((cell (table-probe-cell)))
	(and cell (table-at-cell-p (car cell))))])
    "----"
    ["Show Version" table-version t]))

(defconst table-cell-menu
  '("Table"
    ("Insert"
     ["Row" table-insert-row (and (not buffer-read-only)
				  (or (table-probe-cell)
				      (save-excursion
					(table-find-row-column nil t))))]
     ["Column" table-insert-column (and (not buffer-read-only)
					(or (table-probe-cell)
					    (save-excursion
					      (table-find-row-column 'column t))))])
    "----"
    ("Split a Cell"
     ["Horizontally" table-split-cell-horizontally (table-cell-can-split-horizontally-p)]
     ["Vertically"  table-split-cell-vertically (table-cell-can-split-vertically-p)])
    ("Span a Cell to"
     ["Right" table-span-cell-right (table-cell-can-span-p 'right)]
     ["Left" table-span-cell-left (table-cell-can-span-p 'left)]
     ["Above" table-span-cell-above (table-cell-can-span-p 'above)]
     ["Below" table-span-cell-below (table-cell-can-span-p 'below)])
    "----"
    ("Shrink Cells"
     ["Horizontally" table-narrow-cell (table-probe-cell)]
     ["Vertically" table-shorten-cell (table-probe-cell)])
    ("Expand Cells"
     ["Horizontally" table-widen-cell (table-probe-cell)]
     ["Vertically" table-heighten-cell (table-probe-cell)])
    "----"
    ("Justify"
     ("a Cell"
      ["Left" table-justify-cell-left (table-probe-cell)]
      ["Center" table-justify-cell-center (table-probe-cell)]
      ["Right" table-justify-cell-right (table-probe-cell)])
     ("a Paragraph"
      ["Left" table-justify-cell-paragraph-left (table-probe-cell)]
      ["Center" table-justify-cell-paragraph-center (table-probe-cell)]
      ["Right" table-justify-cell-paragraph-right (table-probe-cell)]))
    "----"
    ["Query Dimension" table-query-dimension (table-probe-cell)]
    ("Unrecognize"
     ["a Table" table-unrecognize-table (table-probe-cell)]
     ["a Cell" table-unrecognize-cell
      (let ((cell (table-probe-cell)))
	(and cell (table-at-cell-p (car cell))))])
    ("Configure to"
     ["Auto Expand Mode" (table-fixed-width-mode -1) :style radio :selected (not table-fixed-width-mode)]
     ["Fixed Width Mode" (table-fixed-width-mode 1) :style radio :selected table-fixed-width-mode])
    ("Navigate"
     ["Forward Cell" table-forward-cell (table-probe-cell)]
     ["Backward Cell" table-backward-cell (table-probe-cell)])
    ))

;; register table menu under global tools menu
(unless table-disable-menu
  (easy-menu-define table-global-menu-map nil "Table global menu" table-global-menu)
  (if (featurep 'xemacs)
      (progn
	(easy-menu-add-item nil '("Tools") table-global-menu-map))
    (easy-menu-add-item (current-global-map) '("menu-bar" "tools") '("--"))
    (easy-menu-add-item (current-global-map) '("menu-bar" "tools") table-global-menu-map)))
;   (define-key (current-global-map) [menu-bar tools table-separator]
;     '("--"))
;   (define-key (current-global-map) [menu-bar tools table]
;     (cons "Table" table-global-menu-map)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Macros
;;

(defmacro table-with-cache-buffer (&rest body)
  "Execute the forms in BODY with table cache buffer as the current buffer.
This macro simplifies the rest of the work greatly by condensing the
common idiom used in many of the cell manipulation functions.  It does
not return any meaningful value.

Save the current buffer and set the cache buffer as the current
buffer.  Move the point to the cache buffer coordinate
`table-cell-cache-point-coordinate'.  After BODY forms are executed,
the paragraph is filled as long as `table-inhibit-auto-fill-paragraph'
remains nil.  BODY can set it to t when it does not want to fill the
paragraph.  If necessary the cell width and height are extended as the
consequence of cell content modification by the BODY.  Then the
current buffer is restored to the original one.  The last cache point
coordinate is stored in `table-cell-cache-point-coordinate'.  The
original buffer's point is moved to the location that corresponds to
the last cache point coordinate."
  (let ((height-expansion (make-symbol "height-expansion-var-symbol"))
	(width-expansion (make-symbol "width-expansion-var-symbol")))
    (`
     (let ((, height-expansion) (, width-expansion))
       ;; make sure cache has valid data unless it is explicitly inhibited.
       (unless table-inhibit-update
	 (table-recognize-cell))
       (with-current-buffer (get-buffer-create table-cache-buffer-name)
	 ;; goto the cell coordinate based on `table-cell-cache-point-coordinate'.
	 (table-goto-coordinate table-cell-cache-point-coordinate)
	 (table-untabify-line)
	 ;; always reset before executing body forms because auto-fill behavior is the default.
	 (setq table-inhibit-auto-fill-paragraph nil)
	 ;; do the body
	 (,@ body)
	 ;; fill paragraph unless the body does not want to by setting `table-inhibit-auto-fill-paragraph'.
	 (unless table-inhibit-auto-fill-paragraph
	   (table-fill-region
	    (save-excursion (forward-paragraph -1) (point))
	    (save-excursion (forward-paragraph 1) (point))))
	 ;; keep the updated cell coordinate.
	 (setq table-cell-cache-point-coordinate (table-get-coordinate))
	 ;; determine the cell width expansion.
	 (setq (, width-expansion) (table-measure-max-width))
	 (if (<= (, width-expansion) table-cell-info-width) nil
	   (table-fill-region (point-min) (point-max) (, width-expansion))
	   ;; keep the updated cell coordinate.
	   (setq table-cell-cache-point-coordinate (table-get-coordinate)))
	 (setq (, width-expansion) (- (, width-expansion) table-cell-info-width))
	 ;; determine the cell height expansion.
	 (if (looking-at "\\s *\\'") nil
	   (goto-char (point-min))
	   (if (re-search-forward "\\(\\s *\\)\\'" nil t)
	       (goto-char (match-beginning 1))))
	 (setq (, height-expansion) (- (cdr (table-get-coordinate)) (1- table-cell-info-height))))
       ;; now back to the table buffer.
       ;; expand the cell width in the table buffer if necessary.
       (if (> (, width-expansion) 0)
	   (table-widen-cell (, width-expansion) 'no-copy))
       ;; expand the cell height in the table buffer if necessary.
       (if (> (, height-expansion) 0)
	   (table-heighten-cell (, height-expansion) 'no-copy))
       ;; move the point in the table buffer to the location that corresponds to
       ;; the location in the cell cache buffer
       (table-goto-coordinate (table-transcoord-cache-to-table table-cell-cache-point-coordinate))
       ;; set up the update timer unless it is explicitly inhibited.
       (unless table-inhibit-update
	 (table-update-cell))))))

(defmacro table-advice-simply-do-at-point-in-cache (func)
  "Advise FUNC to simply execute in table cache when point is in a table cell."
  (`
   (defadvice (, func) (around (, (intern (concat "table-advice-" (symbol-name func))))
			       last activate compile)
     (if table-inhibit-advice ad-do-it
       (let* ((table-inhibit-advice t)
	      (table-inhibit-update t)
	      (deactivate-mark nil))
	 (if (null (table-point-in-cell-p)) ad-do-it
	   (table-finish-delayed-tasks)
	   (table-recognize-cell 'force)
	   (table-with-cache-buffer
	    ad-do-it
	    (setq table-inhibit-auto-fill-paragraph t))))))))

(defmacro table-advice-do-at-point-in-cache (func &rest body)
  "Advise FUNC to execute BODY in table cache when point is in a table cell."
  (`
   (defadvice (, func) (around (, (intern (concat "table-advice-" (symbol-name func))))
			       last activate compile)
     (if table-inhibit-advice ad-do-it
       (let ((table-inhibit-advice t))
	 (if (null (table-point-in-cell-p)) ad-do-it
	   (table-finish-delayed-tasks)
	   (table-recognize-cell 'force)
	   (table-with-cache-buffer
	     (,@ body))
	   (table-finish-delayed-tasks)))))))

(defmacro table-advice-do-region-in-cache (func inhibit-update &rest body)
  "Advise FUNC to execute BODY in table cache when region is in a table cell."
  (`
   (defadvice (, func) (around (, (intern (concat "table-advice-" (symbol-name func))))
			       last activate compile)
     (if table-inhibit-advice ad-do-it
       (let* ((table-inhibit-advice t)
	      (beg (ad-get-arg 0))
	      (end (ad-get-arg 1)))
	 (if (null (table-region-in-cell-p beg end)) ad-do-it
	   (table-finish-delayed-tasks)
	   (table-recognize-cell 'force)
	   (let ((beg-coordinate (table-transcoord-table-to-cache (table-get-coordinate beg)))
		 (end-coordinate (table-transcoord-table-to-cache (table-get-coordinate end)))
		 (table-inhibit-update (, inhibit-update)))
	     (table-with-cache-buffer
	       (let ((beg (save-excursion (table-goto-coordinate beg-coordinate)))
		     (end (save-excursion (table-goto-coordinate end-coordinate))))
		 (ad-set-arg 0 beg)
		 (ad-set-arg 1 end)
		 (,@ body)))
	     (table-finish-delayed-tasks))))))))

;; for debugging the body form of the macro
(put 'table-with-cache-buffer 'edebug-form-spec '(body))
(put 'table-advice-simply-do-at-point-in-cache 'edebug-form-spec nil)
(put 'table-advice-do-at-point-in-cache 'edebug-form-spec '(symbolp body))
(put 'table-advice-do-region-in-cache 'edebug-form-spec '(symbolp symbolp body))
;; for neat presentation use the same indentation as `progn'
(put 'table-with-cache-buffer 'lisp-indent-function 0)
(put 'table-advice-simply-do-at-point-in-cache 'lisp-indent-function 0)
(put 'table-advice-do-at-point-in-cache 'lisp-indent-function 1)
(put 'table-advice-do-region-in-cache 'lisp-indent-function 2)
(if (or (featurep 'xemacs)
	(null (fboundp 'font-lock-add-keywords))) nil
  ;; color it as a keyword
  (font-lock-add-keywords
   'emacs-lisp-mode
   '("\\<\\(table-with-cache-buffer\\|table-advice-simply-do-at-point-in-cache\\|table-advice-do-at-point-in-cache\\|table-advice-do-region-in-cache\\)\\>")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Function advice
;;

(unless table-disable-advising
  (table-advice-simply-do-at-point-in-cache beginning-of-line)
  (table-advice-simply-do-at-point-in-cache end-of-line)
  (table-advice-simply-do-at-point-in-cache beginning-of-buffer)
  (table-advice-simply-do-at-point-in-cache end-of-buffer)
  (table-advice-simply-do-at-point-in-cache forward-word)
  (table-advice-simply-do-at-point-in-cache backward-word)
  (table-advice-simply-do-at-point-in-cache forward-paragraph)
  (table-advice-simply-do-at-point-in-cache backward-paragraph)

  (table-advice-do-region-in-cache kill-region nil
    (table-remove-cell-properties beg end)
    (table-remove-eol-spaces
     (save-excursion (table-goto-coordinate beg-coordinate))
     (save-excursion (table-goto-coordinate end-coordinate)))
    (ad-set-arg 0 (save-excursion (table-goto-coordinate beg-coordinate)))
    (ad-set-arg 1 (save-excursion (table-goto-coordinate end-coordinate)))
    ad-do-it)

  (table-advice-do-region-in-cache delete-region nil
    ad-do-it
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-region-in-cache copy-region-as-kill t
    (table-remove-cell-properties beg end)
    (table-remove-eol-spaces
     (save-excursion (table-goto-coordinate beg-coordinate))
     (save-excursion (table-goto-coordinate end-coordinate)))
    (ad-set-arg 0 (save-excursion (table-goto-coordinate beg-coordinate)))
    (ad-set-arg 1 (save-excursion (table-goto-coordinate end-coordinate)))
    ad-do-it)

  (table-advice-do-at-point-in-cache kill-line
    (unless (looking-at "\\s *$")
      (setq table-inhibit-auto-fill-paragraph t))
    (table-remove-cell-properties (point-min) (point-max))
    (table-remove-eol-spaces (point-min) (point-max))
    ad-do-it)

  (table-advice-do-at-point-in-cache yank
    ad-do-it
    (table-untabify (point-min) (point-max))
    (table-fill-region (point-min) (point-max))
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-at-point-in-cache yank-clipboard-selection
    ad-do-it
    (table-untabify (point-min) (point-max))
    (table-fill-region (point-min) (point-max))
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-at-point-in-cache insert
    (let ((beg (point)))
      ad-do-it
      (table-put-cell-content-property beg (point))))

  (table-advice-do-at-point-in-cache center-line
    (let ((fill-column table-cell-info-width))
      ad-do-it)
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-region-in-cache center-region nil
    (let ((fill-column table-cell-info-width))
      ad-do-it)
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-at-point-in-cache center-paragraph
    (let ((fill-column table-cell-info-width))
      ad-do-it)
    (setq table-inhibit-auto-fill-paragraph t))

  (table-advice-do-at-point-in-cache fill-paragraph
    (let ((fill-column table-cell-info-width))
      ad-do-it)
    (setq table-inhibit-auto-fill-paragraph t))

  ) ;; end of function advice section

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Commands
;;

;;;###autoload
(defun table-insert (columns rows &optional cell-width cell-height)
  "Insert an editable text table.
Insert a table of specified number of COLUMNS and ROWS.  Optional
parameter CELL-WIDTH and CELL-HEIGHT can specify the size of each
cell.  The cell size is uniform across the table if the specified size
is a number.  They can be a list of numbers to specify different size
for each cell.  When called interactively, the list of number is
entered by simply listing all the numbers with space characters
delimiting them.

Examples:

\\[table-insert] inserts a table at the current point location.

Suppose we have the following situation where `-!-' indicates the
location of point.

    -!-

Type \\[table-insert] and hit ENTER key.  As it asks table
specification, provide 3 for number of columns, 1 for number of rows,
5 for cell width and 1 for cell height.  Now you shall see the next
table and the point is automatically moved to the beginning of the
first cell.

    +-----+-----+-----+
    |-!-  |     |     |
    +-----+-----+-----+

Inside a table cell, there are special key bindings. \\<table-cell-map>

M-9 \\[table-widen-cell] widens the first cell which results as

    +--------------+-----+-----+
    |-!-           |     |     |
    +--------------+-----+-----+

Type \\[table-widen-cell] in the middle cell and type M-27 \\[table-widen-cell] in the right cell.  The
result will look like this:

    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    +--------------+------+--------------------------------+

If you knew each width of the columns prior to the table creation,
what you could have done better was to give the complete width
information to `table-insert'.

Cell width(s): 14 6 32

instead of 

Cell width(s): 5

This would eliminate the previously mentioned width adjustment work
all together.

Typing \\[table-heighten-cell] in above context changes the table to

    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Executing `table-insert-row' produces

    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Moving the point under the table as shown below

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    -!-

and issuing `table-insert-row' again produces

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Text editing inside the table cell produces reasonably expected
results.

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |Text editing inside the table   |
    |              |      |cell produces reasonably        |
    |              |      |expected results.-!-            |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Inside a table cell has a special keymap.

\\{table-cell-map}
"
  (interactive
   (progn
     (barf-if-buffer-read-only)
     (if (table-probe-cell)
	 (error "Can't insert a table inside a table"))
     (mapcar (function (lambda (prompt-history)
			 (read-from-minibuffer (car prompt-history)
					       (car (symbol-value (cdr prompt-history)))
					       nil nil (cdr prompt-history))))
	     '(("Number of columns: " . table-columns-history)
	       ("Number of rows: " . table-rows-history)
	       ("Cell width(s): " . table-cell-width-history)
	       ("Cell height(s): " . table-cell-height-history)))))
  (let ((table-inhibit-advice t))
    (table-make-cell-map)
    ;; reform the arguments.
    (if (null cell-width) (setq cell-width (car table-cell-width-history)))
    (if (null cell-height) (setq cell-height (car table-cell-height-history)))
    (if (stringp columns) (setq columns (string-to-number columns)))
    (if (stringp rows) (setq rows (string-to-number rows)))
    (if (stringp cell-width) (setq cell-width (table-string-to-number-list cell-width)))
    (if (stringp cell-height) (setq cell-height (table-string-to-number-list cell-height)))
    (if (numberp cell-width) (setq cell-width (cons cell-width nil)))
    (if (numberp cell-height) (setq cell-height (cons cell-height nil)))
    ;; test validity of the arguments.
    (mapcar (function (lambda (arg)
			(let* ((value (symbol-value arg))
			       (error-handler
				(function (lambda ()
					    (error "%s must be a positive integer%s" arg
						   (if (listp value) " or a list of positive integers" ""))))))
			  (if (null value) (funcall error-handler))
			  (mapcar (function (lambda (arg1)
					      (if (or (not (integerp arg1))
						      (< arg1 1))
						  (funcall error-handler))))
				  (if (listp value) value
				    (cons value nil))))))
	    '(columns rows cell-width cell-height))
    (let ((orig-coord (table-get-coordinate))
	  (coord (table-get-coordinate))
	  r i cw ch cell-str border-str)
      ;; prefabricate the building blocks border-str and cell-str.
      (with-temp-buffer
	;; construct border-str
	(insert table-cell-intersection-char)
	(setq cw cell-width)
	(setq i 0)
	(while (< i columns)
	  (insert (make-string (car cw) table-cell-horizontal-char) table-cell-intersection-char)
	  (if (cdr cw) (setq cw (cdr cw)))
	  (setq i (1+ i)))
	(setq border-str (buffer-substring (point-min) (point-max)))
	;; construct cell-str
	(erase-buffer)
	(insert table-cell-vertical-char)
	(setq cw cell-width)
	(setq i 0)
	(while (< i columns)
	  (let ((beg (point)))
	    (insert (make-string (car cw) ?\ ))
	    (insert table-cell-vertical-char)
	    (table-put-cell-line-property beg (1- (point))))
	  (if (cdr cw) (setq cw (cdr cw)))
	  (setq i (1+ i)))
	(setq cell-str (buffer-substring (point-min) (point-max))))
      ;; if the construction site has a empty border push that border down.
      (save-excursion
	(beginning-of-line)
	(if (looking-at "\\s *$")
	    (progn
	      (setq border-str (concat border-str "\n"))
	      (setq cell-str (concat cell-str "\n")))))
      ;; now build the table using the prefabricated building blocks
      (setq r 0)
      (setq ch cell-height)
      (while (< r rows)
	(if (> r 0) nil
	  (table-goto-coordinate coord) (setcdr coord (1+ (cdr coord)))
	  (table-untabify-line (point))
	  (insert border-str))
	(setq i 0)
	(while (< i (car ch))
	  (table-goto-coordinate coord) (setcdr coord (1+ (cdr coord)))
	  (table-untabify-line (point))
	  (insert cell-str)
	  (setq i (1+ i)))
	(table-goto-coordinate coord) (setcdr coord (1+ (cdr coord)))
	(table-untabify-line (point))
	(insert border-str)
	(if (cdr ch) (setq ch (cdr ch)))
	(setq r (1+ r)))
      ;; stand by at the first cell
      (table-goto-coordinate (table-offset-coordinate orig-coord '(1 . 1)))
      (table-recognize-cell 'force))))

;;;###autoload
(defun table-insert-row (n)
  "Insert N table row(s).
When point is in a table the newly inserted row(s) are placed above
the current row.  When point is outside of the table it must be below
the table within the table width range, then the newly created row(s)
are appended at the bottom of the table."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (let* ((table-inhibit-advice t)
	 (current-coordinate (table-get-coordinate))
	 (coord-list (table-cell-list-to-coord-list (table-horizontal-cell-list t nil 'top)))
	 (append-row (if coord-list nil (setq coord-list (table-find-row-column))))
	 (cell-height (cdr (table-min-coord-list coord-list)))
	 (left-list nil)
	 (this-list coord-list)
	 (right-list (cdr coord-list))
	 (bottom-border-y (1+ (cdr (table-get-coordinate (cdr (table-vertical-cell-list nil t))))))
	 (vertical-str (string table-cell-vertical-char))
	 (vertical-str-with-properties (let ((str (string table-cell-vertical-char)))
					 (table-put-cell-keymap-property 0 (length str) str)
					 (table-put-cell-rear-nonsticky 0 (length str) str) str))
	 (first-time t))
    ;; create the space below for the table to grow
    (table-create-growing-space-below (* n (+ 1 cell-height)) coord-list bottom-border-y)
    ;; vertically expand each cell from left to right
    (while this-list
      (let* ((left (prog1 (car left-list) (setq left-list (if left-list (cdr left-list) coord-list))))
	     (this (prog1 (car this-list) (setq this-list (cdr this-list))))
	     (right (prog1 (car right-list) (setq right-list (cdr right-list))))
	     (exclude-left (and left (< (cdar left) (cdar this))))
	     (exclude-right (and right (<= (cdar right) (cdar this))))
	     (beg (table-goto-coordinate
		   (cons (if exclude-left (caar this) (1- (caar this)))
			 (cdar this))))
	     (end (table-goto-coordinate
		   (cons (if exclude-right (cadr this) (1+ (cadr this)))
			 bottom-border-y)))
	     (rect (if append-row nil (extract-rectangle beg end))))
	;; prepend blank cell lines to the extracted rectangle
	(let ((i n))
	  (while (> i 0)
	    (setq rect (cons
			(concat (if exclude-left "" (char-to-string table-cell-intersection-char))
				(make-string (- (cadr this) (caar this)) table-cell-horizontal-char)
				(if exclude-right "" (char-to-string table-cell-intersection-char)))
			rect))
	    (let ((j cell-height))
	      (while (> j 0)
		(setq rect (cons
			    (concat (if exclude-left ""
				      (if first-time vertical-str vertical-str-with-properties))
				    (table-cell-blank-str (- (cadr this) (caar this)))
				    (if exclude-right "" vertical-str-with-properties))
			    rect))
		(setq j (1- j))))
	    (setq i (1- i))))
	(setq first-time nil)
	(if append-row
	    (table-goto-coordinate (cons (if exclude-left (caar this) (1- (caar this)))
					 (1+ bottom-border-y)))
	  (delete-rectangle beg end)
	  (goto-char beg))
	(table-insert-rectangle rect)))
    ;; fix up the intersections
    (setq this-list (if append-row nil coord-list))
    (while this-list
      (let ((this (prog1 (car this-list) (setq this-list (cdr this-list))))
	    (i 0))
	(while (< i n)
	  (let ((y (1- (* i (+ 1 cell-height)))))
	    (table-goto-coordinate (table-offset-coordinate (car this) (cons -1  y)))
	    (delete-char 1) (insert table-cell-intersection-char)
	    (table-goto-coordinate (table-offset-coordinate (cons (cadr this) (cdar this)) (cons 0  y)))
	    (delete-char 1) (insert table-cell-intersection-char)
	    (setq i (1+ i))))))
    ;; move the point to the beginning of the first newly inserted cell.
    (if (table-goto-coordinate
	 (if append-row (cons (car (caar coord-list)) (1+ bottom-border-y))
	   (caar coord-list))) nil
      (table-goto-coordinate current-coordinate))
    ;; re-recognize the current cell's new dimension
    (table-recognize-cell 'force)))

;;;###autoload
(defun table-insert-column (n)
  "Insert N table column(s).
When point is in a table the newly inserted column(s) are placed left
of the current column.  When point is outside of the table it must be
right side of the table within the table height range, then the newly
created column(s) are appended at the right of the table."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (let* ((table-inhibit-advice t)
	 (current-coordinate (table-get-coordinate))
	 (coord-list (table-cell-list-to-coord-list (table-vertical-cell-list t nil 'left)))
	 (append-column (if coord-list nil (setq coord-list (table-find-row-column 'column))))
	 (cell-width (car (table-min-coord-list coord-list)))
	 (border-str (table-multiply-string (concat (make-string cell-width table-cell-horizontal-char)
						    (char-to-string table-cell-intersection-char)) n))
	 (cell-str (table-multiply-string (concat (table-cell-blank-str cell-width)
						  (let ((str (string table-cell-vertical-char)))
						    (table-put-cell-keymap-property 0 (length str) str)
						    (table-put-cell-rear-nonsticky 0 (length str) str) str)) n))
	 (columns-to-extend (* n (+ 1 cell-width)))
	 (above-list nil)
	 (this-list coord-list)
	 (below-list (cdr coord-list))
	 (right-border-x (car (table-get-coordinate (cdr (table-horizontal-cell-list nil t))))))
    ;; push back the affected area above and below this table
    (table-horizontally-shift-above-and-below columns-to-extend coord-list)
    ;; process each cell vertically from top to bottom
    (while this-list
      (let* ((above (prog1 (car above-list) (setq above-list (if above-list (cdr above-list) coord-list))))
	     (this (prog1 (car this-list) (setq this-list (cdr this-list))))
	     (below (prog1 (car below-list) (setq below-list (cdr below-list))))
	     (exclude-above (and above (<= (caar above) (caar this))))
	     (exclude-below (and below (< (caar below) (caar this))))
	     (beg-coord (cons (if append-column (1+ right-border-x) (caar this))
			      (if exclude-above (cdar this) (1- (cdar this)))))
	     (end-coord (cons (1+ right-border-x)
			      (if exclude-below (cddr this) (1+ (cddr this)))))
	     rect)
	;; untabify the area right of the bar that is about to be inserted
	(let ((coord (table-copy-coordinate beg-coord))
	      (i 0)
	      (len (length rect)))
	  (while (< i len)
	    (if (table-goto-coordinate coord 'no-extension)
		(table-untabify-line (point)))
	    (setcdr coord (1+ (cdr coord)))
	    (setq i (1+ i))))
	;; extract and delete the rectangle area including the current
	;; cell and to the right border of the table.
	(setq rect (extract-rectangle (table-goto-coordinate beg-coord)
				      (table-goto-coordinate end-coord)))
	(delete-rectangle (table-goto-coordinate beg-coord)
			  (table-goto-coordinate end-coord))
	;; prepend the empty column string at the beginning of each
	;; rectangle string extracted before.
	(let ((rect-str rect)
	      (first t))
	  (while rect-str
	    (if (and first (null exclude-above))
		(setcar rect-str (concat border-str (car rect-str)))
	      (if (and (null (cdr rect-str)) (null exclude-below))
		  (setcar rect-str (concat border-str (car rect-str)))
		(setcar rect-str (concat cell-str (car rect-str)))))
	    (setq first nil)
	    (setq rect-str (cdr rect-str))))
	;; insert the extended rectangle
	(table-goto-coordinate beg-coord)
	(table-insert-rectangle rect)))
    ;; fix up the intersections
    (setq this-list (if append-column nil coord-list))
    (while this-list
      (let ((this (prog1 (car this-list) (setq this-list (cdr this-list))))
	    (i 0))
	(while (< i n)
	  (let ((x (1- (* (1+ i) (+ 1 cell-width)))))
	    (table-goto-coordinate (table-offset-coordinate (car this) (cons x  -1)))
	    (delete-char 1) (insert table-cell-intersection-char)
	    (table-goto-coordinate (table-offset-coordinate (cons (caar this) (cddr this)) (cons x  1)))
	    (delete-char 1) (insert table-cell-intersection-char)
	    (setq i (1+ i))))))
    ;; move the point to the beginning of the first newly inserted cell.
    (if (table-goto-coordinate
	 (if append-column
	     (cons (1+ right-border-x)
		   (cdar (car coord-list)))
	   (caar coord-list))) nil
      (table-goto-coordinate current-coordinate))
    ;; re-recognize the current cell's new dimension
    (table-recognize-cell 'force)))

;;;###autoload
(defun table-insert-row-column (row-column n)
  "Insert row(s) or column(s).
See `table-insert-row' and `table-insert-column'."
  (interactive
   (let ((n (prefix-numeric-value current-prefix-arg)))
     (if (< n 0) (setq n 1))
     (list (intern (let* ((completion-ignore-case t)
			(row-column-str (downcase (completing-read
						   (format "Insert %s row%s/column%s: (default %s) "
							   (if (> n 1) (format "%d" n) "a")
							   (if (> n 1) "s" "")
							   (if (> n 1) "s" "")
							   (car table-insert-row-column-history))
						   '(("row") ("column"))
						   nil t nil 'table-insert-row-column-history))))
		   (table-cleanup-xemacs-history 'table-insert-row-column-history)
		   (if (string= row-column-str "")
		       (car table-insert-row-column-history)
		     row-column-str)))
	   n)))
  (cond ((eq row-column 'row)
	 (table-insert-row n))
	((eq row-column 'column)
	 (table-insert-column n))))

;;;###autoload
(defun table-recognize (&optional arg)
  "Recognize all tables within the current buffer and activate them.
Scans the entire buffer and recognizes valid table cells.  If the
optional numeric prefix argument ARG is negative the tables in the
buffer become inactive, meaning the tables become plain text and loses
all the table specific features."
  (interactive "P")
  (let* ((table-inhibit-advice t)
	 (inhibit-read-only t))
    (save-excursion
      (goto-char (point-min))
      (let ((border (format "[%c%c%c]"
			    table-cell-horizontal-char
			    table-cell-vertical-char
			    table-cell-intersection-char))
	    (non-border (format "^[^%c%c%c]*$"
				table-cell-horizontal-char
				table-cell-vertical-char
				table-cell-intersection-char)))
	;; `table-recognize-region' is an expensive function so minimize
	;; the search area.  A minimum table at least consists of three consecutive
	;; table border characters to begin with such as
	;; +-+
	;; |A|
	;; +-+
	;; and any tables end with a line containing no table border characters
	;; or the end of buffer.
	(while (re-search-forward (concat border border border) (point-max) t)
	  (message "Recognizing tables...(%d%%)" (/ (* 100 (match-beginning 0)) (- (point-max) (point-min))))
	  (let ((beg (match-beginning 0))
		end)
	    (if (re-search-forward non-border (point-max) t)
		(setq end (match-beginning 0))
	      (setq end (goto-char (point-max))))
	    (table-recognize-region beg end arg)))
	(message "Recognizing tables...done")))))

;;;###autoload
(defun table-unrecognize ()
  (interactive)
  (table-recognize -1))

;;;###autoload
(defun table-recognize-region (beg end &optional arg)
  "Recognize all tables within region.
BEG and END specify the region to work on.  If the optional numeric
prefix argument ARG is negative the tables in the region become
inactive, meaning the tables become plain text and lose all the table
specific features."
  (interactive "r\nP")
  (if (< (prefix-numeric-value arg) 0)
      (table-remove-cell-properties beg end)
    (save-excursion
      (goto-char beg)
      (let* ((table-inhibit-advice t)
	     (border (format "[%c%c%c]"
			     table-cell-horizontal-char
			     table-cell-vertical-char
			     table-cell-intersection-char))
	     (modified-flag (buffer-modified-p))
	     (inhibit-read-only t))
	(unwind-protect
	    (progn
	      (remove-text-properties beg end '(table-cell nil))
	      (while (and (not (eobp)) (< (point) end))
		(and (null (table-at-cell-p (point)))
		     (not (looking-at border))
		     (table-recognize-cell 'force 'no-copy))
		(forward-char 1)))
	  (set-buffer-modified-p modified-flag))))))

;;;###autoload
(defun table-unrecognize-region (beg end)
  (interactive "r")
  (table-recognize-region beg end -1))

;;;###autoload
(defun table-recognize-table (&optional arg)
  "Recognize a table at point.
If the optional numeric prefix argument ARG is negative the table
becomes inactive, meaning the table becomes plain text and loses all
the table specific features."
  (interactive "P")
  (let ((unrecognize (< (prefix-numeric-value arg) 0))
	(origin-cell (table-probe-cell))
	cell)
    (if origin-cell
	(save-excursion
	  (while
	      (progn
		(table-forward-cell 1 unrecognize)
		(and (setq cell (table-probe-cell))
		     (not (equal cell origin-cell)))))))))

;;;###autoload
(defun table-unrecognize-table ()
  (interactive)
  (table-recognize-table -1))

;;;###autoload
(defun table-recognize-cell (&optional force no-copy arg)
  "Recognize a table cell that contains current point.
Probe the cell dimension and prepare the cell information.  The
optional two arguments FORCE and NO-COPY are for internal use only and
must not be specified.  When the optional numeric prefix argument ARG
is negative the cell becomes inactive, meaning that the cell becomes
plain text and loses all the table specific features."
  (interactive "i\ni\np")
  (table-make-cell-map)
  (if (or force (not (memq (table-get-last-command) table-command-list)))
      (let* ((table-inhibit-advice t)
	     (cell (table-probe-cell (interactive-p)))
	     (cache-buffer (get-buffer-create table-cache-buffer-name))
	     (modified-flag (buffer-modified-p))
	     (inhibit-read-only t))
	(unwind-protect
	    (if (null cell) nil
	      ;; initialize the cell info variables
	      (let ((lu-coordinate (table-get-coordinate (car cell)))
		    (rb-coordinate (table-get-coordinate (cdr cell))))
		;; update the previous cell if this cell is different from the previous one.
		;; care only lu but ignore rb since size change does not matter.
		(unless (equal table-cell-info-lu-coordinate lu-coordinate)
		  (table-finish-delayed-tasks))
		(setq table-cell-info-lu-coordinate lu-coordinate)
		(setq table-cell-info-rb-coordinate rb-coordinate)
		(setq table-cell-info-width (- (car table-cell-info-rb-coordinate)
					       (car table-cell-info-lu-coordinate)))
		(setq table-cell-info-height (+ (- (cdr table-cell-info-rb-coordinate)
						   (cdr table-cell-info-lu-coordinate)) 1)))
	      ;; set/remove table cell properties
	      (if (< (prefix-numeric-value arg) 0)
		  (let ((coord (table-get-coordinate (car cell)))
			(n table-cell-info-height))
		    (save-excursion
		      (while (> n 0)
			(table-remove-cell-properties
			 (table-goto-coordinate coord)
			 (table-goto-coordinate (cons (+ (car coord) table-cell-info-width 1) (cdr coord))))
			(setq n (1- n))
			(setcdr coord (1+ (cdr coord))))))
		(table-put-cell-property cell))
	      ;; copy the cell contents to the cache buffer
	      ;; only if no-copy is nil and timers are not set
	      (unless no-copy
		(setq table-cell-cache-point-coordinate (table-transcoord-table-to-cache))
		(setq table-cell-buffer (current-buffer))
		(let ((rectangle (extract-rectangle (car cell)
						    (cdr cell))))
		  (save-current-buffer
		    (set-buffer cache-buffer)
		    (erase-buffer)
		    (table-insert-rectangle rectangle)))))
	  (set-buffer-modified-p modified-flag)))))

;;;###autoload
(defun table-unrecognize-cell ()
  (interactive)
  (table-recognize-cell nil nil -1))

;;;###autoload
(defun table-heighten-cell (n &optional no-copy)
  "Heighten the current cell by N lines by expanding the cell vertically.
Heightening is done by adding blank lines at the bottom of the current
cell.  Other cells aligned horizontally with the current one are also
heightened in order to keep the rectangular table structure.  The
optional argument NO-COPY is internal use only and must not be
specified."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (let* ((table-inhibit-advice t)
	 (coord-list (table-cell-list-to-coord-list (table-horizontal-cell-list t)))
	 (left-list nil)
	 (this-list coord-list)
	 (right-list (cdr coord-list))
	 (bottom-border-y (1+ (cdr (table-get-coordinate (cdr (table-vertical-cell-list nil t))))))
	 (vertical-str (string table-cell-vertical-char))
	 (vertical-str-with-properties (string table-cell-vertical-char))
	 (first-time t)
	 (current-coordinate (table-get-coordinate)))
    ;; prepare the right vertical string with appropriate properties put
    (table-put-cell-keymap-property 0 (length vertical-str-with-properties) vertical-str-with-properties)
    ;; create the space below for the table to grow
    (table-create-growing-space-below n coord-list bottom-border-y)
    ;; vertically expand each cell from left to right
    (while this-list
      (let* ((left (prog1 (car left-list) (setq left-list (if left-list (cdr left-list) coord-list))))
	     (this (prog1 (car this-list) (setq this-list (cdr this-list))))
	     (right (prog1 (car right-list) (setq right-list (cdr right-list))))
	     (exclude-left (and left (< (cddr left) (cddr this))))
	     (exclude-right (and right (<= (cddr right) (cddr this))))
	     (beg (table-goto-coordinate
		   (cons (if exclude-left (caar this) (1- (caar this)))
			 (1+ (cddr this)))))
	     (end (table-goto-coordinate
		   (cons (if exclude-right (cadr this) (1+ (cadr this)))
			 bottom-border-y)))
	     (rect (extract-rectangle beg end)))
	;; prepend blank cell lines to the extracted rectangle
	(let ((i n))
	  (while (> i 0)
	    (setq rect (cons
			(concat (if exclude-left ""
				  (if first-time vertical-str vertical-str-with-properties))
				(table-cell-blank-str (- (cadr this) (caar this)))
				(if exclude-right "" vertical-str-with-properties))
			rect))
	    (setq i (1- i))))
	(setq first-time nil)
	(delete-rectangle beg end)
	(goto-char beg)
	(table-insert-rectangle rect)))
    (table-goto-coordinate current-coordinate)
    ;; re-recognize the current cell's new dimension
    (table-recognize-cell 'force no-copy)))

;;;###autoload
(defun table-shorten-cell (n)
  "Shorten the current cell by N lines by shrinking the cell vertically.
Shortening is done by removing blank lines from the bottom of the cell
and possibly from the top of the cell as well.  Therefor, the cell
must have some bottom/top blank lines to be shorten effectively.  This
is applicable to all the cells aligned horizontally with the current
one because they are also shortened in order to keep the rectangular
table structure."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (table-finish-delayed-tasks)
  (let* ((table-inhibit-advice t)
	 (table-inhibit-update t)
	 (coord-list (table-cell-list-to-coord-list (table-horizontal-cell-list t)))
	 (left-list nil)
	 (this-list coord-list)
	 (right-list (cdr coord-list))
	 (bottom-budget-list nil)
	 (bottom-border-y (1+ (cdr (table-get-coordinate (cdr (table-vertical-cell-list nil t))))))
	 (current-coordinate (table-get-coordinate))
	 (current-cell-coordinate (table-cell-to-coord (table-probe-cell)))
	 (blank-line-regexp "\\s *$"))
    (message "Shortening...") ;; this operation may be lengthy
    ;; for each cell calculate the maximum number of blank lines we can delete
    ;; and adjust the argument n.  n is adjusted so that the total number of
    ;; blank lines from top and bottom of a cell do not exceed n, all cell has
    ;; at least one line height after blank line deletion.
    (while this-list
      (let ((this (prog1 (car this-list) (setq this-list (cdr this-list)))))
	(table-goto-coordinate (car this))
	(table-recognize-cell 'force)
	(table-with-cache-buffer
	  (catch 'end-count
	    (let ((blank-line-count 0))
	      (table-goto-coordinate (cons 0 (1- table-cell-info-height)))
	      ;; count bottom
	      (while (and (looking-at blank-line-regexp)
			  (setq blank-line-count (1+ blank-line-count))
			  ;; need to leave at least one blank line
			  (if (> blank-line-count n) (throw 'end-count nil) t)
			  (if (zerop (forward-line -1)) t
			    (setq n (if (zerop blank-line-count) 0
				      (1- blank-line-count)))
			    (throw 'end-count nil))))
	      (table-goto-coordinate (cons 0 0))
	      ;; count top
	      (while (and (looking-at blank-line-regexp)
			  (setq blank-line-count (1+ blank-line-count))
			  ;; can consume all blank lines
			  (if (>= blank-line-count n) (throw 'end-count nil) t)
			  (zerop (forward-line 1))))
	      (setq n blank-line-count))))))
    ;; construct the bottom-budget-list which is a list of numbers where each number
    ;; corresponds to how many lines to be deleted from the bottom of each cell.  If
    ;; this number, say bb, is smaller than n (bb < n) that means the difference (n - bb)
    ;; number of lines must be deleted from the top of the cell in addition to deleting
    ;; bb lines from the bottom of the cell.
    (setq this-list coord-list)
    (while this-list
      (let ((this (prog1 (car this-list) (setq this-list (cdr this-list)))))
	(table-goto-coordinate (car this))
	(table-recognize-cell 'force)
	(table-with-cache-buffer
	  (setq bottom-budget-list
		(cons
		 (let ((blank-line-count 0))
		   (table-goto-coordinate (cons 0 (1- table-cell-info-height)))
		   (while (and (looking-at blank-line-regexp)
			       (< blank-line-count n)
			       (setq blank-line-count (1+ blank-line-count))
			       (zerop (forward-line -1))))
		   blank-line-count)
		 bottom-budget-list)))))
    (setq bottom-budget-list (nreverse bottom-budget-list))
    ;; vertically shorten each cell from left to right
    (setq this-list coord-list)
    (while this-list
      (let* ((left (prog1 (car left-list) (setq left-list (if left-list (cdr left-list) coord-list))))
	     (this (prog1 (car this-list) (setq this-list (cdr this-list))))
	     (right (prog1 (car right-list) (setq right-list (cdr right-list))))
	     (bottom-budget (prog1 (car bottom-budget-list) (setq bottom-budget-list (cdr bottom-budget-list))))
	     (exclude-left (and left (< (cddr left) (cddr this))))
	     (exclude-right (and right (<= (cddr right) (cddr this))))
	     (beg (table-goto-coordinate (cons (caar this) (cdar this))))
	     (end (table-goto-coordinate (cons (cadr this) bottom-border-y)))
	     (rect (extract-rectangle beg end))
	     (height (+ (- (cddr this) (cdar this)) 1))
	     (blank-line (make-string (- (cadr this) (caar this)) ?\ )))
	;; delete lines from the bottom of the cell
	(setcdr (nthcdr (- height bottom-budget 1) rect) (nthcdr height rect))
	;; delete lines from the top of the cell
	(if (> n bottom-budget) (setq rect (nthcdr (- n bottom-budget) rect)))
	;; append blank lines below the table
	(setq rect (append rect (make-list n blank-line)))
	;; now swap the area with the prepared rect of the same size
	(delete-rectangle beg end)
	(goto-char beg)
	(table-insert-rectangle rect)
	;; for the left and right borders always delete lines from the bottom of the cell
	(unless exclude-left
	  (let* ((beg (table-goto-coordinate (cons (1- (caar this)) (cdar this))))
		 (end (table-goto-coordinate (cons (caar this) bottom-border-y)))
		 (rect (extract-rectangle beg end)))
	    (setcdr (nthcdr (- height n 1) rect) (nthcdr height rect))
	    (setq rect (append rect (make-list n " ")))
	    (delete-rectangle beg end)
	    (goto-char beg)
	    (table-insert-rectangle rect)))
	(unless exclude-right
	  (let* ((beg (table-goto-coordinate (cons (cadr this) (cdar this))))
		 (end (table-goto-coordinate (cons (1+ (cadr this)) bottom-border-y)))
		 (rect (extract-rectangle beg end)))
	    (setcdr (nthcdr (- height n 1) rect) (nthcdr height rect))
	    (setq rect (append rect (make-list n " ")))
	    (delete-rectangle beg end)
	    (goto-char beg)
	    (table-insert-rectangle rect)))
	;; if this is the cell where the original point was in, adjust the point location
	(if (null (equal this current-cell-coordinate)) nil
	  (let ((y (- (cdr current-coordinate) (cdar this))))
	    (if (< y (- n bottom-budget))
		(setcdr current-coordinate (cdar this))
	      (if (< (- y (- n bottom-budget)) (- height n))
		  (setcdr current-coordinate (+ (cdar this) (- y (- n bottom-budget))))
		(setcdr current-coordinate (+ (cdar this) (- height n 1)))))))))
    (table-goto-coordinate (cons 0 (1+ (- bottom-border-y n))))
    ;; remove the appended blank lines below the table if they are unnecessary
    (let ((i 0))
      (while (< i n)
	(if (looking-at "\\s *$")
	    (delete-region (match-beginning 0) (match-end 0)))
	(setq i (1+ i))))
    (table-goto-coordinate current-coordinate)
    ;; re-recognize the current cell's new dimension
    (table-recognize-cell 'force)
    (message "")))

;;;###autoload
(defun table-widen-cell (n &optional no-copy)
  "Widen the current cell by N columns and expand the cell horizontally.
Some other cells in the same table are widen as well to keep the
table's rectangle structure."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (let* ((table-inhibit-advice t)
	 (coord-list (table-cell-list-to-coord-list (table-vertical-cell-list)))
	 (below-list nil)
	 (this-list coord-list)
	 (above-list (cdr coord-list)))
    (save-excursion
      ;; push back the affected area above and below this table
      (table-horizontally-shift-above-and-below n (reverse coord-list))
      ;; now widen vertically for each cell
      (while this-list
	(let* ((below (prog1 (car below-list) (setq below-list (if below-list (cdr below-list) coord-list))))
	       (this (prog1 (car this-list) (setq this-list (cdr this-list))))
	       (above (prog1 (car above-list) (setq above-list (cdr above-list))))
	       (beg (table-goto-coordinate
		     (cons (car (cdr this))
			   (if (or (null above) (<= (car (cdr this)) (car (cdr above))))
			       (1- (cdr (car this)))
			     (cdr (car this))))))
	       (end (table-goto-coordinate
		     (cons (1+ (car (cdr this)))
			   (if (or (null below) (< (car (cdr this)) (car (cdr below))))
			       (1+ (cdr (cdr this)))
			     (cdr (cdr this))))))
	       (tmp (extract-rectangle (1- beg) end))
	       (border (format "[%c%c]\\%c"
			       table-cell-horizontal-char
			       table-cell-intersection-char
			       table-cell-intersection-char))
	       (blank (table-cell-blank-str))
	       rectangle)
	  ;; create a single wide vertical bar of empty cell fragment
	  (while tmp
	    (setq rectangle (cons (if (string-match border (car tmp))
				      (string table-cell-horizontal-char)
				    blank)
				  rectangle))
	    (setq tmp (cdr tmp)))
	  (setq rectangle (nreverse rectangle))
	  ;; untabify the area right of the bar that is about to be inserted
	  (let ((coord (table-get-coordinate beg))
		(i 0)
		(len (length rectangle)))
	    (while (< i len)
	      (if (table-goto-coordinate coord 'no-extension)
		  (table-untabify-line (point)))
	      (setcdr coord (1+ (cdr coord)))
	      (setq i (1+ i))))
	  ;; insert the bar n times
	  (goto-char beg)
	  (let ((i 0))
	    (while (< i n)
	      (save-excursion
		(table-insert-rectangle rectangle))
	      (setq i (1+ i)))))))
    (table-recognize-cell 'force no-copy)
    (table-update-cell-widened)))

;;;###autoload
(defun table-narrow-cell (n)
  "Narrow the current cell by N columns and shrink the cell horizontally.
Some other cells in the same table are narrowed as well to keep the
table's rectangle structure."
  (interactive "*p")
  (if (< n 0) (setq n 1))
  (table-finish-delayed-tasks)
  (let* ((table-inhibit-advice t)
	 (coord-list (table-cell-list-to-coord-list (table-vertical-cell-list)))
	 (current-cell (table-cell-to-coord (table-probe-cell)))
	 (current-coordinate (table-get-coordinate))
	 tmp-list)
    (message "Narrowing...") ;; this operation may be lengthy
    ;; determine the doable n by try narrowing each cell.
    (setq tmp-list coord-list)
    (while tmp-list
      (let ((cell (prog1 (car tmp-list) (setq tmp-list (cdr tmp-list))))
	    (table-inhibit-update t)
	    cell-n)
	(table-goto-coordinate (car cell))
	(table-recognize-cell 'force)
	(table-with-cache-buffer
	  (table-fill-region (point-min) (point-max) (- table-cell-info-width n))
	  (if (< (setq cell-n (- table-cell-info-width (table-measure-max-width))) n)
	      (setq n cell-n))
	  (erase-buffer)
	  (setq table-inhibit-auto-fill-paragraph t))))
    (if (< n 1) nil
      ;; narrow only the contents of each cell but leave the cell frame as is because
      ;; we need to have valid frame structure in order for table-with-cache-buffer
      ;; to work correctly.
      (setq tmp-list coord-list)
      (while tmp-list
	(let* ((cell (prog1 (car tmp-list) (setq tmp-list (cdr tmp-list))))
	       (table-inhibit-update t)
	       (currentp (equal cell current-cell))
	       old-height)
	  (if currentp (table-goto-coordinate current-coordinate)
	    (table-goto-coordinate (car cell)))
	  (table-recognize-cell 'force)
	  (setq old-height table-cell-info-height)
	  (table-with-cache-buffer
	    (let ((out-of-bound (>= (- (car current-coordinate) (car table-cell-info-lu-coordinate))
				    (- table-cell-info-width n)))
		  (sticky (and currentp
			       (save-excursion
				 (unless (bolp) (forward-char -1))
				 (looking-at ".*\\S ")))))
	      (table-fill-region (point-min) (point-max) (- table-cell-info-width n))
	      (if (or sticky (and currentp (looking-at ".*\\S ")))
		  (setq current-coordinate (table-transcoord-cache-to-table))
		(if out-of-bound (setcar current-coordinate
					 (+ (car table-cell-info-lu-coordinate) (- table-cell-info-width n 1))))))
	    (setq table-inhibit-auto-fill-paragraph t))
	  (table-update-cell 'now)
	  ;; if this cell heightens and pushes the current cell below, move
	  ;; the current-coordinate (point location) down accordingly.
	  (if currentp (setq current-coordinate (table-get-coordinate))
	    (if (and (> table-cell-info-height old-height)
		     (> (cdr current-coordinate) (cdr table-cell-info-lu-coordinate)))
		(setcdr current-coordinate (+ (cdr current-coordinate)
					      (- table-cell-info-height old-height)))))
	  ))
      ;; coord-list is now possibly invalid since some cells may have already
      ;; been heightened so recompute them by table-vertical-cell-list.
      (table-goto-coordinate current-coordinate)
      (setq coord-list (table-cell-list-to-coord-list (table-vertical-cell-list)))
      ;; push in the affected area above and below this table so that things
      ;; on the right side of the table are shifted horizontally neatly.
      (table-horizontally-shift-above-and-below (- n) (reverse coord-list))
      ;; finally narrow the frames for each cell.
      (let* ((below-list nil)
	     (this-list coord-list)
	     (above-list (cdr coord-list)))
	(while this-list
	  (let* ((below (prog1 (car below-list) (setq below-list (if below-list (cdr below-list) coord-list))))
		 (this (prog1 (car this-list) (setq this-list (cdr this-list))))
		 (above (prog1 (car above-list) (setq above-list (cdr above-list)))))
	    (delete-rectangle
	     (table-goto-coordinate
	      (cons (- (cadr this) n)
		    (if (or (null above) (<= (cadr this) (cadr above)))
			(1- (cdar this))
		      (cdar this))))
	     (table-goto-coordinate
	      (cons (cadr this)
		    (if (or (null below) (< (cadr this) (cadr below)))
			(1+ (cddr this))
		      (cddr this)))))))))
    (table-goto-coordinate current-coordinate)
    ;; re-recognize the current cell's new dimension
    (table-recognize-cell 'force)
    (message "")))

;;;###autoload
(defun table-forward-cell (&optional arg unrecognize)
  "Move point forward to the beginning of the next cell.
With argument ARG, do it ARG times;
a negative argument ARG = -N means move backward N cells.

Sample Cell Traveling Order (In Irregular Table Cases)

You can actually try how it works in this buffer.  Press
\\[table-recognize] and go to cells in the following tables and press
\\[table-forward-cell] or TAB key.

+-----+--+  +--+-----+  +--+--+--+  +--+--+--+  +---------+  +--+---+--+
|0    |1 |  |0 |1    |  |0 |1 |2 |  |0 |1 |2 |  |0        |  |0 |1  |2 |
+--+--+  |  |  +--+--+  +--+  |  |  |  |  +--+  +----+----+  +--+-+-+--+
|2 |3 |  |  |  |2 |3 |  |3 +--+  |  |  +--+3 |  |1   |2   |  |3   |4   |
|  +--+--+  +--+--+  |  +--+4 |  |  |  |4 +--+  +--+-+-+--+  +----+----+
|  |4    |  |4    |  |  |5 |  |  |  |  |  |5 |  |3 |4  |5 |  |5        |
+--+-----+  +-----+--+  +--+--+--+  +--+--+--+  +--+---+--+  +---------+

+--+--+--+  +--+--+--+  +--+--+--+  +--+--+--+
|0 |1 |2 |  |0 |1 |2 |  |0 |1 |2 |  |0 |1 |2 |
|  |  |  |  |  +--+  |  |  |  |  |  +--+  +--+
+--+  +--+  +--+3 +--+  |  +--+  |  |3 +--+4 |
|3 |  |4 |  |4 +--+5 |  |  |3 |  |  +--+5 +--+
|  |  |  |  |  |6 |  |  |  |  |  |  |6 |  |7 |
+--+--+--+  +--+--+--+  +--+--+--+  +--+--+--+

+--+--+--+  +--+--+--+  +--+--+--+--+  +--+-----+--+  +--+--+--+--+
|0 |1 |2 |  |0 |1 |2 |	|0 |1 |2 |3 |  |0 |1    |2 |  |0 |1 |2 |3 |
|  +--+  |  |  +--+  |	|  +--+--+  |  |  |     |  |  |  +--+--+  |
|  |3 +--+  +--+3 |  |	+--+4    +--+  +--+     +--+  +--+4    +--+
+--+  |4 |  |4 |  +--+	|5 +--+--+6 |  |3 +--+--+4 |  |5 |     |6 |
|5 +--+  |  |  +--+5 |	|  |7 |8 |  |  |  |5 |6 |  |  |  |     |  |
|  |6 |  |  |  |6 |  |	+--+--+--+--+  +--+--+--+--+  +--+-----+--+
+--+--+--+  +--+--+--+
"
  ;; After modifying this function, test against the above tables in
  ;; the doc string.  It is quite tricky.  The tables above do not
  ;; mean to cover every possible cases of cell layout, of course.
  ;; They are examples of tricky cases from implementation point of
  ;; view and provided for simple regression test purpose.
  (interactive "p")
  (or arg (setq arg 1))
  (let ((table-inhibit-advice t))
    (table-finish-delayed-tasks)
    (while (null (zerop arg))
      (let* ((pivot (table-probe-cell 'abort-on-error))
	     (cell pivot) edge tip)
	;; go to the beginning of the first right/left cell with same height if exists
	(while (and (setq cell (table-goto-coordinate
				(cons (if (> arg 0) (1+ (car (table-get-coordinate (cdr cell))))
					(1- (car (table-get-coordinate (car cell)))))
				      (cdr (table-get-coordinate (car pivot)))) 'no-extension))
		    (setq cell (table-probe-cell))
		    (/= (cdr (table-get-coordinate (car cell)))
			(cdr (table-get-coordinate (car pivot))))))
	(if cell (goto-char (car cell)) ; done
	  ;; if the horizontal move fails search the most left/right edge cell below/above the pivot
	  ;; but first find the edge cell
	  (setq edge pivot)
	  (while (and (table-goto-coordinate
		       (cons (if (> arg 0) (1- (car (table-get-coordinate (car edge))))
			       (1+ (car (table-get-coordinate (cdr edge)))))
			     (cdr (table-get-coordinate (car pivot)))) 'no-extension)
		      (setq cell (table-probe-cell))
		      (setq edge cell)))
	  (setq cell (if (> arg 0) edge
		       (or (and (table-goto-coordinate
				 (cons (car (table-get-coordinate (cdr edge)))
				       (1- (cdr (table-get-coordinate (car edge))))))
				(table-probe-cell))
			   edge)))
	  ;; now search for the tip which is the highest/lowest below/above cell
	  (while cell
	    (let (below/above)
	      (and (table-goto-coordinate
		    (cons (car (table-get-coordinate (if (> arg 0) (car cell)
							   (cdr cell))))
			  (if (> arg 0) (+ 2 (cdr (table-get-coordinate (cdr cell))))
			    (1- (cdr (table-get-coordinate (car pivot)))))) 'no-extension)
		   (setq below/above (table-probe-cell))
		   (or (null tip)
		       (if (> arg 0)
			   (< (cdr (table-get-coordinate (car below/above)))
			      (cdr (table-get-coordinate (car tip))))
			 (> (cdr (table-get-coordinate (car below/above)))
			    (cdr (table-get-coordinate (car tip))))))
		   (setq tip below/above)))
	    (and (setq cell (table-goto-coordinate
			     (cons (if (> arg 0) (1+ (car (table-get-coordinate (cdr cell))))
				     (1- (car (table-get-coordinate (car cell)))))
				   (if (> arg 0) (cdr (table-get-coordinate (car pivot)))
				     (1- (cdr (table-get-coordinate (car pivot)))))) 'no-extension))
		 (setq cell (table-probe-cell))))
	  (if tip (goto-char (car tip)) ; done
	    ;; let's climb up/down to the top/bottom from the edge
	    (while (and (table-goto-coordinate
			 (cons (if (> arg 0) (car (table-get-coordinate (car edge)))
				 (car (table-get-coordinate (cdr edge))))
			       (if (> arg 0) (1- (cdr (table-get-coordinate (car edge))))
				 (+ 2 (cdr (table-get-coordinate (cdr edge)))))) 'no-extension)
			(setq cell (table-probe-cell))
			(setq edge cell)))
	    (if (< arg 0)
		(progn
		  (setq cell edge)
		  (while (and (table-goto-coordinate
			       (cons (1- (car (table-get-coordinate (car cell))))
				     (cdr (table-get-coordinate (cdr cell)))) 'no-extension)
			      (setq cell (table-probe-cell)))
		    (if (> (cdr (table-get-coordinate (car cell)))
			   (cdr (table-get-coordinate (car edge))))
			(setq edge cell)))))
	    (goto-char (car edge)))))	; the top left cell
      (setq arg (if (> arg 0) (1- arg) (1+ arg))))
    (table-recognize-cell 'force nil (if unrecognize -1 nil)))) ; refill the cache with new cell contents

;;;###autoload
(defun table-backward-cell (&optional arg)
  "Move backward to the beginning of the previous cell.
With argument ARG, do it ARG times;
a negative argument ARG = -N means move forward N cells."
  (interactive "p")
  (let ((table-inhibit-advice t))
    (or arg (setq arg 1))
    (table-forward-cell (- arg))))

;;;###autoload
(defun table-span-cell (direction)
  "Span current cell into adjacent cell in DIRECTION.
DIRECTION is one of symbols; right, left, above or below."
  (interactive
   (list
    (let* ((dummy (barf-if-buffer-read-only))
	   (direction-list
	    (let* ((tmp (delete nil
				(mapcar (function (lambda (d)
						    (if (table-cell-can-span-p d)
							(list (symbol-name d)))))
					'(right left above below)))))
	      (if (null tmp)
		  (error "Can't span this cell"))
	      tmp))
	   (default-direction  (if (member (list (car table-cell-span-direction-history)) direction-list)
				   (car table-cell-span-direction-history)
				 (caar direction-list)))
	   (completion-ignore-case t)
	   (direction-str (downcase (completing-read
				     (format "Span into: (default %s) " default-direction)
				     direction-list
				     nil t nil 'table-cell-span-direction-history))))
      (table-cleanup-xemacs-history 'table-cell-span-direction-history)
      (intern
       (if (string= direction-str "") default-direction direction-str)))))
  (unless (memq direction '(right left above below))
    (error "Invalid direction %s, must be right, left, above or below"
	   (symbol-name direction)))
  (let ((table-inhibit-advice t))
    (table-recognize-cell 'force)
    (unless (table-cell-can-span-p direction)
      (error "Can't span %s" (symbol-name direction)))
    ;; prepare beginning and ending positions of the border bar to strike through
    (let ((beg (cond
		((eq direction 'right)
		 (save-excursion
		   (table-goto-coordinate
		    (cons (car table-cell-info-rb-coordinate)
			  (1- (cdr table-cell-info-lu-coordinate))) 'no-extension)))
		((eq direction 'below)
		 (save-excursion
		   (table-goto-coordinate
		    (cons (1- (car table-cell-info-lu-coordinate))
			  (1+ (cdr table-cell-info-rb-coordinate))) 'no-extension)))
		(t
		 (save-excursion
		   (table-goto-coordinate
		    (cons (1- (car table-cell-info-lu-coordinate))
			  (1- (cdr table-cell-info-lu-coordinate))) 'no-extension)))))
	  (end (cond
		((eq direction 'left)
		 (save-excursion
		   (table-goto-coordinate
		    (cons (car table-cell-info-lu-coordinate)
			  (1+ (cdr table-cell-info-rb-coordinate))) 'no-extension)))
		((eq direction 'above)
		 (save-excursion
		   (table-goto-coordinate
		    (cons (1+ (car table-cell-info-rb-coordinate))
			  (1- (cdr table-cell-info-lu-coordinate))) 'no-extension)))
		(t
		 (save-excursion
		   (table-goto-coordinate
		    (cons (1+ (car table-cell-info-rb-coordinate))
			  (1+ (cdr table-cell-info-rb-coordinate))) 'no-extension))))))
      ;; replace the bar with blank space while taking care of edges to be border or intersection
      (save-excursion
	(goto-char beg)
	(if (memq direction '(left right))
	    (let* ((column (current-column))
		   rectangle
		   (n-element (- (length (extract-rectangle beg end)) 2))
		   (above-contp (and (goto-char beg)
				     (zerop (forward-line -1))
				     (= (move-to-column column) column)
				     (looking-at (regexp-quote (char-to-string table-cell-vertical-char)))))
		   (below-contp (and (goto-char end)
				     (progn (forward-char -1) t)
				     (zerop (forward-line 1))
				     (= (move-to-column column) column)
				     (looking-at (regexp-quote (char-to-string table-cell-vertical-char))))))
	      (setq rectangle
		    (cons (if below-contp
			      (char-to-string table-cell-intersection-char)
			    (char-to-string table-cell-horizontal-char))
			  rectangle))
	      (while (> n-element 0)
		(setq rectangle (cons (table-cell-blank-str 1) rectangle))
		(setq n-element (1- n-element)))
	      (setq rectangle
		    (cons (if above-contp
			      (char-to-string table-cell-intersection-char)
			    (char-to-string table-cell-horizontal-char))
			  rectangle))
	      (delete-rectangle beg end)
	      (goto-char beg)
	      (insert-rectangle rectangle))
	  (delete-region beg end)
	  (insert (if (and (> (point) (point-min))
			   (save-excursion
			     (forward-char -1)
			     (looking-at (regexp-quote (char-to-string table-cell-horizontal-char)))))
		      table-cell-intersection-char
		    table-cell-vertical-char)
		  (table-cell-blank-str (- end beg 2))
		  (if (looking-at (regexp-quote (char-to-string table-cell-horizontal-char)))
		      table-cell-intersection-char
		    table-cell-vertical-char))))
      ;; recognize the newly created spanned cell
      (table-recognize-cell 'force)
      (if (member direction '(right left))
	  (table-with-cache-buffer
	    (table-fill-region (point-min) (point-max))
	    (setq table-inhibit-auto-fill-paragraph t))))))

;;;###autoload
(defun table-span-cell-right ()
  (interactive "*")
  (table-span-cell 'right))

;;;###autoload
(defun table-span-cell-left ()
  (interactive "*")
  (table-span-cell 'left))

;;;###autoload
(defun table-span-cell-above ()
  (interactive "*")
  (table-span-cell 'above))

;;;###autoload
(defun table-span-cell-below ()
  (interactive "*")
  (table-span-cell 'below))

;;;###autoload
(defun table-split-cell-vertically ()
  "Split current cell vertically.
Creates a cell above and a cell below the current point location."
  (interactive "*")
  (let ((table-inhibit-advice t))
    (table-recognize-cell 'force)
    (let ((point-y (cdr (table-get-coordinate))))
      (unless (table-cell-can-split-vertically-p)
	(error "Can't split here"))
      (let* ((old-coordinate (table-get-coordinate))
	     (column (current-column))
	     (beg (table-goto-coordinate
		   (cons (1- (car table-cell-info-lu-coordinate))
			 point-y)))
	     (end (table-goto-coordinate
		   (cons (1+ (car table-cell-info-rb-coordinate))
			 point-y)))
	     (line (buffer-substring (1+ beg) (1- end))))
	(goto-char beg)
	(delete-region beg end)
	(insert table-cell-intersection-char
		(make-string table-cell-info-width table-cell-horizontal-char)
		table-cell-intersection-char)
	(table-goto-coordinate old-coordinate)
	;; if the line was blank move point up one line
	;; otherwise insert the old line at the top
	;; of the newly created cell below.
	(if (string-match "^\\s *$" line)
	    (forward-line -1)
	  (forward-line 1)
	  (move-to-column column)
	  (table-with-cache-buffer
	    (goto-char (point-min))
	    (insert line ?\n))
	  (table-update-cell 'now);; can't defer this operation
	  (table-goto-coordinate old-coordinate)
	  (forward-line 1))
	(move-to-column column)
	(table-recognize-cell 'force)))))

;;;###autoload
(defun table-split-cell-horizontally ()
  "Split current cell horizontally.
Creates a cell on the left and a cell on the right of the current point location."
  (interactive "*")
  (let ((table-inhibit-advice t))
    (table-recognize-cell 'force)
    (let* ((o-coordinate (table-get-coordinate))
	   (point-x (car o-coordinate))
	   cell-empty cell-contents cell-coordinate
	   squeeze-to-left beg end rectangle)
      (unless (table-cell-can-split-horizontally-p)
	(error "Can't split here"))
      (table-with-cache-buffer
	(setq cell-coordinate (table-get-coordinate))
	(save-excursion
	  (goto-char (point-min))
	  (setq cell-empty (null (re-search-forward "\\S " nil t))))
	(setq cell-contents (buffer-substring (point-min) (point-max)))
	(setq table-inhibit-auto-fill-paragraph t))
      (setq squeeze-to-left
	    (or cell-empty
		(let* ((completion-ignore-case t)
		       (dir
			(if (member 'click (event-modifiers last-input-event))
			    (x-popup-menu last-input-event
					  '("Put existing contents to:"
					    ("Title"
					     ("Left" . "left") ("Right" . "right"))))
			  (downcase (completing-read
				     (format "Put existing contents to: (default %s) "
					     (car table-cell-split-squeeze-side-history))
				     '(("left") ("right"))
				     nil t nil 'table-cell-split-squeeze-side-history)))))
		  (table-cleanup-xemacs-history 'table-cell-split-squeeze-side-history)
		  (if (string= dir "")
		      (string= (car table-cell-split-squeeze-side-history) "left")
		    (string= dir "left")))))
      (table-with-cache-buffer
	(erase-buffer)
	(setq table-inhibit-auto-fill-paragraph t))
      (table-update-cell 'now)
      (setq beg (table-goto-coordinate
		 (cons point-x
		       (1- (cdr table-cell-info-lu-coordinate)))))
      (setq end (table-goto-coordinate
		 (cons (1+ point-x)
		       (1+ (cdr table-cell-info-rb-coordinate)))))
      (setq rectangle (cons (char-to-string table-cell-intersection-char) nil))
      (let ((n table-cell-info-height))
	(while (prog1 (> n 0) (setq n (1- n)))
	  (setq rectangle (cons (char-to-string table-cell-vertical-char) rectangle))))
      (setq rectangle (cons (char-to-string table-cell-intersection-char) rectangle))
      (delete-rectangle beg end)
      (goto-char beg)
      (insert-rectangle rectangle)
      (table-goto-coordinate o-coordinate)
      (if cell-empty nil
	(forward-char (if squeeze-to-left -1 1))
	(table-recognize-cell 'force)
	(table-with-cache-buffer
	  (erase-buffer)
	  (insert cell-contents)
	  (table-goto-coordinate cell-coordinate)
	  (table-fill-region (point-min) (point-max))
	  ;; avoid unnecessary vertical cell expansion
	  (and (looking-at "\\s *\\'")
	       (re-search-backward "\\S \\(\\s *\\)\\=" nil t)
	       (goto-char (match-beginning 1)))
	  (setq table-inhibit-auto-fill-paragraph t))
	(table-update-cell 'now));; can't defer this operation
      (table-recognize-cell 'force))))

;;;###autoload
(defun table-split-cell (orientation)
  "Split current cell in ORIENTATION.
ORIENTATION is a symbol either horizontally or vertically."
  (interactive
   (list
    (intern
     (let* ((dummy (barf-if-buffer-read-only))
	    (completion-ignore-case t)
	    (orientation (downcase (completing-read
				    (format "Split orientation: (default %s) "
					    (car table-cell-split-orientation-history))
				    '(("horizontally") ("vertically"))
				    nil t nil 'table-cell-split-orientation-history))))
       (table-cleanup-xemacs-history 'table-cell-split-orientation-history)
       (if (string= orientation "")
	   (car table-cell-split-orientation-history)
	 orientation)))))
  (unless (memq orientation '(horizontally vertically))
    (error "Invalid orientation %s, must be horizontally or vertically"
	   (symbol-name orientation)))
  (let ((table-inhibit-advice t))
    (if (eq orientation 'horizontally)
	(table-split-cell-horizontally)
      (table-split-cell-vertically))))

;;;###autoload
(defun table-justify-cell (justify &optional paragraph)
  "Justify cell contents.
JUSTIFY is a symbol 'left, 'center or 'right.  When optional PARAGRAPH
is non-nil the justify operation is limited to the current paragraph,
otherwise the entire cell contents is justified."
  (interactive
   (list (intern
	  (let* ((dummy (barf-if-buffer-read-only))
		 (completion-ignore-case t)
		 (justify (downcase (completing-read
				     (format "Justify: (default %s) "
					     (car table-justify-history))
				     '(("left") ("center") ("right"))
				     nil t nil 'table-justify-history))))
	    (table-cleanup-xemacs-history 'table-justify-history)
	    (if (string= justify "")
		(car table-justify-history)
	      justify)))))
  (let((table-inhibit-advice t)
       beg end)
    (table-finish-delayed-tasks)
    (table-recognize-cell 'force)
    (table-justify-cell-contents justify paragraph)))

;;;###autoload
(defun table-justify-cell-left ()
  (interactive "*")
  (table-justify-cell 'left))

;;;###autoload
(defun table-justify-cell-center ()
  (interactive "*")
  (table-justify-cell 'center))

;;;###autoload
(defun table-justify-cell-right ()
  (interactive "*")
  (table-justify-cell 'right))

;;;###autoload
(defun table-justify-cell-paragraph-left ()
  (interactive "*")
  (table-justify-cell 'left t))

;;;###autoload
(defun table-justify-cell-paragraph-center ()
  (interactive "*")
  (table-justify-cell 'center t))

;;;###autoload
(defun table-justify-cell-paragraph-right ()
  (interactive "*")
  (table-justify-cell 'right t))

;;;###autoload
(defun table-fixed-width-mode (&optional arg)
  "Toggle fixing width mode.
In the fixed width mode, typing inside a cell never changes the cell
width where in the normal mode the cell width expands automatically in
order to prevent a word being folded into multiple lines."
  (interactive "P")
  (table-finish-delayed-tasks)
  (setq table-fixed-width-mode
	(if (null arg)
	    (not table-fixed-width-mode)
	  (> (prefix-numeric-value arg) 0)))
  (save-excursion
    (mapcar (function (lambda (buf)
			(set-buffer buf)
			(if (table-point-in-cell-p)
			    (table-point-entered-cell-function))))
	    (buffer-list)))
  (table-update-cell-face))

;;;###autoload
(defun table-query-dimension (&optional where)
  "Return the dimension of the current cell and the current table.
The result is a list (cw ch tw th c r) where cw is the cell width, ch
is the cell height, tw is the table width, th is the table height, c
is the number of columns and r is the number of rows.  The cell
dimension excludes the cell frame while the table dimension includes
the table frame.  The columns and the rows are counted by the number
of cell boundaries.  Therefore the number tends to be larger than it
appears for the tables with non-uniform cell structure (heavily
spanned and split).  When optional WHERE is provided the cell and
table at that location is reported."
  (interactive)
  (save-excursion
    (if where (goto-char where))
    (let ((origin-cell (table-probe-cell))
	  cell table-lu table-rb col-list row-list)
      (if (null origin-cell) nil
	(setq table-lu (car origin-cell))
	(setq table-rb (cdr origin-cell))
	(setq col-list (cons (car (table-get-coordinate (car origin-cell))) nil))
	(setq row-list (cons (cdr (table-get-coordinate (car origin-cell))) nil))
	(and (interactive-p)
	     (message "Computing cell dimension..."))
	(while
	    (progn
	      (table-forward-cell 1)
	      (and (setq cell (table-probe-cell))
		   (not (equal cell origin-cell))))
	  (if (< (car cell) table-lu)
	      (setq table-lu (car cell)))
	  (if (> (cdr cell) table-rb)
	      (setq table-rb (cdr cell)))
	  (let ((lu-coordinate (table-get-coordinate (car cell))))
	    (if (memq (car lu-coordinate) col-list) nil
	      (setq col-list (cons (car lu-coordinate) col-list)))
	    (if (memq (cdr lu-coordinate) row-list) nil
	      (setq row-list (cons (cdr lu-coordinate) row-list)))))
	(let* ((cell-lu-coordinate (table-get-coordinate (car origin-cell)))
	       (cell-rb-coordinate (table-get-coordinate (cdr origin-cell)))
	       (table-lu-coordinate (table-get-coordinate table-lu))
	       (table-rb-coordinate (table-get-coordinate table-rb))
	       (cw (- (car cell-rb-coordinate) (car cell-lu-coordinate)))
	       (ch (1+ (- (cdr cell-rb-coordinate) (cdr cell-lu-coordinate))))
	       (tw (+ 2 (- (car table-rb-coordinate) (car table-lu-coordinate))))
	       (th (+ 3 (- (cdr table-rb-coordinate) (cdr table-lu-coordinate))))
	       (c (length col-list))
	       (r (length row-list)))
	  (and (interactive-p)
	       (message "Cell: (%dw, %dh), Table: (%dw, %dh), Dim: (%dc, %dr)" cw ch tw th c r))
	  (list  cw ch tw th c r))))))

;;;###autoload
(defun table-version ()
  "Show version number of table package."
  (interactive)
  (let ((table-inhibit-advice t))
    (let ((msg (format "Table version %s" table-version)))
      (message msg)
      msg)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Worker functions (executed implicitly)
;;

(defun table-make-cell-map ()
  "Make the table cell keymap if it does not exist yet."
  ;; this is irrelevant to keymap but good place to make sure to be executed
  (table-update-cell-face)
  (let ((table-inhibit-advice t))
    (unless table-cell-map
      (let ((map (make-sparse-keymap))
	    table-cell-global-map)
	(mapcar (function (lambda (binding)
			    (define-key map (car binding) (cdr binding))))
		table-cell-bindings)
	;; make a deep copy of the global-map and replace commands with table commands
	(setq table-cell-global-map (table-deep-copy-rebind-keymap (current-global-map)))
	(if (featurep 'xemacs)
	    ;; somehow replacement mechanism in `table-deep-copy-rebind-keymap' fails
	    ;; under xemacs.
	    (mapcar (function (lambda (l)
				(substitute-key-definition (car l) (cdr l) table-cell-global-map)))
		    table-command-replacement-alist))
	(set-keymap-parent map table-cell-global-map)
	(setq table-cell-map map)
	(fset 'table-cell-map map)))
    ;; add menu for table cells
    (unless table-disable-menu
      (easy-menu-define table-cell-menu-map table-cell-map "Table cell menu" table-cell-menu)
      (if (featurep 'xemacs)
	  (easy-menu-add table-cell-menu)))
    (run-hooks 'table-cell-map-hook)))

;; Create the keymap after running the user init file so that the user
;; modification to the global-map is accounted.
(add-hook 'after-init-hook 'table-make-cell-map t)

(defun table-cell-self-insert-command ()
  "Any ordinary typing inside a table cell."
  (interactive "*")
  (let ((table-inhibit-advice t))
    (if (eq buffer-undo-list t) nil
      (if (not (eq last-command this-command))
	  (setq table-cell-self-insert-command-count 0)
	(if (car buffer-undo-list) nil
	  (if (>= table-cell-self-insert-command-count 19)
	      (setq table-cell-self-insert-command-count 0)
	    (setq buffer-undo-list (cdr buffer-undo-list))
	    (setq table-cell-self-insert-command-count (1+ table-cell-self-insert-command-count))))))
    (table-cell-insert-char last-command-char)))

(defun table-cell-delete-backward-char ()
  (interactive)
  (let ((table-inhibit-advice t))
    (table-cell-delete-char -1)))

(defun table-cell-newline (&optional indent)
  (interactive "*")
  (let ((table-inhibit-advice t))
    (table-with-cache-buffer
      (let ((column (current-column)))
	(insert ?\n)
	(if indent (indent-to-column column))
	;; fill only when at the beginning of paragraph
	(if (= (point)
	       (save-excursion
		 (forward-paragraph -1)
		 (if (looking-at "\\s *$")
		     (forward-line 1))
		 (point)))
	    nil				; yes, at the beginning of the paragraph
	  (setq table-inhibit-auto-fill-paragraph t))))))

(defun table-cell-open-line (n)
  (interactive "*p")
  (let ((table-inhibit-advice t))
    (table-with-cache-buffer
      (save-excursion
	(insert (make-string n ?\n))
	(table-fill-region (point) (point))
	(setq table-inhibit-auto-fill-paragraph t)))))

(defun table-cell-newline-and-indent ()
  (interactive)
  (let ((table-inhibit-advice t))
    (table-cell-newline t)))

(defun table-cell-delete-char (n)
  (interactive "*p")
  (let ((table-inhibit-advice t))
    (table-with-cache-buffer
      (let ((coordinate (table-get-coordinate))
	    (end-marker (make-marker))
	    (deleted))
	(set-marker end-marker (+ (point) n))
	(if (or (< end-marker (point-min))
		(> end-marker (point-max))) nil
	  (table-remove-eol-spaces (point-min) (point-max))
	  (setq deleted (buffer-substring (point) end-marker))
	  (delete-char n)
	  ;; in fixed width mode when two lines are concatenated
	  ;; remove continuation character if there is one.
	  (and table-fixed-width-mode
	       (string-match "^\n" deleted)
	       (equal (char-before) table-word-continuation-char)
	       (delete-char -2))
	  ;; see if the point is placed at the right tip of the previous
	  ;; blank line, if so get rid of the preceding blanks.
	  (if (and (not (bolp))
		   (/= (cdr coordinate) (cdr (table-get-coordinate)))
		   (let ((end (point)))
		     (save-excursion
		       (beginning-of-line)
		       (re-search-forward "\\s +" end t)
		       (= (point) end))))
	      (replace-match ""))
	  ;; do not fill the paragraph if the point is already at the end
	  ;; of this paragraph and is following a blank character
	  ;; (otherwise the filling squeezes the preceding blanks)
	  (if (and (looking-at "\\s *$")
		   (or (bobp)
		       (save-excursion
			 (backward-char)
			 (looking-at "\\s "))))
	      (setq table-inhibit-auto-fill-paragraph t))
	  )))))

(defun table-cell-quoted-insert (arg)
  (interactive "*p")
  (let ((table-inhibit-advice t)
	(char (read-char)))
    (if (and enable-multibyte-characters
	     (>= char ?\240)
	     (<= char ?\377))
	(setq char (unibyte-char-to-multibyte char)))
    (while (> arg 0)
      (table-cell-insert-char char)
      (setq arg (1- arg)))))

(defun table-present-cell-popup-menu (event)
  "Present and handle cell popup menu."
  (interactive "e")
  (unless table-disable-menu
    (select-window (posn-window (event-start event)))
    (goto-char (posn-point (event-start event)))
    (let ((item-list (x-popup-menu event table-cell-menu-map))
	  (func table-cell-menu-map))
      (while item-list
	(setq func (nth 3 (assoc (car item-list) func)))
	(setq item-list (cdr item-list)))
      (if (and (symbolp func) (fboundp func))
	  (call-interactively func)))))

(defun table-describe-mode ()
  (interactive)
  (if (not (table-point-in-cell-p))
      (call-interactively 'describe-mode)
    (with-output-to-temp-buffer "*Help*"
      (princ "Table mode: (in ")
      (princ mode-name)
      (princ " mode)

Table is not a mode technically.  You can regard it as a pseudo mode
which exists locally within a buffer.  It overrides some standard
editing behaviors.  Editing operations in a table produces confined
effects to the current cell.  It may grow the cell horizontally and/or
vertically depending on the newly entered or deleted contents of the
cell, and also depending on the current mode of cell.

In the normal mode the table preserves word continuity.  Which means
that a word never gets folded into multiple lines.  For this purpose
table will occasionally grow the cell width.  On the other hand, when
in a fixed width mode all cell width are fixed.  When a word can not
fit in the cell width the word is folded into the next line.  The
folded location is marked by a continuation character which is
specified in the variable `table-word-continuation-char'.
")
      (print-help-return-message))))

(defun table-describe-bindings ()
  (interactive)
  (if (not (table-point-in-cell-p))
      (call-interactively 'describe-bindings)
    (with-output-to-temp-buffer "*Help*"
      (princ "Table Bindings:
key             binding
---             -------

")
      (mapcar (function (lambda (binding)
			  (princ (format "%-16s%s\n"
					 (key-description (car binding))
					 (cdr binding)))))
	      table-cell-bindings)
      (print-help-return-message))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Cell updating functions
;;

(defun table-update-cell (&optional now)
  "Update the table cell contents.
When the optional parameter NOW is nil it only sets up the update
timer.  If it is non-nil the function copies the contents of the cell
cache buffer into the designated cell in the table buffer."
  (let ((table-inhibit-advice t))
    (if (null table-update-timer) nil
      (table-cancel-timer table-update-timer)
      (setq table-update-timer nil))
    (if (or (not now)
	    (and (boundp 'quail-converting)
		 quail-converting)) ;; defer operation while current quail work is not finished
	(setq table-update-timer
	      (table-set-timer table-time-before-update
			       (function table-update-cell)
			       'now))
      (save-current-buffer
	(set-buffer table-cell-buffer)
	(let ((cache-buffer (get-buffer-create table-cache-buffer-name))
	      (org-coord (table-get-coordinate))
	      (in-cell (equal (table-cell-to-coord (table-probe-cell))
			      (cons table-cell-info-lu-coordinate table-cell-info-rb-coordinate)))
	      rectangle)
	  (set-buffer cache-buffer)
	  (setq rectangle
		(extract-rectangle
		 1
		 (table-goto-coordinate (cons table-cell-info-width (1- table-cell-info-height)))))
	  (set-buffer table-cell-buffer)
	  (delete-rectangle (table-goto-coordinate table-cell-info-lu-coordinate)
			    (table-goto-coordinate table-cell-info-rb-coordinate))
	  (table-goto-coordinate table-cell-info-lu-coordinate)
	  (table-insert-rectangle rectangle)
	  (table-put-cell-property (table-probe-cell)) ; must probe again in case of wide characters
	  (table-goto-coordinate
	   (if in-cell
	       (table-transcoord-cache-to-table table-cell-cache-point-coordinate)
	     org-coord)))))))

(defun table-update-cell-widened (&optional now)
  "Update the contents of the cells that are affected by widening operation."
  (let ((table-inhibit-advice t))
    (if (null table-widen-timer) nil
      (table-cancel-timer table-widen-timer)
      (setq table-widen-timer nil))
    (if (not now)
	(setq table-widen-timer
	      (table-set-timer (* 2 table-time-before-update)
			       (function table-update-cell-widened)
			       'now))
      (save-current-buffer
	(if table-update-timer
	    (table-update-cell 'now))
	(set-buffer table-cell-buffer)
	(let* ((current-coordinate (table-get-coordinate))
	       (current-cell-coordinate (table-cell-to-coord (table-probe-cell)))
	       (cell-coord-list (progn
				  (table-goto-coordinate table-cell-info-lu-coordinate)
				  (table-cell-list-to-coord-list (table-vertical-cell-list)))))
	  (while cell-coord-list
	    (let* ((cell-coord (prog1 (car cell-coord-list) (setq cell-coord-list (cdr cell-coord-list))))
		   (currentp (equal cell-coord current-cell-coordinate)))
	      (if currentp (table-goto-coordinate current-coordinate)
		(table-goto-coordinate (car cell-coord)))
	      (table-recognize-cell 'froce)
	      (let ((table-inhibit-update t))
		(table-with-cache-buffer
		  (let ((sticky (and currentp
				     (save-excursion
				       (unless (bolp) (forward-char -1))
				       (looking-at ".*\\S ")))))
		    (table-fill-region (point-min) (point-max))
		    (if sticky
			(setq current-coordinate (table-transcoord-cache-to-table))))))
	      (table-update-cell 'now)
	      ))
	  (table-goto-coordinate current-coordinate)
	  (table-recognize-cell 'froce))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Utility functions
;;

(defun table-string-to-number-list (str)
  "Return a list of numbers in STR."
  (let ((idx 0)
	(nl nil))
    (while (string-match "[-0-9.]+" str idx)
      (setq idx (match-end 0))
      (setq nl (cons (string-to-number (match-string 0 str)) nl)))
    (nreverse nl)))

(defun table-justify-cell-contents (justify paragraph)
  "Justify the current cell contents.
JUSTIFY is a symbol 'left, 'center or 'right.  When PARAGRAPH is
non-nil the justify operation is limited to the current paragraph."
  (table-with-cache-buffer
    (let ((beg (point-min))
	  (end (point-max-marker))
	  (fill-column table-cell-info-width))
      (save-excursion
	(if paragraph
	    (let ((paragraph-start "\n"))
	      (forward-paragraph)
	      (or (bolp) (newline 1))
	      (set-marker end (point))
	      (setq beg (progn (forward-paragraph -1) (point)))))
	(table-remove-eol-spaces beg end 'bol)
	(fill-region beg end justify))
      (setq table-inhibit-auto-fill-paragraph t)
      (set-marker end nil)))
  (table-update-cell 'now))

(defun table-horizontally-shift-above-and-below (columns-to-extend top-to-bottom-coord-list)
  "Horizontally shift outside contents right above and right below of the table.
This function moves the surrounding text outside of the table so that
they match the horizontal growth/shrink of the table.  It also
untabify the shift affected area including the right side of the table
so that tab related uneven shifting is avoided.  COLUMNS-TO-EXTEND
specifies the number of columns the table grows, or shrinks if
negative.  TOP-TO-BOTTOM-COORD-LIST is the vertical cell coordinate
list.  This list can be any vertical list within the table."
  (save-excursion
    (let (beg-coord end-coord)
      (table-goto-coordinate (caar top-to-bottom-coord-list))
      (let* ((cell (table-horizontal-cell-list nil 'first-only 'top))
	     (coord (cons (car (table-get-coordinate (cdr cell)))
			  (cdr (table-get-coordinate (car cell))))))
	(setcar coord (1+ (car coord)))
	(setcdr coord (- (cdr coord) 2))
	(setq beg-coord (cons (car coord) (1+ (cdr coord))))
	(while (and (table-goto-coordinate coord 'no-extension)
		    (not (looking-at "\\s *$")))
	  (if (< columns-to-extend 0)
	      (progn
		(table-untabify-line)
		(delete-char columns-to-extend))
	    (table-untabify-line (point))
	    (insert (make-string columns-to-extend ?\ )))
	  (setcdr coord (1- (cdr coord)))))
      (table-goto-coordinate (caar (last top-to-bottom-coord-list)))
      (let ((coord (table-get-coordinate (cdr (table-horizontal-cell-list nil 'first-only 'bottom)))))
	(setcar coord (1+ (car coord)))
	(setcdr coord (+ (cdr coord) 2))
	(setq end-coord (cons (car coord) (1- (cdr coord))))
	(while (and (table-goto-coordinate coord 'no-extension)
		    (not (looking-at "\\s *$")))
	  (if (< columns-to-extend 0)
	      (progn
		(table-untabify-line)
		(delete-char columns-to-extend))
	    (table-untabify-line (point))
	    (insert (make-string columns-to-extend ?\ )))
	  (setcdr coord (1+ (cdr coord)))))
      (while (<= (cdr beg-coord) (cdr end-coord))
	(table-untabify-line (table-goto-coordinate beg-coord 'no-extension))
	(setcdr beg-coord (1+ (cdr beg-coord)))))))

(defun table-create-growing-space-below (lines-to-extend left-to-right-coord-list bottom-border-y)
  "Create growing space below the table.
This function creates growing space below the table slightly
intelligent fashion.  Following is the cases it handles for each
growing line:
  1. When the first line below the table is a complete blank line it
inserts a blank line.
  2. When the line starts with a prefix that matches the prefix of the
bottom line of the table it inserts a line consisting of prefix alone.
  3. Otherwise it deletes the rectangular contents where table will
grow into."
  (save-excursion
    (let ((i 0)
	  (prefix (and (table-goto-coordinate (cons 0 bottom-border-y))
		       (re-search-forward
			".*\\S "
			(save-excursion
			  (table-goto-coordinate
			   (cons (1- (caar (car left-to-right-coord-list))) bottom-border-y)))
			t)
		       (buffer-substring (match-beginning 0) (match-end 0)))))
      (while (< i lines-to-extend)
	(let ((y (+ i bottom-border-y 1)))
	  (table-goto-coordinate (cons 0 y))
	  (cond
	   ((looking-at "\\s *$")
	    (insert ?\n))
	   ((and prefix (looking-at (concat (regexp-quote prefix) "\\s *$")))
	    (insert prefix ?\n))
	   (t
	    (delete-rectangle
	     (table-goto-coordinate (cons (1- (caar (car left-to-right-coord-list))) y))
	     (table-goto-coordinate (cons (1+ (cadr (car (last left-to-right-coord-list)))) y))))))
	(setq i (1+ i))))))

(defun table-untabify-line (&optional from)
  "Untabify current line.
Unlike save-excursion this guarantees preserving the cursor location
even when the point is on a tab character which is to be removed.
Optional FROM narrows the subject operation from this point to the end
of line."
  (let ((current-coordinate (table-get-coordinate)))
    (table-untabify (or from (progn (beginning-of-line) (point)))
		    (progn (end-of-line) (point)))
    (table-goto-coordinate current-coordinate)))

(defun table-untabify (beg end)
  "Wrapper to raw untabify."
  (untabify beg end)
  (if (featurep 'xemacs)
      ;; Cancel strange behavior of xemacs
      (message "")))

(defun table-multiply-string (string multiplier)
  "Multiply string and return it."
  (let ((ret-str ""))
    (while (> multiplier 0)
      (setq ret-str (concat ret-str string))
      (setq multiplier (1- multiplier)))
    ret-str))

(defun table-find-row-column (&optional columnp no-error)
  "Search table and return a cell coordinate list of row or column."
  (let ((current-coordinate (table-get-coordinate)))
    (catch 'end
      (catch 'error
	(let ((coord (table-get-coordinate)))
	  (while
	      (progn
		(if columnp (setcar coord (1- (car coord)))
		  (setcdr coord (1- (cdr coord))))
		(>= (if columnp (car coord) (cdr coord)) 0))
	    (while (progn
		     (table-goto-coordinate coord 'no-extension 'no-tab-expansion)
		     (not (looking-at (format "[%c%c%c]"
					      table-cell-horizontal-char
					      table-cell-vertical-char
					      table-cell-intersection-char))))
	      (if columnp (setcar coord (1- (car coord)))
		(setcdr coord (1- (cdr coord))))
	      (if (< (if columnp (car coord) (cdr coord)) 0)
		  (throw 'error nil)))
	    (if (table-probe-cell)
		(throw 'end (table-cell-list-to-coord-list (if columnp
							       (table-vertical-cell-list t nil 'left)
							     (table-horizontal-cell-list t nil 'top))))
	      (table-goto-coordinate (table-offset-coordinate coord (if columnp '(0 . 1) '(1 . 0)))
				     'no-extension 'no-tab-expansion)
	      (if (table-probe-cell)
		  (throw 'end (table-cell-list-to-coord-list (if columnp
								 (table-vertical-cell-list t nil 'left)
							       (table-horizontal-cell-list t nil 'top)))))))))
      (table-goto-coordinate current-coordinate)
      (if no-error nil
	(error "Table not found")))))

(defun table-average-coord-list (coord-list)
  "Return average cell dimension of COORD-LIST.
COORD-LIST is a list of coordinate pairs (lu-coord . rb-coord), where
each pair in the list represents a cell.  lu-coord is the left upper
coordinate of a cell and rb-coord is the right bottom coordinate of a
cell.  A coordinate is a pair of x and y axis coordinate values.  The
return value is a cons cell (av-w . av-h), where av-w and av-h are
respectively the average width and the average height of all the cells
in the list."
  (if (null coord-list) nil
    (let ((n 0)
	  (sum-width 0)
	  (sum-height 0))
      (while coord-list
	(let ((coord (prog1 (car coord-list) (setq coord-list (cdr coord-list)))))
	  (setq sum-width (+ sum-width (- (cadr coord) (caar coord))))
	  (setq sum-height (+ sum-height (- (cddr coord) (cdar coord)) 1))
	  (setq n (1+ n))))
      (if (zerop n) nil
	(let ((half (/ n 2)))
	  (cons (/ (+ sum-width half) n) (/ (+ sum-height half) n)))))))

(defun table-max-coord-list (coord-list)
  "Return maximum cell dimension of COORD-LIST.
COORD-LIST is a list of coordinate pairs (lu-coord . rb-coord), where
each pair in the list represents a cell.  lu-coord is the left upper
coordinate of a cell and rb-coord is the right bottom coordinate of a
cell.  A coordinate is a pair of x and y axis coordinate values.  The
return value is a cons cell (max-w . max-h), where max-w and max-h are
respectively the maximum width and the maximum height of all the cells
in the list."
  (if (null coord-list) nil
    (let ((max-width 0)
	  (max-height 0))
      (while coord-list
	(let* ((coord (prog1 (car coord-list) (setq coord-list (cdr coord-list))))
	       (width (- (cadr coord) (caar coord)))
	       (height (1+ (- (cddr coord) (cdar coord)))))
	  (if (> width max-width) (setq max-width width))
	  (if (> height max-height) (setq max-height height))))
      (cons max-width max-height))))

(defun table-min-coord-list (coord-list)
  "Return minimum cell dimension of COORD-LIST.
COORD-LIST is a list of coordinate pairs (lu-coord . rb-coord), where
each pair in the list represents a cell.  lu-coord is the left upper
coordinate of a cell and rb-coord is the right bottom coordinate of a
cell.  A coordinate is a pair of x and y axis coordinate values.  The
return value is a cons cell (min-w . min-h), where min-w and min-h are
respectively the minimum width and the minimum height of all the cells
in the list."
  (if (null coord-list) nil
    (let ((min-width 134217727)
	  (min-height 134217727))
      (while coord-list
	(let* ((coord (prog1 (car coord-list) (setq coord-list (cdr coord-list))))
	       (width (- (cadr coord) (caar coord)))
	       (height (1+ (- (cddr coord) (cdar coord)))))
	  (if (< width min-width) (setq min-width width))
	  (if (< height min-height) (setq min-height height))))
      (cons min-width min-height))))

(defun table-cell-can-split-horizontally-p ()
  "Test if a cell can split at current location horizontally."
  (let* ((table-inhibit-advice t)
	 (point-x (car (table-get-coordinate))))
    (table-recognize-cell 'force)
    (and (> point-x (car table-cell-info-lu-coordinate))
	 (< point-x (1- (car table-cell-info-rb-coordinate))))))

(defun table-cell-can-split-vertically-p ()
  "Test if a cell can split at current location vertically."
  (let* ((table-inhibit-advice t)
	 (point-y (cdr (table-get-coordinate))))
    (table-recognize-cell 'force)
    (and (> point-y (cdr table-cell-info-lu-coordinate))
	 (< point-y (cdr table-cell-info-rb-coordinate)))))

(defun table-cell-can-span-p (direction)
  "Test if the current cell can span to DIRECTION."
  (let ((table-inhibit-advice t))
    (table-recognize-cell 'force)
    (and (table-probe-cell)
	 ;; get two adjacent cells from each corner
	 (let ((cell (save-excursion
		       (and
			(table-goto-coordinate
			 (cons (cond ((eq direction 'right) (1+ (car table-cell-info-rb-coordinate)))
				     ((eq direction 'left)  (1- (car table-cell-info-lu-coordinate)))
				     (t (car table-cell-info-lu-coordinate)))
			       (cond ((eq direction 'above) (- (cdr table-cell-info-lu-coordinate) 2))
				     ((eq direction 'below) (+ (cdr table-cell-info-rb-coordinate) 2))
				     (t (cdr table-cell-info-lu-coordinate)))) 'no-extension)
			(table-probe-cell))))
	       (cell2 (save-excursion
			(and
			 (table-goto-coordinate
			  (cons (cond ((eq direction 'right) (1+ (car table-cell-info-rb-coordinate)))
				      ((eq direction 'left)  (1- (car table-cell-info-lu-coordinate)))
				      (t (car table-cell-info-rb-coordinate)))
				(cond ((eq direction 'above) (- (cdr table-cell-info-lu-coordinate) 2))
				      ((eq direction 'below) (+ (cdr table-cell-info-rb-coordinate) 2))
				      (t (cdr table-cell-info-rb-coordinate)))) 'no-extension)
			 (table-probe-cell)))))
	   ;; make sure the two cells exist, and they are identical, that cell's size matches the current one
	   (and cell
		(equal cell cell2)
		(if (or (eq direction 'right) (eq direction 'left))
		    (and (= (cdr (table-get-coordinate (car cell)))
			    (cdr table-cell-info-lu-coordinate))
			 (= (cdr (table-get-coordinate (cdr cell)))
			    (cdr table-cell-info-rb-coordinate)))
		  (and (= (car (table-get-coordinate (car cell)))
			  (car table-cell-info-lu-coordinate))
		       (= (car (table-get-coordinate (cdr cell)))
			  (car table-cell-info-rb-coordinate)))))))))

(defun table-cell-insert-char (char)
  "Insert CHAR inside a table cell."
  (table-with-cache-buffer
    (if (not (eq char ?\ ))
	(if char (insert char))
      (if (not (looking-at "\\s *$"))
	  (if (and table-fixed-width-mode
		   (> (point) 2)
		   (save-excursion
		     (forward-char -2)
		     (looking-at (concat "\\("
					 (regexp-quote (char-to-string table-word-continuation-char))
					 "\\)\n"))))
	      (save-excursion
		(replace-match " " nil nil nil 1))
	    (insert char))
	(let ((coordinate (table-get-coordinate)))
	  (if (< (car coordinate) table-cell-info-width)
	      (move-to-column (1+ (car coordinate)) t)
	    (insert (make-string (forward-line 1) ?\n))
	    (unless (bolp) (insert ?\n))))
	(setq table-inhibit-auto-fill-paragraph t))
      (save-excursion
	(let ((o-point (point)))
	  (if (and (bolp)
		   (or (progn
			 (forward-paragraph)
			 (forward-paragraph -1)
			 (= o-point (point)))
		       (progn
			 (goto-char o-point)
			 (forward-line)
			 (setq o-point (point))
			 (forward-paragraph)
			 (forward-paragraph -1)
			 (= o-point (point)))))
	      (insert ?\n)))))))

(defun table-deep-copy-rebind-keymap (keymap)
  "Return a copy of KEYMAP with commands replaced with table commands.
Copy operation goes as deep as tracing the symbol's function
definition if the binding happens to be a fbound symbol."
  (table-replace-binding (copy-keymap keymap)))

(defun table-replace-binding (keymap)
  "Search through all bindings in KEYMAP and replace them all.
Exclude menu-bar from KEYMAP."
  (let ((tail keymap))
    (while (consp tail)
      (let ((elt (cadr tail))
	    (otail tail))
	(setq tail (cdr tail))
	(cond
	 ((char-table-p elt)
	  (map-char-table
	   (function (lambda (key value) (aset elt key (table-replace-binding1 value))))
	   elt))
	 ((vectorp elt)
	  (let ((i 0)
		(len (length elt)))
	    (while (< i len)
	      (aset elt i (table-replace-binding1 (aref elt i)))
	      (setq i (1+ i)))))
	 ((consp elt)
	  ;; strip the menu bar item
	  (if (or (eq (car elt) 'menu-bar) ;; new format menu item
		  (stringp (car elt))) ;; old format menu item
	      (progn
		(setcdr otail (cddr otail))
		(setq tail otail))
	    (setcdr elt (table-replace-binding1 (cdr elt)))))))))
  keymap)

(defun table-replace-binding1 (binding)
  "Replace one binding."
  (let (tmp)
    (cond ((and (symbolp binding)
		(fboundp binding)
		(keymapp (symbol-function binding)))
	   (or (cdr (assoc binding table-cell-global-map-alist))
	       (let ((symbol (intern (concat "table-cell-map-" (symbol-name binding)))))
		 (setq table-cell-global-map-alist
		       (cons (cons binding symbol) table-cell-global-map-alist))
		 (fset symbol (table-deep-copy-rebind-keymap (symbol-function binding)))
		 symbol)))
	  ((keymapp binding)
	   (table-replace-binding binding))
	  ((stringp binding)
	   (copy-sequence binding))
	  ((setq tmp (assq binding table-command-replacement-alist))
	   (cdr tmp))
	  (t binding))))

(defun table-finish-delayed-tasks ()
  "Finish all outstanding delayed tasks."
  (let ((table-inhibit-advice t))
    (if table-widen-timer
	(table-update-cell-widened 'now)
      (if table-update-timer
	  (table-update-cell 'now)))))

(defmacro table-log (&rest body)
  "Debug logging macro."
  (` (save-excursion
       (set-buffer (get-buffer-create "log"))
       (goto-char (point-min))
       (let ((standard-output (current-buffer)))
	 (,@ body)))))

(defun table-measure-max-width (&optional unlimited)
  "Return maximum width of current buffer.
Normally the current buffer is expected to be already the cache
buffer.  The width excludes following spaces at the end of each line.
Unless UNLIMITED is non-nil minimum return value is 1."
  (save-excursion
    (let ((width 0))
      (goto-char (point-min))
      (while
	  (progn
	    ;; do not count the following white spaces
	    (re-search-forward "\\s *$")
	    (goto-char (match-beginning 0))
	    (if (> (current-column) width)
		(setq width (current-column)))
	    (forward-line)
	    (not (eobp))))
      (if unlimited width
	(max 1 width)))))

(defun table-cell-to-coord (cell)
  "Create a cell coordinate pair from cell location pair."
  (if cell
      (cons (table-get-coordinate (car cell))
	    (table-get-coordinate (cdr cell)))
    nil))

(defun table-cell-list-to-coord-list (cell-list)
  "Create and return a coordinate list that corresponds to CELL-LIST.
CELL-LIST is a list of location pairs (lu . rb), where each pair
represents a cell in the list.  lu is the left upper location and rb
is the right bottom location of a cell.  The return value is a list of
coordinate pairs (lu-coord . rb-coord), where lu-coord is the left
upper coordinate and rb-coord is the right bottom coordinate of a
cell."
  (let ((coord-list))
    (while cell-list
      (let ((cell (prog1 (car cell-list) (setq cell-list (cdr cell-list)))))
	(setq coord-list
	      (cons (table-cell-to-coord cell) coord-list))))
    (nreverse coord-list)))

(defun table-test-cell-list (&optional horizontal reverse first-only pivot)
  "For testing `table-vertical-cell-list' and `table-horizontal-cell-list'."
  (let* ((table-inhibit-advice t)
	 (current-coordinate (table-get-coordinate))
	 (cell-list (if horizontal
			(table-horizontal-cell-list reverse first-only pivot)
		      (table-vertical-cell-list reverse first-only pivot)))
	 (count 0))
    (while cell-list
      (let* ((cell (if first-only (prog1 cell-list (setq cell-list nil))
		     (prog1 (car cell-list) (setq cell-list (cdr cell-list)))))
	     (dig1-str (format "%1d" (prog1 (% count 10) (setq count (1+ count))))))
	(goto-char (car cell))
	(table-with-cache-buffer
	  (replace-regexp "." dig1-str)
	  (setq table-inhibit-auto-fill-paragraph t))
	(table-finish-delayed-tasks)))
    (table-goto-coordinate current-coordinate)))

(defun table-vertical-cell-list (&optional top-to-bottom first-only pivot internal-dir internal-list internal-px)
  "Return a vertical cell list from the table.
The return value represents a list of cells including the current cell
that align vertically.  Each element of the list is a cons cell (lu
. rb) where lu is the cell's left upper location and rb is the cell's
right bottom location.  The cell order in the list is from bottom to
top of the table.  If optional argument TOP-TO-BOTTOM is non-nil the
order is reversed as from top to bottom of the table.  If optional
argument FIRST-ONLY is non-nil the return value is not a list of cells
but a single cons cell that is the first cell of the list, if the list
had been created.  If optional argument PIVOT is a symbol `left' the
vertical cell search is aligned with the left edge of the current
cell, otherwise aligned with the right edge of the current cell.  The
arguments INTERNAL-DIR, INTERNAL-LIST and INTERNAL-PX are internal use
only and must not be specified."
  (save-excursion
    (let* ((cell (table-probe-cell))
	   (lu-coordinate (table-get-coordinate (car cell)))
	   (rb-coordinate (table-get-coordinate (cdr cell)))
	   (px (or internal-px (car (if (eq pivot 'left) lu-coordinate rb-coordinate))))
	   (ty (- (cdr lu-coordinate) 2))
	   (by (+ (cdr rb-coordinate) 2)))
      ;; in case of finding the the first cell, get the last adding item on the list
      (if (and (null internal-dir) first-only) (setq top-to-bottom (null top-to-bottom)))
      ;; travel up and process as recursion traces back (reverse order)
      (and cell
	   (or (eq internal-dir 'up) (null internal-dir))
	   (table-goto-coordinate (cons px (if top-to-bottom by ty)) 'no-extension 'no-tab-expansion)
	   (setq internal-list (table-vertical-cell-list top-to-bottom first-only nil 'up nil px)))
      ;; return the last cell or add this cell to the list
      (if first-only (or internal-list cell)
	(setq internal-list (if cell (cons cell internal-list) internal-list))
	;; travel down and process as entering each recursion (forward order)
	(and cell
	     (or (eq internal-dir 'down) (null internal-dir))
	     (table-goto-coordinate (cons px (if top-to-bottom ty by)) 'no-extension 'no-tab-expansion)
	     (setq internal-list (table-vertical-cell-list top-to-bottom nil nil 'down internal-list px)))
	;; return the result
	internal-list))))

(defun table-horizontal-cell-list (&optional left-to-right first-only pivot internal-dir internal-list internal-py)
  "Return a horizontal cell list from the table.
The return value represents a list of cells including the current cell
that align horizontally.  Each element of the list is a cons cells (lu
. rb) where lu is the cell's left upper location and rb is the cell's
right bottom location.  The cell order in the list is from right to
left of the table.  If optional argument LEFT-TO-RIGHT is non-nil the
order is reversed as from left to right of the table.  If optional
argument FIRST-ONLY is non-nil the return value is not a list of cells
but a single cons cell that is the first cell of the list, if the
list had been created.  If optional argument PIVOT is a symbol `top'
the horizontal cell search is aligned with the top edge of the current
cell, otherwise aligned with the bottom edge of the current cell.  The
arguments INTERNAL-DIR, INTERNAL-LIST and INTERNAL-PY are internal use
only and must not be specified."
  (save-excursion
    (let* ((cell (table-probe-cell))
	   (lu-coordinate (table-get-coordinate (car cell)))
	   (rb-coordinate (table-get-coordinate (cdr cell)))
	   (py (or internal-py (if (eq pivot 'top) (cdr lu-coordinate) (1+ (cdr rb-coordinate)))))
	   (lx (1- (car lu-coordinate)))
	   (rx (1+ (car rb-coordinate))))
      ;; in case of finding the the first cell, get the last adding item on the list
      (if (and (null internal-dir) first-only) (setq left-to-right (null left-to-right)))
      ;; travel left and process as recursion traces back (reverse order)
      (and cell
	   (or (eq internal-dir 'left) (null internal-dir))
	   (table-goto-coordinate (cons (if left-to-right rx lx) py) 'no-extension 'no-tab-expansion)
	   (setq internal-list (table-horizontal-cell-list left-to-right first-only nil 'left nil py)))
      ;; return the last cell or add this cell to the list
      (if first-only (or internal-list cell)
	(setq internal-list (if cell (cons cell internal-list) internal-list))
	;; travel right and process as entering each recursion (forward order)
	(and cell
	     (or (eq internal-dir 'right) (null internal-dir))
	     (table-goto-coordinate (cons (if left-to-right lx rx) py) 'no-extension 'no-tab-expansion)
	     (setq internal-list (table-horizontal-cell-list left-to-right nil nil 'right internal-list py)))
	;; return the result
	internal-list))))

(defun table-point-in-cell-p (&optional location)
  "Return t when point is in a valid table cell in the current buffer.
When optional LOCATION is provided the test is performed at that location."
  (and (table-at-cell-p (or location (point)))
       (if location
	   (save-excursion
	     (goto-char location)
	     (table-probe-cell))
	 (table-probe-cell))))

(defun table-region-in-cell-p (beg end)
  "Return t when location BEG and END are in a valid table cell in the current buffer."
  (and (table-at-cell-p (min beg end))
       (save-excursion
	 (let ((cell-beg (progn (goto-char beg) (table-probe-cell))))
	   (and cell-beg
		(equal cell-beg (progn (goto-char end) (table-probe-cell))))))))

(defun table-at-cell-p (position &optional object at-column)
  "Returns non-nil if POSITION has table-cell property in OBJECT.
OBJECT is optional and defaults to the current buffer.
If POSITION is at the end of OBJECT, the value is nil."
  (if (and at-column (stringp object))
      (setq position (table-str-index-at-column object position)))
  (get-text-property position 'table-cell object))

(defun table--probe-cell-left-up ()
  "Probe left up corner pattern of a cell.
If it finds a valid corner returns a position otherwise returns nil.
The position is the location before the first cell character.
Focus only on the corner pattern.  Further cell validity check is required."
  (save-excursion
    (let ((vertical-str (regexp-quote (char-to-string table-cell-vertical-char)))
	  (horizontal-str (regexp-quote (char-to-string table-cell-horizontal-char)))
	  (intersection-str (regexp-quote (char-to-string table-cell-intersection-char)))
	  (v-border (format "[%c%c]" table-cell-vertical-char table-cell-intersection-char))
	  (h-border (format "[%c%c]" table-cell-horizontal-char table-cell-intersection-char))
	  (limit (save-excursion (beginning-of-line) (point))))
      (catch 'end
	(while t
	  (catch 'retry-horizontal
	    (if (not (search-backward-regexp v-border limit t))
		(throw 'end nil))
	    (save-excursion
	      (let ((column (current-column)))
		(while t
		  (catch 'retry-vertical
		    (if (zerop (forward-line -1)) nil (throw 'end nil))
		    (move-to-column column)
		    (while (and (looking-at vertical-str)
				(= column (current-column)))
		      (if (zerop (forward-line -1)) nil (throw 'end nil))
		      (move-to-column column))
		    (cond
		     ((/= column (current-column))
		      (throw 'end nil))
		     ((looking-at (concat intersection-str h-border))
		      (forward-line 1)
		      (move-to-column column)
		      (forward-char 1)
		      (throw 'end (point)))
		     ((looking-at intersection-str)
		      (throw 'retry-vertical nil))
		     (t (throw 'retry-horizontal nil)))))))))))))

(defun table--probe-cell-right-bottom ()
  "Probe right bottom corner pattern of a cell.
If it finds a valid corner returns a position otherwise returns nil.
The position is the location after the last cell character.
Focus only on the corner pattern.  Further cell validity check is required."
  (save-excursion
    (let ((vertical-str (regexp-quote (char-to-string table-cell-vertical-char)))
	  (horizontal-str (regexp-quote (char-to-string table-cell-horizontal-char)))
	  (intersection-str (regexp-quote (char-to-string table-cell-intersection-char)))
	  (v-border (format "[%c%c]" table-cell-vertical-char table-cell-intersection-char))
	  (h-border (format "[%c%c]" table-cell-horizontal-char table-cell-intersection-char))
	  (limit (save-excursion (end-of-line) (point))))
      (catch 'end
	(while t
	  (catch 'retry-horizontal
	    (if (not (search-forward-regexp v-border limit t))
		(throw 'end nil))
	    (save-excursion
	      (forward-char -1)
	      (let ((column (current-column)))
		(while t
		  (catch 'retry-vertical
		    (while (and (looking-at vertical-str)
				(= column (current-column)))
		      (if (and (zerop (forward-line 1)) (zerop (current-column))) nil (throw 'end nil))
		      (move-to-column column))
		    (cond
		     ((/= column (current-column))
		      (throw 'end nil))
		     ((save-excursion (forward-char -1) (looking-at (concat h-border intersection-str)))
		      (save-excursion
			(and (zerop (forward-line -1))
			     (move-to-column column)
			     (looking-at v-border)
			     (throw 'end (point))))
		      (forward-char 1)
		      (throw 'retry-horizontal nil))
		     ((looking-at intersection-str)
		      (if (and (zerop (forward-line 1)) (zerop (current-column))) nil (throw 'end nil))
		      (move-to-column column)
		      (throw 'retry-vertical nil))
		     (t (throw 'retry-horizontal nil)))))))))))))

(defun table-probe-cell (&optional abort-on-error)
  "Probes a table cell around the point.
Searches for the left upper corner and the right bottom corner of a table
cell which contains the current point location.

The result is a cons cell (left-upper . right-bottom) where
the left-upper is the position before the cell's left upper corner character,
the right-bottom is the position after the cell's right bottom corner character.

When it fails to find either one of the cell corners it returns nil or
signals error if the optional ABORT-ON-ERROR is non-nil."
  (let ((table-inhibit-advice t)
	lu rb
	(border (format "^[%c%c%c]+$"
			table-cell-horizontal-char
			table-cell-vertical-char
			table-cell-intersection-char)))
    (if (and (condition-case nil
		 (progn
		   (and (setq lu (table--probe-cell-left-up))
			(setq rb (table--probe-cell-right-bottom))))
	       (error nil))
	     (< lu rb)
	     (let ((lu-coordinate (table-get-coordinate lu))
		   (rb-coordinate (table-get-coordinate rb)))
	       ;; test for valid upper and lower borders
	       (and (string-match
		     border
		     (buffer-substring
		      (save-excursion
			(table-goto-coordinate
			 (cons (1- (car lu-coordinate))
			       (1- (cdr lu-coordinate)))))
		      (save-excursion
			(table-goto-coordinate
			 (cons (1+ (car rb-coordinate))
			       (1- (cdr lu-coordinate)))))))
		    (string-match
		     border
		     (buffer-substring
		      (save-excursion
			(table-goto-coordinate
			 (cons (1- (car lu-coordinate))
			       (1+ (cdr rb-coordinate)))))
		      (save-excursion
			(table-goto-coordinate
			 (cons (1+ (car rb-coordinate))
			       (1+ (cdr rb-coordinate))))))))))
	(cons lu rb)
      (if abort-on-error
	  (error "Table cell not found")
	nil))))

(defun table-insert-rectangle (rectangle)
  "Insert text of RECTANGLE with upper left corner at point.
Same as insert-rectangle except that mark operation is eliminated."
  (let ((lines rectangle)
	(insertcolumn (current-column))
	(first t))
    (while lines
      (or first
	  (progn
	    (forward-line 1)
	    (or (bolp) (insert ?\n))
	    (move-to-column insertcolumn t)))
      (setq first nil)
      (insert (car lines))
      (setq lines (cdr lines)))))

(defun table-put-cell-property (cell)
  "Put standard text properties to the CELL.
The CELL is a cons cell (left-upper . right-bottom) where the
left-upper is the position before the cell's left upper corner
character, the right-bottom is the position after the cell's right
bottom corner character."
  (let ((lu (table-get-coordinate (car cell)))
	(rb (table-get-coordinate (cdr cell))))
    (save-excursion
      (while (<= (cdr lu) (cdr rb))
	(let ((beg (table-goto-coordinate lu 'no-extension))
	      (end (table-goto-coordinate (cons (car rb) (cdr lu)))))
	  (table-put-cell-line-property beg end))
	(setcdr lu (1+ (cdr lu)))))))

(defun table-put-cell-line-property (beg end &optional object)
  "Put standard text properties to a line of a cell.
BEG is the beginning of the line that is the location between left
cell border character and the first content character.  END is the end
of the line that is the location between the last content character
and the right cell border character."
  (table-put-cell-content-property beg end object)
  (table-put-cell-keymap-property end (1+ end) object)
  (table-put-cell-indicator-property end (1+ end) object)
  (table-put-cell-rear-nonsticky end (1+ end) object))

(defun table-put-cell-content-property (beg end &optional object)
  "Put cell content text properties."
  (table-put-cell-keymap-property beg end object)
  (table-put-cell-indicator-property beg end object)
  (table-put-cell-face-property beg end object)
  (table-put-cell-point-entered/left-property beg end object))

(defun table-put-cell-indicator-property (beg end &optional object)
  "Put cell property which indicates that the location is within a table cell."
  (put-text-property beg end 'table-cell t object))

(defun table-put-cell-face-property (beg end &optional object)
  "Put cell face property."
  (put-text-property beg end 'face 'table-cell-face object))

(defun table-put-cell-keymap-property (beg end &optional object)
  "Put cell keymap property."
  (put-text-property beg end (if (featurep 'xemacs) 'keymap 'local-map) 'table-cell-map object))

(defun table-put-cell-rear-nonsticky (beg end &optional object)
  "Put rear-nonsticky property."
  (put-text-property beg end 'rear-nonsticky t object))
  
(defun table-put-cell-point-entered/left-property (beg end &optional object)
  "Put point-entered/left property."
  (put-text-property beg end 'point-entered 'table-point-entered-cell-function object)
  (put-text-property beg end 'point-left 'table-point-left-cell-function object))

(defun table-remove-cell-properties (beg end &optional object)
  "Remove all cell properties."
  (remove-text-properties beg end
			  (list
			   'table-cell nil
			   'face nil
			   'rear-nonsticky nil
			   'point-entered nil
			   'point-left nil
			   (if (featurep 'xemacs) 'keymap 'local-map) nil)
			  object))

(defun table-update-cell-face ()
  "Update cell face according to the current mode."
  (if (featurep 'xemacs)
      (set-face-property 'table-cell-face 'underline table-fixed-width-mode)
    (set-face-inverse-video-p 'table-cell-face table-fixed-width-mode)))

(table-update-cell-face)

(defun table-point-entered-cell-function (&optional old-point new-point)
  "Point has entered a cell.
Refresh the menu bar."
  (setq table-mode-indicator (not table-fixed-width-mode))
  (setq table-fixed-mode-indicator table-fixed-width-mode)
  (set-buffer-modified-p (buffer-modified-p)))

(defun table-point-left-cell-function (&optional old-point new-point)
  "Point has left a cell.
Refresh the menu bar."
  (setq table-mode-indicator nil)
  (setq table-fixed-mode-indicator nil)
  (set-buffer-modified-p (buffer-modified-p)))

(defun table-cell-blank-str (&optional n)
  "Return blank table cell string of length N."
  (let ((str (make-string (or n 1) ?\ )))
    (table-put-cell-content-property 0 (length str) str)
    str))

(defun table-remove-eol-spaces (beg end &optional bol)
  "Remove spaces at the end of each line in the BEG END region of the current buffer.
When optional BOL is non-nil spaces at the beginning of line are removed."
  (if (> beg end)
      (let ((tmp beg))
	(setq beg end)
	(setq end tmp)))
  (let ((saved-point (point-marker))
	(end-marker (make-marker)))
    (set-marker end-marker end)
    (save-excursion
      (goto-char beg)
      (while (if bol (re-search-forward "^\\( +\\)" end-marker t)
	       (re-search-forward "\\( +\\)$" end-marker t))
	;; avoid removal that causes the saved point to lose its location.
	(if (and (null bol)
		 (<= (match-beginning 1) saved-point)
		 (<= saved-point (match-end 1)))
	    (delete-region saved-point (match-end 1))
	  (delete-region (match-beginning 1) (match-end 1)))))
    (set-marker saved-point nil)
    (set-marker end-marker nil)))

(defun table-fill-region (beg end &optional col)
  "Fill paragraphs in table cell cache.
Current buffer must already be set to the cache buffer."
  (let ((fill-column (or col table-cell-info-width))
	(fill-prefix nil)
	(enable-kinsoku nil)
	(adaptive-fill-mode nil)
	(marker-beg (make-marker))
	(marker-end (make-marker)))
    (set-marker marker-beg beg)
    (set-marker marker-end end)
    (save-excursion
      (table-remove-eol-spaces (point-min) (point-max))
      (if table-fixed-width-mode
	  (table-fill-region-strictly marker-beg marker-end)
	(fill-region marker-beg marker-end nil nil t)))))

(defun table-fill-region-strictly (beg end)
  "Fill region strictly so that no line exceeds fill-column.
When a word exceeds fill-column the word is chopped into pieces.  The
chopped location is indicated with table-word-continuation-char."
  (or (and (markerp beg) (markerp end))
      (error "markerp"))
  (if (< fill-column 2)
      (setq fill-column 2))
  ;; first remove all continuation characters.
  (goto-char beg)
  (while (re-search-forward (concat
			     (format "[^%c ]\\(" table-word-continuation-char)
			     (regexp-quote (char-to-string table-word-continuation-char))
			     "\\s +\\)")
			    end t)
    (delete-region (match-beginning 1) (match-end 1)))
  ;; then fill as normal
  (fill-region beg end nil nil t)
  ;; now fix up
  (goto-char beg)
  (while (let ((col (move-to-column fill-column t)))
	   (cond
	    ((and (<= col fill-column)
		  (looking-at " *$"))
	     (delete-region (match-beginning 0) (match-end 0))
	     (and (zerop (forward-line 1))
		  (< (point) end)))
	    (t (forward-char -1)
	       (insert-before-markers (if (equal (char-before) ?\ ) ?\  table-word-continuation-char)
				      "\n")
	       t)))))

(defun table-goto-coordinate (coordinate &optional no-extension no-tab-expansion)
  "Move point to the given COORDINATE and return the location.
When optional NO-EXTENSION is non-nil and the specified coordinate is
not reachable returns nil otherwise the blanks are added if necessary
to achieve the goal coordinate and returns the goal point.  It
intentionally does not preserve the original point in case it fails
achieving the goal.  When optional NO-TAB-EXPANSION is non-nil and the
goad happens to be in a tab character the tab is not expanded but the
goal ends at the beginning of tab."
  (if (or (null coordinate)
	  (< (car coordinate) 0)
	  (< (cdr coordinate) 0)) nil
    (goto-char (point-min))
    (let ((x (car coordinate))
	  (more-lines (forward-line (cdr coordinate))))
      (catch 'exit
	(if (zerop (current-column)) nil
	  (if no-extension
	      (progn
		(move-to-column x)
		(throw 'exit nil))
	    (setq more-lines (1+ more-lines))))
	(if (zerop more-lines) nil
	  (newline more-lines))
	(if no-extension
	    (if (/= (move-to-column x) x)
		(if (> (move-to-column x) x)
		    (if no-tab-expansion
			(progn
			  (while (> (move-to-column x) x)
			    (setq x (1- x)))
			  (point))
		      (throw 'exit (move-to-column x t)))
		  (throw 'exit nil)))
	  (move-to-column x t))
	(point)))))

(defun table-copy-coordinate (coord)
  "Copy coordinate in a new cons cell."
  (cons (car coord) (cdr coord)))

(defun table-get-coordinate (&optional where)
  "Return the coordinate of point in current buffer.
When optional WHERE is given it returns the coordinate of that
location instead of point in the current buffer.  It does not move the
point"
  (save-excursion
    (if where (goto-char where))
    (cons (current-column)
	  (table-current-line))))

(defun table-current-line (&optional location)
  "Return zero based line count of current line or if non-nil LOCATION line."
  (save-excursion
    (let ((table-inhibit-advice t))
      (if location (goto-char location))
      (beginning-of-line)
      (count-lines (point-min) (point)))))

(defun table-transcoord-table-to-cache (&optional coordinate)
  "Transpose COORDINATE from table coordinate system to cache coordinate system.
When COORDINATE is omitted or nil the point in current buffer is assumed in place."
  (table-offset-coordinate
   (or coordinate (table-get-coordinate))
   table-cell-info-lu-coordinate
   'negative))

(defun table-transcoord-cache-to-table (&optional coordinate)
  "Transpose COORDINATE from cache coordinate system to table coordinate system.
When COORDINATE is omitted or nil the point in current buffer is assumed in place."
  (table-offset-coordinate
   (or coordinate (table-get-coordinate))
   table-cell-info-lu-coordinate))

(defun table-offset-coordinate (coordinate offset &optional negative)
  "Return the offseted COORDINATE by OFFSET.
When optional NEGATIVE is non-nil offsetting direction is negative."
  (cons (if negative (- (car coordinate) (car offset))
	  (+ (car coordinate) (car offset)))
	(if negative (- (cdr coordinate) (cdr offset))
	  (+ (cdr coordinate) (cdr offset)))))

(defun table-char-in-str-at-column (str column)
  "Return the character in STR at COLUMN location.
When COLUMN is out of range it returns null character."
  (let ((idx (table-str-index-at-column str column)))
    (if idx (aref str idx)
      ?\0)))

(defun table-str-index-at-column (str column)
  "Return the character index in STR that corresponds to COLUMN location.
It returns COLUMN unless STR contains some wide characters."
  (let ((col 0)
	(idx 0)
	(len (length str)))
    (while (and (< col column) (< idx len))
      (setq col (+ col (char-width (aref str idx))))
      (setq idx (1+ idx)))
    (if (< idx len)
	idx
      nil)))

(defun table-set-timer (seconds func args)
  "Generic wrapper for setting up a timer."
  (if (featurep 'xemacs)
      (add-timeout seconds func args nil)
    ;;(run-at-time seconds nil func args)))
    ;; somehow run-at-time causes strange problem under Emacs 20.7
    ;; this problem does not show up under Emacs 21.0.90
    (run-with-idle-timer seconds nil func args)))

(defun table-cancel-timer (timer)
  "Generic wrapper for canceling a timer."
  (if (featurep 'xemacs)
      (disable-timeout timer)
    (cancel-timer timer)))

(defun table-get-last-command ()
  "Generic wrapper for getting the real last command."
  (if (featurep 'xemacs)
      last-command
    real-last-command))

(defun table-cleanup-xemacs-history (history-symbol)
  "Get around strange behavior of a version of xemacs in completing-read"
  (if (string= (car (eval history-symbol)) "")
      (set history-symbol (cdr (eval history-symbol)))))

;; This is a workaround for unusual operation to mouse region by [delete] key.
;; Following is a copy of the same function originally defined in mouse.el.
;; The actual delete processing portion is modified so that if the mouse
;; region is in a table cell it is done correctly.
(defun mouse-show-mark ()
  (if transient-mark-mode
      (if window-system
	  (delete-overlay mouse-drag-overlay))
    (if window-system
	(let ((inhibit-quit t)
	      (echo-keystrokes 0)
	      event events key ignore
	      x-lost-selection-hooks)
	  (add-hook 'x-lost-selection-hooks
		    '(lambda (seltype)
		       (if (eq seltype 'PRIMARY)
			   (progn (setq ignore t)
				  (throw 'mouse-show-mark t)))))
	  (move-overlay mouse-drag-overlay (point) (mark t))
	  (catch 'mouse-show-mark
	    ;; In this loop, execute scroll bar and switch-frame events.
	    ;; Also ignore down-events that are undefined.
	    (while (progn (setq event (read-event))
			  (setq events (append events (list event)))
			  (setq key (apply 'vector events))
			  (or (and (consp event)
				   (eq (car event) 'switch-frame))
			      (and (consp event)
				   (eq (posn-point (event-end event))
				       'vertical-scroll-bar))
			      (and (memq 'down (event-modifiers event))
				   (not (key-binding key))
				   (not (mouse-undouble-last-event events))
				   (not (member key mouse-region-delete-keys)))))
	      (and (consp event)
		   (or (eq (car event) 'switch-frame)
		       (eq (posn-point (event-end event))
			   'vertical-scroll-bar))
		   (let ((keys (vector 'vertical-scroll-bar event)))
		     (and (key-binding keys)
			  (progn
			    (call-interactively (key-binding keys)
						nil keys)
			    (setq events nil)))))))
	  ;; If we lost the selection, just turn off the highlighting.
	  (if ignore
	      nil
	    ;; For certain special keys, delete the region.
	    (let ((beg (overlay-start mouse-drag-overlay))
		  (end (overlay-end mouse-drag-overlay)))
	      (if (member key mouse-region-delete-keys)
		  (if (table-region-in-cell-p beg end)
		      (let ((table-inhibit-advice t))
			(table-recognize-cell 'force)
			(let ((beg-coordinate (table-transcoord-table-to-cache (table-get-coordinate beg)))
			      (end-coordinate (table-transcoord-table-to-cache (table-get-coordinate end))))
			  (table-with-cache-buffer
			    (delete-region (table-goto-coordinate beg-coordinate)
					   (table-goto-coordinate end-coordinate)))))
		    (delete-region beg end))
		;; Otherwise, unread the key so it gets executed normally.
		(setq unread-command-events
		      (nconc events unread-command-events)))))
	  (setq quit-flag nil)
	  (delete-overlay mouse-drag-overlay))
      (save-excursion
       (goto-char (mark t))
       (sit-for 1)))))

(provide 'table)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Local Variables: ***
;; time-stamp-line-limit: 16 ***
;; time-stamp-start: ";; Created:[ \t]+" ***
;; time-stamp-end: "$" ***
;; time-stamp-format: "%3a, %02d %3b %:y %02H:%02M:%02S (%Z)" ***
;; End: ***
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; table.el ends here



