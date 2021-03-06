7
; Add the libs folder to the load path
(add-to-list 'load-path "~/.emacs.d/my")

; Load files for stuff I want
(load "my-el-get.el")
(load "my-buffer-stack.el")
(load "my-edit.el")
(load "my-file.el")
(load "my-keymap.el")
(load "my-irc.el")

(load "my-sql.el")
(load "sql/my-pg-sql.el")

(load "my-cpp.el")

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

; Truncate long lines
(toggle-truncate-lines 1)

; Highlight brackets
(show-paren-mode 1)

; Enable CUA
(require 'xclip)
(cua-mode t)
(setq cua-keep-region-after-copy t)
(transient-mark-mode 1)

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

; Use mouse wheel for scrolling through the buffer
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-line 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-line 3)))

; Make mouse region select work properly
(global-set-key [drag-mouse-0] 'mouse-set-region)

; Enable ibuffer
(ibuffer)
(ibuffer-auto-mode)

(global-set-key "\M-w" 'ibuffer)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-enable-flex-matching t)
 '(ido-enable-regexp t)
 '(ido-mode (quote both) nil (ido)))

