(load "buffer-stack.el")

(require 'buffer-stack)
(require 'seq)
(global-set-key [C-tab] 'buffer-stack-down)
(global-set-key [C-iso-lefttab] 'buffer-stack-up)

(define-key input-decode-map "\e[1;5G" [C-tab])
(define-key input-decode-map "\e[6;6G" [C-iso-lefttab])

; Exlude certain file types from buffer tracking, i.e. Ctrl+Tab will
; never cycle to them
(defun buffer-stack-untrack-filter (buffer)
  "Non-nil if buffer is not in buffer-stack-untracked or a 'hidden' buffer."
  (let ((name (buffer-name buffer)))
    (not (or (null name)
             (char-equal ?  (string-to-char name))
             (member name buffer-stack-untracked)
             (string-match "^\*.*\*$" name)
             (string-match "^magit[:] .+$" name)
             (not (member buffer (persp-buffer-list)))
             (string= (with-current-buffer buffer major-mode) "dired-mode"))
         )))

(defun my-kill-other-buffers ()
  (interactive)
  (mapc 'kill-buffer (seq-filter 'buffer-stack-untrack-filter (delq (current-buffer) (persp-buffer-list)))))

; Use the above function at the buffer stack filter
(setq buffer-stack-filter 'buffer-stack-untrack-filter)

(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")
