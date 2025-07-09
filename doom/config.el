;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Dan Boitnott"
      user-mail-address "dan.boitnott@boldyn.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
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
(setq display-line-numbers-type 'relative)

(defun doom-dashboard-draw-ascii-banner-fn ()
  (let* ((banner
          '("  ,           ,"
            " /             \\"
            "((__-^^-,-^^-__))"
            " `-_---' `---_-'"
            "  `--|o` 'o|--'"
            "     \\  `  /"
            "      ): :("
            "      :o_o:"
            "       \"-\""))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

;; Custom keybindings
(map! :n "M-/" 'comment-line)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

;;
;; Pkl
;;
(load! "lisp/pkl-mode.el")

;;
;; Python
;;
(use-package! python-black
  :demand t
  :after python
  :config
  (add-hook! 'python-mode-hook #'python-black-on-save-mode)
  ;; Feel free to throw your own personal keybindings here
  ;; (map! :leader :desc "Blacken Buffer" "m b b" #'python-black-buffer)
  ;; (map! :leader :desc "Blacken Region" "m b r" #'python-black-region)
  ;; (map! :leader :desc "Blacken Statement" "m b s" #'python-black-statement)
  )

;;
;; Clojure
;;
(use-package! zprint-format
  :config
  (add-hook! 'clojure-mode-hook #'zprint-format-on-save-mode)
  (add-hook! 'clojurescript-mode-hook #'zprint-format-on-save-mode))

;; (use-package! smartparens
;;   :init
;;   (map! :map smartparens-mode-map
;;         "C->" #'sp-forward-slurp-sexp
;;         "C-<" #'sp-forward-barf-sexp
;;         "C-{" #'sp-backward-slurp-sexp
;;         "C-}" #'sp-backward-barf-sexp))

(add-hook! 'clojure-mode-hook #'paredit-mode)
(add-hook! 'clojurescript-mode-hook #'paredit-mode)
(add-hook! clojurescript-mode-map #'paredit-mode)

(map! :map smartparens-mode-map
      :nvie "C->" #'sp-forward-slurp-sexp
      :nvie "C-<" #'sp-forward-barf-sexp
      :nvie "C-{" #'sp-backward-slurp-sexp
      :nvie "C-}" #'sp-backward-barf-sexp)

(map! :map paredit-mode-map
      :nvie ")" #'paredit-close-round)

;;
;; Misc
;;
(use-package! just-mode)

(setq lsp-disabled-clients '(mspyls))

;; I'm ignoring "line too long" errors because I'm using the Python Black
;; auto-formatter and it sometimes allows lines to be slightly long.
(setq lsp-pylsp-plugins-flake8-ignore ["E501" "W503"])

;; Let evil-snipe operate on visble lines
(after! evil-snipe (setq evil-snipe-scope 'visible))
