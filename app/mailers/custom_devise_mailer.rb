class CustomDeviseMailer < Devise::Mailer
  # Implemented to enable us to configure emails more.
  #
  # For example, we want to set `reply-to` to corresponding
  # organization emails of partners rather than a globally
  # set one for invitation emails.
  #
  # Following the suggestion of -
  # https://github.com/heartcombo/devise/wiki/How-To:-Use-custom-mailer
  #

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  #
  # Set the reply_to to attr `invitation_reply_to` on User otherwise fallback to
  # the email address of the default sender.
  #
  default reply_to: ->(x) { x&.resource&.invitation_reply_to || DEVISE_DEFAULT_MAIL_SENDER }
end
