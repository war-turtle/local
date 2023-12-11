;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Personel config

;; starting the emacs server
(server-start)

;; requiring org-protocol. so that I can capture stuff from anywhere
(require 'org-protocol)

;; Setting tab width
;; (setq tab-width 2)
(setq-default tab-width 2)

;; Configuring org
(setq notesDir "~/App/notes/notes")

;; Providing path to mmdc (mermaid js cli tool) to ob-mermaid for orgmode support
(setq ob-mermaid-cli-path "~/.nvm/versions/node/v14.21.3/bin/mmdc")
(org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)))

(after! org
  (setq org-directory notesDir
        org-agenda-files (directory-files-recursively notesDir "\\.org$")
        org-indent-mode t
        org-todo-keywords '((sequence "TODO(t)" "IP-1(i)" "IP-2(o)" "IP-3(p)" "HOLD(h)" "|" "DONE(d)" "CANCELLED(c)"))
        org-priority-highest 0
        org-priority-lowest 3
        org-priority-default 2
        org-priority-faces '((?0 :foreground "red" :background "yellow" :weight 'bold)
                             (?1 :foreground "red" :background "white")
                             (?2 :foreground "yellow")
                             (?3 :foreground "green"))
        org-log-done 'time
  )
  (add-to-list 'org-emphasis-alist '("*" (:foreground "green" :background "black")))
  (add-to-list 'org-emphasis-alist '("=" (:foreground "red" :background "black")))
  ;; configuring org-refile
  (setq org-refile-allow-creating-parent-nodes t)
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps t)
  ;; org-refile-targets expect a list of files instead of a directory. So we use directory-files-recusively function here.
  (setq org-refile-targets `((nil :maxlevel . 1)
                             (,(directory-files-recursively notesDir "^[a-z0-9]*.org$") :maxlevel . 1)
                             )
  )
  ;; Configuring org-capture
  (setq org-default-notes-file (concat org-directory "/projects/todo.org"))
  (setq org-capture-templates
        '(
          ("l" "Todo Life" entry (file+olp org-default-notes-file "Life")
           "* TODO %?\n%U\n%i\n%a\n" :empty-lines-after 1)
          ("s" "Todo Study" entry (file+olp org-default-notes-file "Study")
           "* TODO %?\n%U\n%i\n%a\n" :empty-lines-after 1)
          ("w" "Todo Work" entry (file+olp org-default-notes-file "Work")
           "* TODO %?\n%U\n%i\n%a\n" :empty-lines-after 1)
          ("m" "Todo WorkMinor" entry (file+olp org-default-notes-file "WorkMinor")
           "* TODO %?\n%U\n%i\n%a\n" :empty-lines-after 1)))
  (map! :leader "m i" #'org-toggle-inline-images)
)

;; to find whether the executable is in path or not
;; (executable-find "kotlin-language-server")
;;
;; to find the value of environment variable
;; (getenv "JAVA_HOME")

;; Use $PATH from shell as path variable for emacs
(doom-require 'exec-path-from-shell)
(use-package! exec-path-from-shell
   :init
   (add-to-list 'exec-path-from-shell-variables "JAVA_HOME")
   (when (memq window-system '(mac ns x))
     (exec-path-from-shell-initialize)))

;; (doom-require 'lsp-java)
;; (add-hook 'java-mode-hook #'lsp)

;; Package used to store images in org file
;; (doom-require 'org-download)
(use-package! org-download
    :after org
    :defer nil
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "images")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y-%m-%d-%H:%M:%S-")
    (org-image-actual-width 300)
    :config
    (doom-require 'org-download)
    (map! :leader "m a c" #'org-download-clipboard))

;; Stop evil yank or delete from using the clipboard
(setq select-enable-clipboard nil)
(defun paste-from-clipboard ()
  (interactive)
  (setq select-enable-clipboard t)
  (clipboard-yank)
  (setq select-enable-clipboard nil))
(defun copy-to-clipboard()
  (interactive)
  (setq select-enable-clipboard t)
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy")
  ;; (kill-ring-save (region-beginning) (region-end))
  (setq select-enable-clipboard nil))
(defun cut-to-clipboard()
  (interactive)
  (setq select-enable-clipboard t)
  ;; (kill-ring-save (region-beginning) (region-end))
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy")
  (delete-region (region-beginning) (region-end))
  (setq select-enable-clipboard nil))
;; binding super+c to copy
(map! "s-c" #'copy-to-clipboard)
(map! "s-v" #'paste-from-clipboard)
(map! "s-x" #'cut-to-clipboard)
(map! :leader "s R" #'replace-string)

;; setting the location where org-archive-subtree command will store the tasks
(setq org-archive-location "%s_archive::")
