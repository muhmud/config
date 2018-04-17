
(require 'flycheck)
(require 'flycheck-flow)
(require 'js2-refactor)
(require 'tern)
(require 'company-tern)

;; load Indium from its source code
(add-to-list 'load-path "~/.emacs.d/Indium")
(require 'indium)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'js2-mode-hook (lambda() (when (eq major-mode 'js2-mode) (flycheck-select-checker 'javascript-eslint))))
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))

(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-next-checker 'javascript-eslint 'javascript-flow)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers '(javascript-jshint))

(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-tern))
