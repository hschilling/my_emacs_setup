;; Example code for adding new tags to html-helper-mode.el.
;; This code must be called *after* html-helper-mode loads. It can be
;; run nicely from the html-helper-load-hook.


;; First, let's add new tags to an existing map:
;; I've always liked the ae ligature (note - keybinding is global)
(html-helper-add-tag
 '(entity "\C-c!" "&aelig;" "AE Ligature" ("&aelig;")))
;; A somewhat useful extension supported by some browsers
;; (keybinding is in the map for type phys):
(html-helper-add-tag
 '(phys "c" "<center>" "Center" ("<center>" (r "Text:") "</center>")))


;; Now let's deliberately clobber an existing binding, just to show
;; it can be done. Use this if you like <p></p> containers.
;; Note that there's no completion string.
(html-helper-add-tag
  '(textel "\e\C-m"  nil "Paragraph" ("<p>\n</p>\n")))


;; Now let's try a whole new tag type! C-c C-q is the prefix binding.
;; first, make html-helper-mode aware of the new type:
(html-helper-add-type-to-alist
 '(sell-hhm . (my-special-sell-hhm-map "\C-c\C-q" my-special-sell-hhm-menu "Sell Hhm!")))
;; now let's install the type into the keymap and menu:
(html-helper-install-type 'sell-hhm)
;; finally, we need some tags:
(html-helper-add-tag
 '(sell-hhm "z" "" "My Message" ("html helper is great!")))
(html-helper-add-tag
 '(sell-hhm "q" "" "My Home Page"
	    ("See <a href=\"http://www.santafe.edu/~nelson/\">the beautiful author</a>")))


;; now rebuild the menu so all my new tags show up.
(html-helper-rebuild-menu)
