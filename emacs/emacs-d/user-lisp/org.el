
(general-def
  :keymaps 'org-mode-map :states '(normal visual insert motion emacs)
  ;; RESERVED FOR MAJOR MODE SPECIFIC INTERACTIONS
  "M-m"   'org-todo
  "M-,"   '(lambda () (interactive))
  "M-."   '(lambda () (interactive))
  "M-/"   '(lambda () (interactive)))
