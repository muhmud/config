
; Add the libs folder to the load path

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq byte-compile-warnings nil)
(package-initialize)

(add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t)

(add-to-list 'load-path "~/.emacs.d/my")

; Load files for stuff I want
(load "my-el-get.el")
(load "my-evil.el")

(load "my-buffer-stack.el")
(load "my-edit.el")
(load "my-file.el")
(load "my-irc.el")

(load "my-sql.el")
(load "my-js.el")

(load "my-slack.el")

; Functions to load different SQL environments
(defun my-mssql-setter (switch)
  (load "sql/my-ms-sql.el"))

(defun my-pgsql-setter (switch)
  (load "sql/my-pg-sql.el"))

; Control which SQL environment is loaded using command line arguments
(add-to-list 'command-switch-alist '("-mssql" . my-mssql-setter))
(add-to-list 'command-switch-alist '("-pgsql" . my-pgsql-setter))

; Default to postgresql
(load "sql/my-pg-sql.el")

(load "my-cpp.el")

; Custom themes directory
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

; Theme
(color-theme-ld-dark)

; Neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

; Undo handling
(require 'undo-tree)
(global-undo-tree-mode 1)

(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-y") 'redo)

(setq initial-major-mode (quote text-mode))

; Company
; Use company-irony
(require 'company-irony)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "C-@") 'company-complete)

; Expand Region
(require 'expand-region)
(global-set-key (kbd "C-e") 'er/expand-region)

; Projectile
(require 'projectile)
(projectile-global-mode)

; Truncate long lines
(toggle-truncate-lines 1)

; Highlight brackets
(show-paren-mode 1)

; Enable CUA
(require 'xclip)
(cua-mode t)
(setq cua-keep-region-after-copy t)
(transient-mark-mode 1)

; Make sure org mode doesn't mess with shift select
(setq org-support-shift-select t)
(eval-after-load "org"
    '(progn
       (eval-after-load "cua-base"
         '(progn            
            (defadvice org-call-for-shift-select (before org-call-for-shift-select-cua activate)
              (if (and cua-mode
                       org-support-shift-select
                       (not (use-region-p)))
                  (cua-set-mark)))))))

; Make scrolling smooth
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

; Get rid of menu bar
(menu-bar-mode -1)

; Put line numbers in always
(global-linum-mode 1)
(setq linum-format "%d ")

; Don't make backup files
(setq auto-save-default nil)
(setq make-backup-files nil)

; Show the current column in the mode line
(column-number-mode 1)

; Enable the mouse
(xterm-mouse-mode)

; Right click to paste
(global-set-key (kbd "<mouse-3>") (lambda () (interactive) (clipboard-yank)))

; Use mouse wheel for scrolling through the buffer
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-line 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-line 3)))

; Make mouse region select work properly
(global-set-key [drag-mouse-0] 'mouse-set-region)

; Enable ibuffer
(ibuffer)
(ibuffer-auto-mode)
(global-set-key "\M-w" 'ibuffer)

; No electric indent
(electric-indent-mode -1)

; No electric indent for RET and ()
;(setq electric-indent-chars (remq ?\n electric-indent-chars))
;(setq electric-indent-chars (remq ?( electric-indent-chars))
;(setq electric-indent-chars (remq ?) electric-indent-chars))

; Show the date & time in the mode line
(setq display-time-day-and-date t display-time-24hr-format t)
(display-time)

; Tab options
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq html-indent-offset 2)
(setq css-indent-offset 2)
(setq js-indent-level 2)
(setq tab-always-indent t)

; Creates a new empty buffer
(defun xah-new-empty-buffer ()
  "Open a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

; Removes *messages* from the buffer.
;(setq-default message-log-max nil)
;(kill-buffer "*Messages*")

; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
          '(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                                    (kill-buffer buffer)))))

; Save search history
(setq savehist-additional-variables '(search-ring regexp-search-ring)
      savehist-file "~/.emacs.d/savehist")
(savehist-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-enable-flex-matching t)
 '(ido-enable-regexp t)
 '(ido-mode (quote both) nil (ido))
 '(package-selected-packages (quote (slack oauth2)))
 '(safe-local-variable-values
   (quote
    ((cmake-ide-build-dir . my-project-path)
     (cmake-ide-build-dir concat my-project-path "build/debug")
     (eval setq cmake-ide-build-dir
           (concat my-project-path "build/debug"))
     (cmake-ide-project-dir . my-project-path)
     (eval set
           (make-local-variable
            (quote my-project-path))
           (file-name-directory
            (let
                ((d
                  (dir-locals-find-file ".")))
              (if
                  (stringp d)
                  d
                (car d)))))
     (cmake-ide-build-dir . build/debug)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Load keys
(load "my-keymap.el")
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
