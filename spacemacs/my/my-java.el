(define-minor-mode my-java-mode
  "My Java Stuff"
  :lighter ""
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-S-o") 'lsp-organize-imports)
            (define-key map (kbd "C-S-f") 'google-java-format-buffer)
            (define-key map [f3] 'lsp-find-definition)
            (define-key map [C-f3] 'lsp-find-references)
            (define-key map [C-S-f3] 'lsp-goto-implementation)
            (define-key map (kbd "C-S-m") 'lsp-java-convert-to-static-import)
            (define-key map (kbd "C-S-t") 'helm-lsp-workspace-symbol)
            (define-key map (kbd "C-S-p") (lambda () (interactive) (toggle-side "*LSP Error List*" 'lsp-treemacs-errors-list)))
            (define-key map (kbd "C-S-e") 'open-treemacs)
            (define-key map (kbd "C-S-d") (lambda () (interactive) (toggle-side "*Java Dependency List*" 'lsp-treemacs-java-deps-list)))
            (define-key map (kbd "C-S-u") (lambda () (interactive) (toggle-side "*LSP Symbols List*" 'lsp-treemacs-symbols)))
            (define-key map (kbd "C-S-b") 'dap-breakpoint-toggle)
            (define-key map [C-f11] 'dap-java-debug)
            (define-key map [C-S-f11] 'dap-delete-session)
            (define-key map [C-S-f12] 'dap-delete-all-sessions)
            (define-key map [f4] 'dap-ui-inspect-thing-at-point)
            (define-key map [f5] 'dap-step-in)
            (define-key map [f6] 'dap-next)
            (define-key map [f7] 'dap-step-out)
            (define-key map [f8] 'dap-continue)
            (define-key map [f9] 'maven-test-toggle-between-test-and-class)
            (define-key map (kbd ";") (lambda () (interactive) (insert ";")))
            (define-key map (kbd ",") (lambda () (interactive) (insert ",")))
            map))

(defun open-treemacs ()
  (interactive)
  (treemacs)
  (when (/= my-treemacs-frame-width (frame-width))
    (setq my-treemacs-frame-width (frame-width))
    (setq my-treemacs-width (round (* (frame-width) 0.28))))
  (treemacs--set-width my-treemacs-width))

(defun get-window (prefix)
  (->> (window-list (selected-frame))
     (--first (->> it
                (window-buffer)
                (buffer-name)
                (s-starts-with? prefix)))))

(defun toggle-side (prefix side)
  (interactive)
  (let ((window (get-window prefix)))
    (if window
      (delete-window window)
      (funcall side))))

(defun java-package-name ()
  (interactive)
  (mapconcat 'identity (split-string (replace-regexp-in-string ".*src\\(/\\(main\\|test\\)\\)?\\(/java\\)?" "" default-directory) "/" t) "."))

;(defun java-package-name ()
;  (interactive)
;  (-let* ((symbols (lsp--get-document-symbols))
;          (package-name (-some->> symbols
;                          (-first (-lambda ((&hash "kind")) (= kind 4)))
;                          (gethash "name"))))
;    (prin1 package-name)))

(defun java-class-name ()
  (interactive)
  (file-name-sans-extension (buffer-name)))

;(defun java-class-name ()
;  (interactive)
;  (-let* ((symbols (lsp--get-document-symbols)))
;    (->> symbols
;       (-keep (-lambda ((&hash "children" "kind" "name" class-name))
;                (if (= kind 5)
;                   class-name))))))

;(defun remap-java-keys ()
;  (define-key treemacs-mode-map (kbd "M-<up>") nil)
;  (define-key lsp-treemacs-errors-mode-map (kbd "M-<down>") nil))

;(defun remap-java-keys ()
;  (define-key java-mode-map ";" nil))

;(add-hook 'lsp-treemacs-errors-mode-hook 'remap-java-keys)
(add-hook 'java-mode-hook 'my-java-mode)

(add-hook 'java-mode-hook #'tree-sitter-mode)
(add-hook 'java-mode-hook #'tree-sitter-hl-mode)
(add-hook 'tree-sitter-mode-hook
  (lambda () (diminish 'tree-sitter-mode))
  (tree-sitter-hl-add-patterns 'java [
    (generic_type (type_identifier) @generic.type)
    (object_creation_expression (type_identifier) @constructor.call)
    (
     (field_declaration (modifiers) @keyword (variable_declarator (identifier) @class.staticField))
     (.match? @keyword "static")
     )
    (formal_parameter (type_identifier) @formal.type)
    (formal_parameter (identifier) @formal.parameter)
    (local_variable_declaration (variable_declarator (identifier) @locals.variable))
    (
      (method_invocation (identifier) @method.staticInvocationObject (identifier) @method.staticMethod)
      (.match? @method.staticInvocationObject "^[A-Z]")
    )
    (
      (method_invocation (identifier) @constant (identifier) @method.logMethod)
      (.match? @constant "^log$")
    )
    (method_invocation (identifier) @method.invocationObject (identifier) @method.objectMethod)
    (method_invocation (identifier) @method.objectMethod)
    (
      (method_reference (identifier) @method.staticInvocationObject (identifier) @method.staticReference)
      (.match? @method.staticInvocationObject "^[A-Z]")
    )
    (method_reference (class_literal (identifier) @method.staticInvocationObject) (identifier) @method.objectMethod)
    (method_reference (identifier) @method.invocationObject (identifier) @method.objectMethod)
    (field_declaration (variable_declarator (identifier)) @class.field)
    (class_literal (identifier) @method.staticInvocationObject)
    ((null_literal) @keyword)
    ((class_body) @local.scope)
    ((block) @local.scope)
    (field_declaration (variable_declarator (identifier) @local.definition))
    (formal_parameter (identifier) @local.definition)
    (local_variable_declaration (variable_declarator (identifier) @local.definition))
    ((identifier) @local.reference)
  ])
  )

(defface tree-sitter-hl-face:constructor.call '((t :foreground "#A7EC21" :weight semilight))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:class.field '((t :foreground "#66E1F8"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:class.staticField '((t :foreground "#8DDAF8" :slant italic))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:formal.type '((t :foreground "#1280AD" :weight semilight))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:formal.parameter '((t :foreground "#79ABFF"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.staticInvocationObject '((t :foreground "#118BBD"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.staticMethod '((t :foreground "#96EC3F" :slant italic))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.staticReference '((t :foreground "#80F6A7"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.invocationObject '((t :foreground "#1DE1F8"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.objectMethod '((t :foreground "#98D621"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:method.logMethod '((t :foreground "#80F6A7"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:inscope.identifier '((t :foreground "#F2F200"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:locals.variable '((t :foreground "#F3EC79"))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)
(defface tree-sitter-hl-face:generic.type '((t :foreground "#80F2F6" :weight semilight))
  "Face for Java annotations" :group 'tree-sitter-hl-faces)

(add-hook 'lsp-mode-hook (lambda () (diminish 'lsp-mode)))
(add-hook 'java-mode-hook
          (lambda ()
            (setq c-electric-flag nil)
            (setq c-syntactic-indentation nil)))

(add-hook 'dap-mode-hook
          (lambda ()
            (dap-register-debug-template "Spring"
              (list :type "java"
                    :request "launch"
                    :args ""
                    :vmArgs "-Dspring.profiles.active=development"
                    :cwd nil
                    :stopOnEntry :json-false
                    :host "localhost"
                    :modulePaths []
                    :classPaths nil
                    :name "Spring"
                    :projectName nil
                    :mainClass nil))

            (dap-register-debug-template "Open"
              (list :type "java"
                    :args "/cfg=/home/muhmud/toptal/clients/open-practice/code/gitlab/openpm/openpm/openpm-ui/openpm.cfg"
                    :cwd nil
                    :host "localhost"
                    :request "compile_attach"
                    :modulePaths []
                    :classPaths nil
                    :name "Open"
                    :projectName nil
                    :mainClass "com.fkc.opm.startServer"))))
