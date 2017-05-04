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
      '(erc
        undo-tree
        xclip
        neotree
        cmake-mode
        irony-mode
        company-mode
        flycheck
        flycheck-irony
        rtags
        cmake-ide
        magit
        js2-mode))

; Sync packages
(el-get 'sync my:el-get-packages)
