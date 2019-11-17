; Write a string to a file overwriting the existing contents
(defun write-string-to-file (string file)
   (interactive "sEnter the string: \nFFile to save to: ")
   (with-temp-buffer
     (insert string)
     (when (file-writable-p file)
       (write-region (point-min)
                     (point-max)
                     file nil))))

; Appends a string to a file
(defun append-string-to-file (string file)
   (interactive "sEnter the string: \nFFile to save to: ")
   (with-temp-buffer
     (insert string)
     (when (file-writable-p file)
       (write-region (point-min)
                     (point-max)
                     file t))))

(defun my-treemacs-RET (&optional ARG)
  (interactive)
  (treemacs-visit-node-default ARG)
  (treemacs))
