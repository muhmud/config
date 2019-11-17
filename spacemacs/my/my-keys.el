(define-key evil-insert-state-map (kbd "C-z") 'undo-tree-undo)
(define-key evil-insert-state-map (kbd "C-y") 'undo-tree-redo)
(define-key evil-motion-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-c") nil)
(define-key evil-insert-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-x") nil)
(define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map (kbd "C-a") 'select-whole-buffer)
(define-key evil-insert-state-map "\e[6;5!" 'evil-delete-backward-word) ; Ctrl+Backspace
(define-key evil-normal-state-map (kbd "RET") 'custom-normal-newline)
(define-key evil-insert-state-map (kbd "RET") 'custom-newline)
(define-key evil-normal-state-map (kbd "DEL") 'backward-delete-char-untabify)
(define-key evil-insert-state-map (kbd "TAB") 'indent-block)
(define-key evil-insert-state-map [(backtab)] 'unindent-block)
(define-key evil-insert-state-map (kbd "C-SPC") 'company-complete)
(define-key evil-insert-state-map (kbd "C-@") 'company-complete)
(define-key evil-normal-state-map (kbd "C-SPC") 'evil-append)
(define-key evil-normal-state-map (kbd "C-@") 'evil-append)
(define-key evil-motion-state-map (kbd "M-<left>") 'evil-jump-backward)
(define-key evil-motion-state-map (kbd "M-<right>") 'evil-jump-forward)
(define-key evil-motion-state-map (kbd "C-i") 'evil-jump-forward)

(with-eval-after-load 'cua-base
  (define-key cua-global-keymap (kbd "C-@") nil)
  (define-key cua-global-keymap (kbd "C-SPC") nil))

(global-set-key (kbd "C-SPC") nil)
(global-set-key (kbd "C-@") nil)

(global-set-key (kbd "M-SPC") 'yas-expand)

;(defun my-treemacs-keys ()
;  (define-key treemacs-mode-map (kbd "M-<up>") nil)
;  (define-key treemacs-mode-map (kbd "M-<down>") nil))

;(add-hook 'treemacs-mode-hook 'my-treemacs-keys)

(global-set-key (kbd "C-<prior>") 'previous-buffer)
(global-set-key (kbd "C-<next>")  'next-buffer)
(global-set-key (kbd "C-<up>") (lambda() (interactive) (other-window -1)))
(global-set-key (kbd "C-<down>") (lambda() (interactive) (other-window 1)))

(global-set-key (kbd "M-q") 'spacemacs/kill-emacs)
(global-set-key (kbd "M-w") 'my-kill-other-buffers)

(global-set-key (kbd "C-S-<up>") 'xah-backward-block)
(global-set-key (kbd "C-S-<down>") 'xah-forward-block)

(global-set-key [home] 'smart-beginning-of-line)

(global-set-key "\C-n" 'spacemacs/new-empty-buffer)
(global-set-key "\C-s" 'save-buffer)
(global-set-key (kbd "C-S-s") (lambda() (interactive) (save-some-buffers 0 t)))

(global-set-key "\C-q" (lambda() (interactive) (save-some-buffers) (spacemacs/kill-this-buffer nil)))
(global-set-key (kbd "C-S-q") (lambda() (interactive) (kill-buffer-and-window)))
(global-set-key (kbd "C-w") (lambda() (interactive) (spacemacs/kill-this-buffer nil)))

(define-key input-decode-map "\e[6D6~" [C-S-left])
(define-key input-decode-map "\e[6C6~" [C-S-right])
(define-key input-decode-map "\e[6S6~" [C-S-s])
(define-key input-decode-map [?\C-m] [C-m])

(global-set-key [C-m] 'window-toggle-side-windows)
(global-set-key [C-delete] 'treemacs)
(global-set-key [C-escape] 'evil-append)

; Use mouse wheel for scrolling through the buffer
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-line 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-line 3)))

(fset 'select-whole-buffer
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([C-home C-S-end])) arg)))

;(load "my-markdown-keys.el")
