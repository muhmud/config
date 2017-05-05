
(defun write-pg-desc-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "\\d+ " "/ram/buffer.sql")
  (append-sql-to-buffer))

(defun write-pg-select-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "select * from " "/ram/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file " limit 1000;" "/ram/buffer.sql"))

(defun write-pg-select-tables-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "select * from information_schema.tables where table_schema not in ('information_schema', 'pg_catalog') order by table_schema, table_name;" "/ram/buffer.sql"))

(defun write-pg-script-sql-region-to-buffer()
  (interactive)
  "Write some sql to script an object to a buffer file"
  (write-string-to-file "\\! pg_dump -st " "/ram/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file " > /ram/script.sql" "/ram/buffer.sql"))

(defun write-pg-sql-result-to-buffer()
  (interactive)
  "Write the result of running some sql to a buffer file"
  (write-string-to-file "copy (" "/ram/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file ") to '/ram/script.sql' with (format csv);" "/ram/buffer.sql"))

(defun write-pg-drop-table()
  (interactive)
  "Drop a table"
  (write-string-to-file "drop table " "/ram/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file ";" "/ram/buffer.sql"))

(defun write-pg-drop-table-cascade()
  (interactive)
  "Drop a table"
  (write-string-to-file "drop table " "/ram/buffer.sql")
  (append-sql-to-buffer)
  (append-string-to-file " cascade;" "/ram/buffer.sql"))

(eval-after-load "sql"
  '(progn
     (sql-set-product 'postgres)
     (define-key sql-mode-map [f5] 'write-sql-region-to-buffer)
     (define-key sql-mode-map "\eO1;3P" 'write-pg-desc-sql-region-to-buffer) ;Alt + F1
     (define-key sql-mode-map "\eO1;3Q" 'write-pg-script-sql-region-to-buffer) ;Alt + F2
     (define-key sql-mode-map "\eO1;3R" 'insert-script) ;Alt + F3
     (define-key sql-mode-map (kbd "M-<f5>") 'write-pg-sql-result-to-buffer) ;Alt + F5
     (define-key sql-mode-map (kbd "M-<f6>") 'write-pg-select-sql-region-to-buffer) ;Alt + F6
     (define-key sql-mode-map "\e[24;9{" 'write-pg-drop-table) ;Alt + D
     (define-key sql-mode-map "\e[24;9}" 'write-pg-drop-table-cascade) ;Alt + Shift + D
     (define-key sql-mode-map "\e " 'write-pg-select-tables-sql-region-to-buffer) ;Alt + Space
     (define-key sql-mode-map "\e[24;9~" 'create-sql-region-and-write-to-buffer) ;Ctrl + Return
   )
)
