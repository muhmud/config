
(defun write-ms-desc-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  
  (write-string-to-file "\\desc '" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file "'" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-select-sql-region-to-buffer()
  (interactive)
  "Write some sql to select some rows from a table"
  (write-string-to-file "select top 1000 * from " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file ";" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-select-tables-sql-region-to-buffer()
  (interactive)
  "Write some sql to desc an object to a buffer file"
  (write-string-to-file "select * from information_schema.tables order by 1, 2, 3;" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-script-sql-region-to-buffer()
  (interactive)
  "Write some sql to script an object to a buffer file"
  (write-string-to-file "\\! pg_dump -st " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file " > " sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-sql-result-to-buffer()
  (interactive)
  "Write the result of running some sql to a buffer file"
  (write-string-to-file "" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file "\nGO -m bcp > " sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-drop()
  (interactive)
  "Drop an object"
  (write-string-to-file "drop " sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file ";" sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(defun write-ms-get-columns()
  (interactive)
  "Gets a column list for a view or table"  
  (write-string-to-file "select stuff(cast((select ', ' + COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = parsename('" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file "', 2) and TABLE_NAME = parsename('" sql-buffer-file)
  (append-sql-to-buffer)
  (append-string-to-file "', 1) order by ORDINAL_POSITION for xml path(''), type) as varchar(max)), 1, 2, '')\n" sql-buffer-file)
  (append-string-to-file "GO -m bcp > " sql-buffer-file)
  (append-string-to-file sql-script-file sql-buffer-file)
  (write-string-to-file "DONE" sql-buffer-status-file))

(eval-after-load "sql"
  '(progn
     (sql-set-product 'ms)
     (define-key sql-mode-map [f5] 'write-sql-region-to-buffer)
     (define-key sql-mode-map "\eO1;3P" 'write-ms-desc-sql-region-to-buffer) ;Alt + F1
     (define-key sql-mode-map "\eO1;3Q" 'write-ms-script-sql-region-to-buffer) ;Alt + F2
     (define-key sql-mode-map (kbd "M-<f3>") 'insert-script) ;Alt + F3
     (define-key sql-mode-map (kbd "M-<f5>") 'write-ms-sql-result-to-buffer) ;Alt + F5
     (define-key sql-mode-map (kbd "M-<f6>") 'write-ms-select-sql-region-to-buffer) ;Alt + F6
     (define-key sql-mode-map (kbd "M-<f7>") 'write-ms-get-columns) ;Alt + F7
     (define-key sql-mode-map "\e[24;9{" 'write-ms-drop) ;Alt + D
     (define-key sql-mode-map "\e " 'write-ms-select-tables-sql-region-to-buffer) ;Alt + Space
     (define-key sql-mode-map "\e[24;9~" 'create-sql-region-and-write-to-buffer) ;Ctrl + Return
   )
)
