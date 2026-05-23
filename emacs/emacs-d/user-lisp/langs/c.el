
;; C LANGUAGE
(setq c-default-style '((c-mode . "awk")))
(setq lsp-clangd-binary-path "/run/current-system/sw/bin/clangd")

(general-def
  :keymaps 'c-mode-map :states '(normal visual insert motion emacs)
  ;; RESERVED FOR MAJOR MODE SPECIFIC INTERACTIONS
  "M-m"   'lsp-find-definition
  "M-,"   'lsp-find-references
  "M-."   '(lambda () (interactive))
  "M-/"   '(lambda () (interactive)))
