; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

; Install el-get, if required
(unless (require 'el-get nil 'noerror)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/"))
  (package-refresh-contents)
  (package-initialize)
  (package-install 'el-get)
  (require 'el-get))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

; List of packages to manage
(setq my:el-get-packages
      '(color-theme
	      erc
        undo-tree
        xclip
        neotree
        cmake-mode
        irony-mode
        company-mode
        company-irony
        flycheck
        flycheck-irony
        rtags
        cmake-ide
        magit
        magit-gitflow
        js2-mode
        projectile
        clang-format
        semantic-refactor
        evil
        s
        yaml-mode
        yasnippet
        expand-region
        js2-mode
        js2-refactor
        json-mode
        tern
        company-tern
        websocket
        request
        circe
        alert
        emojify
        use-package
        ensime
	slack))

; Sync packages
(el-get 'sync my:el-get-packages)
