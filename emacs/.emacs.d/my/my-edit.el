(defun shift-region(numcols)
" my trick to expand the region to the beginning and end of the area selected
 much in the handy way I liked in the Dreamweaver editor."
  (if (< (point)(mark))
    (if (not(bolp))    (progn (beginning-of-line)(exchange-point-and-mark) (end-of-line)))
    (progn (end-of-line)(exchange-point-and-mark)(beginning-of-line)))
  (setq region-start (region-beginning))
  (setq region-finish (region-end))
  (save-excursion
    (if (< (point) (mark)) (exchange-point-and-mark))
    (let ((save-mark (mark)))
      (indent-rigidly region-start region-finish numcols))))

(defun indent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region 2)
      (setq deactivate-mark nil))
    (tab-to-tab-stop)))

(defun unindent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region -2)
      (setq deactivate-mark nil))
    (progn
      (backward-char)
      (backward-char))))

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
