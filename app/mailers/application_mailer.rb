class ApplicationMailer < ActionMailer::Base
  default from: "partner@diaper-app.org"
  layout "mailer"

  def invitation(email)
    mail to: email,
         subject: "Account Registration"
  end
end
