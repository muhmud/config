(defun shift-region (distance)
  (let ((mark (mark)))
    (setq beg (region-beginning) end (region-end))
    (save-excursion
      (setq beg (progn (goto-char beg) (line-beginning-position))
            end (progn (goto-char end) (line-end-position)))
      (indent-rigidly beg end distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun indent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region 2))
    (if (= (point) (line-beginning-position))
      (progn
        (indent-relative-first-indent-point)
        (if (= (point) (line-beginning-position))
          (tab-to-tab-stop)))
      (tab-to-tab-stop))))

(defun unindent-block()
  (interactive)
  (if (use-region-p)
    (progn
      (shift-region -2))
    (delete-backward-char 2)))

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive "^")
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line)))
)

(defun current-line-empty-p ()
  (save-excursion
    (beginning-of-line)
    (looking-at "[[:space:]]*$")))

(defun custom-newline ()
  (interactive "^")
  (if (current-line-empty-p)
    (progn
      (beginning-of-line)
      (delete-region (point) (line-end-position))
      ))
  (newline)
  (indent-relative-first-indent-point))

(defun custom-normal-newline ()
  (interactive "^")
  (end-of-line)
  (newline)
  (indent-relative-first-indent-point)
  (evil-insert 1))

(defun xah-forward-block (&optional n)
  "Move cursor beginning of next text block.
A text block is separated by blank lines.
This command similar to `forward-paragraph', but this command's behavior is the same regardless of syntax table.
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((c (buffer-substring-no-properties (point) (+ 1 (point)))))
    (if (or (equal c "[") (equal c "{") (equal c "(") (equal c "\"") (equal c "'"))
      (progn (forward-sexp) (backward-char))
      (let ((n (if (null n) 1 n)))
        (search-forward-regexp "\n[\t\n ]*\n+" nil "NOERROR" n)))))

(defun xah-backward-block (&optional n)
  "Move cursor to previous text block.
See: `xah-forward-block'
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((c (buffer-substring-no-properties (point) (+ 1 (point)))))
    (if (or (equal c "]") (equal c "}") (equal c ")") (equal c "\"") (equal c "'"))
      (progn (forward-char) (backward-sexp))
      (let ((n (if (null n) 1 n))
            (-i 1))
        (while (<= -i n)
          (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
              (progn (skip-chars-backward "\n\t "))
            (progn (goto-char (point-min))
                   (setq -i n)))
          (setq -i (1+ -i)))))))

(defun close-and-kill-next-pane ()
  "If there are multiple windows, then close the other pane and kill the buffer in it also."
  (interactive)
  (other-window 1)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))
