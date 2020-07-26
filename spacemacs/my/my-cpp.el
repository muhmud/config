(define-minor-mode my-c++-mode
  "My C++ Stuff"
  :lighter ""
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-S-f") 'lsp-format-buffer)
            (define-key map [f3] 'lsp-find-definition)
            (define-key map [C-f3] 'lsp-find-references)
            (define-key map [C-S-f3] 'lsp-goto-implementation)
            (define-key map (kbd "C-S-t") 'helm-lsp-workspace-symbol)
            (define-key map (kbd "C-S-p") (lambda () (interactive) (toggle-side "*LSP Error List*" 'lsp-treemacs-errors-list)))
            (define-key map (kbd "C-S-e") 'open-treemacs)
            (define-key map (kbd "C-S-u") (lambda () (interactive) (toggle-side "*LSP Symbols List*" 'lsp-treemacs-symbols)))
            (define-key map (kbd "C-S-b") 'dap-breakpoint-toggle)
            (define-key map [f5] 'dap-step-in)
            (define-key map [f6] 'dap-next)
            (define-key map [f7] 'dap-step-out)
            (define-key map [f8] 'dap-continue)
            map))

(add-hook 'c++-mode-hook 'my-c++-mode)

