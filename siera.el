(defun siera--command (&rest command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command (format "%s %s 2> /dev/null" siera (string-join command " "))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

(defmacro siera! (&rest names)
  (macroexp-progn
   (mapcar (lambda (name)
             `(defun ,(intern (format "siera--%s" name)) (&optional maybe-subcommand)
                ,(format "Siera wrapper for the %s subcommand" name)
                (setq subcommand
                      (if (not (null maybe-subcommand))
                          maybe-subcommand
                        (read-string "Enter subcommand: ")))
                (siera--command ,(format "%s" name) subcommand))) names)))

(siera! proof
        connection
        credential)
