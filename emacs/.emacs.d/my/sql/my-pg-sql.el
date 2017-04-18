(defun write-pg-desc-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "\\d+ " "/tmp/buffer.sql")
  (append-sql-to-buffer))

(defun write-pg-script-sql-region-to-buffer()
  (interactive)
  "Write some sql to script an object to a buffer file"
  (write-string-to-file "\\! pg_dump -st " "/tmp/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file " > /tmp/script.sql" "/tmp/buffer.sql"))

(eval-after-load "sql"
  '(progn
     (sql-set-product 'postgres)
     (define-key sql-mode-map [f5] 'write-sql-region-to-buffer)
     (define-key sql-mode-map (kbd "<M-f1>") 'write-pg-desc-sql-region-to-buffer)
     (define-key sql-mode-map (kbd "<M-f2>") 'write-pg-script-sql-region-to-buffer)
     (define-key sql-mode-map (kbd "<M-f3>") 'insert-script)
   )
  )
