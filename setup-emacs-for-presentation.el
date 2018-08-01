;;; setup-emacs-for-presentation --- do the thing it says on the tin

;;; Commentary:

;;; Code:

(require 'yasnippet)

(add-to-list 'yas-snippet-dirs
             (concat
              (projectile-project-root)
              (file-name-as-directory "snippets")))

(yas-reload-all)

;;; setup-emacs-for-presentation.el ends here
