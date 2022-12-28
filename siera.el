(defun string-join-with-delim (args &optional delim)
  (or delim (setq delim " "))
  (string-join args " "))

(mapatoms (lambda (symbol)
            (if (string-prefix-p "siera-" (symbol-name symbol))
                (unintern symbol))))

(defun siera--command (command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command (format "%s %s 2> /dev/null" siera (string-join-with-delim command))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

(defun siera-plist! (plist)
  (dolist (command (list :connection :proof :credential))
    (setq subcommands (plist-get plist command))
    (setq command (substring (format "%s" command) 1))
    (when (boundp 'subcommands)
      (or (listp subcommands) (setq subcommands (list subcommands)))
      (dolist (subcommand subcommands)
        (setq subcommand (format "%s" subcommand))
        `(defun (intern (format "siera--%s-%s" command subcommand)) ()
             ,(format "Siera subcommand ey: %s - %s" command subcommand)
             (message "kaas")
             ;;(siera--command (command subcommand))
             )))))

(siera-plist! '(:connection
               (invite list)
               :proof
               foo
               :credential
               yes
               ))

(siera--connection-invite)
