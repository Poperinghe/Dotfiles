;;
;; clement.pochart and matthiru's
;;         __
;;        / /__ _ __ ___   __ _  ___ ___
;;  /\/| / / _ \ '_ ` _ \ / _` |/ __/ __|
;; |/\/ / /  __/ | | | | | (_| | (__\__ \
;;     /_(_)___|_| |_| |_|\__,_|\___|___/


;; SENSIBLE DEFAULTS
;; -----------------

(setq inhibit-startup-message t)                                ; no startup message
(scroll-bar-mode -1)                                            ; disable the visible scrollbar
(menu-bar-mode -1)                                              ; disable the menu-bar
(tool-bar-mode -1)                                              ; disable the toolbar
(tooltip-mode -1)                                               ; disable the tooltips
(set-fringe-mode 5)                                             ; adds some margins
(setq visible-bell t)                                           ; Visually show errors instead of beeping
(setq gc-cons-threshold 50000000)                               ; Reduces the freq. of garbage collection
(setq display-line-numbers-type 'relative)                      ; Changes line numbers to relative mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)           ; Displays line numbers
(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves"))) ; Prevents autosave file clutter
(setq scroll-step 1 scroll-margin 1)                            ; Scroll one line at a time


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
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(when (bound-and-true-p evil-mode)
  (define-key evil-normal-state-map (kbd "/") 'swiper))

(use-package avy)

;; FONT AND THEME
;; --------------

;; (set-face-attribute 'default nil :font "Mononoki Nerd Font Mono")
(set-face-attribute 'default nil :height 140)
(set-frame-parameter nil 'alpha-background 60)
(add-to-list 'default-frame-alist '(alpha-background . 60))

(use-package kaolin-themes
  :config (load-theme 'kaolin-dark t))


;; MINIBUFFER ENHANCEMENTS
;; -----------------------

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel)


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode)


;; CODE FORMATTING
;; ---------------

(setq c-default-style '((c-mode . "awk") ;; default style close from
                        (c++-mode . "awk") ;; the coding style
                        (java-mode . "java") ;; the coding style
                        (other . "awk")))

;; DIRED
;; -----

(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file
    " " 'nil))

(use-package magit)

;; PROJECTILE
;; ----------

(use-package projectile
  :init
  (setq projectile-project-search-path '("~/Files/"))
  :config
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package counsel-projectile
 :after projectile
 :config (counsel-projectile-mode 1))


;; LSP 
;; ---

(use-package lsp-mode
  :hook (java-mode . lsp-mode))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package flycheck)
(use-package flycheck-pos-tip
  :hook (lsp-mode . flycheck-pos-tip-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)


;; GENERAL AND HYDRA
;; -----------------

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer rune/leader-keys
    :keymaps '(normal visual emacs)
    :prefix "SPC"))


(rune/leader-keys
  "k"  '(:ignore t :which-key "orgmode")
  "kk"  '(org-todo :which-key "org-todo-cycle")
  "ko"  '(org-open-at-point :which-key "org-open-link"))

(rune/leader-keys
  "d"  '((lambda () (interactive) (dired default-directory)) :which-key "dired"))

(rune/leader-keys
  "g" '(magit :which-key "magit"))

(rune/leader-keys
  "e"  '(:ignore t :which-key "execute")
  "ej" '(counsel-M-x :which-key "M-x"))

(rune/leader-keys
  "t"  '(:ignore t :which-key "toggles")
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "ta" '(hydra-all-switch-theme/body :which-key "toggle ALL themes")
  "tt" '(hydra-switch-theme/body :which-key "toggle favorite theme"))

(rune/leader-keys
  "f"  '(:ignore t :which-key "find")
  "ff" '(find-file :which-key "find file")
  "fs" '(save-buffer :which-key "file save")
  "fh" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "scratch")
  "fi" '((lambda() (interactive)(find-file "~/.emacs")) :which-key "~/.emacs"))

(rune/leader-keys
  "j"  '(:ignore t :which-key "jump")
  "jl"  '(avy-goto-line :which-key "avy go to line")
  "ja"  '(avy-goto-word-1 :which-key "avy go to word 1"))

(rune/leader-keys
  "b"  '(:ignore t :which-key "buffer")
  "by" '(copy-whole-buffer :which-key "yank buffer")
  "bl" '(ibuffer :which-key "buffer list")
  "be" '(eval-buffer :which-key "eval buffer")
  "bj" '(next-buffer :which-key "next")
  "bd" '(kill-this-buffer :which-key "kill buffer")
  "bk" '(previous-buffer :which-key "previous"))

(rune/leader-keys
  "p"  '(:ignore t :which-key "projectile")
  "pp" '(projectile-switch-project :which-key "switch project")
  "pa" '(projectile-find-other-file :which-key "find other file")
  "pg" '(counsel-projectile-grep :which-key "grep")
  "pd" '(projectile-discover-projects-in-search-path :which-key "discover projects")
  "pf" '(projectile-find-file :which-key "find file in project"))

(rune/leader-keys
  "l"  '(:ignore t :which-key "lsp")
  "lr" '(lsp-rename :which-key "rename")
  "ls" '(lsp-workspace-restart :which-key "restart lsp")
  "la" '(lsp-execute-code-action :which-key "code action")
  "ln" '(flycheck-next-error :which-key "next error")
  "lm" '(:ignore t :which-key "maven")
  "lma" '(maven-test-all t :which-key "run all tests")
  "ld" '(:ignore r :which-key "doc")
  "lds" '(lsp-ui-doc-show :which-key "doc show")
  "ldh" '(lsp-ui-doc-hide :which-key "doc hide"))


(rune/leader-keys
  "w"  '(:ignore t :which-key "windows")
  "wv" '(split-window-horizontally :which-key "split window vertically")
  "wh" '(split-window-vertically :which-key "split window horizontally")
  "wt" '(toggle-transparency :which-key "split window horizontally")
  "wd" '(delete-window :which-keh "close current window"))










(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9d5a33a0097c43f44759530c846e1adf9c40171f232a4b2ae561feccc99a03c4"
     "5291b60ee27dfc12078f787929498ce82efe5e4d42decdbb994be80cdb2def1f"
     "c341518f5a80752f3113699a7f845dfc7299667311858e7cdfe64677d359d87e"
     "5beb9cc517b24959e2ee7be47584270bbe11a7b210807fa419d41ede12174a26"
     "ca2ce81d33e0b4bd0fdf20caefdde9cb617fec42eeeaf5cd79c80d630bd5cf6a"
     default))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
