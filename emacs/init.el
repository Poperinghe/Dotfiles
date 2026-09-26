;; -*- lexical-binding: t; -*-

;; SYSTEM
(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves")))
(setq custom-file "~/.emacs.d/custom.el") (load-file custom-file)
(setq gc-cons-threshold (* 500 1024 1024)) ; GC runs after 500 MB

;; PACKAGE MANAGER
(require 'package)
(require 'use-package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(setq use-package-always-ensure t)

;; EVIL
(use-package evil
  :diminish :ensure t :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :config (evil-collection-init))

(setq mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq scroll-conservatively 101
      scroll-margin 1)

(setq default-frame-alist
      '((ns-transparent-titlebar . t)
        (vertical-scroll-bars . nil)))
(setq frame-title-format "")

(fringe-mode 5)
(tab-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default truncate-lines t)
(setq ring-bell-function 'ignore)
(setq default-frame-alist '((ns-transparent-titlebar . t)))
(set-face-attribute 'default nil :height 150)
(setq display-line-numbers-type 'relative)

(use-package doom-themes
  :config (load-theme 'doom-plain-dark))

(use-package mood-line
  :config (mood-line-mode t))

(setq global-auto-revert-mode t)

(use-package magit)
(use-package vterm)
(use-package vterm-toggle)

;; KEYBINDINGS
(use-package general)

(general-def
 :keymaps 'override :states '(normal insert visual motion emacs)

 "M-q"   'kill-current-buffer
 "M-w"   'delete-window
 "M-RET" '(lambda () (interactive) (select-window (split-window-right)))
 "M-;"   '(lambda () (interactive) (select-window (split-window-below)))
 "C-k"   '(lambda () (interactive) (scroll-down-command 5))
 "C-j"   '(lambda () (interactive) (scroll-up-command   5))
 "M-n"   '(lambda () (interactive)) ;; TODO multiple cursors
 
 "M-u"   'buffer-menu               ;; frequently used modes
 "M-i"   'vterm-toggle-cd
 "M-o"   'dired-jump
 "M-p"   'magit
 
 "M-h"   'windmove-left             ;; window movement
 "M-j"   'windmove-down
 "M-k"   'windmove-up
 "M-l"   'windmove-right)

(general-def
  :keymaps 'override :states '(normal) :prefix "SPC"
  "l"     'display-line-numbers-mode
  "ff"    'find-file
  "fs"    'scratch-buffer
  "fi"    '(lambda () (interactive) (find-file (concat user-emacs-directory "init.el"))))

(evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
(evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)
(evil-define-key nil company-active-map (kbd "<tab>") 'company-complete-selection)

(setq global-auto-revert-non-file-buffers t)
(add-hook 'dired-mode-hook #'auto-revert-mode)
(setq dired-listing-switches "-alp")

(use-package magit :config
  (setq magit-display-buffer-function
	'magit-display-buffer-same-window-except-diff-v1))


(with-eval-after-load 'evil
  (evil-set-initial-state 'vterm-mode 'emacs))
