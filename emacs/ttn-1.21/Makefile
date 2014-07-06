# ID: Makefile,v 1.14 1998/09/11 19:14:41 ttn Exp

# Copyright (C) 1998 Thien-Thi Nguyen
# This file is part of ttn's personal elisp library, released under GNU
# GPL with ABSOLUTELY NO WARRANTY.  See the file COPYING for details.

dd = ttn-`cat VERSION`
extradist = AUTHORS COPYING NEWS VERSION \
		$(wildcard lisp/import/*.elc) \
		lisp/customized-state.el \
		lisp/bookmarks.bmk
dirlist-cmd = find . -type d -a -path '*/RCS' -prune -o -type d -print

# Make ttn-VERSION directory w/ everything "co -kv".
# Copy extradist files into thud-VERSION .
# Lastly, tgz and put in cwd.
#
dist: subdirs-file autoload-file readme-files
	rm -rf $(dd) $(dd).tar.gz
	mkdir $(dd)
	for d in `$(dirlist-cmd)` ; do			\
	  mkdir -p $(dd)/$$d ;				\
	  ln -s `pwd`/$$d/RCS $(dd)/$$d/RCS ;		\
	  (cd $(dd)/$$d ; for f in RCS/*,v ; do		\
	                    test -f $$f || continue ;	\
	                    g=`basename $$f ,v` ;	\
	                    co -kv $$g ;		\
	                  done) ;			\
	  rm $(dd)/$$d/RCS ;				\
	done
	for f in $(extradist) ; do cp -p $$f $(dd)/$$f ; done
	rmdir $(dd)/$(dd)
	GZIP=--best tar czf $(dd).tar.gz $(dd)
	rm -rf $(dd)

# Use emacs to do the work.
emacs_ttn_make = emacs -batch -l ttn.el -f ttn-make-# no spaces aloud :->

autoload-file subdirs-file readme-files:
	$(emacs_ttn_make)$@

snapshot:
	d=`date +"%Y%m%d"` ; cd .. ; \
	tar cf - ttn | gzip --best > ttn-$$d.tar.gz

# Makefile,v1.14 ends here
