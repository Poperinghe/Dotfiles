;;
;; poperinghe's emacs configuration
;; https://github.com/Poperinghe/Dotfiles.git
;;         __
;;        / /__ _ __ ___   __ _  ___ ___
;;  /\/| / / _ \ '_ ` _ \ / _` |/ __/ __|
;; |/\/ / /  __/ | | | | | (_| | (__\__ \
;;     /_(_)___|_| |_| |_|\__,_|\___|___/

;; PACKAGE MANAGEMENT
;; ------------------

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

;; EVIL MODE
;; ---------

(use-package evil
  :diminish :ensure t :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))


;; WINDOW, BUFFER & FILE MANAGEMENT
;; --------------------------------

(tab-bar-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell t)
(setq-default truncate-lines t)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq scroll-step 1 scroll-margin 1 scroll-conservatively 101)

(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves")))

(setq global-auto-revert-non-file-buffers t)
  (add-hook 'dired-mode-hook #'auto-revert-mode)
  (setq dired-listing-switches "-alh --group-directories-first")

(use-package ibuffer
  :commands (ibuffer)
  :hook
  (ibuffer-mode
   . (lambda ()
       (setq ibuffer-filter-groups
  	     '(("Dired" (mode . dired-mode))
  	       ("C"     (derived-mode . c-mode))
  	       ("Magit" (derived-mode . magit-mode))
  	       ("Org"   (mode . org-mode))))
       (setq ibuffer-show-empty-filter-groups nil)
       (ibuffer-update nil t))))

(use-package avy)

;; MISCELLANEOUS
;; -------------

(use-package doric-themes
  :init (setq custom-safe-themes t)
  :config (load-theme 'doric-obsidian))
(set-face-attribute 'default nil :family "Ubuntu Mono Nerd Font" :height 130)

(use-package counsel :defer t)

(use-package ivy :diminish :config (ivy-mode 1))

(use-package company :diminish
  :hook (prog-mode . company-mode)
  :config
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (setq company-tooltip-align-annotations t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

(use-package magit :defer t)

;;(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; KEYBINDS WITH GENERAL
;; ---------------------

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer poperinghe/leader-key-map
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC"))

(general-define-key :keymaps 'evil-normal-state-map "/" 'swiper)

(general-define-key
 :keymaps 'ivy-minibuffer-map
 "C-j" 'ivy-next-line
 "C-k" 'ivy-previous-line)

(general-define-key
 :keymaps 'dired-mode-map
 :states '(normal)
 "h" 'dired-up-directory
 "l" 'dired-find-file)


(use-package quick-dired :ensure nil
  :load-path user-emacs-directory)

;;(use-package)

(general-define-key
 :keymaps 'override
 :states '(org normal visual insert emacs)
 "M-w" 'delete-window
 "M-q" 'kill-buffer
 "M-RET" '(lambda () (interactive) (select-window (split-window-right)))
 "M-;" '(lambda () (interactive) (select-window (split-window-below)))
 "M-1" '(lambda () (interactive) (tab-bar-select-tab 1))
 "M-2" '(lambda () (interactive) (tab-bar-select-tab 2))
 "M-3" '(lambda () (interactive) (tab-bar-select-tab 3))
 "M-4" '(lambda () (interactive) (tab-bar-select-tab 4))
 "C-k" '(lambda () (interactive) (scroll-down-command 5))
 "C-j" '(lambda () (interactive) (scroll-up-command 5))
 "M-i" 'eval-buffer
 "M-o" 'quick-dired
 "M-h" 'windmove-left
 "M-j" 'windmove-down
 "M-k" 'windmove-up
 "M-l" 'windmove-right)

(poperinghe/leader-key-map

  "SPC" '(execute-extended-command :which-key "m-x")

  ;; FIND KEYBINDINGS ;;
  "f" '(:ignore t)
  "ff" 'find-file
  "fi" '((lambda () (interactive)(find-file "~/.emacs")) :which-key "")
  "fs" 'scratch-buffer

  "j"  '(lambda () (interactive) (avy-goto-word-or-subword-1))

  ;; EXTENDED ROOT ;;
  "e" '(:ignore t :which-key "extend")
  "ej" '(eval-buffer t :which-key "eval buffer")
  "ek" '(:ignore t :which-key "eval buffer")
  "el" '(:ignore t :which-key "eval buffer")

  ;; BUFFER NAVIGATION KEYBINDINGS ;;
  "u" 'ibuffer

  ;; PROJECTILE KEYBINDINGS ;;
  "p" '(:ignore t)
  "pg" 'counsel-projectile-grep
  "ps" 'projectile-switch-project
  "pf" 'projectile-find-file

  ;; MAGIT KEYBINDINGS ;;
  "g" '(:ignore t)
  "gs" 'magit
)


;; ------------------------------------------------------------------
;;                     IDE SETTINGS BEYOND THIS POINT
;; ------------------------------------------------------------------


(use-package projectile :defer t
  :init (setq projectile-project-search-path '("~/Files/"))
  :config (projectile-mode +1))
(use-package counsel-projectile :defer t)

(use-package lsp-mode :defer t
  :config
  (setq lsp-completion-show-kind nil)
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-format-buffer-on-save-list '(c-mode c++-mode))
  (setq lsp-format-buffer-on-save t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(use-package flycheck :defer t)
(use-package flycheck-pos-tip
  :hook (lsp-mode . flycheck-pos-tip-mode))

(defun poperinghe/lsp-stop ()
  "Disconnect all clangd-related LSP workspaces for the current project and kill their processes."
  (interactive)
  (let ((lsp-keep-workspace-alive nil)
        (project-root (lsp-workspace-root)))
    (dolist (ws (lsp-workspaces))
      (when (string-prefix-p project-root (lsp--workspace-root ws))
        (lsp-workspace-shutdown ws)))
    (lsp-mode -1)
    (flycheck-mode -1)
    (message "Disconnected all clangd workspaces for project: %s" project-root)))

(defun poperinghe/man-page-at-point ()
  "open man page for the symbol at point."
  (interactive)
  (let ((sym (thing-at-point 'symbol t)))
    (when sym (man sym))))

(defun poperinghe/lsp-start-or-restart ()
  "starts the language server or restarts it if it is already active."
  (interactive)
  (if (bound-and-true-p lsp--cur-workspace)
      (lsp-restart-workspace)
    (lsp)))

(poperinghe/leader-key-map
  ;; LSP KEYBINDINGS ;;
  "l" '(:ignore t :which-key "lsp")
  "lp" '(:ignore t :which-key "lsp peek WIP")
  "ls" '(poperinghe/lsp-start-or-restart :which-key "lsp start or restart")
  "lk" '(poperinghe/lsp-stop :which-key "lsp kill")
  "lm" '(poperinghe/man-page-at-point :which-key "lsp man-page")
  "ln" '(flycheck-next-error :which-key "lsp next error")
  "lr" '(lsp-rename :which-key "lsp rename")
  "lf" '(:ignore t :which-key "lsp find")
  "lfd" '(lsp-find-definition :which-key "lsp find definition")
  "lfr" '(lsp-find-references :which-key "lsp find references")
  )

;; (add-hook 'lsp-after-apply-edits-hook (lambda (&rest _) (save-some-buffers t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(avy company counsel-projectile doric-themes evil-collection
	 flycheck-pos-tip general lsp-ivy lsp-ui magit nix-mode
	 sudo-edit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
