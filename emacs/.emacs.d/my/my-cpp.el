; rtags
(require 'rtags)

; irony
(require 'irony)
(require 'company-irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook #'global-flycheck-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c-mode-hook #'global-flycheck-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map "\C-@"
    'company-complete))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

; flycheck-irony
(eval-after-load 'flycheck
  '(progn
     (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
     (set-face-attribute 'flycheck-error nil :foreground "black" :background "red")
     (set-face-attribute 'flycheck-warning nil :foreground "black" :background "yellow")
     (set-face-attribute 'flycheck-info nil :foreground "black" :background "green")))

; Key bindings
(add-hook 'c++-mode-hook (lambda () (interactive)
                           (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)))

; Debugging
(setq
 ; use gdb-many-windows by default
 gdb-many-windows t

 ; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
)

(cmake-ide-setup)
