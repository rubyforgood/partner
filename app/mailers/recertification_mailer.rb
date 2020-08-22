class RecertificationMailer < ApplicationMailer
  default from: "partner@diaper-app.org"
  layout "mailer"

  def notice_email(user)
    @partner = user.partner

    mail to: user.email,
         subject: "Please update your agency information"
  end
end
