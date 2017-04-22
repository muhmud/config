(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun indent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region 2)
      (activate-mark t))
    (tab-to-tab-stop)))

(defun unindent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region -2)
      (setq deactivate-mark nil))
    (delete-backward-char 2)))

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive "^")
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(defun delete-word (arg)
    "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
    (interactive "p")
    (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
    "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
    (interactive "p")
      (delete-word (- arg)))

(defun delete-whole-line()
  (interactive)
  (beginning-of-line)
  (setq line-start (point))
  (forward-line 1)
  (setq line-end (point))
  (delete-region line-start line-end))

(defun delete-line-to-right()
  (interactive)
  (setq line-start (point))
  (end-of-line)
  (setq line-end (point))
  (delete-region line-start line-end))

(defun delete-line-to-left()
  (interactive)
  (setq line-start (point))
  (beginning-of-line)
  (setq line-end (point))
    (delete-region line-start line-end))
