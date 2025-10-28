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
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; EVIL MODE
;; ---------

(use-package evil
  :diminish :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; WINDOW MANAGEMENT
;; -----------------

(setq inhibit-startup-message t)
(tab-bar-mode 1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(setq global-display-line-numbers-mode 1)
(setq scroll-step 1 scroll-margin 1)
(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves")))
(setq-default truncate-lines t)

(setq global-auto-revert-non-file-buffers t)
(add-hook 'dired-mode-hook #'auto-revert-mode)
(setq dired-listing-switches "-alh --group-directories-first")

;; sync emacs env with shell env
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package ibuffer)

(dotimes (_ 3)
  (tab-bar-new-tab))

;; KEYBINDS WITH GENERAL
;; ---------------------

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer poperinghe/leader-key-map
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC"))

(use-package ivy
  :diminish
  :config (ivy-mode 1))

(use-package counsel)

(general-define-key
 :keymaps 'evil-normal-state-map
 "/" 'swiper)

(general-define-key
 :keymaps 'ivy-minibuffer-map
 "C-j" 'ivy-next-line
 "C-k" 'ivy-previous-line)

(general-define-key
 :keymaps 'ibuffer-mode-map
 :states '(normal)
 "l" 'ibuffer-visit-buffer)

(general-define-key
 :keymaps 'dired-mode-map
 :states '(normal)
 "h" 'dired-up-directory
 "l" 'dired-find-file)

(general-define-key
 :keymaps 'override
 :states '(normal visual insert emacs)
 "M-Q" 'delete-window
 "M-q" 'kill-buffer
 "M-RET" '(lambda () (interactive) (select-window (split-window-right)))
 "M-;" '(lambda () (interactive) (select-window (split-window-below)))
 "M-1" '(lambda () (interactive) (tab-bar-select-tab 1))
 "M-2" '(lambda () (interactive) (tab-bar-select-tab 2))
 "M-3" '(lambda () (interactive) (tab-bar-select-tab 3))
 "M-4" '(lambda () (interactive) (tab-bar-select-tab 4))
 "C-u" '(lambda () (interactive) (scroll-down-command 5))
 "C-d" '(lambda () (interactive) (scroll-up-command 5))
 "M-h" 'windmove-left
 "M-j" 'windmove-down
 "M-k" 'windmove-up
 "M-l" 'windmove-right)

(poperinghe/leader-key-map
  ;; FIND KEYBINDINGS ;;
  "f" '(:ignore t :which-key "find")
  "ff" '(find-file :which-key "find file")
  "fi" '((lambda () (interactive)(find-file "~/.emacs")) :which-key "find emacs-config")
  "fs" '(scratch-buffer :which-key "find scratch buffer")

  ;; EVAL/EXECUTE KEYBINDINGS ;;
  "e" '(:ignore t :which-key "eval/execute")
  "eb" '(eval-buffer t :which-key "eval buffer")
  "ej" '(execute-extended-command :which-key "m-x")

  ;; BUFFER NAVIGATION KEYBINDINGS ;;
  "u" '(ibuffer :which-key "buffers")
)



;; ------------------------------------------------------------------
;;                     IDE SETTINGS BEYOND THIS POINT
;; ------------------------------------------------------------------



(use-package doom-modeline
  :config (doom-modeline-mode 1))

;;(use-package doom-themes
  ;;:config (load-theme 'doom-horizon))

(use-package kaolin-themes
  :config (load-theme 'kaolin-dark))
  ;;:config (load-theme 'kaolin-galaxy))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package magit)
(use-package projectile
  :init (setq projectile-project-search-path '("~/Files/"))
  :config (projectile-mode +1))
(use-package counsel-projectile)

(use-package lsp-mode
  :config
  (setq lsp-completion-show-kind nil)
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-format-buffer-on-save-list '(c-mode c++-mode))
  (setq lsp-format-buffer-on-save t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions))

(use-package flycheck)
(use-package flycheck-pos-tip
  :hook (lsp-mode . flycheck-pos-tip-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (setq company-tooltip-align-annotations t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

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

(defun poperinghe/magit-log-all-graph ()
  "Show Magit log with --graph --decorate --all."
  (interactive)
  (magit-log '("HEAD") '("--graph" "--decorate" "--all")))

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

  ;; PROJECTILE KEYBINDINGS ;;
  "p" '(:ignore t :which-key "projectile")
  "pg" '(projectile-grep :which-key "projectile grep")
  "ps" '(projectile-switch-project :which-key "projectile switch (switch project)")
  "pf" '(projectile-find-file :which-key "projectile find")

  ;; MAGIT KEYBINDINGS ;;
  "g" '(:ignore t :which-key "git (magit)")
  "gs" '(magit :which-key "git status")
  "gl" '(poperinghe/magit-log-all-graph :which-key "git log")
  )

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5291b60ee27dfc12078f787929498ce82efe5e4d42decdbb994be80cdb2def1f"
     "4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7"
     "3538194fff1b928df280dc08f041518a8d51ac3ff704c5e46d1517f5c4d8a0e0"
     default))
 '(package-selected-packages
   '(company counsel-projectile doom-modeline doom-themes evil-collection
	     exec-path-from-shell flycheck-pos-tip general
	     kaolin-themes lsp-ivy lsp-ui magit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
