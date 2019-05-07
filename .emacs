;;; package --- Emacs's per-user configuration file
;;; Commentary:
;;; Code:

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode -1)
(column-number-mode)
(display-time-mode)
(show-paren-mode)
(setq inhibit-startup-screen 1)
(defalias 'yes-or-no-p 'y-or-n-p)

;;(set-default-font "Fixedsys 12")
(set-default-font "Ubuntu Mono Nerd Font Bold 14")

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(let ((el-get-user-package-directory "~/.emacs.d/init")))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-x E") 'eval-buffer)))

;; (require 'base16-theme)
;; (load-theme 'base16-google-light t)
(load-theme 'leuven t)

(require 'smartparens-config)
(smartparens-global-mode)

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(require 'popup)
(require 'yasnippet)
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-go")
;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas/popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas/prompt-functions '(yas/popup-isearch-prompt yas/no-prompt))

(yas-global-mode)

(require 'company)
;(require 'company-go)

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
;(add-to-list 'company-backends 'company-go)
;(add-hook 'before-save-hook 'gofmt-before-save)

(require 'tern)
(require 'company-tern)
(add-to-list 'company-backends 'company-tern)

(global-company-mode)

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)))
(setq js-indent-level 2)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(require 'tiling)
(winner-mode)
(windmove-default-keybindings)
;;; Windows related operations
;; Split & Resize
(define-key global-map (kbd "C-x |") 'split-window-horizontally)
(define-key global-map (kbd "C-x _") 'split-window-vertically)
(define-key global-map (kbd "C-{") 'shrink-window-horizontally)
(define-key global-map (kbd "C-}") 'enlarge-window-horizontally)
(define-key global-map (kbd "C-^") 'enlarge-window)
;; Navgating: Windmove uses C-<up> etc.
(define-key global-map (kbd "C-<up>"   ) 'windmove-up)
(define-key global-map (kbd "C-<down>" ) 'windmove-down)
(define-key global-map (kbd "C-<right>") 'windmove-right)
(define-key global-map (kbd "C-<left>" ) 'windmove-left)
;; Swap buffers: M-<up> etc.
(define-key global-map (kbd "M-<up>"   ) 'buf-move-up)
(define-key global-map (kbd "M-<down>" ) 'buf-move-down)
(define-key global-map (kbd "M-<right>") 'buf-move-right)
(define-key global-map (kbd "M-<left>" ) 'buf-move-left)
;; Tile
(define-key global-map (kbd "C-\\") 'tiling-cycle) ; accepts prefix number
(define-key global-map (kbd "C-M-<up>") 'tiling-tile-up)
(define-key global-map (kbd "C-M-<down>") 'tiling-tile-down)
(define-key global-map (kbd "C-M-<right>") 'tiling-tile-right)
(define-key global-map (kbd "C-M-<left>") 'tiling-tile-left)
;; Another type of representation of same keys, in case your terminal doesn't
;; recognize above key-binding. Tip: C-h k C-up etc. to see into what your
;; terminal tranlated the key sequence.
(define-key global-map (kbd "M-[ a"     ) 'windmove-up)
(define-key global-map (kbd "M-[ b"     ) 'windmove-down)
(define-key global-map (kbd "M-[ c"     ) 'windmove-right)
(define-key global-map (kbd "M-[ d"     ) 'windmove-left)
(define-key global-map (kbd "ESC <up>"   ) 'buf-move-up)
(define-key global-map (kbd "ESC <down>" ) 'buf-move-down)
(define-key global-map (kbd "ESC <right>") 'buf-move-right)
(define-key global-map (kbd "ESC <left>" ) 'buf-move-left)
(define-key global-map (kbd "ESC M-[ a" ) 'tiling-tile-up)
(define-key global-map (kbd "ESC M-[ b" ) 'tiling-tile-down)
(define-key global-map (kbd "ESC M-[ c" ) 'tiling-tile-right)
(define-key global-map (kbd "ESC M-[ d" ) 'tiling-tile-left)

(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(setq fci-rule-column 80)
(setq fci-rule-use-dashes 1)
(setq fci-dash-pattern 0.10)
(setq fci-rule-color "#fba922")

(setq-default indent-tabs-mode nil)
(setq c-basic-offset 2 tab-width 2)

(require 'delete-nl-spaces)
(delete-nl-spaces-mode)

(require 'flycheck)

(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode)
  (setq flycheck-pos-tip-timeout 64))

(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

(flycheck-add-mode 'javascript-eslint 'web-mode)
(setq-default flycheck-temp-prefix ".flycheck")

(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
          '(json-jsonlist)))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode.  Adjust indents."
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;; Tramp setup
(setq tramp-default-method "ssh")
(setq tramp-connection-timeout 10)

;;; End of tramp setup

(require 'php-mode)

(add-hook 'php-mode-hook (lambda ()
    (defun ywb-php-lineup-arglist-intro (langelem)
      (save-excursion
        (goto-char (cdr langelem))
        (vector (+ (current-column) c-basic-offset))))
    (defun ywb-php-lineup-arglist-close (langelem)
      (save-excursion
        (goto-char (cdr langelem))
        (vector (current-column))))
    (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
    (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))

(cd "/sshx:yar:/home/tm/web-vue")

(custom-set-variables
 '(package-selected-packages (quote (dumb-jump vue-mode))))

(provide '.emacs)
;;; .emacs ends here
