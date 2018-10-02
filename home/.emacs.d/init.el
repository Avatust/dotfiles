(setq user-full-name "Martin Roznovjak")
(setq user-mail-address "martin.roznovjak@gmail.com")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit evil-leader evil-surround evil-indent-plus evil-commentary evil-matchit evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)

(setq-default highlight-tabs t)
(setq-default show-trailing-whitespace t)
(setq completion-cycle-threshold 4)
(setq completion-styles '(basic partial-completion emacs22 initials))

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))



;; APPEARANCE
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode -1)
(load-theme 'misterioso t)



;; PACKAGES

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)


(use-package evil
  :config (evil-mode 1)

  (use-package evil-matchit
    :config (global-evil-matchit-mode 1))

  (use-package evil-commentary
    :config (evil-commentary-mode))

  (use-package evil-indent-plus
    :config (evil-indent-plus-default-bindings))

  (use-package evil-surround
    :config (global-evil-surround-mode))

  (use-package evil-leader
    :config (global-evil-leader-mode))
)

(use-package magit
  :bind ("C-x g" . magit-status))


;; MISC

(defun find-user-init-file ()
  "Edit the `user-init-file'"
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c i") 'find-user-init-file)

(global-set-key (kbd "C-c e") 'eval-buffer)
