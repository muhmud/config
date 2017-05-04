(load "buffer-stack.el")

(require 'buffer-stack)
(global-set-key "\e[6;6G" 'buffer-stack-up)     ; Ctrl+Shift+Tab
(global-set-key "\e[1;5G" 'buffer-stack-down)   ; Ctrl+Tab

; Exlude certain file types from buffer tracking, i.e. Ctrl+Tab will
; never cycle to them
(defun buffer-stack-untrack-filter (buffer)
  "Non-nil if buffer is not in buffer-stack-untracked or a 'hidden' buffer."
  (let ((name (buffer-name buffer)))
    (not (or (null name)
             (char-equal ?  (string-to-char name))
             (member name buffer-stack-untracked)
             (string-match "^\*.*\*$" name))
         )))

; Use the above function at the buffer stack filter
(setq buffer-stack-filter 'buffer-stack-untrack-filter)

; Define buffer groups
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("scala" (mode . scala-mode))
               ("java" (mode . java-mode))
               ("sql" (mode . sql-mode))
               ("xml" (mode . nxml-mode))
               ("cpp" (mode . c++-mode))
             ))
      )
)

(add-hook 'ibuffer-mode-hook
          (lambda () (ibuffer-switch-to-saved-filter-groups "default")))

(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")
