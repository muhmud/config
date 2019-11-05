(load "my-edit.el")
(load "my-buffer-stack.el")
(load "my-file.el")
(load "my-sql.el")

; Default to postgresql
(load "sql/my-pg-sql.el")

(load "my-keys.el")

(require 'xclip)
(define-globalized-minor-mode global-xclip-mode xclip-mode xclip-mode)
(global-xclip-mode 1)

(cua-mode t)
(transient-mark-mode 1)
(delete-selection-mode t)
(setq cua-keep-region-after-copy t)

(setq auto-save-default nil)
(setq make-backup-files nil)

(unless (display-graphic-p)
  (setq linum-format (concat linum-format " ")))
