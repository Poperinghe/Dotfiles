
(fringe-mode 5)
(tab-bar-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell t)
(setq-default truncate-lines t)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package doric-themes
  :config (load-theme 'doric-obsidian))
