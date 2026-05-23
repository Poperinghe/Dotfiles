
;; SYSTEM
(setq backup-directory-alist `(("." . "~/.emacs.d/autosaves")))
(setq custom-file "~/.emacs.d/custom.el") (load-file custom-file)

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

;; CORE TOOLS
(use-package ibuffer)

(defun eshell-jump () (interactive)
    (let ((dir default-directory))
      (eshell) (insert (concat "cd " dir)) (eshell-send-input)))
(evil-set-initial-state 'eshell-mode 'emacs)

(setq global-auto-revert-non-file-buffers t)
(add-hook 'dired-mode-hook #'auto-revert-mode)
(setq dired-listing-switches "-alh --group-directories-first")

(use-package magit :config
  (setq magit-display-buffer-function
	'magit-display-buffer-same-window-except-diff-v1))

;; COMPLETION
(use-package company :diminish
  :hook (prog-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

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
 "C-t"   'tab-bar-new-tab
 "C-w"   'tab-bar-close-tab
 "M-n"   '(lambda () (interactive)) ;; TODO multiple cursors
 
 "M-u"   'buffer-menu               ;; frequently used modes
 "M-i"   'eshell-jump
 "M-o"   'dired-jump
 "M-p"   'magit
 
 "M-h"   'windmove-left             ;; window movement
 "M-j"   'windmove-down
 "M-k"   'windmove-up
 "M-l"   'windmove-right)

(general-def
  :keymaps 'override :states '(normal) :prefix "SPC"

  "ff"    'find-file
  "fs"    'scratch-buffer
  "fn"    '(lambda () (interactive) (find-file "~/notebook.org"))
  "fi"    '(lambda () (interactive) (find-file (concat user-emacs-directory "init.el"))))

(setq scroll-step 1 scroll-margin 1 scroll-conservatively 101)
(evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
(evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)
(evil-define-key nil company-active-map (kbd "<tab>") 'company-complete-selection)

;; MODULES
(setq ul-dir (concat user-emacs-directory "user-lisp/"))
(load-file (concat ul-dir "appearance.el"))
(load-file (concat ul-dir "org.el"))
;; (load-file (concat ul-dir "mail.el")) TODO
;; (load-file (concat ul-dir "irc.el"))  TODO
(load-file (concat ul-dir "langs/c.el"))
