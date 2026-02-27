
;; SYSTEM
(setq custom-file "~/.emacs.d/custom.el")

(load-file custom-file)
(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves")))

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

;; APPEARANCE
(fringe-mode 5)
(tab-bar-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell t)
(setq-default truncate-lines t)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq scroll-step 1 scroll-margin 1 scroll-conservatively 101)

(use-package doric-themes
  :config (load-theme 'doric-obsidian))

;; FILE MANAGEMENT
(setq global-auto-revert-non-file-buffers t)
(add-hook 'dired-mode-hook #'auto-revert-mode)
(setq dired-listing-switches "-alh --group-directories-first")

(use-package quick-dired :ensure nil
  :load-path "~/.emacs.d/user-lisp/")

(defun quick-eshell ()
  (interactive)
  (let ((buf (generate-new-buffer "*eshell*")))
    (with-current-buffer buf (eshell-mode))
    (select-window (display-buffer-in-side-window buf '((side . bottom) (slot . 0) (dedicated . t))))))

;; COMPLETION
(use-package company :diminish
  :hook (prog-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

;; KEYBINDINGS
(use-package evil
  :diminish :ensure t :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :config (evil-collection-init))

(defun set-my-key (kbstr action) (evil-global-set-key 'normal (kbd kbstr) action))

(set-my-key "M-q"   'kill-buffer)
(set-my-key "M-w"   'delete-window)
(set-my-key "M-RET" '(lambda () (interactive) (select-window (split-window-right))))
(set-my-key "M-;"   '(lambda () (interactive) (select-window (split-window-below))))
(set-my-key "M-h"   'windmove-left)
(set-my-key "M-j"   'windmove-down)
(set-my-key "M-k"   'windmove-up)
(set-my-key "M-l"   'windmove-right)
(set-my-key "C-k"   '(lambda () (interactive) (scroll-down-command 5)))
(set-my-key "C-j"   '(lambda () (interactive) (scroll-up-command   5)))
(set-my-key "M-o"   'quick-dired)
(set-my-key "M-i"   'eval-buffer)
(set-my-key "M-n"   'next-buffer)
(set-my-key "M-m"   'quick-eshell)
(set-my-key "C-c C-c" 'compile)

(evil-set-leader 'normal (kbd "SPC"))
(set-my-key "<leader>SPC" 'execute-extended-command)
(set-my-key "<leader>ff"  'find-file)
(set-my-key "<leader>fi"  '(lambda () (interactive) (find-file "~/.emacs")))
(set-my-key "<leader>fs"  'scratch-buffer)
(set-my-key "<leader>u"   'buffer-menu)

(evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
(evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)

(evil-define-key nil company-active-map (kbd "<tab>") 'company-complete-selection)

;; C LANGUAGE
(setq c-default-style '((c-mode . "awk")))
(setq lsp-clangd-binary-path "/run/current-system/sw/bin/clangd")

