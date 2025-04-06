;;; org.el -*- lexical-binding: t; -*-

(use-package! org-roam
  :config
  (setq org-roam-database-connector 'sqlite-builtin))

(use-package websocket
    :after org-roam)

(use-package org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
    :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-id-locations-file (expand-file-name "org-id-locations" org-directory)))

(after! org
  (setq org-capture-templates
        (append org-capture-templates
                '(("r" "Roam: Build Later" entry
                  (file+headline "~/org/inbox.org" "To Build")
                  "* TODO [[roam:%^{Node Title}]] %?")
                ("B" "Battle Plan" entry
                  (file+headline "~/org/kahua/kbuilder.org" "Battle Plans")
                  "* %^{Title} %?")))))

(use-package! org-modern
  :hook
  (org-mode . global-org-modern-mode)
  :custom
  (org-modern-keyword nil)
  (org-modern-checkbox nil)
  (org-modern-table nil))

(use-package! org-todoist
   :config
  (setq org-todoist-api-token "44632c3f513b8103b9a74b1b659a1fb509755840"))

(defun org-toggle-emphasis ()
  "Toggle hiding/showing of org emphasize markers."
  (interactive)
  (if org-hide-emphasis-markers
      (set-variable 'org-hide-emphasis-markers nil)
    (set-variable 'org-hide-emphasis-markers t))
  (org-mode-restart))
;(define-key org-mode-map (kbd "C-c e") 'org-toggle-emphasis)
; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         ;;(dot . t)
         ;;(ditaa . t)
         ;;(R . t)
         ;;(python . t)
         ;;(ruby . t)
         ;;(gnuplot . t)
         (clojure . t)
         (sh . t)
         ;;(ledger . t)
         (org . t)
         (plantuml . t)
         ;;(latex . t)
         )))

; Do not prompt to confirm evaluation
; This may be dangerous - make sure you understand the consequences
; of setting this -- see the docstring for details
;;(setq org-confirm-babel-evaluate nil)

; Use fundamental mode when editing plantuml blocks with C-c '
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
(setq plantuml-jar-path "C:\\Program Files\\WindowsApps\\50760EliasAE.PlantUml_1.0.9.0_x64__em4zjwbm1gapy\\Java\\plantuml.jar")
(setq plantuml-default-exec-mode 'jar)

;;Define Paths to Org Agenda Files
;; (defvar org-agenda-main-dir "~/gtd")
;; (defvar org-agenda-filenames '("tickler" "someday" "gtd" "inbox"))

;; ;;loop to create paths
;; (dolist (file org-agenda-filenames)
;;   (let ((var-name (intern (format "org-agenda-%s-file" file)))
;;         (file-path (concat org-agenda-main-dir "/" file ".org")))
;;     (set var-name file-path)
;;     (princ (concat (symbol-name var-name) ", "))))

;; (setq org-refile-targets `((,org-agenda-tickler-file :maxlevel . 2)
;;                           (,org-agenda-someday-file :maxlevel . 1)
;;                           (,org-agenda-gtd-file :maxlevel . 3)))

;; (setq org-capture-templates `(("t" "Todo [inbox]" entry
;;                                (file+headline ,org-agenda-inbox-file "Tasks")
;;                                "* TODO  %i%?")
;;                               ("T" "Tickler" entry
;;                                (file+headline ,org-agenda-tickler-file "Tickler")
;;                                "* %i%? \n %U")))

;; (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
