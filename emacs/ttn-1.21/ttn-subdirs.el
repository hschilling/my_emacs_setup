;;; ID: ttn-subdirs.el,v 1.38 1998/09/27 07:50:26 ttn Exp
;;;


(setq ttn-subdirs '("." "./lisp" "./lisp/ahm" "./lisp/import" "./lisp/import/pixmaps" "./lisp/low-stress" "./lisp/test" "./lisp/prog-env" "./doc"))

(mapc
 (progsa (dir)
   (pushnew (expand-file-name dir ttn-elisp-home)
	    load-path
	    :test #'string=))
 ttn-subdirs)


;;; ttn-subdirs.el,v1.38 ends here