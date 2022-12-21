(defun siera--command (&rest command)
  "Wrapper for siera"
  (setq siera (executable-find "siera"))
  (if (not siera)
      (error "siera is not installed"))
  (setq formatted-command (format "%s %s 2> /dev/null" siera (string-join command " "))
        command-output (shell-command-to-string formatted-command)
        out command-output)
  (message out))

;; DIT MOET EEN MAKRO ZIJN
(defun siera--connection (&optional subcommand)
  "Create a connection with siera"
  (setq foo (if (not (null subcommand)) subcommand (read-string "Enter subcommand: ")))
  (siera--command "connection" foo))

;; example
;; (meta-siera! connection credential)
;; (siera! :connnection
;;         invite
;;         list
;;         create)

(siera--connection "invite")
