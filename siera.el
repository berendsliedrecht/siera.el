(defun siera--command (command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command
        (s-replace ")" "" (s-replace "(" "" (format "%s %s 2> /dev/null" siera command)))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

(defmacro siera! (&rest commands)
  (macroexp-progn
   (mapcar (lambda (command)
           `(defun ,(intern (format "siera--%s" command)) (&optional args)
              ,(format "Siera wrapper for %s subcommand" command)
              (setq a (append (list ,(format "%s" command) args)))
              (siera--command a))) commands)))

(siera! connection
        proof
        credential)

;;(siera--connection '(invite --qr))
;;(siera--credential '(-h))
