(defun string-join-with-delim (args &optional delim)
  (or delim (setq b " "))
  (string-join args " "))

(defun siera--command (&rest command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command (format "%s %s 2> /dev/null" siera (string-join-with-delim command))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

(defmacro siera! (&rest commands)
  (macroexp-progn
   (mapcar (lambda (command)
             `(defun ,(intern (format "siera--%s" (string-join-with-delim command "-"))) (&optional args)
                ,(format "Siera wrapper for the %s subcommand" command)
                (siera--command ,(string-join-with-delim command) args))
             ) commands)))

(defun sample-siera (plist)
  (setq commands (list :connections :proofs :credentials))
  (dolist (command commands)
    (setq subcommand (plist-get plist command))
    (when (boundp 'subcommand)
        (message subcommand))))

(sample-siera '(:connections "invite"
                :proofs "foo"
                :credentials "yes"
                :cheese "lol"))
