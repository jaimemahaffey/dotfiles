;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

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


(setq doom-font (font-spec :family "Iosevka NFM" :size 18 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(define-key emacs-lisp-mode-map (kbd "C-c e") 'macrostep-expand)
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

(defhydra doom-window-resize-hydra (:hint nil)
  "
             _k_ increase height
_h_ decrease width    _l_ increase width
             _j_ decrease height
"
  ("h" evil-window-decrease-width)
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)

  ("q" nil))

(map!
    (:prefix "M-w"
      :desc "Hydra resize" :n "SPC" #'doom-window-resize-hydra/body))

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))


(defun display-kill-ring ()
  "Display the contents of the kill ring in a new buffer."
  (interactive)
  (let ((buffer (get-buffer-create "*Kill Ring*")))
    (with-current-buffer buffer
      (erase-buffer) ;; Clear the buffer
      (insert (string-join kill-ring "\n\n")) ;; Add the kill ring contents
      (goto-char (point-min))) ;; Move point to the start
    (display-buffer buffer)))

(defun ap/load-doom-theme (theme)
  "Disable active themes and load a Doom theme."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name)
                                                   (--select (string-prefix-p "doom-" it)))))))
  (ap/switch-theme theme)

  (set-face-foreground 'org-indent (face-background 'default)))

(defun ap/switch-theme (theme)
  "Disable active themes and load THEME."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name))))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme 'no-confirm))

(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

(map! :leader
      :desc "Bigger font"
      "+" (lambda () (interactive)
            (set-face-attribute 'default nil :height (+ (face-attribute 'default :height) 10)))
      :desc "Smaller font"
      "-" (lambda () (interactive)
            (set-face-attribute 'default nil :height (- (face-attribute 'default :height) 10))))

;; (defun my/doom-reload-via-bash ()
;;   "Call doom sync using bash even if shell is PowerShell."
;;   (interactive)
;;   (start-process-shell-command
;;    "doom-reload"
;;    "*doom-reload*"
;;    "pwsh C:/Users/JMahaffey/.emacs.d/bin/doom.ps1 sync -e -B"))

(defun my/doom-reload-via-pwsh ()
  "Run doom sync via PowerShell wrapper script and show output in buffer."
  (interactive)
  (let* ((doom-script (expand-file-name "bin/doom.ps1" doom-emacs-dir))
         (output-buffer (get-buffer-create "*doom sync*"))
         ;; Build the full PowerShell command with stderr redirected
         (command (format "pwsh -NoLogo -NoProfile -Command \"& '%s' sync -e -B 2>&1\"" doom-script)))
    (with-current-buffer output-buffer
      (read-only-mode -1)
      (erase-buffer)
      (insert (format "Running: %s\n\n" command)))
    (let ((proc (start-process-shell-command "doom-sync" output-buffer command)))
      ;; When the process finishes, show a message in the minibuffer
      (set-process-sentinel
       proc
       (lambda (process event)
         (message "Doom sync process: %s" (string-trim event)))))
    (pop-to-buffer output-buffer)))

(map! :leader
      :desc "Doom reload via bash (PowerShell safe)"
      "h R" #'my/doom-reload-via-bash)

(load! "./org.el")
