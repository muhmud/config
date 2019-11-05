
(defun write-pg-desc-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  
  (write-string-to-file "\\d+ " sql-buffer-file)
  (append-sql-to-buffer)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-select-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "select * from " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file " limit 1000;" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-select-tables-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "select * from information_schema.tables where table_schema not in ('information_schema', 'pg_catalog') order by table_schema, table_name;" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-script-sql-region-to-buffer()
  (interactive)
  "Write some sql to script an object to a buffer file"
  (write-string-to-file "\\! pg_dump -st " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file " > " sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-sql-result-to-buffer()
  (interactive)
  "Write the result of running some sql to a buffer file"
  (write-string-to-file "copy (" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file ") to '" sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (append-string-to-file "' with (format csv);" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-drop()
  (interactive)
  "Drop an object"
  (write-string-to-file "drop " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file ";" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-drop-cascade()
  (interactive)
  "Drop an object with cascade"
  (write-string-to-file "drop " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file " cascade;" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-pg-get-columns()
  (interactive)
  "Gets a column list for a view or table"  
  (write-string-to-file "copy (select string_agg(attname, ', ' order by attnum) from pg_attribute where attrelid = '" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file "'::regclass and attnum > 0) to '" sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (append-string-to-file "';" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(eval-after-load "sql"
  '(progn
     (sql-set-product 'postgres)
     (define-key sql-mode-map [f5] 'write-sql-region-to-buffer)
     (define-key sql-mode-map "\eO1;3P" 'write-pg-desc-sql-region-to-buffer) ;Alt + F1
     (define-key sql-mode-map "\eO1;3Q" 'write-pg-script-sql-region-to-buffer) ;Alt + F2
     (define-key sql-mode-map "\eO1;3R" 'insert-script) ;Alt + F3
     (define-key sql-mode-map (kbd "M-<f5>") 'write-pg-sql-result-to-buffer) ;Alt + F5
     (define-key sql-mode-map (kbd "M-<f6>") 'write-pg-select-sql-region-to-buffer) ;Alt + F6
     (define-key sql-mode-map (kbd "M-<f7>") 'write-pg-get-columns) ;Alt + F7
     (define-key sql-mode-map "\e[24;9{" 'write-pg-drop) ;Alt + D
     (define-key sql-mode-map "\e[24;9}" 'write-pg-drop-cascade) ;Alt + Shift + D
     (define-key sql-mode-map "\e " 'write-pg-select-tables-sql-region-to-buffer) ;Alt + Space
     (define-key sql-mode-map "\e[24;9~" 'create-sql-region-and-write-to-buffer) ;Ctrl + Return
   )
)
