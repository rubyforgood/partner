class RecertificationMailer < ApplicationMailer
  default from: "info@diaper.app"
  layout "mailer"

  def notice_email(user)
    @partner = user.partner

    mail to: user.email,
         subject: "Please Update Your Agency Information"
  end
end
