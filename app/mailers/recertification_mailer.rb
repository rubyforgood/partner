class RecertificationMailer < ActionMailer::Base
  default from: "partner@diaper-app.org"
  layout "mailer"

  def notice_email
    @partner = params[:partner]

    mail to: @partner.email,
         subject: "Please update your agency information"
  end
end
