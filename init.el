;; C-x v g ---- git blame


(global-linum-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (fiplr multiple-cursors drag-stuff bind-key))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


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

(drag-stuff-global-mode 1)
(define-key drag-stuff-mode-map (drag-stuff--kbd 'up) 'drag-stuff-up)
(define-key drag-stuff-mode-map (drag-stuff--kbd 'down) 'drag-stuff-down)

(setq package-list '(drag-stuff bind-key fiplr multiple-cursors))
; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(set-default-font "ayuthaya 14")

(global-set-key (kbd "C-x l") 'goto-line)
(global-set-key (kbd "C-x t") 'eshell)
(global-set-key [s-left] 'bs-cycle-previous)
(global-set-key [s-right] 'bs-cycle-next)
(setq show-paren-delay 0)
(show-paren-mode 1)

;(windmove-default-keybindings)
;(windmove-default-keybindings 'meta)

;; Save all tempfiles in $TMPDIR/emacs$UID/                                                        
(defconst emacs-tmp-dir (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;;(global-set-key (kbd "<C-up>") 'shrink-window)
;;(global-set-key (kbd "<C-down>") 'enlarge-window)
;;(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
;;(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)
;;(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)

(defun delete-current-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(global-set-key (kbd "<s-backspace>") 'delete-current-line)


(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))

(global-set-key (kbd "<s-up>") (lambda () (interactive) (forward-line  -10)))
(global-set-key (kbd "<s-down>") (lambda () (interactive) (forward-line  10)))
(require 'bind-key)
(bind-key* "s-d" 'duplicate-current-line-or-region)
(bind-key* "s-e" 'move-end-of-line)
(bind-key* "s-o" 'fiplr-find-file)
(bind-key* "s-q" 'move-beginning-of-line)
(bind-key* "s-w" 'kill-buffer-and-window)
(bind-key* "s-/" 'comment-or-uncomment-region-or-line)
(bind-key* "<s-right>" 'forward-word)
(bind-key* "<s-left>" 'backward-word)

(global-set-key (kbd "s-[") 'windmove-left)
(global-set-key (kbd "s-]") 'windmove-right)
(global-set-key (kbd "s-=") 'windmove-up)
(global-set-key (kbd "s--") 'windmove-down)

(global-hl-line-mode 1)
(set-face-background 'hl-line "#fffae3")

(require 'multiple-cursors)
(global-set-key (kbd "<s-w>") 'kill-buffer-and-window)
(global-set-key (kbd "s-r") 'mc/mark-next-like-this)

(setq jit-lock-defer-time 0.05)
