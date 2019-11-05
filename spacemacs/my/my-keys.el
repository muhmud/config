(define-key evil-insert-state-map (kbd "C-z") 'undo-tree-undo)
(define-key evil-insert-state-map (kbd "C-y") 'undo-tree-redo)
(define-key evil-motion-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-c") nil)
(define-key evil-insert-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-x") nil)
;(define-key evil-insert-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map "\e[6;5!" 'evil-delete-backward-word) ; Ctrl+Backspace
(define-key evil-normal-state-map (kbd "RET") 'evil-open-below)
(define-key evil-insert-state-map (kbd "RET") 'custom-newline)
(define-key evil-normal-state-map (kbd "DEL") 'backward-delete-char-untabify)
(define-key evil-insert-state-map (kbd "TAB") 'indent-block)
(define-key evil-insert-state-map [(backtab)] 'unindent-block)

(define-key evil-motion-state-map (kbd "M-<left>") 'evil-jump-backward)
(define-key evil-motion-state-map (kbd "M-<right>") 'evil-jump-forward)

(global-set-key (kbd "M-<prior>") 'previous-buffer)
(global-set-key (kbd "M-<next>")  'next-buffer)
(global-set-key (kbd "M-<up>") (lambda() (interactive) (other-window -1)))
(global-set-key (kbd "M-<down>") (lambda() (interactive) (other-window 1)))

(global-set-key (kbd "C-<prior>") 'xah-backward-block)
(global-set-key (kbd "C-<next>") 'xah-forward-block)

(global-set-key [home] 'smart-beginning-of-line)

(global-set-key "\C-s" 'save-buffer)
(global-set-key "\e[6S6~" (lambda() (interactive) (save-some-buffers 0 t))) ; Ctrl+Shift+s

(global-set-key "\C-q" (lambda() (interactive) (save-some-buffers)(kill-emacs)))
;(global-set-key (kbd "C-w") (lambda() (interactive) (kill-buffer nil)))

(define-key input-decode-map "\e[6D6~" [C-S-left])
(define-key input-decode-map "\e[6C6~" [C-S-right])

; Use mouse wheel for scrolling through the buffer
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-line 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-line 3)))
