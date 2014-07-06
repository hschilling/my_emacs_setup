(require 'dmacro)

(add-dmacros 'c-mode-abbrev-table '(
 ("b" "{
~@
}" dmacro-indent "curly braces (ideal for dmacro-wrap-line)")
 ("ife" "if (~@)
 ~(mark)
else
 ~(mark)
" dmacro-indent "if/else statement")
 ("ifd" "#ifdef ~@
~(mark)
#endif 
" dmacro-indent "#ifdef/#endif (no prompting)")
 ("if" "if (~@)
 ~(mark)
" dmacro-indent "if statement")
 ("mal" "= (~(prompt type \"Variable type: \") *) ~(dmacro malloc)(~@sizeof(~(prompt)));
" dmacro-indent "call to malloc (prompts for var type)")
 ("void" "(void)" dmacro-indent nil)
 ("history" "     ~(user-id) - ~(mon) ~dd, ~(year): " dmacro-expand "a new HISTORY entry in the masthead")
 ("foriefficient" "for (i = ~@; --i >= 0; )
{
 ~mark
}
" dmacro-indent "for statement (decrements i efficiently)")
 ("ifddebug" "#ifdef DEBUG
if (debuglevel >= ~(prompt debug \"Debug level: \") {
(void) fprintf(stderr, \"DEBUG: ~@\\n\");
(void) fflush (stderr);
(void) getch ();
}
#endif /* DEBUG */" dmacro-indent "print debugging info to stderr")
 ("while" "while (~@)
{
 ~mark
}
" dmacro-indent "while statement")
 ("main" "main(argc, argv)
int argc;
char **argv;
{
~@
}
" dmacro-indent "an empty main() function with args")
 ("ifdnever" "#ifdef NEVER
~@
#endif /* NEVER */
" dmacro-expand "#ifdef NEVER (ideal for use with dmacro-wrap-region)")
 ("iinclude" "#ifndef ~((prompt file \"Header file name: \") :up)
# include <~(prompt file).h>
#endif /* ~((prompt file) :up) */
" dmacro-expand "interactive #include with #ifndef (prompts for file name)")
 ("iifnd" "#ifndef ~(prompt constant \"#ifndef condition: \")
~@
#endif /* ~(prompt) */
" dmacro-expand "#ifndef/#endif (prompts for condition)")
 ("ifmal" "if ((~@ = (~(prompt type \"Variable type: \") *) ~(dmacro malloc)(~(mark)sizeof(~(prompt)))) == NULLP(~(prompt)))
" dmacro-indent "malloc with check for error (prompts for var type)")
 ("switch" "switch (~@)
{

}" dmacro-indent "switch statement")
 ("fdesc" "/**
NAME:    
  ~@
PURPOSE:
  ~mark
ARGS:
  > ~mark
RETURNS:
  < ~mark
NOTES:
  ~mark
**/
" dmacro-expand "Standard function comment block")
 ("p" "(void) printf(\"~@\\n\"~mark);" dmacro-indent "printf")
 ("ifor" "for (~(prompt var \"Variable: \") = 0; ~prompt < ~@; ++~prompt)
{
 ~mark
}
" dmacro-indent "interactive for statment (prompts for variable name)")
 ("dot-h" "~(dmacro masthead t)~(dmacro hifndef)" dmacro-expand "comment block for the top of a .h file")
 ("fori" "for (i = 0; i < ~@; ++i)
{
 ~mark
}
" dmacro-indent "for statement (increments variable i)")
 ("iifed" "#ifdef ~(prompt constant \"#ifdef condition: \")
~@
#else
 ~(mark)
#endif /* ~(prompt) */
" dmacro-expand "#ifdef/#else/#endif (prompts for condition)")
 ("for" "for (~@; ; )
{
 ~mark
}
" dmacro-indent "for statment")
 ("i" "#include <~@.h>
" dmacro-expand "simple #include directive")
 ("hifndef" "#ifndef ~((file-name) :up)
#define ~((file-name) :up)

~@

#endif /* ~((file-name) :up) */" dmacro-expand "used by dot-h macro")
 ("func" "~(prompt type \"Function type: \") ~(prompt name \"Function name: \")(~@)
{
~mark
} /* ~(prompt name) */
" dmacro-indent "function definition (prompts for type and name)")
 ("case" "case ~@:

break;" dmacro-indent "case/break")
 ("d" "#define " dmacro-expand nil)
 ("masthead" "/* Copyright (c) ~(year) by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     ~(file-name)
   PURPOSE
     ~point
   NOTES
     ~mark
   HISTORY
~(dmacro history)Created.
***/

" dmacro-expand "commment block for the top of a .c file")
 ("iifd" "#ifdef ~(prompt constant \"#ifdef condition: \")
~@
#endif /* ~(prompt) */
" dmacro-expand "#ifdef/#endif (prompts for condition)")
))

(add-dmacros 'text-mode-abbrev-table '(
))

(add-dmacros 'lisp-mode-abbrev-table '(
 ("junk" "testing testing
" dmacro-expand "a test")
))

(add-dmacros 'fundamental-mode-abbrev-table '(
))

(add-dmacros 'global-abbrev-table '(
 ("dtstamp" " -~((user-initials) :down)~dn/~dd/~dy ~((hour) :pad nil):~min~ampm." dmacro-expand "user id, date and time")
 ("dstamp" " -~((user-initials) :down)~dn/~dd/~dy." dmacro-expand "user id and date")
))

