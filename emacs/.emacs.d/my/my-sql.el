; Take the selected text and write it to a file, overwriting any existing data. 
; This is the first step in getting a cool sql client working.
(defun write-sql-region-to-buffer()
  (interactive)
  "Write some sql to a buffer file"
  (write-region (region-beginning) (region-end) "/ram/buffer.sql"))

; Appends the selected text to a file. Related to sql client implementation
(defun append-sql-to-buffer ()
  (interactive)
  (write-region (region-beginning) (region-end) "/ram/buffer.sql" t))

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
  (message "Sql >>>"))

; Read a sql script from a file and insert the contents at point
(defun insert-script()
  (interactive)
  (if (use-region-p)
      (delete-region (point) (mark)))
    (insert-file-contents "/ram/script.sql"))

