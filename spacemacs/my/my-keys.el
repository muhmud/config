(define-key evil-insert-state-map (kbd "C-z") 'undo-tree-undo)
(define-key evil-insert-state-map (kbd "C-y") 'undo-tree-redo)
(define-key evil-motion-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-c") nil)
(define-key evil-insert-state-map (kbd "C-v") nil)
(define-key evil-insert-state-map (kbd "C-x") nil)
(define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map (kbd "C-w") 'spacemacs/kill-this-buffer)
(define-key evil-insert-state-map (kbd "C-a") 'select-whole-buffer)
(define-key evil-insert-state-map "\e[6;5!" 'evil-delete-backward-word) ; Ctrl+Backspace
(define-key evil-normal-state-map (kbd "RET") 'custom-normal-newline)
(define-key evil-insert-state-map (kbd "RET") 'custom-newline)
(define-key evil-normal-state-map (kbd "DEL") 'backward-delete-char-untabify)
(define-key evil-normal-state-map [delete] 'delete-char)
(define-key evil-insert-state-map (kbd "TAB") 'indent-block)
(define-key evil-insert-state-map [(backtab)] 'unindent-block)
(define-key evil-insert-state-map (kbd "C-SPC") 'company-complete)
(define-key evil-insert-state-map (kbd "C-@") 'company-complete)
(define-key evil-normal-state-map (kbd "C-SPC") 'evil-append)
(define-key evil-normal-state-map (kbd "C-@") 'evil-append)
(define-key evil-motion-state-map (kbd "M-<left>") 'evil-jump-backward)
(define-key evil-insert-state-map (kbd "M-<left>") 'evil-jump-backward)
(define-key evil-motion-state-map (kbd "M-<right>") 'evil-jump-forward)
(define-key evil-insert-state-map (kbd "M-<right>") 'evil-jump-forward)
(define-key evil-motion-state-map (kbd "C-i") 'evil-jump-forward)

;(define-key evil-normal-state-map (kbd "<escape>") (lambda() (interactive) (cond
;                                                                            ((eq evil-state 'visual) (forward-char) (evil-normal-state))
;                                                          ((eq evil-state 'normal) (evil-insert-state))
;                                                          ((eq evil-state 'insert) (forward-char) (evil-normal-state)))))

(evil-define-key 'normal evil-mc-key-map (kbd "C-n") nil)
(evil-define-key 'normal evil-mc-key-map (kbd "C-p") nil)
(evil-define-key 'normal evil-mc-key-map (kbd "C-t") nil)
(evil-define-key 'normal evil-mc-key-map (kbd "M-t") 'evil-mc-skip-and-goto-next-match)

(evil-define-operator my-evil-delete (beg end type yank-handler)
  (interactive "<R><y>")
  (evil-delete beg end type ?_ yank-handler))

(define-key evil-normal-state-map "d" 'my-evil-delete)

(with-eval-after-load 'cua-base
  (define-key cua-global-keymap (kbd "C-@") nil)
  (define-key cua-global-keymap (kbd "C-SPC") nil))

(global-set-key (kbd "C-SPC") nil)
(global-set-key (kbd "C-@") nil)

(global-set-key (kbd "M-SPC") 'yas-expand)

(defun shrink-treemacs ()
  (interactive)
  (shrink-window-horizontally 3)
  (setq my-treemacs-width (window-width)))

(defun expand-treemacs ()
  (interactive)
  (enlarge-window-horizontally 3)
  (setq my-treemacs-width (window-width)))

(defun my-treemacs-keys ()
  (define-key evil-treemacs-state-local-map (kbd "<right>") 'treemacs-TAB-action)
  (define-key evil-treemacs-state-local-map (kbd "<left>") 'treemacs-TAB-action)
  (define-key evil-treemacs-state-local-map (kbd "C-<left>") 'expand-treemacs)
  (define-key evil-treemacs-state-local-map (kbd "C-<right>") 'shrink-treemacs)
  (define-key evil-treemacs-state-local-map (kbd "/") 'helm-ag)
  (define-key evil-treemacs-state-local-map (kbd "C-/") 'helm-find)
  (define-key evil-treemacs-state-local-map (kbd "C-S-p") 'delete-window)
  (define-key evil-treemacs-state-local-map (kbd "C-S-e") 'delete-window)
  (define-key evil-treemacs-state-local-map (kbd "C-S-d") 'delete-window)
  (define-key evil-treemacs-state-local-map (kbd "C-S-u") 'delete-window)
  (define-key evil-treemacs-state-local-map (kbd "C-S-u") 'delete-window)
  (define-key evil-treemacs-state-local-map (kbd "C-<insert>") (lambda () (interactive) (if auto-hide-treemacs (setq auto-hide-treemacs nil) (setq auto-hide-treemacs t))))
  (define-key treemacs-mode-map (kbd "<prior>") nil)
  (define-key treemacs-mode-map (kbd "<next>") nil)
  (define-key treemacs-mode-map (kbd "<right>") 'treemacs-TAB-action)
  (define-key treemacs-mode-map (kbd "<left>") 'treemacs-TAB-action))

(add-hook 'treemacs-mode-hook 'my-treemacs-keys)

(global-set-key (kbd "C-n") 'spacemacs/new-empty-buffer)
(global-set-key (kbd "C-<prior>") 'xah-backward-block)
(global-set-key (kbd "C-<next>")  'xah-forward-block)
(global-set-key (kbd "C-<up>") (lambda() (interactive) (other-window -1)))
(global-set-key (kbd "C-<down>") (lambda() (interactive) (other-window 1)))

(global-set-key (kbd "C-f") (lambda() (interactive) (evil-normal-state) (evil-ex-search-forward)))

(global-set-key (kbd "M-q") 'spacemacs/kill-emacs)
(global-set-key (kbd "M-w") 'my-kill-other-buffers)
(global-set-key (kbd "M-e") 'kill-buffer-and-window)

(global-set-key (kbd "M-<prior>") 'previous-buffer)
(global-set-key (kbd "M-<next>")  'next-buffer)

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
(global-set-key [C-delete] 'open-treemacs)
(global-set-key [C-escape] 'evil-append)

; Use mouse wheel for scrolling through the buffer
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down-line 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up-line 3)))

(fset 'select-whole-buffer
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([C-home C-S-end])) arg)))

;(load "my-markdown-keys.el")
