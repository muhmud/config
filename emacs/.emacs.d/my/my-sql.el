(load "format-sql.el")

; Take the selected text and write it to a file, overwriting any existing data. 
; This is the first step in getting a cool sql client working.
(defun write-sql-region-to-buffer()
  (interactive)
  "Write some sql to a buffer file"
  (write-region (region-beginning) (region-end) sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

; Appends the selected text to a file. Related to sql client implementation
(defun append-sql-to-buffer ()
  (interactive)
  (write-region (region-beginning) (region-end) sql-buffer-file t))

; Takes the text at point, searching backwards for a newline and forwards
; for a semi-colon, and writes it to a file. Sql client implementation related.
(defun create-sql-region-and-write-to-buffer()
  (interactive)
  (setq current-point (point))
  (when (search-backward-regexp ";" nil "")
    (goto-char (match-end 0)))
  (cua-set-mark)
  (when (search-forward-regexp ";" nil "")
    (goto-char (match-end 0)))
  (cua-set-mark)
  (write-sql-region-to-buffer)
  (goto-char current-point)
  (message "Sql >>>")
  (write-string-to-file "DONE" sql-buffer-status-file))

; Read a sql script from a file and insert the contents at point
(defun insert-script()
  (interactive)
  (if (use-region-p)
      (delete-region (point) (mark)))
    (insert-file-contents sql-script-file))

; Manage SQL buffer & script files. Allows for multiple query environments
(setq sql-buffer-file "/tmp/buffer.sql")
(setq sql-buffer-status-file "/tmp/buffer-status")
(setq sql-script-file "/tmp/script.sql")
(defun update-sql-tab-files()
  (interactive)
  (setq sql-tab-id (with-temp-buffer
    (insert-file-contents "/tmp/sql-tab")
    (buffer-string)))
  (setq sql-buffer-file (concat (concat "/tmp/buffer." sql-tab-id) ".sql"))
  (setq sql-buffer-status-file (concat "/tmp/buffer-status." sql-tab-id))
  (setq sql-script-file (concat (concat "/tmp/script." sql-tab-id) ".sql")))
  
(eval-after-load "sql"
  '(progn
     (define-key sql-mode-map (kbd "M-f") 'format-sql-buffer)))


(global-set-key "\e[24;99" 'update-sql-tab-files) ; Special byte sequence to update the sql files used
