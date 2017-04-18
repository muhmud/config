(require 'scala-mode2)
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

; ENSIME
(setq ecb-showing 1)
(define-key ensime-mode-map [f12] (lambda() (interactive)
                    (if (= 0 ecb-showing)
                      (progn (ecb-show-ecb-windows)(setq ecb-showing 1))
                      (progn (ecb-hide-ecb-windows)(setq ecb-showing 0)))))

(setq in-ecb 0)
(define-key ensime-mode-map [f10] (lambda() (interactive)
                    (if (= 0 in-ecb)
                      (progn (ecb-goto-window-directories)(setq in-ecb 1))
                      (progn (ecb-goto-window-edit-last)(setq in-ecb 0)))))
(define-key ensime-mode-map [f2] 'other-window)
(define-key ensime-mode-map [f3] 'ensime-db-quit)
(define-key ensime-mode-map [f4] 'ensime-db-start)
(define-key ensime-mode-map [f5] 'ensime-db-next)     
(define-key ensime-mode-map [f6] 'ensime-db-step)
(define-key ensime-mode-map [f7] 'ensime-db-step-out)
(define-key ensime-mode-map [f8] 'ensime-db-continue)
(define-key ensime-mode-map "\C-b" 'ensime-db-set-break)
(define-key ensime-mode-map "\C-u" 'ensime-db-clear-break)
(define-key ensime-mode-map [C-f5] 'ensime-db-inspect-value-at-point)
(define-key ensime-mode-map "\C-t" 'ensime-print-type-at-point)
(define-key ensime-mode-map "\C-e" 'ensime-print-errors-at-point)
(define-key ensime-mode-map [C-S-o] 'ensime-refactor-organize-imports)
(define-key ensime-mode-map (kbd "C-@") 'ensime-company-complete-or-indent)

(defun setup-scala-windows()
  (interactive)
  (delete-other-windows)
  (ensime-show-all-errors-and-warnings)
  (delete-window)
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer "*ENSIME-Compilation-Result*")
  (split-window-horizontally)
  (other-window 1)
  (ensime-sbt)
  (other-window 1)
  (enlarge-window 10)
  (window-configuration-to-register ?w))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ensime-breakpoint-face ((t (:background "green"))))
 '(ensime-marker-face ((t (:inherit ensime-breakpoint-face))))
 '(ensime-pending-breakpoint-face ((t (:background "green"))))
 '(sx-question-mode-content-face ((t (:background "black")))))
