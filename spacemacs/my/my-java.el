(define-minor-mode my-java-mode
  "My Java Stuff"
  :lighter ""
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-S-o") 'lsp-organize-imports)
            (define-key map (kbd "C-S-f") 'google-java-format-buffer)
            (define-key map [f3] 'lsp-find-definition)
            (define-key map [C-f3] 'lsp-find-references)
            (define-key map (kbd "C-S-m") 'lsp-java-convert-to-static-import)
            (define-key map (kbd "C-S-t") 'helm-lsp-workspace-symbol)
            (define-key map (kbd "C-S-p") 'lsp-treemacs-errors-list)
            (define-key map (kbd "C-S-e") 'treemacs)
            (define-key map (kbd "C-S-d") 'lsp-treemacs-java-deps-list)
            (define-key map (kbd "C-S-b") 'dap-breakpoint-toggle)
            (define-key map [C-f11] 'dap-java-debug)
            (define-key map [C-S-f11] 'dap-delete-session)
            (define-key map [C-S-f12] 'dap-delete-all-sessions)
            (define-key map [f4] 'dap-ui-inspect-thing-at-point)
            (define-key map [f5] 'dap-step-in)
            (define-key map [f6] 'dap-next)
            (define-key map [f7] 'dap-step-out)
            (define-key map [f8] 'dap-continue)
            (define-key map [f9] 'goto-java-or-test-file)
            map))

(defun goto-java-or-test-file ()
  (interactive)
  (let ((file (buffer-file-name))
        (is-java (string-match-p "/src/main/java/" (buffer-file-name)))
        (is-test (string-match-p "/src/test/java/" (buffer-file-name))))
    (cond (is-java (find-file (replace-regexp-in-string "[.]java$" "Test.java" (replace-regexp-in-string "/src/main/java/" "/src/test/java/" file))))
          (is-test (find-file (replace-regexp-in-string "Test[.]java$" ".java" (replace-regexp-in-string "/src/test/java/" "/src/main/java/" file))))
          (t nil))))

;(defun remap-java-keys ()
;  (define-key treemacs-mode-map (kbd "M-<up>") nil)
;  (define-key lsp-treemacs-errors-mode-map (kbd "M-<down>") nil))

;(defun remap-java-keys ()
;  (define-key java-mode-map ";" nil))

;(add-hook 'lsp-treemacs-errors-mode-hook 'remap-java-keys)
(add-hook 'java-mode-hook 'my-java-mode)
;(add-hook 'java-mode-hook 'remap-java-keys)

(diminish 'lsp-mode "L")
