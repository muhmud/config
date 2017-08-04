;(define-key input-decode-map "\e[1;2D" [S-left])  
;(define-key input-decode-map "\e[1;2C" [S-right])  
;(define-key input-decode-map "\e[1;2B" [S-down])  
;(define-key input-decode-map "\e[1;2A" [S-up])  
;(define-key input-decode-map "\e[1;2H" [S-home])
;(define-key input-decode-map "\e[1;2F" [S-end])

(define-key input-decode-map "\e[6D6~" [C-S-left])
(define-key input-decode-map "\e[6C6~" [C-S-right])

;(global-set-key "\e[1;2C" 'forward-word)
;(global-set-key "\e[1;5D" 'backward-word)
;(global-set-key "\e[1;5H" 'beginning-of-buffer)
;(global-set-key "\e[1;5F" 'end-of-buffer)

; Shortcuts
(global-set-key "\M-z" 'other-window)           ; Alt+z

(global-set-key "\C-a" 'mark-whole-buffer)
(global-set-key "\C-g" 'goto-line)

(global-set-key [delete] (lambda() (interactive) (delete-char 1)))

(global-set-key "\C-s" 'save-buffer)
(global-set-key "\C-p" 'write-file)
(global-set-key "\e[6S6~" (lambda() (interactive) (save-some-buffers 0 t))) ; Ctrl+Shift+a

(global-set-key [delete] (lambda() (interactive) (delete-char 1)))

(global-set-key "\C-f" 'isearch-forward)
(global-set-key "\C-r" 'isearch-forward-regexp)
(global-set-key "\e[6F6~" 'isearch-backward) ; Ctrl+Shift+f
(global-set-key "\e[6R6~" 'isearch-backward-regexp) ; Ctrl+Shift+r
(global-set-key "\C-h" 'replace-string)
(global-set-key "\e[6H6~" 'replace-regexp) ; Ctrl+Shift+h

(global-set-key "\M-n" 'isearch-repeat-forward)
(global-set-key "\M-b" 'isearch-repeat-backward)

(global-set-key (kbd "<f1>") 'help)

(global-set-key "\C-q" (lambda() (interactive) (save-some-buffers)(kill-emacs)))
(global-set-key "\M-q" (lambda() (interactive) (save-buffers-kill-emacs t)))
(global-set-key "\e[6Q6~" 'kill-emacs)
(global-set-key "\C-w" (lambda() (interactive) (kill-buffer nil)))

(global-set-key "\C-o" 'find-file)
(global-set-key "\C-n" 'xah-new-empty-buffer)
(global-set-key "\C-l" 'list-buffers)

(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)

(global-set-key (kbd "M-1") 'rectangle-number-lines)

(global-set-key [(backtab)] 'unindent-block)

(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\e[6;5!" 'backward-delete-word) ; Ctrl+Backspace
(global-set-key "\C-d" 'delete-whole-line)
(global-set-key "\M-d" 'delete-line-to-right)
(global-set-key "\M-s" 'delete-line-to-left)
(global-set-key "\C-i" 'quoted-insert)
;(global-set-key "\C-/" 'pop-global-mark)

(global-set-key "\e[1111" (lambda() (interactive) (other-window 1))) ; Ctrl+Ins
(global-set-key "\e[1112" (lambda() (interactive) (other-window -1))) ; Ctrl+Del

(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "TAB") 'indent-block)

; Change keys in org-mode-map
(eval-after-load "org"
  '(progn
     (define-key org-mode-map (kbd "C-S-<right>") nil)
     (define-key org-mode-map (kbd "S-<right>") nil)
     (define-key org-mode-map (kbd "C-S-<left>") nil)
     (define-key org-mode-map (kbd "S-<left>") nil)
   )
)

