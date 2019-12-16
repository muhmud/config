(setq mu4e-maildir "~/.mail"
      mu4e-attachment-dir "~/.mail/files"
      mu4e-update-interval nil
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-view-show-addresses t)

(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "gmail"
           :enter-func (lambda () (mu4e-message "Switch to the Private context"))
           ;; leave-func not defined
           :match-func (lambda (msg)
                         (when msg
                           (mu4e-message-contact-field-matches msg
                                                               :to "muhmud.ahmad@googlemail.com")))
           :vars '( ( user-mail-address      . "muhmud.ahmad@googlemail.com" )
                    ( user-full-name         . "Muhmud Ahmad" )))))
