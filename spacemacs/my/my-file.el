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

(setq auto-hide-treemacs t)
(setq my-treemacs-width 0)
(setq my-treemacs-frame-width 0)

(defun my-treemacs-RET (&optional ARG)
  (interactive)
  (setq my-treemacs-width (window-width))
  (treemacs-visit-node-default ARG)
  (when auto-hide-treemacs (treemacs)))
