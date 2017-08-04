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

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
This command select between any bracket chars, not the inner text of a bracket. For example, if text is

 (a(b)c▮)

 the selected char is “c”, not “a(b)c”.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-12-18"
  (interactive)
  (let (
        (-skipChars
         (if (boundp 'xah-brackets)
             (concat "^\"" xah-brackets)
           "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"))
        -pos
        )
    (skip-chars-backward -skipChars)
    (setq -pos (point))
    (skip-chars-forward -skipChars)
    (set-mark -pos)))

(defun xah-extend-selection ()
  "Select the current word, bracket/quote expression, or expand selection.
Subsequent calls expands the selection.

when no selection,
• if cursor is on a bracket, select whole bracketed thing including bracket
• if cursor is on a quote, select whole quoted thing including quoted
• if cursor is on the beginning of line, select the line.
• else, select current word.

when there's a selection, the selection extension behavior is still experimental.
Roughly:
• if 1 line is selected, extend to next line.
• if multiple lines is selected, extend to next line.
• if a bracketed text is selected, extend to include the outer bracket. If there's no outer, select current line.

 to line, or bracket/quoted text,
or text block, whichever is the smallest.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-01-15"
  (interactive)
  (if (region-active-p)
      (progn
        (let ((-rb (region-beginning)) (-re (region-end)))
          (goto-char -rb)
          (cond
           ((looking-at "\\s(")
            (if (eq (nth 0 (syntax-ppss)) 0)
                (progn
                  (message "left bracket, depth 0.")
                  (end-of-line) ; select current line
                  (set-mark (line-beginning-position)))
              (progn
                (message "left bracket, depth not 0")
                (up-list -1 t t)
                (mark-sexp))))
           ((eq -rb (line-beginning-position))
            (progn
              (goto-char -rb)
              (let ((-firstLineEndPos (line-end-position)))
                (cond
                 ((eq -re -firstLineEndPos)
                  (progn
                    (message "exactly 1 line. extend to next whole line." )
                    (forward-line 1)
                    (end-of-line)))
                 ((< -re -firstLineEndPos)
                  (progn
                    (message "less than 1 line. complete the line." )
                    (end-of-line)))
                 ((> -re -firstLineEndPos)
                  (progn
                    (message "beginning of line, but end is greater than 1st end of line" )
                    (goto-char -re)
                    (if (eq (point) (line-end-position))
                        (progn
                          (message "exactly multiple lines" )
                          (forward-line 1)
                          (end-of-line))
                      (progn
                        (message "multiple lines but end is not eol. make it so" )
                        (goto-char -re)
                        (end-of-line)))))
                 (t (error "logic error 42946" ))))))
           ((and (> (point) (line-beginning-position)) (<= (point) (line-end-position)))
            (progn
              (message "less than 1 line" )
              (end-of-line) ; select current line
              (set-mark (line-beginning-position))))
           (t (message "last resort" ) nil))))
    (progn
      (cond
       ((looking-at "\\s(")
        (message "left bracket")
        (mark-sexp)) ; left bracket
       ((looking-at "\\s)")
        (message "right bracket")
        (backward-up-list) (mark-sexp))
       ((looking-at "\\s\"")
        (message "string quote")
        (mark-sexp)) ; string quote
       ((and (eq (point) (line-beginning-position)) (not (looking-at "\n")))
        (message "beginning of line and not empty")
        (end-of-line)
        (set-mark (line-beginning-position)))
       ((or (looking-back "\\s_" 1) (looking-back "\\sw" 1))
        (message "left is word or symbol")
        (skip-syntax-backward "_w" )
        ;; (re-search-backward "^\\(\\sw\\|\\s_\\)" nil t)
        (mark-sexp))
       ((and (looking-at "\\s ") (looking-back "\\s " 1))
        (message "left and right both space" )
        (skip-chars-backward "\\s " ) (set-mark (point))
        (skip-chars-forward "\\s "))
       ((and (looking-at "\n") (looking-back "\n" 1))
        (message "left and right both newline")
        (skip-chars-forward "\n")
        (set-mark (point))
        (re-search-forward "\n[ \t]*\n")) ; between blank lines, select next text block
       (t (message "just mark sexp" )
          (mark-sexp))
       ;;
       ))))
