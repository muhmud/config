(defun my-markdown-config ()
  ;; Markup insertion & removal
  (define-key markdown-mode-map (kbd "M-c C-s") markdown-mode-style-map)
  (define-key markdown-mode-map (kbd "M-c C-l") 'markdown-insert-link)
  (define-key markdown-mode-map (kbd "M-c C-k") 'markdown-kill-thing-at-point)
  ;; Promotion, demotion, and cycling
  (define-key markdown-mode-map (kbd "M-c C--") 'markdown-promote)
  (define-key markdown-mode-map (kbd "M-c C-=") 'markdown-demote)
  (define-key markdown-mode-map (kbd "M-c C-]") 'markdown-complete)
  ;; Following and doing things
  (define-key markdown-mode-map (kbd "M-c C-o") 'markdown-follow-thing-at-point)
  (define-key markdown-mode-map (kbd "M-c C-d") 'markdown-do)
  (define-key markdown-mode-map (kbd "M-c '") 'markdown-edit-code-block)
  ;; Indentation
  (define-key markdown-mode-map (kbd "C-m") 'markdown-enter-key)
  (define-key markdown-mode-map (kbd "DEL") 'markdown-outdent-or-delete)
  (define-key markdown-mode-map (kbd "M-c >") 'markdown-indent-region)
  (define-key markdown-mode-map (kbd "M-c <") 'markdown-outdent-region)
  ;; Visibility cycling
  (define-key markdown-mode-map (kbd "TAB") 'markdown-cycle)
  (define-key markdown-mode-map (kbd "<S-iso-lefttab>") 'markdown-shifttab)
  (define-key markdown-mode-map (kbd "<S-tab>")  'markdown-shifttab)
  (define-key markdown-mode-map (kbd "<backtab>") 'markdown-shifttab)
  ;; Heading and list navigation
  (define-key markdown-mode-map (kbd "M-c C-n") 'markdown-outline-next)
  (define-key markdown-mode-map (kbd "M-c C-p") 'markdown-outline-previous)
  (define-key markdown-mode-map (kbd "M-c C-f") 'markdown-outline-next-same-level)
  (define-key markdown-mode-map (kbd "M-c C-b") 'markdown-outline-previous-same-level)
  (define-key markdown-mode-map (kbd "M-c C-u") 'markdown-outline-up)
  ;; Buffer-wide commands
  (define-key markdown-mode-map (kbd "M-c M-c") markdown-mode-command-map)
  ;; Subtree, list, and table editing
  (define-key markdown-mode-map (kbd "M-c <up>") 'markdown-move-up)
  (define-key markdown-mode-map (kbd "M-c <down>") 'markdown-move-down)
  (define-key markdown-mode-map (kbd "M-c <left>") 'markdown-promote)
  (define-key markdown-mode-map (kbd "M-c <right>") 'markdown-demote)
  (define-key markdown-mode-map (kbd "M-c S-<up>") 'markdown-table-delete-row)
  (define-key markdown-mode-map (kbd "M-c S-<down>") 'markdown-table-insert-row)
  (define-key markdown-mode-map (kbd "M-c S-<left>") 'markdown-table-delete-column)
  (define-key markdown-mode-map (kbd "M-c S-<right>") 'markdown-table-insert-column)
  (define-key markdown-mode-map (kbd "M-c C-M-h") 'markdown-mark-subtree)
  (define-key markdown-mode-map (kbd "M-z n s") 'markdown-narrow-to-subtree)
  (define-key markdown-mode-map (kbd "M-RET") 'markdown-insert-list-item)
  (define-key markdown-mode-map (kbd "M-c C-j") 'markdown-insert-list-item)
  ;; Paragraphs (Markdown context aware)
  (define-key markdown-mode-map [remap backward-paragraph] 'markdown-backward-paragraph)
  (define-key markdown-mode-map [remap forward-paragraph] 'markdown-forward-paragraph)
  (define-key markdown-mode-map [remap mark-paragraph] 'markdown-mark-paragraph)
  ;; Blocks (one or more paragraphs)
  (define-key markdown-mode-map (kbd "C-M-{") 'markdown-backward-block)
  (define-key markdown-mode-map (kbd "C-M-}") 'markdown-forward-block)
  (define-key markdown-mode-map (kbd "M-c M-h") 'markdown-mark-block)
  (define-key markdown-mode-map (kbd "M-z n b") 'markdown-narrow-to-block)
  ;; Pages (top-level sections)
  (define-key markdown-mode-map [remap backward-page] 'markdown-backward-page)
  (define-key markdown-mode-map [remap forward-page] 'markdown-forward-page)
  (define-key markdown-mode-map [remap mark-page] 'markdown-mark-page)
  (define-key markdown-mode-map [remap narrow-to-page] 'markdown-narrow-to-page)
  ;; Link Movement
  (define-key markdown-mode-map (kbd "M-n") 'markdown-next-link)
  (define-key markdown-mode-map (kbd "M-p") 'markdown-previous-link)
  ;; Toggling functionality
  (define-key markdown-mode-map (kbd "M-c C-x C-e") 'markdown-toggle-math)
  (define-key markdown-mode-map (kbd "M-c C-x C-f") 'markdown-toggle-fontify-code-blocks-natively)
  (define-key markdown-mode-map (kbd "M-c C-x C-i") 'markdown-toggle-inline-images)
  (define-key markdown-mode-map (kbd "M-c C-x C-l") 'markdown-toggle-url-hiding)
  (define-key markdown-mode-map (kbd "M-c C-x C-m") 'markdown-toggle-markup-hiding)
  ;; Alternative keys (in case of problems with the arrow keys)
  (define-key markdown-mode-map (kbd "M-c C-x u") 'markdown-move-up)
  (define-key markdown-mode-map (kbd "M-c C-x d") 'markdown-move-down)
  (define-key markdown-mode-map (kbd "M-c C-x l") 'markdown-promote)
  (define-key markdown-mode-map (kbd "M-c C-x r") 'markdown-demote)
  ;; Deprecated keys that may be removed in a future version
  (define-key markdown-mode-map (kbd "M-c C-a L") 'markdown-insert-link) ;; M-c C-l
  (define-key markdown-mode-map (kbd "M-c C-a l") 'markdown-insert-link) ;; M-c C-l
  (define-key markdown-mode-map (kbd "M-c C-a r") 'markdown-insert-link) ;; M-c C-l
  (define-key markdown-mode-map (kbd "M-c C-a u") 'markdown-insert-uri) ;; M-c C-l
  (define-key markdown-mode-map (kbd "M-c C-a f") 'markdown-insert-footnote)
  (define-key markdown-mode-map (kbd "M-c C-a w") 'markdown-insert-wiki-link)
  (define-key markdown-mode-map (kbd "M-c C-t 1") 'markdown-insert-header-atx-1)
  (define-key markdown-mode-map (kbd "M-c C-t 2") 'markdown-insert-header-atx-2)
  (define-key markdown-mode-map (kbd "M-c C-t 3") 'markdown-insert-header-atx-3)
  (define-key markdown-mode-map (kbd "M-c C-t 4") 'markdown-insert-header-atx-4)
  (define-key markdown-mode-map (kbd "M-c C-t 5") 'markdown-insert-header-atx-5)
  (define-key markdown-mode-map (kbd "M-c C-t 6") 'markdown-insert-header-atx-6)
  (define-key markdown-mode-map (kbd "M-c C-t !") 'markdown-insert-header-setext-1)
  (define-key markdown-mode-map (kbd "M-c C-t @") 'markdown-insert-header-setext-2)
  (define-key markdown-mode-map (kbd "M-c C-t h") 'markdown-insert-header-dwim)
  (define-key markdown-mode-map (kbd "M-c C-t H") 'markdown-insert-header-setext-dwim)
  (define-key markdown-mode-map (kbd "M-c C-t s") 'markdown-insert-header-setext-2)
  (define-key markdown-mode-map (kbd "M-c C-t t") 'markdown-insert-header-setext-1)
  (define-key markdown-mode-map (kbd "M-c C-i") 'markdown-insert-image)
  (define-key markdown-mode-map (kbd "M-c C-x m") 'markdown-insert-list-item) ;; M-c C-j
  (define-key markdown-mode-map (kbd "M-c C-x C-x") 'markdown-toggle-gfm-checkbox) ;; M-c C-d
  (define-key markdown-mode-map (kbd "M-c -") 'markdown-insert-hr)

  (define-key gfm-mode-map (kbd "M-c C-s d") 'markdown-insert-strike-through))


