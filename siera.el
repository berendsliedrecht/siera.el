(defun siera--command (&rest command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command (format "%s %s 2> /dev/null" siera (mapconcat 'identity command " "))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

(defmacro siera! (&rest commands)
  (macroexp-progn
   (mapcar (lambda (command)
             `(defun ,(intern (format "siera--%s" (string-join command "-"))) (&optional args)
                ,(format "Siera wrapper for the %s subcommand" command)
                (siera--command ,(string-join command " ") args))
             ) commands)))

(siera! ("connection" "invite"))
(siera--connection-invite)
